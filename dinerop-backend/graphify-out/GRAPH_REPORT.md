# Graph Report - dinerop-backend  (2026-11-18)

## Corpus Check
- 307 files · ~40,368 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1973 nodes · 5466 edges · 119 communities (50 shown, 69 thin omitted)
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 415 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `65383fa5`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.Getter
- SolicitudCooperativaRepository
- SolicitudCooperativa
- CooperativeAdminService.java
- AuthController
- PersonaOnboarding
- org.springframework.security.access.prepost.PreAuthorize
- UserRepository
- InvestmentService
- AdminInvestmentCalculationSettingsController.java
- org.springframework.http.ResponseEntity
- SolicitudOnboarding
- SolicitudOnboardingRequest
- CooperativeService
- bigdecimal
- FinancialProductServiceTest.java
- .findByProductIdOrderByValidFromDescIdDesc
- JwtAuthenticationFilter.java
- CreditController
- lombok.RequiredArgsConstructor
- SecurityActivityTest.java
- CreditService
- .handleBadRequest
- UserAdminService
- UserAdminService.java
- PasswordResetToken
- CreditRequirement
- OnboardingMapper
- FinancialProduct
- JwtService
- User
- CreditRequestStatus
- .createMyRequest
- notnull
- .publicRegister
- FinancialProductService
- org.springframework.data.jpa.repository.JpaRepository
- DireccionOnboarding
- auth/config/SecurityConfig.java
- InvestmentRequest
- postgres
- .crearSolicitudConSolicitante
- CreditService.java
- ActivationTokenRepository
- InvestmentController
- application-prod.yaml
- org.junit.jupiter.api.Test
- InterestPaymentOption
- org.springframework.web.bind.annotation.ResponseStatus
- ActividadEconomica
- InvestmentAcceptanceRecord.java
- InvestmentRequestStatusEvent
- CreditGuarantorEvaluation
- CreditReferralPdfService.java
- IngresoEgreso
- CooperativeInvitation
- DireccionOnboarding
- OnboardingServiceImpl.java
- AuthService.java
- CreditGuarantorSubmission
- CreditExceptionHandler.java
- SolicitudOnboardingRequest
- EstadoGarante
- tomcat
- CreditOfferEmailBuilder
- InvitationService
- PreRegisterRequest
- hikari
- management
- IngresoEgresoRequest
- AuthServicePasswordResetOtpTest
- DireccionOnboarding
- LinkClientRequest
- CooperativeCreditProductController
- PreRegisterRequest
- PreRegisterResponse
- org.springframework.transaction.annotation.Transactional
- flyway
- hibernate
- level
- CreditGuarantorHistoryItemDto
- DineropBackendApplication.java
- spring
- datasource
- VisitService
- CooperativeInvestmentController
- com.markup:dinerop-backend
- Role
- AuthServiceSecurityActivityTest
- OnboardingServiceImpl
- CreditGuarantorWorkflowServiceTest
- FinancialProductService
- OnboardingCooperativaController.java
- UserPreRegistration
- CreditRequest.java
- CooperativeRepository
- PageVisitRepository
- PushDeviceToken
- CreditGuarantorStatus
- .startRegistrationOtp
- LinkClientRequestDto
- FinancialProductRequest
- InternalCreditController

## God Nodes (most connected - your core abstractions)
1. `User` - 89 edges
2. `AuthService` - 47 edges
3. `UserRepository` - 46 edges
4. `SolicitudCooperativaRepository` - 45 edges
5. `FinancialProductService` - 43 edges
6. `CreditService` - 40 edges
7. `NotificationService` - 39 edges
8. `CooperativeService` - 38 edges
9. `CreditRequest` - 36 edges
10. `SolicitudCooperativa` - 35 edges

## Surprising Connections (you probably didn't know these)
- `CreditService` --references--> `CreditDistributionService`  [EXTRACTED]
  src/main/java/com/markup/dinerop/credit/domain/service/CreditService.java → src/main/java/com/markup/dinerop/credit/domain/service/CreditDistributionService.java
