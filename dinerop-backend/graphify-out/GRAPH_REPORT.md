# Graph Report - dinerop-backend  (2026-11-18)

## Corpus Check
- 293 files · ~38,142 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1857 nodes · 5097 edges · 116 communities (53 shown, 63 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 372 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e229d99f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.Getter
- CreditRequest
- org.springframework.web.bind.annotation.ResponseStatus
- CooperativeAdminService
- jakarta.transaction.Transactional
- PersonaOnboarding
- lombok.RequiredArgsConstructor
- InvitationServiceTest.java
- CooperativeRate
- PublicCreditOffersController.java
- CreditGuarantorWorkflowService.java
- OnboardingClienteController.java
- CooperativeService
- InvestmentService
- NotificationService
- FinancialProduct
- InvitationActivationRequest
- org.springframework.stereotype.Service
- SolicitudOnboarding
- CreditService.java
- PageVisitRepository
- UserDetailResponse
- InternalCooperativeDto
- PasswordResetToken
- CreditRequirement
- OnboardingMapper
- auth/config/SecurityConfig.java
- org.junit.jupiter.api.Test
- User
- LinkClientResponseDto
- org.springframework.http.ResponseEntity
- TestEmailController
- .publicRegister
- FinancialProductService
- notblank
- DireccionOnboarding
- org.springframework.context.annotation.Bean
- .details
- postgres
- OnboardingMapper
- SolicitudCooperativa
- CreditGuarantorWorkflowService
- .findBySolicitudIdAndCooperativaId
- application-prod.yaml
- Cooperative
- InvestmentService
- UserRepository
- ActividadEconomica
- UserAdminService.java
- .toEvaluationDto
- CreditProcessEvent
- list
- IngresoEgreso
- CooperativeInvitation
- OnboardingServiceImpl.java
- .handleBadRequest
- CreditGuarantorSubmission
- OnboardingServiceImpl.java
- FirebaseConfig.java
- PersonaOnboardingResponse
- tomcat
- CreditOfferEmailBuilder
- OnboardingClienteController.java
- PreRegisterRequest
- hikari
- management
- CooperativeInvestmentController.java
- Role
- DireccionOnboarding
- LinkClientRequest
- CreditGuarantorEvaluation
- PreRegisterRequest
- PreRegisterResponse
- PushNotificationController
- flyway
- hibernate
- level
- org.springframework.transaction.annotation.Transactional
- DineropBackendApplication.java
- AccountNotActiveException
- spring
- AuthServiceSecurityActivityTest
- datasource
- CooperativeInvestmentController
- com.markup:dinerop-backend
- AuthService.java
- CreditRejectionReason
- OnboardingServiceImpl
- InvitationService
- org.springframework.http.HttpStatus
- OnboardingUnificadoResponse
- UserPreRegistration
- CreditRequest.java
- PushDeviceToken
- ForgotPasswordRequest
- .startRegistrationOtp
- InternalCreditController

## God Nodes (most connected - your core abstractions)
1. `User` - 99 edges
2. `UserRepository` - 48 edges
3. `SolicitudCooperativaRepository` - 47 edges
4. `AuthService` - 45 edges
5. `CooperativeService` - 40 edges
6. `CreditService` - 40 edges
7. `CreditRequest` - 38 edges
8. `NotificationService` - 38 edges
9. `Cooperative` - 37 edges
10. `FinancialProductService` - 36 edges

## Surprising Connections (you probably didn't know these)
- `InvestmentAcceptanceResponse` --references--> `Requirement`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/dto/InvestmentAcceptanceResponse.java → src/main/java/com/markup/dinerop/cooperative/dto/InvestmentAcceptanceRequest.java
- `CooperativeAdminService` --references--> `CooperativeAdminMapper`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/cooperative/service/CooperativeAdminService.java → src/main/java/com/markup/dinerop/admin/cooperative/mapper/CooperativeAdminMapper.java
- `CooperativeAdminService` --references--> `CooperativeRateRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/cooperative/service/CooperativeAdminService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRateRepository.java
- `CooperativeAdminService` --references--> `CooperativeRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/cooperative/service/CooperativeAdminService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRepository.java
- `DashboardController` --references--> `DashboardService`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/dashboard/controller/DashboardController.java → src/main/java/com/markup/dinerop/admin/dashboard/service/DashboardService.java

## Import Cycles
- None detected.

## Communities (116 total, 63 thin omitted)

### Community 0 - "lombok.Getter"
Cohesion: 0.06
Nodes (24): AuthController, ChangeRegistrationEmailRequest, CompleteRegistrationRequest, JwtResponse, LoginRequest, LoginResponse, UserInfo, OtpRegistrationStartResponse (+16 more)

### Community 1 - "CreditRequest"
Cohesion: 0.09
Nodes (8): RecentCreditDto, DashboardService, CreditRequest, CreditRequestStatus, CREADA, ENVIADA, CreditRequestRepository, ClientCreditQueryAcceptedStatusTest

### Community 3 - "CooperativeAdminService"
Cohesion: 0.13
Nodes (5): CooperativeAdminController, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeNotFoundException, CooperativeAdminService

### Community 5 - "PersonaOnboarding"
Cohesion: 0.13
Nodes (7): PersonaOnboarding, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE, GARANTE, SOLICITANTE, PersonaOnboardingRepository

### Community 7 - "InvitationServiceTest.java"
Cohesion: 0.11
Nodes (4): InvitationServiceTest, ClientCreditQuerySecurityTest, CooperativeCreditDecisionServiceTest, CreditGuarantorWorkflowServiceTest

### Community 8 - "CooperativeRate"
Cohesion: 0.10
Nodes (6): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto

### Community 9 - "PublicCreditOffersController.java"
Cohesion: 0.23
Nodes (5): CreditProductCategory, CONSUMO, MICROCREDITO, PublicCreditOfferResponse, PublicCreditOffersController

### Community 10 - "CreditGuarantorWorkflowService.java"
Cohesion: 0.17
Nodes (6): CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA

### Community 13 - "CooperativeService"
Cohesion: 0.13
Nodes (4): CooperativeService, CooperativeDto, CreateCooperativeDto, CooperativeController

### Community 14 - "InvestmentService"
Cohesion: 0.08
Nodes (18): InvestmentAcceptanceRecord, InvestmentRequestStatus, CONDITIONS_CONFIRMED, DECLINED, IN_REVIEW, INFORMATION_REQUIRED, SUBMITTED, InvestmentAcceptanceRepository (+10 more)

### Community 16 - "FinancialProduct"
Cohesion: 0.11
Nodes (5): FinancialProduct, FinancialProductCondition, FinancialProductConditionRepository, FinancialProductRepository, FinancialProductServiceTest

### Community 18 - "org.springframework.stereotype.Service"
Cohesion: 0.14
Nodes (11): ClientCreditAcceptanceService, ClientCreditCooperativeStatusService, ClientCreditQueryService, CooperativeCreditQueryService, CooperativeCreditRequestItemDto, CreditProcessEventRepository, SolicitudCooperativaRepository, CreditController (+3 more)

### Community 19 - "SolicitudOnboarding"
Cohesion: 0.13
Nodes (7): OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, ObtenerOnboardingUnificadoUseCase, SolicitarGaranteUseCase, OnboardingCooperativaController, SolicitudOnboarding

### Community 21 - "CreditService.java"
Cohesion: 0.08
Nodes (7): SolicitudCooperativaCotizacion, LoanCalculationResult, LoanCalculator, CooperativeCreditDecisionService, CooperativeOfferDefaultsDto, CreditRequirementDto, SolicitudCooperativaCotizacionRepository

### Community 22 - "PageVisitRepository"
Cohesion: 0.14
Nodes (4): PageVisit, PageVisitRepository, VisitService, VisitController

### Community 23 - "UserDetailResponse"
Cohesion: 0.13
Nodes (6): UserAdminController, ChangeStatusRequest, CreateUserRequest, UserDetailResponse, UserNotFoundException, UserAdminService

### Community 25 - "PasswordResetToken"
Cohesion: 0.12
Nodes (3): ResetPasswordRequest, PasswordResetToken, PasswordResetTokenRepository

### Community 27 - "OnboardingMapper"
Cohesion: 0.14
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaPersonalResponse, ReferenciaPersonalRepository

### Community 29 - "org.junit.jupiter.api.Test"
Cohesion: 0.05
Nodes (5): JwtAuthenticationFilter, JwtService, AuthenticatedRequestResult, DineropBackendApplicationTests, SecurityActivityTest

### Community 35 - "FinancialProductService"
Cohesion: 0.12
Nodes (6): FinancialProductAdminController, FinancialProductService, FinancialProductConditionRequest, Condition, FinancialProductResponse, FinancialProductController

### Community 37 - "DireccionOnboarding"
Cohesion: 0.12
Nodes (3): ActividadEconomicaRequest, IngresoEgresoRequest, PersonaOnboardingRequest

### Community 38 - "org.springframework.context.annotation.Bean"
Cohesion: 0.15
Nodes (4): OpenApiConfig, WebClientConfig, PasswordEncoderConfig, ResendConfig

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "SolicitudCooperativa"
Cohesion: 0.09
Nodes (7): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, SolicitudCooperativa

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 46 - "Cooperative"
Cohesion: 0.15
Nodes (6): CreateCooperativeRequest, CooperativeListItemResponse, PagedCooperativesResponse, CooperativeAdminMapper, CooperativeSpecification, Cooperative

### Community 48 - "InvestmentService"
Cohesion: 0.14
Nodes (10): InterestPaymentOption, AT_MATURITY, MONTHLY, REINVEST, InvestmentCalculationMethod, MONTHLY_COMPOUNDING, SIMPLE_INTEREST, UNSPECIFIED (+2 more)

### Community 50 - "ActividadEconomica"
Cohesion: 0.17
Nodes (3): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository

### Community 51 - "UserAdminService.java"
Cohesion: 0.18
Nodes (4): PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserAdminMapper

### Community 54 - "list"
Cohesion: 0.17
Nodes (4): CooperativeRepository, InvestmentRequestStatusEventRepository, CreditGuarantorEvaluationRepository, CreditGuarantorSubmissionRepository

### Community 55 - "IngresoEgreso"
Cohesion: 0.17
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 59 - ".handleBadRequest"
Cohesion: 0.19
Nodes (4): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException

### Community 62 - "OnboardingServiceImpl.java"
Cohesion: 0.14
Nodes (12): EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO (+4 more)

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 66 - "CreditOfferEmailBuilder"
Cohesion: 0.14
Nodes (3): ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate

### Community 67 - "OnboardingClienteController.java"
Cohesion: 0.18
Nodes (3): DashboardController, OnboardingClienteController, GuarantorProfileResponse

### Community 68 - "PreRegisterRequest"
Cohesion: 0.11
Nodes (3): InternalAuthController, PreRegisterRequest, PreRegisterResponse

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 71 - "CooperativeInvestmentController.java"
Cohesion: 0.17
Nodes (6): FinancialProductType, CREDIT, INVESTMENT, FinancialProductRequest, InvestmentAcceptanceRequest, Requirement

### Community 72 - "Role"
Cohesion: 0.10
Nodes (11): CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, RecentUserDto, UserStatsDto, VisitStatsDto, ChangeRoleRequest, Role (+3 more)

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

### Community 86 - "AuthServiceSecurityActivityTest"
Cohesion: 0.22
Nodes (3): ActivationTokenRepository, AuthServiceOtpFlowTest, AuthServiceSecurityActivityTest

### Community 87 - "datasource"
Cohesion: 0.40
Nodes (5): driver-class-name, password, url, username, datasource

### Community 103 - "AuthService.java"
Cohesion: 0.11
Nodes (5): AdminBootstrapRunner, AccountDisabledException, CooperativeNotFoundException, OtpAttemptsExceededException, OtpExpiredException

### Community 106 - "CreditRejectionReason"
Cohesion: 0.15
Nodes (9): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, CreditService, PublicCreditRequestResult, CooperativeDecisionRequestDto (+1 more)

### Community 107 - "OnboardingServiceImpl"
Cohesion: 0.19
Nodes (4): OnboardingServiceImpl, BusinessException, ResourceNotFoundException, SolicitudOnboardingRepository

### Community 112 - "CreditRequest.java"
Cohesion: 0.11
Nodes (8): CreditRequestType, CREDITO, INVERSION, CreditType, CONSUMO, MICROCREDITO, ClientCreditRequestDto, PublicCreditRequestDto

### Community 118 - ".startRegistrationOtp"
Cohesion: 0.17
Nodes (5): OtpInvalidException, OtpRateLimitException, UserAlreadyActiveException, EmailVerificationOtpRepository, AuthService

## Knowledge Gaps
- **58 isolated node(s):** `com.markup:dinerop-backend`, `CLIENT`, `COOPERATIVE`, `ADMIN`, `CONSUMO` (+53 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 631 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **63 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `lombok.Getter`, `InvestmentService.java`, `jakarta.transaction.Transactional`, `lombok.RequiredArgsConstructor`, `InvitationServiceTest.java`, `OnboardingClienteController.java`, `InvestmentService`, `org.springframework.stereotype.Service`, `SolicitudOnboarding`, `CreditService.java`, `UserDetailResponse`, `PasswordResetToken`, `org.junit.jupiter.api.Test`, `.findBySolicitudIdAndCooperativaId`, `lombok`, `UserRepository`, `UserAdminService.java`, `list`, `CooperativeInvitation`, `OnboardingServiceImpl.java`, `OnboardingClienteController.java`, `CooperativeInvestmentController.java`, `Role`, `PushNotificationController`, `AuthServiceSecurityActivityTest`, `CooperativeInvestmentController`, `AuthService.java`, `CreditRejectionReason`, `InvitationService`, `OnboardingUnificadoResponse`, `PushDeviceToken`, `.startRegistrationOtp`?**
  _High betweenness centrality (0.103) - this node is a cross-community bridge._
- **What connects `com.markup:dinerop-backend`, `CLIENT`, `COOPERATIVE` to the rest of the system?**
  _58 weakly-connected nodes found - possible missing edges._
- **Should `lombok.Getter` be split into smaller, more focused modules?**
  _Cohesion score 0.05975485188968335 - nodes in this community are weakly interconnected._
- **Why does `AuthService` connect `.startRegistrationOtp` to `lombok.Getter`, `.publicRegister`, `PreRegisterRequest`, `jakarta.transaction.Transactional`, `lombok.RequiredArgsConstructor`, `AuthService.java`, `CreditRejectionReason`, `InvestmentService`, `UserPreRegistration`, `NotificationService`, `UserRepository`, `org.springframework.stereotype.Service`, `CreditService.java`, `AuthServiceSecurityActivityTest`, `list`, `PasswordResetToken`, `org.junit.jupiter.api.Test`?**
  _High betweenness centrality (0.038) - this node is a cross-community bridge._
- **Should `CreditRequest` be split into smaller, more focused modules?**
  _Cohesion score 0.08771929824561403 - nodes in this community are weakly interconnected._
- **Why does `UserRepository` connect `UserRepository` to `CreditRequest`, `InvestmentService.java`, `jakarta.transaction.Transactional`, `PersonaOnboarding`, `InvitationServiceTest.java`, `InvestmentService`, `org.springframework.stereotype.Service`, `CreditService.java`, `UserDetailResponse`, `org.junit.jupiter.api.Test`, `User`, `UserAdminService.java`, `list`, `OnboardingServiceImpl.java`, `Role`, `org.springframework.transaction.annotation.Transactional`, `AuthServiceSecurityActivityTest`, `AuthService.java`, `CreditRejectionReason`, `OnboardingServiceImpl`, `InvitationService`, `PushDeviceToken`, `.startRegistrationOtp`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.13230769230769232 - nodes in this community are weakly interconnected._