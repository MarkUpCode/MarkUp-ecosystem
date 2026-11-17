# Graph Report - dinerop-backend  (2026-11-17)

## Corpus Check
- 282 files · ~36,446 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1947 nodes · 5069 edges · 128 communities (55 shown, 73 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 343 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `49ee4c13`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.Getter
- .getDashboard
- CreditControllerOnboardingGateTest.java
- CooperativeAdminService
- PersonaOnboarding
- lombok.RequiredArgsConstructor
- InvitationServiceTest.java
- CooperativeRate
- AuthService.java
- InvestmentRequestStatus
- SecurityActivityTest.java
- EstadoOnboarding
- CooperativeService
- PersonaOnboardingRequest
- CreditRequest
- FinancialProduct
- Cooperative
- CreditController
- org.springframework.stereotype.Component
- InternalCreditController
- SolicitudCooperativaRepository
- PageVisitRepository
- UserDetailResponse
- bigdecimal
- PasswordResetToken
- CreditRequirement
- ReferenciaPersonal
- auth/config/SecurityConfig.java
- JwtService
- User
- SolicitudCooperativaCotizacion
- org.springframework.http.ResponseEntity
- .toEvaluationDto
- .publicRegister
- FinancialProductService
- Role
- DireccionOnboarding
- org.springframework.context.annotation.Bean
- CreditGuarantorWorkflowService
- postgres
- OnboardingMapper
- .createMyRequest
- JwtAuthenticationFilter.java
- CreditGuarantorHistoryItemDto
- application-prod.yaml
- .getCooperatives
- InvestmentService
- UserRepository
- ActividadEconomica
- UserAdminService.java
- AuthController
- .decide
- org.springframework.data.jpa.repository.Query
- IngresoEgreso
- CooperativeInvitation
- InternalCooperativeController
- OnboardingServiceImpl.java
- org.springframework.stereotype.Service
- CreditGuarantorSubmission
- PersonaOnboardingResponse
- FirebaseConfig.java
- DashboardService.java
- tomcat
- NotificationService
- OnboardingClienteController.java
- PreRegisterRequest
- hikari
- management
- GuarantorProfile
- CooperativeDecisionRequestDto.java
- CustomUserDetailsService.java
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
- AuthServiceSecurityActivityTest
- spring
- ActivationToken
- datasource
- CreditGuarantorStatus
- com.markup.dinerop.auth.entity.User
- com.markup:dinerop-backend
- AdminBootstrapRunner.java
- CreditGuarantorWorkflowServiceTest
- CreditGuarantorWorkflowService.java
- CreditRejectionReason
- InvestmentRequestStatusEvent
- InvitationService
- .verifyRegistrationOtp
- OnboardingUnificadoResponse
- UserPreRegistration
- CreditRequest.java
- .createPublicRequest
- TipoVivienda
- PushDeviceToken
- ForgotPasswordRequest
- .startRegistrationOtp
- FinancialProductType

## God Nodes (most connected - your core abstractions)
1. `User` - 62 edges
2. `AuthService` - 49 edges
3. `CreditService` - 46 edges
4. `SolicitudCooperativaRepository` - 43 edges
5. `NotificationService` - 39 edges
6. `CreditController` - 36 edges
7. `UserRepository` - 36 edges
8. `CooperativeService` - 35 edges
9. `SolicitudCooperativa` - 34 edges
10. `Cooperative` - 32 edges

## Surprising Connections (you probably didn't know these)
- `InvestmentRequest` --references--> `InterestPaymentOption`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentRequest.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InterestPaymentOption.java
- `InvestmentRequest` --references--> `InvestmentCalculationMethod`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentRequest.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentCalculationMethod.java
- `InvestmentRequest` --references--> `InvestmentRequestStatus`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentRequest.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentRequestStatus.java
- `InvestmentRequestRepository` --references--> `InvestmentRequest`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/repository/InvestmentRequestRepository.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentRequest.java
- `InvestmentService` --references--> `InvestmentRequestStatus`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/InvestmentService.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentRequestStatus.java

## Import Cycles
- None detected.

## Communities (128 total, 73 thin omitted)

### Community 0 - "lombok.Getter"
Cohesion: 0.09
Nodes (19): UpdateUserRequest, ChangeRegistrationEmailRequest, CompleteRegistrationRequest, JwtResponse, LoginResponse, UserInfo, OtpRegistrationStartResponse, OtpResendRequest (+11 more)

### Community 1 - ".getDashboard"
Cohesion: 0.16
Nodes (6): CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, RecentUserDto, UserStatsDto, VisitStatsDto

### Community 3 - "CooperativeAdminService"
Cohesion: 0.11
Nodes (8): CooperativeAdminController, CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeListItemResponse, CooperativeNotFoundException, CooperativeAdminMapper, CooperativeAdminService

### Community 5 - "PersonaOnboarding"
Cohesion: 0.12
Nodes (7): PersonaOnboarding, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE, GARANTE, SOLICITANTE, PersonaOnboardingRepository

### Community 6 - "lombok.RequiredArgsConstructor"
Cohesion: 0.12
Nodes (7): DashboardController, DashboardService, InternalAuthController, InvitationController, TestEmailController, RegisterPushTokenRequest, ObtenerOnboardingUnificadoUseCase

### Community 7 - "InvitationServiceTest.java"
Cohesion: 0.10
Nodes (3): AuthServiceOtpFlowTest, InvitationServiceTest, ClientCreditQuerySecurityTest

### Community 8 - "CooperativeRate"
Cohesion: 0.09
Nodes (6): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto

### Community 9 - "AuthService.java"
Cohesion: 0.11
Nodes (3): CooperativeRequiredException, AccountDisabledException, CooperativeNotFoundException

### Community 10 - "InvestmentRequestStatus"
Cohesion: 0.13
Nodes (8): InvestmentRequestStatus, CONDITIONS_CONFIRMED, DECLINED, IN_REVIEW, INFORMATION_REQUIRED, SUBMITTED, InvestmentRequestRepository, UpdateInvestmentRequestStatus

### Community 12 - "EstadoOnboarding"
Cohesion: 0.20
Nodes (5): EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE, SolicitudOnboardingResponse

### Community 13 - "CooperativeService"
Cohesion: 0.16
Nodes (4): CooperativeService, CooperativeDto, CreateCooperativeDto, CooperativeController

### Community 16 - "FinancialProduct"
Cohesion: 0.11
Nodes (5): FinancialProduct, FinancialProductCondition, FinancialProductConditionRepository, FinancialProductRepository, FinancialProductServiceTest

### Community 18 - "CreditController"
Cohesion: 0.06
Nodes (5): CreditProcessEvent, CreditProcessEventDto, CreditProcessEventRepository, CreditController, CreditReferralPdfService

### Community 19 - "org.springframework.stereotype.Component"
Cohesion: 0.14
Nodes (6): ActivationEmailBuilder, OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, SolicitarGaranteUseCase, SolicitudOnboardingRequest

### Community 20 - "InternalCreditController"
Cohesion: 0.07
Nodes (10): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, ActualizarEstadoSolicitudRequest, LinkClientRequestDto (+2 more)

### Community 21 - "SolicitudCooperativaRepository"
Cohesion: 0.09
Nodes (3): SolicitudCooperativa, ClientCreditAcceptanceService, SolicitudCooperativaRepository

### Community 23 - "UserDetailResponse"
Cohesion: 0.18
Nodes (4): UserAdminController, ChangeStatusRequest, UserDetailResponse, UserAdminService

### Community 24 - "bigdecimal"
Cohesion: 0.09
Nodes (6): InvestmentCalculationMethod, MONTHLY_COMPOUNDING, SIMPLE_INTEREST, UNSPECIFIED, FinancialProductRequest, CooperativeOfferDefaultsDto

### Community 25 - "PasswordResetToken"
Cohesion: 0.12
Nodes (3): ResetPasswordRequest, PasswordResetToken, PasswordResetTokenRepository

### Community 26 - "CreditRequirement"
Cohesion: 0.17
Nodes (4): CreditRequirement, CreditRequirementDto, CreditRequirementRepository, CreditRequirementService

### Community 27 - "ReferenciaPersonal"
Cohesion: 0.11
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaRequest, ReferenciaPersonalResponse

### Community 31 - "SolicitudCooperativaCotizacion"
Cohesion: 0.11
Nodes (5): CreditType, CONSUMO, MICROCREDITO, SolicitudCooperativaCotizacion, SolicitudCooperativaCotizacionRepository

### Community 32 - "org.springframework.http.ResponseEntity"
Cohesion: 0.07
Nodes (10): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException, GlobalExceptionHandler, ApiError, CreditExceptionHandler, BusinessException (+2 more)

### Community 35 - "FinancialProductService"
Cohesion: 0.12
Nodes (6): FinancialProductAdminController, FinancialProductService, FinancialProductConditionRequest, Condition, FinancialProductResponse, FinancialProductController

### Community 36 - "Role"
Cohesion: 0.21
Nodes (6): ChangeRoleRequest, InviteUserRequest, Role, ADMIN, CLIENT, COOPERATIVE

### Community 37 - "DireccionOnboarding"
Cohesion: 0.12
Nodes (4): DireccionOnboarding, DireccionRequest, DireccionOnboardingResponse, DireccionOnboardingRepository

### Community 38 - "org.springframework.context.annotation.Bean"
Cohesion: 0.15
Nodes (4): OpenApiConfig, WebClientConfig, PasswordEncoderConfig, ResendConfig

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 48 - "InvestmentService"
Cohesion: 0.12
Nodes (11): InterestPaymentOption, AT_MATURITY, MONTHLY, REINVEST, InvestmentService, CreateInvestmentRequest, InvestmentAvailabilityResponse, InvestmentOfferResponse (+3 more)

### Community 50 - "ActividadEconomica"
Cohesion: 0.14
Nodes (4): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository, ReferenciaPersonalRepository

### Community 51 - "UserAdminService.java"
Cohesion: 0.15
Nodes (5): PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserNotFoundException, UserAdminMapper

### Community 55 - "IngresoEgreso"
Cohesion: 0.17
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 56 - "CooperativeInvitation"
Cohesion: 0.08
Nodes (4): InvitationActivationRequest, InvitationDetailsResponse, CooperativeInvitation, CooperativeInvitationRepository

### Community 58 - "OnboardingServiceImpl.java"
Cohesion: 0.09
Nodes (5): CooperativeCreditQueryService, OnboardingServiceImpl, SolicitudOnboarding, GuarantorProfileRepository, SolicitudOnboardingRepository

### Community 59 - "org.springframework.stereotype.Service"
Cohesion: 0.13
Nodes (7): ClientCreditCooperativeStatusService, CooperativeCreditDecisionService, CreditDistributionService, AuthenticatedRequestResult, CreditService, NotificationService, CooperativeCreditDecisionServiceTest

### Community 62 - "PersonaOnboardingResponse"
Cohesion: 0.14
Nodes (9): EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO (+1 more)

### Community 64 - "DashboardService.java"
Cohesion: 0.28
Nodes (4): RecentCreditDto, CreditRequestStatus, CREADA, ENVIADA

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 66 - "NotificationService"
Cohesion: 0.08
Nodes (3): CreditOfferEmailBuilder, EmailTemplate, EmailTemplateEngine

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 79 - "flyway"
Cohesion: 0.18
Nodes (11): baseline-description, baseline-on-migrate, baseline-version, enabled, ddl-auto, hibernate, open-in-view, show-sql (+3 more)

### Community 80 - "hibernate"
Cohesion: 0.25
Nodes (8): format_sql, generate_statistics, jdbc, order_inserts, order_updates, batch_size, properties, hibernate

### Community 81 - "level"
Cohesion: 0.33
Nodes (6): com.markup.dinerop, com.zaxxer.hikari, org.hibernate, org.springframework, root, level

### Community 84 - "AuthServiceSecurityActivityTest"
Cohesion: 0.23
Nodes (3): LoginRequest, AccountNotActiveException, AuthServiceSecurityActivityTest

### Community 85 - "spring"
Cohesion: 0.25
Nodes (7): name, enabled, active, spring, application, flyway, profiles

### Community 87 - "datasource"
Cohesion: 0.40
Nodes (5): driver-class-name, password, url, username, datasource

### Community 88 - "CreditGuarantorStatus"
Cohesion: 0.20
Nodes (6): CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA

### Community 106 - "CreditRejectionReason"
Cohesion: 0.25
Nodes (6): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, GuaranteeDecisionRequestDto

### Community 109 - ".verifyRegistrationOtp"
Cohesion: 0.17
Nodes (3): OtpAttemptsExceededException, OtpExpiredException, OtpInvalidException

### Community 112 - "CreditRequest.java"
Cohesion: 0.12
Nodes (6): CreditRequestType, CREDITO, INVERSION, ClientCreditRequestDto, CooperativeCreditRequestItemDto, PublicCreditRequestDto

### Community 114 - "TipoVivienda"
Cohesion: 0.50
Nodes (3): TipoVivienda, ARRENDADA, PROPIA

### Community 118 - ".startRegistrationOtp"
Cohesion: 0.16
Nodes (4): OtpRateLimitException, UserAlreadyActiveException, EmailVerificationOtpRepository, AuthService

### Community 119 - "FinancialProductType"
Cohesion: 0.50
Nodes (3): FinancialProductType, CREDIT, INVESTMENT

## Knowledge Gaps
- **56 isolated node(s):** `CONDITIONS_CONFIRMED`, `DECLINED`, `IN_REVIEW`, `INFORMATION_REQUIRED`, `SUBMITTED` (+51 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 659 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **73 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `.getDashboard`, `jakarta.transaction.Transactional`, `lombok.RequiredArgsConstructor`, `InvitationServiceTest.java`, `AuthService.java`, `UserDetailResponse`, `PasswordResetToken`, `JwtService`, `Role`, `lombok`, `UserRepository`, `UserAdminService.java`, `CooperativeInvitation`, `org.springframework.stereotype.Service`, `CustomUserDetailsService.java`, `PushNotificationController`, `AuthServiceSecurityActivityTest`, `ActivationToken`, `AdminBootstrapRunner.java`, `InvitationService`, `OnboardingUnificadoResponse`, `PushDeviceToken`, `.startRegistrationOtp`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **What connects `CONDITIONS_CONFIRMED`, `DECLINED`, `IN_REVIEW` to the rest of the system?**
  _56 weakly-connected nodes found - possible missing edges._
- **Should `lombok.Getter` be split into smaller, more focused modules?**
  _Cohesion score 0.08846153846153847 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboarding` connect `PersonaOnboarding` to `DireccionOnboarding`, `GuarantorProfile`, `OnboardingMapper`, `lombok`, `ActividadEconomica`, `IngresoEgreso`, `OnboardingServiceImpl.java`, `ReferenciaPersonal`, `PersonaOnboardingResponse`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._
- **Why does `GuarantorProfile` connect `GuarantorProfile` to `OnboardingServiceImpl.java`, `InvitationServiceTest.java`, `PersonaOnboarding`, `lombok`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Should `PersonaOnboarding` be split into smaller, more focused modules?**
  _Cohesion score 0.12380952380952381 - nodes in this community are weakly interconnected._