- `ActivationToken` --references--> `User`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/entity/ActivationToken.java → src/main/java/com/markup/dinerop/auth/entity/User.java
- `ActivationTokenRepository` --references--> `ActivationToken`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/repository/ActivationTokenRepository.java → src/main/java/com/markup/dinerop/auth/entity/ActivationToken.java
- `CooperativeStatusItemDto` --references--> `CreditRequirementDto`  [EXTRACTED]
  src/main/java/com/markup/dinerop/credit/dto/CooperativeStatusItemDto.java → src/main/java/com/markup/dinerop/credit/dto/CreditRequirementDto.java
- `FormularioClienteStatusResponse` --references--> `EstadoFormulario`  [EXTRACTED]
  src/main/java/com/markup/dinerop/onboarding/dto/response/FormularioClienteStatusResponse.java → src/main/java/com/markup/dinerop/onboarding/domain/enums/EstadoFormulario.java

## Import Cycles
- None detected.

## Communities (119 total, 69 thin omitted)

### Community 0 - "lombok.Getter"
Cohesion: 0.05
Nodes (29): UpdateUserRequest, ChangeRegistrationEmailRequest, CompleteRegistrationRequest, JwtResponse, LoginResponse, UserInfo, OtpRegistrationStartResponse, OtpResendRequest (+21 more)

### Community 1 - "SolicitudCooperativaRepository"
Cohesion: 0.09
Nodes (12): CreditRequest, CreditRequestStatus, CREADA, ENVIADA, ClientCreditQueryService, CreditRequestRepository, SolicitudCooperativaRepository, CreditReferralPdfService (+4 more)

### Community 2 - "SolicitudCooperativa"
Cohesion: 0.10
Nodes (9): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, SolicitudCooperativa, ClientCreditAcceptanceService (+1 more)

### Community 3 - "CooperativeAdminService.java"
Cohesion: 0.05
Nodes (17): CooperativeAdminController, CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeListItemResponse, PagedCooperativesResponse, CooperativeNotFoundException, CooperativeAdminMapper (+9 more)

### Community 5 - "PersonaOnboarding"
Cohesion: 0.10
Nodes (11): PersonaOnboarding, EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE (+3 more)

### Community 7 - "UserRepository"
Cohesion: 0.10
Nodes (6): AdminBootstrapRunner, CooperativeInvitationRepository, UserRepository, InvitationService, AuthServiceOtpFlowTest, InvitationServiceTest

### Community 8 - "InvestmentService"
Cohesion: 0.16
Nodes (10): InvestmentRequestStatus, CONDITIONS_CONFIRMED, DECLINED, IN_REVIEW, INFORMATION_REQUIRED, SUBMITTED, InvestmentService, InvestmentRequestResponse (+2 more)

### Community 9 - "AdminInvestmentCalculationSettingsController.java"
Cohesion: 0.24
Nodes (4): InvestmentCalculationSettingsService, InvestmentCalculationSettingsResponse, UpdateInvestmentCalculationSettingsRequest, AdminInvestmentCalculationSettingsController

### Community 13 - "CooperativeService"
Cohesion: 0.09
Nodes (3): CooperativeService, CooperativeController, InternalCooperativeController

### Community 14 - "bigdecimal"
Cohesion: 0.15
Nodes (4): InvestmentAcceptanceRequest, Requirement, InvestmentAcceptanceResponse, Requirement

### Community 18 - "CreditController"
Cohesion: 0.09
Nodes (6): CooperativeCreditDecisionService, CooperativeCreditRequestItemDto, CooperativeDecisionRequestDto, CooperativeOfferDefaultsDto, CreditProcessEventDto, CreditController

### Community 19 - "lombok.RequiredArgsConstructor"
Cohesion: 0.13
Nodes (13): CooperativeCreditQueryService, CreditDistributionService, CreditGuarantorWorkflowService, OnboardingServiceImpl, OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, ObtenerOnboardingUnificadoUseCase (+5 more)

### Community 21 - "CreditService"
Cohesion: 0.18
Nodes (7): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, CreditService, GuaranteeDecisionRequestDto

### Community 22 - ".handleBadRequest"
Cohesion: 0.19
Nodes (4): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException

### Community 23 - "UserAdminService"
Cohesion: 0.16
Nodes (5): UserAdminController, ChangeStatusRequest, UserDetailResponse, UserNotFoundException, UserAdminService

