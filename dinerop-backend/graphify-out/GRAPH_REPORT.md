# Graph Report - dinerop-backend  (2026-11-16)

## Corpus Check
- 265 files · ~33,373 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1812 nodes · 4670 edges · 121 communities (52 shown, 69 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 329 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `105f90ed`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.AllArgsConstructor
- CreditOfferEmailBuilder
- CooperativeAdminService
- AuthService
- PersonaOnboarding
- lombok.RequiredArgsConstructor
- AuthServiceOtpFlowTest.java
- CooperativeRate
- AuthService.java
- CreditType
- SecurityActivityTest.java
- localdatetime
- CooperativeService
- PersonaOnboardingRequest
- CreditRequest
- .getDashboard
- Cooperative
- org.springframework.http.ResponseEntity
- org.springframework.stereotype.Component
- InternalCreditController
- SolicitudCooperativaRepository
- PageVisitRepository
- UserDetailResponse
- ForgotPasswordRequest
- CreditRequirement
- ReferenciaPersonal
- auth/config/SecurityConfig.java
- JwtService
- User
- SolicitudCooperativaCotizacion
- jakarta.servlet.http.HttpServletRequest
- org.springframework.data.jpa.repository.JpaRepository
- AuthController
- FinancialProductService
- UserAdminController.java
- DireccionOnboarding
- org.springframework.context.annotation.Bean
- SolicitudCooperativaStatus
- postgres
- OnboardingMapper
- CreditService
- JwtAuthenticationFilter.java
- CreditGuarantorWorkflowService.java
- application-prod.yaml
- bigdecimal
- notblank
- CreditGuarantorHistoryItemDto
- UserRepository
- ActividadEconomica
- UserAdminService.java
- PasswordResetToken
- .decide
- CreditProcessEventRepository
- IngresoEgreso
- CooperativeInvitation
- InternalCooperativeController
- SolicitudOnboarding
- CreditService.java
- lombok.Builder
- PersonaOnboardingResponse
- FirebaseConfig.java
- Role
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
- .login
- spring
- ActivationToken
- datasource
- CreditGuarantorSubmission
- com.markup:dinerop-backend
- AdminBootstrapRunner.java
- CreditGuarantorWorkflowServiceTest
- ClientCreditQueryService.java
- InvitationService.java
- LinkClientResponseDto
- InvitationService
- EmailTemplateEngine.java
- LinkClientRequestDto
- CreditRequest.java
- EmailVerificationOtp
- TipoVivienda
- .preRegister
- PublicRegistrationRequest
- .sendTestEmail

## God Nodes (most connected - your core abstractions)
1. `User` - 62 edges
2. `AuthService` - 49 edges
3. `CreditService` - 46 edges
4. `SolicitudCooperativaRepository` - 43 edges
5. `NotificationService` - 39 edges
6. `UserRepository` - 36 edges
7. `CooperativeService` - 35 edges
8. `SolicitudCooperativa` - 34 edges
9. `CooperativeRepository` - 32 edges
10. `Cooperative` - 31 edges

## Surprising Connections (you probably didn't know these)
- `CooperativeAdminController` --references--> `CooperativeAdminService`  [EXTRACTED]
  src/main/java/com/markup/dinerop/admin/cooperative/controller/CooperativeAdminController.java → dinerop-backend/src/main/java/com/markup/dinerop/admin/cooperative/service/CooperativeAdminService.java
- `CooperativeAdminService` --references--> `CooperativeRateRepository`  [EXTRACTED]
  dinerop-backend/src/main/java/com/markup/dinerop/admin/cooperative/service/CooperativeAdminService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRateRepository.java
- `CreateUserRequest` --references--> `Role`  [EXTRACTED]
  dinerop-backend/src/main/java/com/markup/dinerop/admin/users/dto/request/CreateUserRequest.java → src/main/java/com/markup/dinerop/auth/entity/Role.java
- `SecurityConfig` --references--> `JwtAuthenticationFilter`  [EXTRACTED]
  dinerop-backend/src/main/java/com/markup/dinerop/auth/config/SecurityConfig.java → src/main/java/com/markup/dinerop/auth/config/JwtAuthenticationFilter.java
- `ActivationToken` --references--> `User`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/entity/ActivationToken.java → dinerop-backend/src/main/java/com/markup/dinerop/auth/entity/User.java

## Import Cycles
- None detected.

## Communities (121 total, 69 thin omitted)

### Community 0 - "lombok.AllArgsConstructor"
Cohesion: 0.22
Nodes (9): ChangeRegistrationEmailRequest, JwtResponse, LoginRequest, LoginResponse, UserInfo, ClientCreditResponseDto, CooperativeDto, CooperativeStatusItemDto (+1 more)

### Community 3 - "CooperativeAdminService"
Cohesion: 0.14
Nodes (6): CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeNotFoundException, CooperativeAdminMapper, CooperativeAdminService

### Community 5 - "PersonaOnboarding"
Cohesion: 0.12
Nodes (7): PersonaOnboarding, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE, GARANTE, SOLICITANTE, PersonaOnboardingRepository

### Community 6 - "lombok.RequiredArgsConstructor"
Cohesion: 0.10
Nodes (7): CooperativeAdminController, FinancialProductAdminController, DashboardController, DashboardService, InternalAuthController, InvitationController, TestEmailController

### Community 7 - "AuthServiceOtpFlowTest.java"
Cohesion: 0.17
Nodes (7): EmailVerificationOtpRepository, PasswordResetTokenRepository, UserPreRegistrationRepository, AuthServiceOtpFlowTest, AuthServiceSecurityActivityTest, InvitationServiceTest, ClientCreditQuerySecurityTest

### Community 8 - "CooperativeRate"
Cohesion: 0.10
Nodes (6): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto

### Community 9 - "AuthService.java"
Cohesion: 0.07
Nodes (6): CooperativeRequiredException, CooperativeNotFoundException, OtpAttemptsExceededException, OtpExpiredException, OtpInvalidException, OtpRateLimitException

### Community 10 - "CreditType"
Cohesion: 0.20
Nodes (4): CreditRequestType, CREDITO, INVERSION, ClientCreditRequestDto

### Community 12 - "localdatetime"
Cohesion: 0.06
Nodes (9): UserPreRegistration, CreditProcessEventDto, PushDeviceToken, PushDeviceTokenRepository, EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE (+1 more)

### Community 13 - "CooperativeService"
Cohesion: 0.25
Nodes (3): CooperativeService, CooperativeDto, CreateCooperativeDto

### Community 14 - "PersonaOnboardingRequest"
Cohesion: 0.10
Nodes (4): ActividadEconomicaRequest, IngresoEgresoRequest, PersonaOnboardingRequest, ReferenciaRequest

### Community 15 - "CreditRequest"
Cohesion: 0.10
Nodes (6): RecentCreditDto, CreditRequest, CreditRequestStatus, CREADA, ENVIADA, CreditRequestRepository

### Community 16 - ".getDashboard"
Cohesion: 0.17
Nodes (5): CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, UserStatsDto, VisitStatsDto

### Community 19 - "org.springframework.stereotype.Component"
Cohesion: 0.14
Nodes (6): ActivationEmailBuilder, OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, SolicitarGaranteUseCase, SolicitudOnboardingRequest

### Community 21 - "SolicitudCooperativaRepository"
Cohesion: 0.08
Nodes (3): SolicitudCooperativa, CreditDistributionService, SolicitudCooperativaRepository

### Community 22 - "PageVisitRepository"
Cohesion: 0.15
Nodes (4): PageVisit, PageVisitRepository, VisitService, VisitController

### Community 23 - "UserDetailResponse"
Cohesion: 0.23
Nodes (4): ChangeStatusRequest, UserDetailResponse, UserAdminMapper, UserAdminService

### Community 26 - "CreditRequirement"
Cohesion: 0.16
Nodes (4): CreditRequirement, CreditRequirementDto, CreditRequirementRepository, CreditRequirementService

### Community 27 - "ReferenciaPersonal"
Cohesion: 0.13
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaPersonalResponse, ReferenciaPersonalRepository

### Community 32 - "jakarta.servlet.http.HttpServletRequest"
Cohesion: 0.08
Nodes (8): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException, GlobalExceptionHandler, CooperativeController, ApiError, CreditExceptionHandler

### Community 34 - "AuthController"
Cohesion: 0.15
Nodes (3): AuthController, OtpRegistrationStartResponse, PublicRegistrationResponse

### Community 35 - "FinancialProductService"
Cohesion: 0.07
Nodes (14): FinancialProduct, FinancialProductCondition, FinancialProductType, CREDIT, INVESTMENT, FinancialProductConditionRepository, FinancialProductRepository, FinancialProductService (+6 more)

### Community 36 - "UserAdminController.java"
Cohesion: 0.10
Nodes (4): UserAdminController, BusinessException, OnboardingExceptionHandler, ResourceNotFoundException

### Community 37 - "DireccionOnboarding"
Cohesion: 0.17
Nodes (3): DireccionOnboarding, DireccionOnboardingResponse, DireccionOnboardingRepository

### Community 38 - "org.springframework.context.annotation.Bean"
Cohesion: 0.15
Nodes (4): OpenApiConfig, WebClientConfig, PasswordEncoderConfig, ResendConfig

### Community 39 - "SolicitudCooperativaStatus"
Cohesion: 0.20
Nodes (8): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, ActualizarEstadoSolicitudRequest, CooperativeCreditRequestItemDto

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "CreditService"
Cohesion: 0.13
Nodes (7): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, AuthenticatedRequestResult, CreditService

### Community 44 - "CreditGuarantorWorkflowService.java"
Cohesion: 0.14
Nodes (5): CreditGuarantorWorkflowService, TypeReference<>, CreditGuarantorEvaluationDto, CreditReferralPdfService, OnboardingServiceImpl

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 46 - "bigdecimal"
Cohesion: 0.12
Nodes (3): CooperativeListItemResponse, PagedCooperativesResponse, CooperativeSpecification

### Community 50 - "ActividadEconomica"
Cohesion: 0.15
Nodes (3): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository

### Community 51 - "UserAdminService.java"
Cohesion: 0.16
Nodes (4): PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserNotFoundException

### Community 55 - "IngresoEgreso"
Cohesion: 0.15
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 56 - "CooperativeInvitation"
Cohesion: 0.12
Nodes (3): InvitationActivationRequest, CooperativeInvitation, CooperativeInvitationRepository

### Community 58 - "SolicitudOnboarding"
Cohesion: 0.08
Nodes (5): ObtenerOnboardingUnificadoUseCase, OnboardingCooperativaController, SolicitudOnboarding, OnboardingUnificadoResponse, SolicitudOnboardingRepository

### Community 59 - "CreditService.java"
Cohesion: 0.23
Nodes (4): LoanCalculator, ClientCreditCooperativeStatusService, CooperativeCreditDecisionService, CooperativeCreditDecisionServiceTest

### Community 60 - "lombok.Builder"
Cohesion: 0.26
Nodes (7): CompleteRegistrationRequest, OtpResendRequest, OtpVerificationRequest, InternalCooperativeDto, InternalOnboardingCompletedRequest, FormularioClienteStatusResponse, PreRegistrationDataResponse

### Community 62 - "PersonaOnboardingResponse"
Cohesion: 0.11
Nodes (9): EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO (+1 more)

### Community 64 - "Role"
Cohesion: 0.24
Nodes (7): RecentUserDto, ChangeRoleRequest, InviteUserRequest, Role, ADMIN, CLIENT, COOPERATIVE

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 72 - "CooperativeDecisionRequestDto.java"
Cohesion: 0.13
Nodes (3): CooperativeDecisionRequestDto, CooperativeOfferDefaultsDto, GuaranteeDecisionRequestDto

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

### Community 88 - "CreditGuarantorSubmission"
Cohesion: 0.11
Nodes (7): CreditGuarantorSubmission, CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA

### Community 112 - "CreditRequest.java"
Cohesion: 0.16
Nodes (4): CreditType, CONSUMO, MICROCREDITO, PublicCreditRequestDto

### Community 114 - "TipoVivienda"
Cohesion: 0.50
Nodes (3): TipoVivienda, ARRENDADA, PROPIA

## Knowledge Gaps
- **45 isolated node(s):** `CREDIT`, `INVESTMENT`, `CONSUMO`, `MICROCREDITO`, `ACEPTADO` (+40 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 621 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **69 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `AuthService`, `AuthServiceOtpFlowTest.java`, `AuthService.java`, `localdatetime`, `.getDashboard`, `UserDetailResponse`, `JwtService`, `jakarta.servlet.http.HttpServletRequest`, `org.springframework.data.jpa.repository.JpaRepository`, `UserRepository`, `UserAdminService.java`, `PasswordResetToken`, `CooperativeInvitation`, `SolicitudOnboarding`, `CreditService.java`, `Role`, `CustomUserDetailsService.java`, `PushNotificationController`, `ActivationToken`, `InvitationServiceTest.java`, `AdminBootstrapRunner.java`, `CreditGuarantorWorkflowServiceTest`, `InvitationService`, `.generateToken`?**
  _High betweenness centrality (0.052) - this node is a cross-community bridge._
- **What connects `CREDIT`, `INVESTMENT`, `CONSUMO` to the rest of the system?**
  _45 weakly-connected nodes found - possible missing edges._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.1396011396011396 - nodes in this community are weakly interconnected._
- **Why does `AuthService` connect `AuthService` to `lombok.RequiredArgsConstructor`, `AuthServiceOtpFlowTest.java`, `AuthService.java`, `CreditRequest`, `Cooperative`, `UserDetailResponse`, `ForgotPasswordRequest`, `JwtService`, `AuthController`, `CreditService`, `CreditGuarantorWorkflowService.java`, `UserRepository`, `UserAdminService.java`, `PasswordResetToken`, `CreditService.java`, `NotificationService`, `.login`, `ActivationToken`, `AdminBootstrapRunner.java`, `.preRegister`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **Should `AuthService` be split into smaller, more focused modules?**
  _Cohesion score 0.12605042016806722 - nodes in this community are weakly interconnected._
- **Why does `CooperativeRepository` connect `Cooperative` to `org.springframework.data.jpa.repository.JpaRepository`, `CooperativeAdminService`, `AuthService`, `FinancialProductService`, `lombok.RequiredArgsConstructor`, `AuthServiceOtpFlowTest.java`, `AuthService.java`, `InvitationService.java`, `InvitationService`, `CooperativeService`, `bigdecimal`, `PageVisitRepository`, `InvitationServiceTest.java`?**
  _High betweenness centrality (0.036) - this node is a cross-community bridge._
- **Should `PersonaOnboarding` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._