# Graph Report - dinerop-backend  (2026-11-18)

## Corpus Check
- 307 files · ~40,246 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1960 nodes · 5453 edges · 125 communities (56 shown, 69 thin omitted)
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 413 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7e59bae2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.Getter
- CreditRequest
- CooperativeAdminService
- AuthController
- PersonaOnboarding
- lombok.RequiredArgsConstructor
- InvitationServiceTest.java
- CooperativeRate
- PublicCreditOffersController.java
- .verifyPasswordResetOtp
- SecurityActivityTest.java
- SolicitudOnboardingRequest
- CooperativeService
- bigdecimal
- ClientCreditRequestDto
- FinancialProduct
- JwtAuthenticationFilter.java
- org.springframework.stereotype.Service
- OnboardingService
- SecurityActivityTest
- SolicitudCooperativaCotizacion
- PageVisitRepository
- UserDetailResponse
- InternalCooperativeDto
- PasswordResetToken
- CreditRequirement
- OnboardingMapper
- FinancialProductService
- JwtService
- User
- CreditRequestStatus
- org.springframework.http.ResponseEntity
- TestEmailController
- .publicRegister
- FinancialProductService
- notblank
- DireccionOnboarding
- auth/config/SecurityConfig.java
- postgres
- OnboardingMapper
- CreditService.java
- .findBySolicitudIdAndCooperativaId
- application-prod.yaml
- Cooperative
- InvestmentService
- UserRepository
- ActividadEconomica
- UserAdminService.java
- org.springframework.context.annotation.Configuration
- CreditProcessEvent
- list
- IngresoEgreso
- CooperativeInvitation
- AccountDisabledException
- OnboardingServiceImpl.java
- .handleBadRequest
- CreditGuarantorSubmission
- org.springframework.security.access.prepost.PreAuthorize
- CooperativeNotFoundException
- PersonaOnboardingResponse
- tomcat
- CreditOfferEmailBuilder
- InvitationService
- PreRegisterRequest
- hikari
- management
- CreditProductCategory
- AuthServicePasswordResetOtpTest.java
- DireccionOnboarding
- LinkClientRequest
- CooperativeCreditProductController
- PreRegisterRequest
- PreRegisterResponse
- PushNotificationController
- flyway
- hibernate
- level
- Cooperative
- DineropBackendApplication.java
- CreditGuarantorEvaluation
- spring
- FinancialProductServiceTest.java
- datasource
- FirebaseConfig.java
- CooperativeInvestmentController
- com.markup:dinerop-backend
- Role
- InvitationService.java
- .findByEmail
- CooperativeService
- OnboardingServiceImpl
- CreditGuarantorWorkflowServiceTest
- org.springframework.http.HttpStatus
- OnboardingCooperativaController.java
- UserPreRegistration
- CreditRequest.java
- OpenApiConfig.java
- CustomUserDetailsService.java
- PushDeviceToken
- ActivationToken
- CreditGuarantorStatus
- .startRegistrationOtp
- LinkClientRequestDto
- FinancialProductRequest
- AccountNotActiveException
- InternalCreditController

## God Nodes (most connected - your core abstractions)
1. `User` - 89 edges
2. `AuthService` - 47 edges
3. `SolicitudCooperativaRepository` - 47 edges
4. `UserRepository` - 46 edges
5. `FinancialProductService` - 42 edges
6. `CreditService` - 40 edges
7. `CooperativeService` - 40 edges
8. `NotificationService` - 39 edges
9. `CreditRequest` - 38 edges
10. `Cooperative` - 37 edges