### Community 24 - "UserAdminService.java"
Cohesion: 0.22
Nodes (4): PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserAdminMapper

### Community 25 - "PasswordResetToken"
Cohesion: 0.09
Nodes (4): ForgotPasswordRequest, ResetPasswordRequest, PasswordResetToken, PasswordResetTokenRepository

### Community 27 - "OnboardingMapper"
Cohesion: 0.13
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaPersonalResponse, ReferenciaPersonalRepository

### Community 28 - "FinancialProduct"
Cohesion: 0.13
Nodes (8): CreditProductCategory, CONSUMO, MICROCREDITO, FinancialProduct, FinancialProductType, CREDIT, INVESTMENT, PublicCreditOfferResponse

### Community 31 - "CreditRequestStatus"
Cohesion: 0.12
Nodes (8): DashboardController, CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, RecentCreditDto, UserStatsDto, VisitStatsDto, DashboardService

### Community 35 - "FinancialProductService"
Cohesion: 0.16
Nodes (3): FinancialProductCondition, FinancialProductConditionRequest, Condition

### Community 38 - "auth/config/SecurityConfig.java"
Cohesion: 0.06
Nodes (7): OpenApiConfig, SecurityConfig, WebClientConfig, CustomUserDetailsService, PasswordEncoderConfig, FirebaseConfig, ResendConfig

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "CreditService.java"
Cohesion: 0.09
Nodes (7): SolicitudCooperativaCotizacion, LoanCalculationResult, LoanCalculator, ClientCreditCooperativeStatusService, CreditRequirementDto, SolicitudCooperativaCotizacionRepository, CreditRequirementService

### Community 44 - "InvestmentController"
Cohesion: 0.29
Nodes (3): CreateInvestmentRequest, PublicInvestmentRegistrationRequest, InvestmentController

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 48 - "InterestPaymentOption"
Cohesion: 0.15
Nodes (10): InterestPaymentOption, AT_MATURITY, MONTHLY, REINVEST, InvestmentCalculationMethod, MONTHLY_COMPOUNDING, SIMPLE_INTEREST, UNSPECIFIED (+2 more)

### Community 50 - "ActividadEconomica"
Cohesion: 0.17
Nodes (3): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository

### Community 51 - "InvestmentAcceptanceRecord.java"
Cohesion: 0.33
Nodes (4): EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE

### Community 53 - "CreditGuarantorEvaluation"
Cohesion: 0.13
Nodes (4): CreditGuarantorEvaluation, TypeReference<>, CreditGuarantorEvaluationDto, CreditGuarantorEvaluationRepository

### Community 55 - "IngresoEgreso"
Cohesion: 0.17
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 56 - "CooperativeInvitation"
Cohesion: 0.06
Nodes (4): InvitationController, InvitationActivationRequest, InvitationDetailsResponse, CooperativeInvitation

### Community 59 - "AuthService.java"
Cohesion: 0.09
Nodes (6): CooperativeRequiredException, AccountDisabledException, CooperativeNotFoundException, OtpAttemptsExceededException, OtpExpiredException, OtpRateLimitException

### Community 64 - "EstadoGarante"
Cohesion: 0.40
Nodes (4): EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 66 - "CreditOfferEmailBuilder"
Cohesion: 0.08
Nodes (6): TestEmailController, NotificationService, ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate, EmailTemplateEngine

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 73 - "DireccionOnboarding"
Cohesion: 0.18
Nodes (5): TipoVivienda, ARRENDADA, PROPIA, DireccionRequest, DireccionOnboardingResponse

### Community 79 - "flyway"
Cohesion: 0.18
Nodes (11): baseline-description, baseline-on-migrate, baseline-version, enabled, ddl-auto, hibernate, open-in-view, show-sql (+3 more)

### Community 80 - "hibernate"
Cohesion: 0.25
Nodes (8): format_sql, generate_statistics, jdbc, order_inserts, order_updates, batch_size, properties, hibernate

### Community 81 - "level"
Cohesion: 0.33
Nodes (6): com.markup.dinerop, com.zaxxer.hikari, org.hibernate, org.springframework, root, level

