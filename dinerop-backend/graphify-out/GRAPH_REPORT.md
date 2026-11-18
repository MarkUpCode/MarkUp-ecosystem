# Graph Report - dinerop-backend  (2026-11-18)

## Corpus Check
- 297 files · ~38,992 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1879 nodes · 5221 edges · 110 communities (51 shown, 59 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 390 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2f94400a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.Getter
- CreditRequest
- org.springframework.web.bind.annotation.ResponseStatus
- CooperativeAdminService
- AuthController
- PersonaOnboarding
- InvitationServiceTest.java
- CooperativeRate
- PublicCreditOffersController.java
- .verifyPasswordResetOtp
- SecurityActivityTest.java
- OnboardingClienteController.java
- CooperativeService
- InvestmentService
- ClientCreditRequestDto
- FinancialProduct
- JwtAuthenticationFilter.java
- lombok.RequiredArgsConstructor
- SolicitudOnboarding
- SecurityActivityTest
- SolicitudCooperativaCotizacion
- .getDashboard
- UserDetailResponse
- InternalCooperativeDto
- PasswordResetToken
- CreditRequirement
- OnboardingMapper
- InvestmentRequest
- JwtService
- User
- ResetPasswordRequest
- org.springframework.http.ResponseEntity
- TestEmailController
- .publicRegister
- FinancialProductService
- notblank
- DireccionOnboarding
- auth/config/SecurityConfig.java
- InvestmentAcceptanceRecord.java
- postgres
- OnboardingMapper
- SolicitudCooperativaStatus
- .findBySolicitudIdAndCooperativaId
- application-prod.yaml
- Cooperative
- InvestmentService
- PagedUsersResponse
- ActividadEconomica
- UserAdminService.java
- IngresoEgresoRequest
- CreditProcessEvent
- list
- IngresoEgreso
- InvitationServiceTest.java
- AccountDisabledException
- OnboardingServiceImpl.java
- .handleBadRequest
- CreditGuarantorSubmission
- EstadoFormulario
- CooperativeNotFoundException
- PersonaOnboardingResponse
- tomcat
- CreditOfferEmailBuilder
- OtpRateLimitException
- PreRegisterRequest
- hikari
- management
- DireccionOnboarding
- LinkClientRequest
- PreRegisterRequest
- PreRegisterResponse
- PushNotificationController
- flyway
- hibernate
- level
- org.springframework.transaction.annotation.Transactional
- DineropBackendApplication.java
- spring
- org.junit.jupiter.api.Test
- datasource
- CooperativeInvestmentController
- com.markup:dinerop-backend
- UserRepository
- bigdecimal
- CreditService
- OnboardingServiceImpl
- org.springframework.http.HttpStatus
- OnboardingUnificadoResponse
- UserPreRegistration
- CreditRequest.java
- PushDeviceToken
- .startRegistrationOtp
- InvestmentService.java
- InternalCreditController

## God Nodes (most connected - your core abstractions)
1. `User` - 102 edges
2. `UserRepository` - 50 edges
3. `AuthService` - 47 edges
4. `SolicitudCooperativaRepository` - 47 edges
5. `NotificationService` - 41 edges
6. `CooperativeService` - 40 edges
7. `CreditService` - 40 edges
8. `CreditRequest` - 38 edges
9. `Cooperative` - 37 edges
10. `CooperativeRepository` - 36 edges

## Surprising Connections (you probably didn't know these)
- `CooperativeAdminService` --references--> `CooperativeRateRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/cooperative/service/CooperativeAdminService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRateRepository.java
- `CooperativeAdminService` --references--> `CooperativeRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/cooperative/service/CooperativeAdminService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRepository.java
- `RecentCreditDto` --references--> `CreditRequestStatus`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/dashboard/dto/RecentCreditDto.java → src/main/java/com/markup/dinerop/credit/domain/model/enums/CreditRequestStatus.java
- `RecentUserDto` --references--> `Role`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/dashboard/dto/RecentUserDto.java → src/main/java/com/markup/dinerop/auth/entity/Role.java
- `DashboardService` --references--> `UserRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/dashboard/service/DashboardService.java → src/main/java/com/markup/dinerop/auth/repository/UserRepository.java

## Import Cycles
- None detected.

## Communities (110 total, 59 thin omitted)

### Community 0 - "lombok.Getter"
Cohesion: 0.06
Nodes (23): ChangeRegistrationEmailRequest, CompleteRegistrationRequest, JwtResponse, LoginRequest, LoginResponse, UserInfo, OtpResendRequest, OtpVerificationRequest (+15 more)

### Community 1 - "CreditRequest"
Cohesion: 0.07
Nodes (4): CreditRequest, SolicitudCooperativa, CreditRequestRepository, ClientCreditQueryAcceptedStatusTest

### Community 3 - "CooperativeAdminService"
Cohesion: 0.13
Nodes (7): CooperativeAdminController, CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeNotFoundException, CooperativeAdminMapper, CooperativeAdminService

### Community 5 - "PersonaOnboarding"
Cohesion: 0.11
Nodes (11): PersonaOnboarding, EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE (+3 more)

### Community 7 - "InvitationServiceTest.java"
Cohesion: 0.17
Nodes (10): ActivationTokenRepository, EmailVerificationOtpRepository, PasswordResetTokenRepository, UserPreRegistrationRepository, NotificationService, AuthServiceOtpFlowTest, AuthServicePasswordResetOtpTest, AuthServiceSecurityActivityTest (+2 more)

### Community 8 - "CooperativeRate"
Cohesion: 0.13
Nodes (5): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository

### Community 9 - "PublicCreditOffersController.java"
Cohesion: 0.15
Nodes (5): CreditProductCategory, CONSUMO, MICROCREDITO, PublicCreditOfferResponse, PublicCreditOffersController

### Community 10 - ".verifyPasswordResetOtp"
Cohesion: 0.11
Nodes (4): PasswordResetOtpVerificationRequest, OtpAttemptsExceededException, OtpExpiredException, OtpInvalidException

### Community 13 - "CooperativeService"
Cohesion: 0.17
Nodes (4): CooperativeService, CooperativeDto, CreateCooperativeDto, CooperativeController

### Community 14 - "InvestmentService"
Cohesion: 0.12
Nodes (14): InvestmentRequestStatus, CONDITIONS_CONFIRMED, DECLINED, IN_REVIEW, INFORMATION_REQUIRED, SUBMITTED, InvestmentService, InvestmentAcceptanceRequest (+6 more)

### Community 16 - "FinancialProduct"
Cohesion: 0.15
Nodes (4): FinancialProduct, FinancialProductType, CREDIT, INVESTMENT

### Community 18 - "lombok.RequiredArgsConstructor"
Cohesion: 0.17
Nodes (14): LoanCalculator, ClientCreditAcceptanceService, ClientCreditCooperativeStatusService, ClientCreditQueryService, CooperativeCreditDecisionService, CooperativeCreditQueryService, CreditDistributionService, CreditProcessEventRepository (+6 more)

### Community 19 - "SolicitudOnboarding"
Cohesion: 0.10
Nodes (8): OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, ObtenerOnboardingUnificadoUseCase, SolicitarGaranteUseCase, OnboardingClienteController, SolicitudOnboarding, GuarantorProfileResponse

### Community 22 - ".getDashboard"
Cohesion: 0.06
Nodes (13): DashboardController, CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, RecentCreditDto, RecentUserDto, UserStatsDto, VisitStatsDto (+5 more)

### Community 23 - "UserDetailResponse"
Cohesion: 0.16
Nodes (5): UserAdminController, ChangeStatusRequest, CreateUserRequest, UserDetailResponse, UserAdminService

### Community 27 - "OnboardingMapper"
Cohesion: 0.14
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaPersonalResponse, ReferenciaPersonalRepository

### Community 35 - "FinancialProductService"
Cohesion: 0.13
Nodes (6): FinancialProductAdminController, FinancialProductCondition, FinancialProductService, FinancialProductConditionRequest, FinancialProductRequest, Condition

### Community 37 - "DireccionOnboarding"
Cohesion: 0.12
Nodes (3): ActividadEconomicaRequest, PersonaOnboardingRequest, ReferenciaRequest

### Community 38 - "auth/config/SecurityConfig.java"
Cohesion: 0.06
Nodes (7): OpenApiConfig, SecurityConfig, WebClientConfig, CustomUserDetailsService, PasswordEncoderConfig, FirebaseConfig, ResendConfig

### Community 39 - "InvestmentAcceptanceRecord.java"
Cohesion: 0.25
Nodes (4): EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "SolicitudCooperativaStatus"
Cohesion: 0.20
Nodes (7): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, CooperativeCreditRequestItemDto

### Community 44 - ".findBySolicitudIdAndCooperativaId"
Cohesion: 0.19
Nodes (4): CreditGuarantorWorkflowService, TypeReference<>, CreditGuarantorEvaluationDto, CreditGuarantorHistoryItemDto

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 46 - "Cooperative"
Cohesion: 0.16
Nodes (4): CooperativeListItemResponse, PagedCooperativesResponse, CooperativeSpecification, Cooperative

### Community 48 - "InvestmentService"
Cohesion: 0.09
Nodes (13): InterestPaymentOption, AT_MATURITY, MONTHLY, REINVEST, InvestmentCalculationMethod, MONTHLY_COMPOUNDING, SIMPLE_INTEREST, UNSPECIFIED (+5 more)

### Community 50 - "ActividadEconomica"
Cohesion: 0.17
Nodes (3): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository

### Community 51 - "UserAdminService.java"
Cohesion: 0.23
Nodes (3): UserListItemResponse, UserNotFoundException, UserAdminMapper

### Community 55 - "IngresoEgreso"
Cohesion: 0.17
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 56 - "InvitationServiceTest.java"
Cohesion: 0.06
Nodes (7): InvitationController, InvitationActivationRequest, InvitationDetailsResponse, CooperativeInvitation, CooperativeInvitationRepository, InvitationService, InvitationServiceTest

### Community 59 - ".handleBadRequest"
Cohesion: 0.15
Nodes (5): ApiErrorResponse, AdminGlobalExceptionHandler, CooperativeRequiredException, InvalidUserRoleException, UserAlreadyExistsException

### Community 60 - "CreditGuarantorSubmission"
Cohesion: 0.07
Nodes (11): CreditGuarantorEvaluation, CreditGuarantorSubmission, CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA (+3 more)

### Community 62 - "EstadoFormulario"
Cohesion: 0.15
Nodes (6): EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, SolicitudOnboardingRequest, FormularioClienteStatusResponse

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 66 - "CreditOfferEmailBuilder"
Cohesion: 0.09
Nodes (4): ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate, EmailTemplateEngine

### Community 68 - "PreRegisterRequest"
Cohesion: 0.11
Nodes (3): InternalAuthController, PreRegisterRequest, PreRegisterResponse

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 73 - "DireccionOnboarding"
Cohesion: 0.10
Nodes (7): DireccionOnboarding, TipoVivienda, ARRENDADA, PROPIA, DireccionRequest, DireccionOnboardingResponse, DireccionOnboardingRepository

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

### Community 89 - "CooperativeInvestmentController"
Cohesion: 0.15
Nodes (3): FinancialProductResponse, CooperativeInvestmentController, FinancialProductController

### Community 103 - "UserRepository"
Cohesion: 0.11
Nodes (11): ChangeRoleRequest, AdminBootstrapRunner, InviteUserRequest, Role, ADMIN, CLIENT, COOPERATIVE, UserRepository (+3 more)

### Community 106 - "CreditService"
Cohesion: 0.08
Nodes (11): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, CreditService, CooperativeDecisionRequestDto, CooperativeOfferDefaultsDto (+3 more)

### Community 107 - "OnboardingServiceImpl"
Cohesion: 0.13
Nodes (5): OnboardingServiceImpl, OnboardingCooperativaController, BusinessException, ResourceNotFoundException, SolicitudOnboardingRepository

### Community 112 - "CreditRequest.java"
Cohesion: 0.14
Nodes (7): CreditRequestType, CREDITO, INVERSION, CreditType, CONSUMO, MICROCREDITO, PublicCreditRequestDto

### Community 118 - ".startRegistrationOtp"
Cohesion: 0.21
Nodes (3): UserAlreadyActiveException, AuthService, PublicCreditRequestResult

### Community 131 - "InternalCreditController"
Cohesion: 0.10
Nodes (3): LinkClientRequestDto, LinkClientResponseDto, InternalCreditController

## Knowledge Gaps
- **58 isolated node(s):** `com.markup:dinerop-backend`, `CLIENT`, `COOPERATIVE`, `ADMIN`, `CONSUMO` (+53 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 633 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **59 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `lombok.Getter`, `CreditRequest`, `InvestmentService.java`, `lombok.RequiredArgsConstructor`, `InvitationServiceTest.java`, `.verifyPasswordResetOtp`, `SecurityActivityTest.java`, `OnboardingClienteController.java`, `InvestmentService`, `ClientCreditRequestDto`, `JwtAuthenticationFilter.java`, `lombok.RequiredArgsConstructor`, `SolicitudOnboarding`, `.getDashboard`, `UserDetailResponse`, `PasswordResetToken`, `JwtService`, `auth/config/SecurityConfig.java`, `.findBySolicitudIdAndCooperativaId`, `lombok`, `InvestmentService`, `UserAdminService.java`, `list`, `InvitationServiceTest.java`, `PushNotificationController`, `org.springframework.transaction.annotation.Transactional`, `org.junit.jupiter.api.Test`, `CooperativeInvestmentController`, `UserRepository`, `CreditService`, `OnboardingServiceImpl`, `OnboardingUnificadoResponse`, `PushDeviceToken`, `.startRegistrationOtp`?**
  _High betweenness centrality (0.108) - this node is a cross-community bridge._
- **What connects `com.markup:dinerop-backend`, `CLIENT`, `COOPERATIVE` to the rest of the system?**
  _58 weakly-connected nodes found - possible missing edges._
- **Should `lombok.Getter` be split into smaller, more focused modules?**
  _Cohesion score 0.06493506493506493 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboarding` connect `PersonaOnboarding` to `PersonaOnboardingResponse`, `OnboardingMapper`, `DireccionOnboarding`, `.findBySolicitudIdAndCooperativaId`, `lombok`, `lombok.RequiredArgsConstructor`, `ActividadEconomica`, `SolicitudOnboarding`, `IngresoEgreso`, `OnboardingServiceImpl.java`, `OnboardingMapper`, `CreditGuarantorSubmission`, `EstadoFormulario`?**
  _High betweenness centrality (0.038) - this node is a cross-community bridge._
- **Should `CreditRequest` be split into smaller, more focused modules?**
  _Cohesion score 0.06852497096399536 - nodes in this community are weakly interconnected._
- **Why does `SolicitudCooperativaCotizacion` connect `SolicitudCooperativaCotizacion` to `CreditService`, `lombok`, `CreditRequest.java`, `lombok.RequiredArgsConstructor`, `list`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.1310344827586207 - nodes in this community are weakly interconnected._