import { useEffect, useState } from "react";
import { Link, Navigate, useNavigate, useSearchParams } from "react-router-dom";
import {
  forgotPassword,
  resetPassword,
  verifyPasswordResetCode,
} from "../../api/auth/auth.api";
import { getErrorMessage } from "../../api/errors";

type Step = "code" | "password" | "success";

export default function ResetPassword() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const email = (searchParams.get("email") ?? "").trim().toLowerCase();
  const [step, setStep] = useState<Step>("code");
  const [code, setCode] = useState("");
  const [resetToken, setResetToken] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [countdown, setCountdown] = useState(45);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (step !== "code" || countdown <= 0) return;
    const timer = window.setTimeout(() => setCountdown((value) => value - 1), 1000);
    return () => window.clearTimeout(timer);
  }, [countdown, step]);

  const verify = async () => {
    setError(null);
    setMessage(null);
    if (!/^\d{6}$/.test(code)) {
      setError("Ingresa el código de 6 dígitos.");
      return;
    }
    try {
      setLoading(true);
      const result = await verifyPasswordResetCode({ email, code });
      setResetToken(result.resetToken);
      setStep("password");
    } catch (e) {
      setError(getErrorMessage(e, "El código no es correcto, expiró o ya no es válido."));
    } finally {
      setLoading(false);
    }
  };

  const resend = async () => {
    if (countdown > 0 || loading) return;
    setError(null);
    setMessage(null);
    try {
      setLoading(true);
      await forgotPassword(email);
      setCode("");
      setCountdown(45);
      setMessage("Si el correo existe, recibirás un nuevo código.");
    } catch (e) {
      setError(getErrorMessage(e, "No se pudo procesar la solicitud."));
    } finally {
      setLoading(false);
    }
  };

  const savePassword = async () => {
    setError(null);
    setMessage(null);
    if (newPassword.length < 8) {
      setError("La contraseña debe tener al menos 8 caracteres.");
      return;
    }
    if (newPassword !== confirmPassword) {
      setError("Las contraseñas no coinciden.");
      return;
    }
    if (!resetToken) {
      setError("Valida primero el código enviado a tu correo.");
      setStep("code");
      return;
    }
    try {
      setLoading(true);
      await resetPassword({ token: resetToken, newPassword });
      setStep("success");
      setMessage("¡Contraseña restablecida! Ya puedes iniciar sesión");
    } catch (e) {
      setError(getErrorMessage(e, "No se pudo actualizar la contraseña."));
    } finally {
      setLoading(false);
    }
  };

  if (!email) return <Navigate to="/forgot-password" replace />;

  return (
    <div className="min-h-screen flex items-center justify-center bg-neutral-50 px-4 py-8">
      <div className="w-full max-w-md rounded-2xl bg-white shadow-xl p-6 border border-neutral-100">
        <div className="mb-5 flex items-center justify-center">
          <div className="grid h-12 w-12 place-items-center rounded-full bg-indigo-50 text-indigo-700">
            {step === "success" ? "✓" : step === "code" ? "✉" : "🔒"}
          </div>
        </div>
        {step === "code" && (
          <div className="space-y-4" key="reset-code">
            <h1 className="text-center text-2xl font-bold">Verifica tu correo</h1>
            <p className="text-center text-sm text-neutral-600">
              Si el correo está registrado, enviamos un código a <span className="font-semibold text-neutral-800">{email}</span>. Expira en 10 minutos.
            </p>
            <label className="block text-sm font-semibold text-neutral-700">
              Código de 6 dígitos
              <input
                value={code}
                onChange={(event) => setCode(event.target.value.replace(/\D/g, "").slice(0, 6))}
                inputMode="numeric"
                autoComplete="one-time-code"
                maxLength={6}
                className="mt-1 w-full rounded-xl border-2 border-neutral-200 px-4 py-3 text-center text-xl tracking-[0.5em] transition-all focus:ring-2 focus:ring-brand-primary"
                placeholder="123456"
              />
            </label>
            <div className="flex justify-end">
              <button type="button" onClick={() => void resend()} disabled={loading || countdown > 0} className="text-sm font-semibold text-indigo-600 disabled:text-neutral-400">
                {countdown > 0 ? `Reenviar código en ${countdown}s` : "Reenviar código"}
              </button>
            </div>
            <button type="button" onClick={() => void verify()} disabled={loading} className="w-full rounded-xl bg-indigo-600 px-4 py-3 font-semibold text-white transition hover:bg-indigo-700 disabled:opacity-60">
              {loading ? "Validando..." : "Validar código"}
            </button>
          </div>
        )}
        {step === "password" && (
          <div className="space-y-4" key="reset-password">
            <h1 className="text-center text-2xl font-bold">Crea una nueva contraseña</h1>
            <p className="text-center text-sm text-neutral-600">Usa al menos 8 caracteres. El código verificado ya no puede volver a utilizarse.</p>
            <label className="block text-sm font-semibold text-neutral-700">
              Nueva contraseña
              <div className="mt-1 flex rounded-xl border-2 border-neutral-200 focus-within:ring-2 focus-within:ring-brand-primary">
                <input type={showPassword ? "text" : "password"} value={newPassword} onChange={(event) => setNewPassword(event.target.value)} autoComplete="new-password" className="min-w-0 flex-1 rounded-l-xl px-4 py-3 outline-none" placeholder="Mínimo 8 caracteres" />
                <button type="button" onClick={() => setShowPassword((value) => !value)} className="px-4 text-sm font-semibold text-indigo-600" aria-label={showPassword ? "Ocultar contraseña" : "Mostrar contraseña"}>{showPassword ? "Ocultar" : "Ver"}</button>
              </div>
            </label>
            <label className="block text-sm font-semibold text-neutral-700">
              Confirmar contraseña
              <div className="mt-1 flex rounded-xl border-2 border-neutral-200 focus-within:ring-2 focus-within:ring-brand-primary">
                <input type={showConfirmPassword ? "text" : "password"} value={confirmPassword} onChange={(event) => setConfirmPassword(event.target.value)} autoComplete="new-password" className="min-w-0 flex-1 rounded-l-xl px-4 py-3 outline-none" placeholder="Repite la contraseña" />
                <button type="button" onClick={() => setShowConfirmPassword((value) => !value)} className="px-4 text-sm font-semibold text-indigo-600" aria-label={showConfirmPassword ? "Ocultar confirmación" : "Mostrar confirmación"}>{showConfirmPassword ? "Ocultar" : "Ver"}</button>
              </div>
            </label>
            <button type="button" onClick={() => void savePassword()} disabled={loading} className="w-full rounded-xl bg-gradient-to-r from-brand-secondary to-brand-dark px-4 py-3 font-semibold text-white shadow-lg transition hover:opacity-95 disabled:opacity-60">
              {loading ? "Actualizando..." : "Guardar nueva contraseña"}
            </button>
          </div>
        )}
        {step === "success" && (
          <div className="space-y-5 text-center" key="reset-success">
            <h1 className="text-2xl font-bold text-green-800">¡Contraseña restablecida! Ya puedes iniciar sesión</h1>
            <button type="button" onClick={() => navigate("/login")} className="w-full rounded-xl bg-gradient-to-r from-brand-secondary to-brand-dark px-4 py-3 font-semibold text-white shadow-lg transition hover:opacity-95">Volver al inicio de sesión</button>
          </div>
        )}
        {message && step !== "success" && <div role="status" className="mt-4 rounded-r-lg border-l-4 border-green-500 bg-green-50 p-3"><p className="text-sm font-medium text-green-800">{message}</p></div>}
        {error && <div role="alert" className="mt-4 rounded-r-lg border-l-4 border-red-500 bg-red-50 p-3"><p className="text-sm font-medium text-red-700">{error}</p></div>}
        {step !== "success" && <div className="mt-5 text-center"><Link to="/login" className="text-sm font-semibold text-brand-primary hover:underline">Volver al inicio de sesión</Link></div>}
      </div>
    </div>
  );
}
