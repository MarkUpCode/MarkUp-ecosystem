# Graph Report - dinerop-backend  (2026-11-12)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 1406 nodes · 3508 edges · 103 communities (49 shown, 54 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 235 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `39c30a4f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 6
- Community 7
- Community 8
- Community 9
- Community 10
- Community 11
- Community 12
- Community 13
- Community 14
- Community 15
- Community 16
- Community 17
- Community 18
- Community 19
- Community 20
- Community 21
- Community 22
- Community 23
- Community 24
- Community 25
- Community 26
- Community 27
- Community 28
- Community 29
- Community 30
- Community 31
- Community 32
- Community 33
- Community 34
- Community 35
- Community 36
- Community 37
- Community 38
- Community 39
- Community 40
- Community 41
- Community 42
- Community 43
- Community 44
- Community 45
- Community 46
- Community 47
- Community 48
- Community 49
- Community 50
- Community 51
- Community 52
- Community 53
- Community 54
- Community 55
- Community 56
- Community 57
- Community 58
- Community 59
- Community 60
- Community 62
- Community 63
- Community 64
- Community 65
- Community 66
- Community 67
- Community 68
- Community 69
- Community 70
- Community 71
- Community 72
- Community 73
- Community 74
- Community 75
- Community 76
- Community 77
- Community 78
- Community 79
- Community 80
- Community 81
- Community 83
- Community 84
- Community 85
- Community 87
- Community 88
- Community 89
- Community 90

## God Nodes (most connected - your core abstractions)
1. `User` - 75 edges
2. `AuthService` - 46 edges
3. `UserRepository` - 40 edges
4. `CooperativeService` - 36 edges
5. `SolicitudOnboarding` - 34 edges
6. `CreditService` - 34 edges
7. `CreditRequest` - 33 edges
8. `SolicitudCooperativaRepository` - 32 edges
9. `Cooperative` - 31 edges
10. `Role` - 31 edges

## Surprising Connections (you probably didn't know these)
- `ActivationToken` --references--> `User`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/entity/ActivationToken.java → src/main/java/com/markup/dinerop/auth/entity/User.java
- `ActivationTokenRepository` --references--> `ActivationToken`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/repository/ActivationTokenRepository.java → src/main/java/com/markup/dinerop/auth/entity/ActivationToken.java
- `EmailVerificationOtpRepository` --references--> `EmailVerificationOtp`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/repository/EmailVerificationOtpRepository.java → src/main/java/com/markup/dinerop/auth/entity/EmailVerificationOtp.java
- `CooperativeStatusItemDto` --references--> `CreditRequirementDto`  [EXTRACTED]
  src/main/java/com/markup/dinerop/credit/dto/CooperativeStatusItemDto.java → src/main/java/com/markup/dinerop/credit/dto/CreditRequirementDto.java
- `AuthService` --references--> `NotificationService`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/service/AuthService.java → src/main/java/com/markup/dinerop/notification/service/NotificationService.java

## Import Cycles
- None detected.

## Communities (103 total, 54 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.10
Nodes (17): ChangeRegistrationEmailRequest, JwtResponse, LoginRequest, LoginResponse, UserInfo, OtpRegistrationStartResponse, OtpResendRequest, OtpVerificationRequest (+9 more)

### Community 1 - "Community 1"
Cohesion: 0.11
Nodes (5): NotificationService, ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate, EmailTemplateEngine

### Community 2 - "Community 2"
Cohesion: 0.10
Nodes (5): OnboardingServiceImpl, SolicitudOnboarding, BusinessException, ResourceNotFoundException, SolicitudOnboardingRepository

### Community 3 - "Community 3"
Cohesion: 0.12
Nodes (7): CooperativeAdminController, CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeNotFoundException, CooperativeAdminMapper, CooperativeAdminService

### Community 4 - "Community 4"
Cohesion: 0.16
Nodes (5): OtpInvalidException, OtpRateLimitException, UserAlreadyActiveException, EmailVerificationOtpRepository, AuthService

### Community 5 - "Community 5"
Cohesion: 0.11
Nodes (17): EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO (+9 more)

