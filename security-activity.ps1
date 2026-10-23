[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$backend = Join-Path $repoRoot "dinerop-backend"
$evidence = Join-Path $repoRoot "evidencias-seguridad"
$runId = Get-Date -Format "yyyyMMdd-HHmmss"
$runDir = Join-Path $evidence "posterior\$runId"

New-Item -ItemType Directory -Force -Path $runDir | Out-Null

function Invoke-CheckedCommand {
    param(
        [string]$Name,
        [string]$Command,
        [string]$WorkingDirectory
    )

    $outputFile = Join-Path $runDir "$Name.log"
    Push-Location $WorkingDirectory
    try {
        $quotedOutputFile = '"' + $outputFile + '"'
        & $env:ComSpec /c "$Command > $quotedOutputFile 2>&1"
        $exitCode = $LASTEXITCODE
        Get-Content $outputFile
        if ($exitCode -ne 0) {
            throw "$Name falló con código $exitCode. Consulte $outputFile"
        }
    }
    finally {
        Pop-Location
    }
}

git -C $repoRoot status --short --branch | Set-Content (Join-Path $runDir "git-status.txt")
git -C $repoRoot log -1 --oneline --decorate | Set-Content (Join-Path $runDir "git-commit.txt")

Invoke-CheckedCommand -Name "security-activity-tests" `
    -Command ".\mvnw.cmd -Dtest=SecurityActivityTest test" `
    -WorkingDirectory $backend

$trivyReport = Join-Path $runDir "trivy-report.json"
$trivyTable = Join-Path $runDir "trivy-report.txt"

if (Get-Command trivy -ErrorAction SilentlyContinue) {
    Push-Location $backend
    try {
        & trivy fs --scanners vuln --format json --output $trivyReport `
            --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed . 2>&1 |
            Set-Content $trivyTable
        $scanExitCode = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }
}
elseif (Get-Command docker -ErrorAction SilentlyContinue) {
    $relativeReport = "evidencias-seguridad/posterior/$runId/trivy-report.json"
    $dockerCommand = "docker run --rm -v `"$repoRoot`:/workspace`" aquasec/trivy:0.57.1 fs --scanners vuln --format json --output /workspace/$relativeReport --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed /workspace/dinerop-backend"
    Invoke-CheckedCommand -Name "trivy" -Command $dockerCommand -WorkingDirectory $repoRoot
    Copy-Item (Join-Path $runDir "trivy.log") $trivyTable
    $scanExitCode = 0
}
else {
    "Trivy no está instalado y Docker tampoco está disponible. Instale Trivy desde https://trivy.dev/latest/getting-started/installation/ o habilite Docker." |
        Set-Content (Join-Path $runDir "trivy.log")
    throw "No se pudo ejecutar Trivy. Consulte $(Join-Path $runDir "trivy.log")"
}

if ($scanExitCode -ne 0) {
    throw "Trivy encontró vulnerabilidades HIGH/CRITICAL o falló. Consulte $trivyTable y $trivyReport"
}

Write-Output "Ejecución completada. Evidencias: $runDir"