### Community 85 - "spring"
Cohesion: 0.25
Nodes (7): name, enabled, active, spring, application, flyway, profiles

### Community 87 - "datasource"
Cohesion: 0.40
Nodes (5): driver-class-name, password, url, username, datasource

### Community 103 - "Role"
Cohesion: 0.24
Nodes (7): RecentUserDto, ChangeRoleRequest, InviteUserRequest, Role, ADMIN, CLIENT, COOPERATIVE

### Community 105 - "AuthServiceSecurityActivityTest"
Cohesion: 0.27
Nodes (3): LoginRequest, AccountNotActiveException, AuthServiceSecurityActivityTest

### Community 109 - "FinancialProductService"
Cohesion: 0.17
Nodes (5): FinancialProductAdminController, FinancialProductService, FinancialProductRequest, FinancialProductResponse, FinancialProductController

### Community 112 - "CreditRequest.java"
Cohesion: 0.11
Nodes (8): CreditRequestType, CREDITO, INVERSION, CreditType, CONSUMO, MICROCREDITO, ClientCreditRequestDto, PublicCreditRequestDto

### Community 117 - "CreditGuarantorStatus"
Cohesion: 0.29
Nodes (6): CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA

### Community 118 - ".startRegistrationOtp"
Cohesion: 0.15
Nodes (5): PublicRegistrationRequest, UserAlreadyActiveException, EmailVerificationOtpRepository, AuthService, PublicCreditRequestResult

## Knowledge Gaps
- **58 isolated node(s):** `CREADA`, `ENVIADA`, `ADMIN`, `CLIENT`, `COOPERATIVE` (+53 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 640 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **69 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `lombok.Getter`, `SolicitudCooperativaRepository`, `org.springframework.security.access.prepost.PreAuthorize`, `UserRepository`, `InvestmentService`, `SolicitudOnboardingRequest`, `JwtAuthenticationFilter.java`, `CreditController`, `lombok.RequiredArgsConstructor`, `SecurityActivityTest.java`, `UserAdminService`, `UserAdminService.java`, `PasswordResetToken`, `JwtService`, `CreditRequestStatus`, `.createMyRequest`, `auth/config/SecurityConfig.java`, `CreditService.java`, `InvestmentController`, `lombok`, `CreditReferralPdfService.java`, `CooperativeInvitation`, `AuthService.java`, `InvitationService`, `AuthServicePasswordResetOtpTest`, `org.springframework.transaction.annotation.Transactional`, `CreditGuarantorHistoryItemDto`, `org.springframework.data.jpa.repository.Query`, `Role`, `AuthServiceSecurityActivityTest`, `OnboardingCooperativaController.java`, `PushDeviceToken`, `.startRegistrationOtp`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **What connects `CREADA`, `ENVIADA`, `ADMIN` to the rest of the system?**
  _58 weakly-connected nodes found - possible missing edges._
- **Should `lombok.Getter` be split into smaller, more focused modules?**
  _Cohesion score 0.05112347969490827 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboarding` connect `PersonaOnboarding` to `EstadoGarante`, `.crearSolicitudConSolicitante`, `SolicitudOnboarding`, `OnboardingServiceImpl`, `lombok`, `ActividadEconomica`, `lombok.RequiredArgsConstructor`, `CreditGuarantorHistoryItemDto`, `IngresoEgreso`, `DireccionOnboarding`, `OnboardingServiceImpl.java`, `OnboardingMapper`, `CreditGuarantorSubmission`?**
  _High betweenness centrality (0.038) - this node is a cross-community bridge._
- **Should `SolicitudCooperativaRepository` be split into smaller, more focused modules?**
  _Cohesion score 0.09276018099547512 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboardingRequest` connect `DireccionOnboarding` to `lombok.Getter`, `org.springframework.security.access.prepost.PreAuthorize`, `IngresoEgresoRequest`, `.crearSolicitudConSolicitante`, `DireccionOnboarding`, `OnboardingServiceImpl`, `SolicitudOnboardingRequest`, `bigdecimal`, `lombok.RequiredArgsConstructor`, `SolicitudOnboardingRequest`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **Should `SolicitudCooperativa` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._