### Community 6 - "Community 6"
Cohesion: 0.16
Nodes (3): InternalAuthController, CreditReferralPdfService, ObtenerOnboardingUnificadoUseCase

### Community 7 - "Community 7"
Cohesion: 0.14
Nodes (4): ActivationTokenRepository, AuthServiceOtpFlowTest, AuthServiceSecurityActivityTest, ClientCreditQuerySecurityTest

### Community 8 - "Community 8"
Cohesion: 0.11
Nodes (6): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto

### Community 9 - "Community 9"
Cohesion: 0.09
Nodes (6): CooperativeRequiredException, AdminBootstrapRunner, AccountDisabledException, CooperativeNotFoundException, OtpAttemptsExceededException, OtpExpiredException

### Community 10 - "Community 10"
Cohesion: 0.11
Nodes (8): CreditRequestType, CREDITO, INVERSION, CreditType, CONSUMO, MICROCREDITO, ClientCreditRequestDto, PublicCreditRequestDto

### Community 12 - "Community 12"
Cohesion: 0.13
Nodes (3): PushDeviceToken, PushDeviceTokenRepository, PushNotificationService

### Community 13 - "Community 13"
Cohesion: 0.16
Nodes (4): CooperativeService, CooperativeDto, CreateCooperativeDto, CooperativeController

### Community 14 - "Community 14"
Cohesion: 0.09
Nodes (4): ActividadEconomicaRequest, DireccionRequest, IngresoEgresoRequest, PersonaOnboardingRequest

### Community 15 - "Community 15"
Cohesion: 0.14
Nodes (3): CreditRequest, ClientCreditQueryService, CreditRequestRepository

### Community 16 - "Community 16"
Cohesion: 0.13
Nodes (7): DashboardController, CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, UserStatsDto, VisitStatsDto, DashboardService

### Community 17 - "Community 17"
Cohesion: 0.19
Nodes (3): CooperativeSpecification, Cooperative, CooperativeRepository

### Community 19 - "Community 19"
Cohesion: 0.18
Nodes (6): OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, SolicitarGaranteUseCase, OnboardingClienteController, FormularioClienteStatusResponse

### Community 20 - "Community 20"
Cohesion: 0.11
Nodes (3): LinkClientRequestDto, LinkClientResponseDto, InternalCreditController

### Community 22 - "Community 22"
Cohesion: 0.15
Nodes (4): PageVisit, PageVisitRepository, VisitService, VisitController

### Community 23 - "Community 23"
Cohesion: 0.17
Nodes (5): UserAdminController, CreateUserRequest, UserDetailResponse, UserNotFoundException, UserAdminService

### Community 25 - "Community 25"
Cohesion: 0.15
Nodes (3): AuthController, CompleteRegistrationRequest, ForgotPasswordRequest

### Community 26 - "Community 26"
Cohesion: 0.17
Nodes (3): CreditRequirement, CreditRequirementRepository, CreditRequirementService

### Community 27 - "Community 27"
Cohesion: 0.13
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaPersonalResponse, ReferenciaPersonalRepository

### Community 31 - "Community 31"
Cohesion: 0.14
Nodes (3): SolicitudCooperativaCotizacion, ClientCreditCooperativeStatusService, SolicitudCooperativaCotizacionRepository

### Community 33 - "Community 33"
Cohesion: 0.19
Nodes (3): ClientCreditAcceptanceService, CooperativeCreditRequestItemDto, SolicitudCooperativaRepository

### Community 36 - "Community 36"
Cohesion: 0.15
Nodes (3): UserPreRegistration, UserPreRegistrationRepository, CooperativeCreditQueryService

### Community 37 - "Community 37"
Cohesion: 0.15
Nodes (5): DireccionOnboarding, TipoVivienda, ARRENDADA, PROPIA, DireccionOnboardingResponse

### Community 38 - "Community 38"
Cohesion: 0.23
Nodes (3): WebClientConfig, PasswordEncoderConfig, ResendConfig

### Community 39 - "Community 39"
Cohesion: 0.16
Nodes (7): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, ActualizarEstadoSolicitudRequest

