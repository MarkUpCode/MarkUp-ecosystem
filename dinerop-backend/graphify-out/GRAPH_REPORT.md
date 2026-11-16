# Graph Report - dinerop-backend  (2026-11-16)

## Corpus Check
- 244 files · ~30,093 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1592 nodes · 3961 edges · 117 communities (48 shown, 69 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 282 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e0dc7a77`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.Builder
- CreditOfferEmailBuilder
- SolicitudOnboarding
- CooperativeAdminService
- AuthService
- PersonaOnboarding
- lombok.RequiredArgsConstructor
- AuthServiceOtpFlowTest.java
- CooperativeRate
- AuthService.java
- CreditType
- SecurityActivityTest.java
- PushDeviceToken
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
- AuthController
- CreditRequirement
- ReferenciaPersonal
- auth/config/SecurityConfig.java
- JwtService
- User
- SolicitudCooperativaCotizacion
- jakarta.servlet.http.HttpServletRequest
- org.springframework.data.jpa.repository.JpaRepository
- PublicRegistrationRequest
- EstadoOnboarding
- UserPreRegistration
- DireccionOnboarding
- org.springframework.context.annotation.Bean
- SolicitudCooperativaStatus
- postgres
- OnboardingMapper
- org.springframework.stereotype.Service
- JwtAuthenticationFilter.java
- CreditGuarantorWorkflowService.java
- application-prod.yaml
- bigdecimal
- notblank
- UserRepository
- ActividadEconomica
- UserAdminService.java
- PasswordResetToken
- CreditRejectionReason
- CreditProcessEventRepository
- IngresoEgreso
- InternalCooperativeController
- CooperativeCreditQueryService.java
- CooperativeCreditDecisionServiceTest.java
- CreditRequestStatus
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
- AuthServiceSecurityActivityTest
- spring
- datasource
- CreditGuarantorSubmission
- com.markup:dinerop-backend
- AdminBootstrapRunner.java
- CreditGuarantorWorkflowServiceTest
- CreditGuarantorStatus
- CreditRequestType
- LinkClientResponseDto
- VisitController
- EmailTemplateEngine.java
- LinkClientRequestDto
- PublicCreditRequestDto
- IngresoEgresoRequest
- TipoVivienda

## God Nodes (most connected - your core abstractions)
1. `User` - 53 edges
2. `SolicitudCooperativaRepository` - 43 edges
3. `AuthService` - 42 edges
4. `CreditService` - 38 edges
5. `SolicitudCooperativa` - 34 edges
6. `NotificationService` - 33 edges
7. `Cooperative` - 31 edges
8. `UserRepository` - 30 edges
9. `Role` - 30 edges
10. `CreditController` - 28 edges

## Surprising Connections (you probably didn't know these)
- `SecurityConfig` --references--> `JwtAuthenticationFilter`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/config/SecurityConfig.java → src/main/java/com/markup/dinerop/auth/config/JwtAuthenticationFilter.java
- `CreditGuarantorSubmission` --references--> `CreditGuarantorStatus`  [EXTRACTED]
  src/main/java/com/markup/dinerop/credit/domain/model/CreditGuarantorSubmission.java → src/main/java/com/markup/dinerop/credit/domain/model/enums/CreditGuarantorStatus.java
- `CreditGuarantorSubmissionRepository` --references--> `CreditGuarantorSubmission`  [EXTRACTED]
  src/main/java/com/markup/dinerop/credit/infrastructure/repository/CreditGuarantorSubmissionRepository.java → src/main/java/com/markup/dinerop/credit/domain/model/CreditGuarantorSubmission.java
- `SolicitudCooperativa` --references--> `CreditRequest`  [EXTRACTED]
  src/main/java/com/markup/dinerop/credit/domain/model/SolicitudCooperativa.java → src/main/java/com/markup/dinerop/credit/domain/model/CreditRequest.java
- `SolicitudCooperativa` --references--> `CreditRejectionReason`  [EXTRACTED]
  src/main/java/com/markup/dinerop/credit/domain/model/SolicitudCooperativa.java → src/main/java/com/markup/dinerop/credit/domain/model/enums/CreditRejectionReason.java

## Import Cycles
- None detected.

## Communities (117 total, 69 thin omitted)

### Community 0 - "lombok.Builder"
Cohesion: 0.11
Nodes (18): ChangeRegistrationEmailRequest, CompleteRegistrationRequest, JwtResponse, LoginResponse, UserInfo, OtpRegistrationStartResponse, OtpResendRequest, OtpVerificationRequest (+10 more)

### Community 1 - "CreditOfferEmailBuilder"
Cohesion: 0.17
Nodes (3): ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate

### Community 3 - "CooperativeAdminService"
Cohesion: 0.13
Nodes (6): CooperativeAdminController, CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeNotFoundException, CooperativeAdminService

### Community 4 - "AuthService"
Cohesion: 0.22
Nodes (4): UserAlreadyActiveException, EmailVerificationOtpRepository, AuthService, PublicCreditRequestResult

### Community 5 - "PersonaOnboarding"
Cohesion: 0.08
Nodes (15): PersonaOnboarding, EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, EstadoGarante, ACEPTADO, EN_REVISION (+7 more)

### Community 6 - "lombok.RequiredArgsConstructor"
Cohesion: 0.11
Nodes (7): DashboardController, DashboardService, UserAdminController, UserAdminService, InternalAuthController, TestEmailController, TestEmailRequest

### Community 8 - "CooperativeRate"
Cohesion: 0.10
Nodes (6): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto

### Community 9 - "AuthService.java"
Cohesion: 0.08
Nodes (8): CooperativeRequiredException, InviteUserRequest, AccountDisabledException, CooperativeNotFoundException, OtpAttemptsExceededException, OtpExpiredException, OtpInvalidException, OtpRateLimitException

### Community 10 - "CreditType"
Cohesion: 0.18
Nodes (4): CreditType, CONSUMO, MICROCREDITO, ClientCreditRequestDto

### Community 13 - "CooperativeService"
Cohesion: 0.17
Nodes (4): CooperativeService, CooperativeDto, CreateCooperativeDto, CooperativeController

### Community 14 - "PersonaOnboardingRequest"
Cohesion: 0.10
Nodes (4): ActividadEconomicaRequest, PersonaOnboardingRequest, ReferenciaRequest, SolicitudOnboardingRequest

### Community 16 - ".getDashboard"
Cohesion: 0.17
Nodes (5): CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, UserStatsDto, VisitStatsDto

### Community 19 - "org.springframework.stereotype.Component"
Cohesion: 0.21
Nodes (5): OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, ObtenerOnboardingUnificadoUseCase, SolicitarGaranteUseCase

### Community 21 - "SolicitudCooperativaRepository"
Cohesion: 0.11
Nodes (3): SolicitudCooperativa, ClientCreditQueryService, SolicitudCooperativaRepository

### Community 22 - "PageVisitRepository"
Cohesion: 0.29
Nodes (3): PageVisit, PageVisitRepository, VisitService

### Community 23 - "UserDetailResponse"
Cohesion: 0.19
Nodes (4): ChangeStatusRequest, CreateUserRequest, UserDetailResponse, UserNotFoundException

### Community 26 - "CreditRequirement"
Cohesion: 0.17
Nodes (4): CreditRequirement, CreditRequirementDto, CreditRequirementRepository, CreditRequirementService

### Community 27 - "ReferenciaPersonal"
Cohesion: 0.14
Nodes (6): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaPersonalResponse, ReferenciaPersonalRepository

### Community 32 - "jakarta.servlet.http.HttpServletRequest"
Cohesion: 0.07
Nodes (10): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException, GlobalExceptionHandler, ApiError, CreditExceptionHandler, BusinessException (+2 more)

### Community 35 - "EstadoOnboarding"
Cohesion: 0.20
Nodes (5): EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE, SolicitudOnboardingResponse

### Community 37 - "DireccionOnboarding"
Cohesion: 0.12
Nodes (4): DireccionOnboarding, DireccionRequest, DireccionOnboardingResponse, DireccionOnboardingRepository

### Community 38 - "org.springframework.context.annotation.Bean"
Cohesion: 0.15
Nodes (4): OpenApiConfig, WebClientConfig, PasswordEncoderConfig, ResendConfig

### Community 39 - "SolicitudCooperativaStatus"
Cohesion: 0.22
Nodes (7): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, ActualizarEstadoSolicitudRequest

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "org.springframework.stereotype.Service"
Cohesion: 0.15
Nodes (5): CreditDistributionService, AuthenticatedRequestResult, CreditService, CreditReferralPdfService, OnboardingServiceImpl

### Community 44 - "CreditGuarantorWorkflowService.java"
Cohesion: 0.14
Nodes (5): CreditGuarantorWorkflowService, TypeReference<>, CreditGuarantorEvaluationDto, CreditGuarantorHistoryItemDto, CreditGuarantorSubmissionRepository

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 46 - "bigdecimal"
Cohesion: 0.14
Nodes (5): CooperativeListItemResponse, PagedCooperativesResponse, CooperativeAdminMapper, CooperativeSpecification, CooperativeOfferDefaultsDto

### Community 50 - "ActividadEconomica"
Cohesion: 0.17
Nodes (3): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository

### Community 51 - "UserAdminService.java"
Cohesion: 0.18
Nodes (4): PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserAdminMapper

### Community 52 - "PasswordResetToken"
Cohesion: 0.12
Nodes (3): ResetPasswordRequest, PasswordResetToken, PasswordResetTokenRepository

### Community 53 - "CreditRejectionReason"
Cohesion: 0.11
Nodes (6): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, LoanCalculationResult

### Community 58 - "CooperativeCreditQueryService.java"
Cohesion: 0.13
Nodes (4): CooperativeCreditQueryService, OnboardingCooperativaController, OnboardingUnificadoResponse, SolicitudOnboardingRepository

### Community 59 - "CooperativeCreditDecisionServiceTest.java"
Cohesion: 0.16
Nodes (5): LoanCalculator, ClientCreditCooperativeStatusService, CooperativeCreditDecisionService, ClientCreditQuerySecurityTest, CooperativeCreditDecisionServiceTest

### Community 60 - "CreditRequestStatus"
Cohesion: 0.29
Nodes (4): RecentCreditDto, CreditRequestStatus, CREADA, ENVIADA

### Community 64 - "Role"
Cohesion: 0.28
Nodes (6): RecentUserDto, ChangeRoleRequest, Role, ADMIN, CLIENT, COOPERATIVE

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

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
Cohesion: 0.27
Nodes (3): LoginRequest, AccountNotActiveException, AuthServiceSecurityActivityTest

### Community 85 - "spring"
Cohesion: 0.25
Nodes (7): name, enabled, active, spring, application, flyway, profiles

### Community 87 - "datasource"
Cohesion: 0.40
Nodes (5): driver-class-name, password, url, username, datasource

### Community 105 - "CreditGuarantorStatus"
Cohesion: 0.29
Nodes (6): CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA

### Community 106 - "CreditRequestType"
Cohesion: 0.33
Nodes (4): CreditRequestType, CREDITO, INVERSION, CooperativeCreditRequestItemDto

### Community 114 - "TipoVivienda"
Cohesion: 0.50
Nodes (3): TipoVivienda, ARRENDADA, PROPIA

## Knowledge Gaps
- **43 isolated node(s):** `com.markup:dinerop-backend`, `EN_REVISION`, `CORRECCION_SOLICITADA`, `RECHAZADO`, `ACEPTADO` (+38 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 552 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **69 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `lombok.Builder`, `AuthService`, `lombok.RequiredArgsConstructor`, `AuthServiceOtpFlowTest.java`, `AuthService.java`, `SecurityActivityTest.java`, `PushDeviceToken`, `.getDashboard`, `UserDetailResponse`, `lombok`, `JwtService`, `UserRepository`, `UserAdminService.java`, `PasswordResetToken`, `CooperativeCreditQueryService.java`, `Role`, `CustomUserDetailsService.java`, `PushNotificationController`, `AuthServiceSecurityActivityTest`, `AdminBootstrapRunner.java`?**
  _High betweenness centrality (0.056) - this node is a cross-community bridge._
- **What connects `com.markup:dinerop-backend`, `EN_REVISION`, `CORRECCION_SOLICITADA` to the rest of the system?**
  _43 weakly-connected nodes found - possible missing edges._
- **Should `lombok.Builder` be split into smaller, more focused modules?**
  _Cohesion score 0.10909090909090909 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboarding` connect `PersonaOnboarding` to `SolicitudOnboarding`, `DireccionOnboarding`, `GuarantorProfile`, `OnboardingMapper`, `ActividadEconomica`, `IngresoEgreso`, `lombok`, `CooperativeCreditQueryService.java`, `ReferenciaPersonal`, `PersonaOnboardingResponse`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Should `SolicitudOnboarding` be split into smaller, more focused modules?**
  _Cohesion score 0.13725490196078433 - nodes in this community are weakly interconnected._
- **Why does `SolicitudCooperativaRepository` connect `SolicitudCooperativaRepository` to `org.springframework.data.jpa.repository.JpaRepository`, `CreditGuarantorWorkflowServiceTest`, `org.springframework.stereotype.Service`, `SecurityActivityTest.java`, `CreditGuarantorWorkflowService.java`, `org.springframework.transaction.annotation.Transactional`, `org.springframework.http.ResponseEntity`, `CreditRejectionReason`, `org.springframework.data.jpa.repository.Query`, `CreditGuarantorWorkflowServiceTest.java`, `CooperativeCreditQueryService.java`, `CooperativeCreditDecisionServiceTest.java`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.1339031339031339 - nodes in this community are weakly interconnected._