## Surprising Connections (you probably didn't know these)
- `InvestmentCalculationSettings` --references--> `InvestmentCalculationMethod`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentCalculationSettings.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentCalculationMethod.java
- `InvestmentCalculationSettingsService` --references--> `InvestmentCalculationSettingsRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/InvestmentCalculationSettingsService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/InvestmentCalculationSettingsRepository.java
- `CooperativeService` --references--> `FinancialProductService`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/CooperativeService.java → src/main/java/com/markup/dinerop/cooperative/domain/service/FinancialProductService.java
- `FinancialProductService` --references--> `CooperativeRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/FinancialProductService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRepository.java
- `FinancialProductService` --references--> `FinancialProductConditionRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/FinancialProductService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/FinancialProductConditionRepository.java

## Import Cycles
- None detected.

## Communities (125 total, 69 thin omitted)

### Community 0 - "lombok.Getter"
Cohesion: 0.05
Nodes (23): ChangeRegistrationEmailRequest, JwtResponse, LoginRequest, LoginResponse, UserInfo, OtpResendRequest, OtpVerificationRequest, PasswordResetOtpVerificationResponse (+15 more)

### Community 1 - "CreditRequest"
Cohesion: 0.08
Nodes (4): CreditRequest, SolicitudCooperativa, CreditRequestRepository, ClientCreditQueryAcceptedStatusTest

### Community 3 - "CooperativeAdminService"
Cohesion: 0.11
Nodes (7): CooperativeAdminController, CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeNotFoundException, CooperativeAdminMapper, CooperativeAdminService

### Community 4 - "AuthController"
Cohesion: 0.15
Nodes (3): AuthController, CompleteRegistrationRequest, ForgotPasswordRequest

### Community 5 - "PersonaOnboarding"
Cohesion: 0.09
Nodes (12): PersonaOnboarding, EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE (+4 more)

### Community 7 - "InvitationServiceTest.java"
Cohesion: 0.16
Nodes (8): AdminBootstrapRunner, EmailVerificationOtpRepository, PasswordResetTokenRepository, UserPreRegistrationRepository, AuthServiceOtpFlowTest, AuthServiceSecurityActivityTest, InvitationServiceTest, ClientCreditQuerySecurityTest

### Community 8 - "CooperativeRate"
Cohesion: 0.11
Nodes (6): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto

### Community 9 - "PublicCreditOffersController.java"
Cohesion: 0.18
Nodes (5): InvestmentCalculationSettingsService, InvestmentCalculationSettingsResponse, UpdateInvestmentCalculationSettingsRequest, AdminInvestmentCalculationSettingsController, PublicCreditOffersController

### Community 10 - ".verifyPasswordResetOtp"
Cohesion: 0.14
Nodes (3): PasswordResetOtpVerificationRequest, OtpAttemptsExceededException, OtpExpiredException

### Community 12 - "SolicitudOnboardingRequest"
Cohesion: 0.12
Nodes (6): EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE, SolicitudOnboardingRequest, SolicitudOnboardingResponse

### Community 13 - "CooperativeService"
Cohesion: 0.13
Nodes (3): CooperativeDto, CreateCooperativeDto, CooperativeController

### Community 14 - "bigdecimal"
Cohesion: 0.14
Nodes (4): InvestmentAcceptanceRequest, Requirement, InvestmentAcceptanceResponse, Requirement

### Community 16 - "FinancialProduct"
Cohesion: 0.17
Nodes (3): FinancialProduct, FinancialProductRepository, FinancialProductServiceTest

### Community 18 - "org.springframework.stereotype.Service"
Cohesion: 0.12
Nodes (11): ClientCreditAcceptanceService, ClientCreditCooperativeStatusService, ClientCreditQueryService, CooperativeCreditQueryService, CooperativeCreditRequestItemDto, CooperativeDecisionRequestDto, CreditProcessEventRepository, SolicitudCooperativaRepository (+3 more)

### Community 19 - "OnboardingService"
Cohesion: 0.28
Nodes (6): OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, ObtenerOnboardingUnificadoUseCase, SolicitarGaranteUseCase, OnboardingClienteController

### Community 22 - "PageVisitRepository"
Cohesion: 0.15
Nodes (4): PageVisit, PageVisitRepository, VisitService, VisitController

### Community 23 - "UserDetailResponse"
Cohesion: 0.14
Nodes (5): UserAdminController, ChangeStatusRequest, CreateUserRequest, UserDetailResponse, UserNotFoundException

### Community 26 - "CreditRequirement"
Cohesion: 0.18
Nodes (3): CreditRequirement, CreditRequirementRepository, CreditRequirementService

### Community 27 - "OnboardingMapper"
Cohesion: 0.14
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaPersonalResponse, ReferenciaPersonalRepository

### Community 28 - "FinancialProductService"
Cohesion: 0.16
Nodes (4): FinancialProductAdminController, FinancialProductService, FinancialProductResponse, FinancialProductController

### Community 31 - "CreditRequestStatus"
Cohesion: 0.11
Nodes (9): CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, RecentCreditDto, UserStatsDto, VisitStatsDto, CreditRequestStatus, CREADA (+1 more)

### Community 35 - "FinancialProductService"
Cohesion: 0.15
Nodes (4): FinancialProductCondition, FinancialProductConditionRepository, FinancialProductConditionRequest, Condition

### Community 37 - "DireccionOnboarding"
Cohesion: 0.11
Nodes (3): ActividadEconomicaRequest, IngresoEgresoRequest, PersonaOnboardingRequest

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "CreditService.java"
Cohesion: 0.10
Nodes (14): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, SolicitudCooperativaStatus, ACEPTADA, ENVIADA (+6 more)

### Community 44 - ".findBySolicitudIdAndCooperativaId"
Cohesion: 0.18
Nodes (4): CreditGuarantorWorkflowService, TypeReference<>, CreditGuarantorEvaluationDto, CreditGuarantorHistoryItemDto

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 46 - "Cooperative"
Cohesion: 0.28
Nodes (3): CooperativeListItemResponse, PagedCooperativesResponse, CooperativeSpecification

### Community 48 - "InvestmentService"
Cohesion: 0.07
Nodes (23): InterestPaymentOption, AT_MATURITY, MONTHLY, REINVEST, InvestmentCalculationMethod, MONTHLY_COMPOUNDING, SIMPLE_INTEREST, UNSPECIFIED (+15 more)

### Community 50 - "ActividadEconomica"
Cohesion: 0.17
Nodes (3): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository

### Community 51 - "UserAdminService.java"
Cohesion: 0.23
Nodes (4): PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserAdminMapper

### Community 52 - "org.springframework.context.annotation.Configuration"
Cohesion: 0.20
Nodes (3): WebClientConfig, PasswordEncoderConfig, ResendConfig

### Community 55 - "IngresoEgreso"
Cohesion: 0.17
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 56 - "CooperativeInvitation"
Cohesion: 0.13
Nodes (3): InvitationActivationRequest, CooperativeInvitation, CooperativeInvitationRepository

### Community 59 - ".handleBadRequest"
Cohesion: 0.15
Nodes (5): ApiErrorResponse, AdminGlobalExceptionHandler, CooperativeRequiredException, InvalidUserRoleException, UserAlreadyExistsException

### Community 62 - "org.springframework.security.access.prepost.PreAuthorize"
Cohesion: 0.20
Nodes (3): DashboardController, DashboardService, GuarantorProfileResponse

### Community 64 - "PersonaOnboardingResponse"
Cohesion: 0.15
Nodes (5): EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO, PersonaOnboardingResponse

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 66 - "CreditOfferEmailBuilder"
Cohesion: 0.10
Nodes (5): NotificationService, ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate, EmailTemplateEngine

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 71 - "CreditProductCategory"
Cohesion: 0.21
Nodes (7): CreditProductCategory, CONSUMO, MICROCREDITO, FinancialProductType, CREDIT, INVESTMENT, PublicCreditOfferResponse

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

### Community 103 - "Role"
Cohesion: 0.24
Nodes (7): RecentUserDto, ChangeRoleRequest, InviteUserRequest, Role, ADMIN, CLIENT, COOPERATIVE

### Community 106 - "CooperativeService"
Cohesion: 0.19
Nodes (6): CooperativeService, CooperativeCreditDecisionService, CreditService, CooperativeOfferDefaultsDto, SolicitudCooperativaCotizacionRepository, CooperativeCreditDecisionServiceTest

### Community 107 - "OnboardingServiceImpl"
Cohesion: 0.11
Nodes (5): OnboardingServiceImpl, SolicitudOnboarding, BusinessException, ResourceNotFoundException, SolicitudOnboardingRepository

### Community 109 - "org.springframework.http.HttpStatus"
Cohesion: 0.15
Nodes (3): ApiError, CreditExceptionHandler, OnboardingExceptionHandler

### Community 112 - "CreditRequest.java"
Cohesion: 0.14
Nodes (7): CreditRequestType, CREDITO, INVERSION, CreditType, CONSUMO, MICROCREDITO, PublicCreditRequestDto

### Community 115 - "PushDeviceToken"
Cohesion: 0.11
Nodes (4): CreditDistributionService, PushDeviceToken, PushDeviceTokenRepository, PushNotificationService

### Community 117 - "CreditGuarantorStatus"
Cohesion: 0.29
Nodes (6): CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA

### Community 118 - ".startRegistrationOtp"
Cohesion: 0.19
Nodes (5): OtpRegistrationStartResponse, OtpInvalidException, OtpRateLimitException, UserAlreadyActiveException, AuthService

## Knowledge Gaps
- **58 isolated node(s):** `ADMIN`, `CLIENT`, `COOPERATIVE`, `CREADA`, `ENVIADA` (+53 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 640 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **69 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `CreditController.java`, `lombok.RequiredArgsConstructor`, `InvitationServiceTest.java`, `SecurityActivityTest.java`, `SolicitudOnboardingRequest`, `ClientCreditRequestDto`, `JwtAuthenticationFilter.java`, `org.springframework.stereotype.Service`, `OnboardingService`, `SecurityActivityTest`, `UserDetailResponse`, `PasswordResetToken`, `JwtService`, `CreditRequestStatus`, `InvitationServiceTest.java`, `CreditService.java`, `jakarta.transaction.Transactional`, `.findBySolicitudIdAndCooperativaId`, `lombok`, `InvestmentService`, `UserRepository`, `UserAdminService.java`, `CreditProcessEvent`, `list`, `CooperativeInvitation`, `org.springframework.security.access.prepost.PreAuthorize`, `InvitationService`, `PushNotificationController`, `Role`, `.findByEmail`, `CooperativeService`, `OnboardingCooperativaController.java`, `CustomUserDetailsService.java`, `PushDeviceToken`, `ActivationToken`, `.startRegistrationOtp`, `.validCredentialsGenerateAccessToken`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **What connects `ADMIN`, `CLIENT`, `COOPERATIVE` to the rest of the system?**
  _58 weakly-connected nodes found - possible missing edges._
- **Should `lombok.Getter` be split into smaller, more focused modules?**
  _Cohesion score 0.05445665445665446 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboarding` connect `PersonaOnboarding` to `PersonaOnboardingResponse`, `OnboardingMapper`, `DireccionOnboarding`, `OnboardingServiceImpl`, `.findBySolicitudIdAndCooperativaId`, `lombok`, `org.springframework.stereotype.Service`, `ActividadEconomica`, `list`, `IngresoEgreso`, `OnboardingServiceImpl.java`, `OnboardingMapper`, `CreditGuarantorSubmission`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **Should `CreditRequest` be split into smaller, more focused modules?**
  _Cohesion score 0.08253968253968254 - nodes in this community are weakly interconnected._
- **Why does `InvestmentService` connect `InvestmentService` to `lombok.Getter`, `InvestmentService.java`, `FinancialProductService`, `lombok.RequiredArgsConstructor`, `AuthServicePasswordResetOtpTest.java`, `PublicCreditOffersController.java`, `FinancialProduct`, `org.springframework.stereotype.Service`, `Cooperative`, `FinancialProductServiceTest.java`, `list`, `CooperativeInvestmentController`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.11491935483870967 - nodes in this community are weakly interconnected._