### Community 40 - "Community 40"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "Community 42"
Cohesion: 0.19
Nodes (4): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException

### Community 45 - "Community 45"
Cohesion: 0.14
Nodes (13): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+5 more)

### Community 46 - "Community 46"
Cohesion: 0.24
Nodes (3): CooperativeListItemResponse, PagedCooperativesResponse, CreditDistributionService

### Community 50 - "Community 50"
Cohesion: 0.19
Nodes (3): ActividadEconomica, ActividadEconomicaRepository, DireccionOnboardingRepository

### Community 51 - "Community 51"
Cohesion: 0.23
Nodes (4): PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserAdminMapper

### Community 55 - "Community 55"
Cohesion: 0.17
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 56 - "Community 56"
Cohesion: 0.23
Nodes (3): AuthenticatedRequestResult, CreditService, PublicCreditRequestResult

### Community 59 - "Community 59"
Cohesion: 0.29
Nodes (3): LoanCalculator, CooperativeOfferDefaultsDto, CreditRequirementDto

### Community 60 - "Community 60"
Cohesion: 0.24
Nodes (4): RecentCreditDto, CreditRequestStatus, CREADA, ENVIADA

### Community 64 - "Community 64"
Cohesion: 0.28
Nodes (7): RecentUserDto, ChangeRoleRequest, InviteUserRequest, Role, ADMIN, CLIENT, COOPERATIVE

### Community 65 - "Community 65"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 69 - "Community 69"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "Community 70"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 79 - "Community 79"
Cohesion: 0.29
Nodes (7): ddl-auto, hibernate, open-in-view, properties, show-sql, spring, jpa

### Community 80 - "Community 80"
Cohesion: 0.29
Nodes (7): format_sql, generate_statistics, jdbc, order_inserts, order_updates, batch_size, hibernate

### Community 81 - "Community 81"
Cohesion: 0.29
Nodes (7): com.markup.dinerop, com.zaxxer.hikari, org.hibernate, org.springframework, root, logging, level

### Community 85 - "Community 85"
Cohesion: 0.33
Nodes (5): name, active, spring, application, profiles

### Community 87 - "Community 87"
Cohesion: 0.40
Nodes (5): driver-class-name, password, url, username, datasource

## Knowledge Gaps
- **34 isolated node(s):** `CREDITO`, `INVERSION`, `CONSUMO`, `MICROCREDITO`, `FAMILIAR` (+29 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 506 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **54 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `Community 30` to `Community 0`, `Community 4`, `Community 5`, `Community 6`, `Community 7`, `Community 9`, `Community 10`, `Community 12`, `Community 16`, `Community 18`, `Community 19`, `Community 21`, `Community 23`, `Community 24`, `Community 29`, `Community 35`, `Community 43`, `Community 49`, `Community 51`, `Community 52`, `Community 58`, `Community 64`, `Community 73`, `Community 78`?**
  _High betweenness centrality (0.080) - this node is a cross-community bridge._
- **What connects `CREDITO`, `INVERSION`, `CONSUMO` to the rest of the system?**
  _34 weakly-connected nodes found - possible missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.09585037989479836 - nodes in this community are weakly interconnected._
- **Why does `AuthService` connect `Community 4` to `Community 0`, `Community 1`, `Community 6`, `Community 7`, `Community 9`, `Community 10`, `Community 11`, `Community 17`, `Community 23`, `Community 25`, `Community 29`, `Community 34`, `Community 36`, `Community 46`, `Community 49`, `Community 51`, `Community 52`, `Community 56`, `Community 67`, `Community 86`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.11092436974789915 - nodes in this community are weakly interconnected._
- **Why does `CreditService` connect `Community 56` to `Community 1`, `Community 2`, `Community 4`, `Community 5`, `Community 6`, `Community 10`, `Community 12`, `Community 13`, `Community 15`, `Community 18`, `Community 20`, `Community 26`, `Community 31`, `Community 33`, `Community 39`, `Community 44`, `Community 46`, `Community 49`, `Community 53`, `Community 54`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.09915966386554621 - nodes in this community are weakly interconnected._