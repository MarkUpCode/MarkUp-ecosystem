# Graph Report - dinerop-backend  (2026-11-17)

## Corpus Check
- 291 files · ~37,795 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1999 nodes · 5212 edges · 151 communities (56 shown, 95 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 359 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `332b3abb`
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
- AuthService.java
- InvestmentRequestStatus
- org.junit.jupiter.api.Test
- EstadoOnboarding
- CooperativeService
- InvestmentService
- NotificationService
- Cooperative
- CreditController
- lombok.RequiredArgsConstructor
- SolicitudCooperativaStatus
- org.springframework.stereotype.Service
- PageVisitRepository
- UserDetailResponse
- InternalCooperativeDto
- PasswordResetToken
- CreditRequirement
- OnboardingMapper
- auth/config/SecurityConfig.java
- JwtService
- User
- SolicitudCooperativaCotizacion
- org.springframework.http.ResponseEntity
- .publicRegister
- FinancialProductService
- notblank
- DireccionOnboarding
- org.springframework.context.annotation.Bean
- .verifyRegistrationOtp
- postgres
- DireccionRequest
- SolicitudCooperativaRepository
- JwtAuthenticationFilter.java
- CreditGuarantorWorkflowService.java
- application-prod.yaml
- .getCooperatives
- InvestmentService
- UserRepository
- ActividadEconomica
- UserAdminService.java
- AuthController
- OnboardingServiceImpl.java
- IngresoEgreso
- CooperativeInvitation
- OnboardingServiceImpl.java
- .handleBadRequest
- CreditGuarantorSubmission
- bigdecimal
- FirebaseConfig.java
- PersonaOnboardingResponse
- tomcat
- CreditOfferEmailBuilder
- OnboardingClienteController.java
- PreRegisterRequest
- hikari
- management
- InvestmentAcceptanceRecord
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
- .findByEmail
- spring
- ActivationToken
- datasource
- ResetPasswordRequest
- com.markup.dinerop.auth.entity.User
- com.markup:dinerop-backend
- AdminBootstrapRunner.java
- CreditGuarantorWorkflowService.java
- CreditRejectionReason
- SolicitudOnboarding
- InvitationService
- org.springframework.http.HttpStatus
- OnboardingUnificadoResponse
- UserPreRegistration
- CreditRequest.java
- TipoVivienda
- PushDeviceToken
- ForgotPasswordRequest
- .startRegistrationOtp
- UserListItemResponse
- org.springframework.boot.test.context.SpringBootTest
- InternalCreditController
- EmailVerificationOtp
- EstadoGarante

## God Nodes (most connected - your core abstractions)
1. `User` - 62 edges
2. `AuthService` - 49 edges
3. `CreditService` - 46 edges
4. `SolicitudCooperativaRepository` - 43 edges
5. `NotificationService` - 39 edges
6. `CreditController` - 36 edges
7. `UserRepository` - 36 edges
8. `CooperativeService` - 35 edges
9. `FinancialProductService` - 34 edges
10. `SolicitudCooperativa` - 34 edges

## Surprising Connections (you probably didn't know these)
- `SecurityConfig` --references--> `JwtAuthenticationFilter`  [EXTRACTED]
  src/main/java/com/markup/dinerop/auth/config/SecurityConfig.java → src/main/java/com/markup/dinerop/auth/config/JwtAuthenticationFilter.java
- `FinancialProduct` --references--> `InterestPaymentOption`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/entity/FinancialProduct.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InterestPaymentOption.java
- `FinancialProduct` --references--> `InvestmentCalculationMethod`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/entity/FinancialProduct.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentCalculationMethod.java
- `CooperativeService` --references--> `FinancialProductService`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/CooperativeService.java → src/main/java/com/markup/dinerop/cooperative/domain/service/FinancialProductService.java
- `FinancialProductService` --references--> `CooperativeRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/FinancialProductService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRepository.java

## Import Cycles
- None detected.

## Communities (151 total, 95 thin omitted)

### Community 0 - "lombok.Getter"
Cohesion: 0.15
Nodes (15): ChangeRegistrationEmailRequest, JwtResponse, LoginResponse, UserInfo, OtpResendRequest, OtpVerificationRequest, Requirement, InvestmentRequest (+7 more)

### Community 1 - "CreditRequest"
Cohesion: 0.07
Nodes (11): CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, RecentCreditDto, UserStatsDto, VisitStatsDto, CreditRequest, CreditRequestStatus (+3 more)

### Community 2 - "org.springframework.web.bind.annotation.ResponseStatus"
Cohesion: 0.17
Nodes (3): BusinessException, OnboardingExceptionHandler, ResourceNotFoundException

### Community 3 - "CooperativeAdminService"
Cohesion: 0.13
Nodes (6): CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeNotFoundException, CooperativeAdminMapper, CooperativeAdminService

### Community 5 - "PersonaOnboarding"
Cohesion: 0.15
Nodes (7): PersonaOnboarding, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE, GARANTE, SOLICITANTE, PersonaOnboardingRepository

### Community 6 - "lombok.RequiredArgsConstructor"
Cohesion: 0.12
Nodes (6): CooperativeAdminController, DashboardController, DashboardService, InternalAuthController, InvitationController, TestEmailController

### Community 7 - "InvitationServiceTest.java"
Cohesion: 0.09
Nodes (6): EmailVerificationOtpRepository, UserPreRegistrationRepository, AuthServiceOtpFlowTest, AuthServiceSecurityActivityTest, InvitationServiceTest, ClientCreditQuerySecurityTest

### Community 8 - "CooperativeRate"
Cohesion: 0.10
Nodes (6): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto

### Community 9 - "AuthService.java"
Cohesion: 0.11
Nodes (3): CooperativeRequiredException, CooperativeNotFoundException, AuthService

### Community 10 - "InvestmentRequestStatus"
Cohesion: 0.14
Nodes (9): InvestmentRequestStatus, CONDITIONS_CONFIRMED, DECLINED, IN_REVIEW, INFORMATION_REQUIRED, SUBMITTED, InvestmentRequestStatusEvent, InvestmentRequestStatusEventRepository (+1 more)

### Community 12 - "EstadoOnboarding"
Cohesion: 0.20
Nodes (5): EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE, SolicitudOnboardingResponse

### Community 13 - "CooperativeService"
Cohesion: 0.18
Nodes (4): CooperativeService, CooperativeDto, CreateCooperativeDto, CooperativeController

### Community 14 - "InvestmentService"
Cohesion: 0.22
Nodes (4): InvestmentRequestRepository, InvestmentService, InvestmentRequestResponse, StatusEvent

### Community 18 - "CreditController"
Cohesion: 0.08
Nodes (4): PublicCreditRequestResult, CreditProcessEventDto, CreditController, CreditControllerOnboardingGateTest

### Community 19 - "lombok.RequiredArgsConstructor"
Cohesion: 0.22
Nodes (5): OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, ObtenerOnboardingUnificadoUseCase, SolicitarGaranteUseCase

### Community 20 - "SolicitudCooperativaStatus"
Cohesion: 0.24
Nodes (8): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, ActualizarEstadoSolicitudRequest, CooperativeCreditRequestItemDto

### Community 21 - "org.springframework.stereotype.Service"
Cohesion: 0.14
Nodes (5): LoanCalculationResult, LoanCalculator, ClientCreditCooperativeStatusService, CooperativeCreditDecisionService, CooperativeCreditDecisionServiceTest

### Community 22 - "PageVisitRepository"
Cohesion: 0.14
Nodes (4): PageVisit, PageVisitRepository, VisitService, VisitController

### Community 23 - "UserDetailResponse"
Cohesion: 0.19
Nodes (3): UserAdminController, UserDetailResponse, UserAdminService

### Community 26 - "CreditRequirement"
Cohesion: 0.17
Nodes (4): CreditRequirement, CreditRequirementDto, CreditRequirementRepository, CreditRequirementService

### Community 27 - "OnboardingMapper"
Cohesion: 0.09
Nodes (8): ReferenciaPersonal, TipoReferencia, FAMILIAR, PERSONAL, ReferenciaRequest, ReferenciaPersonalResponse, OnboardingMapper, ReferenciaPersonalRepository

### Community 35 - "FinancialProductService"
Cohesion: 0.05
Nodes (20): FinancialProductAdminController, CreditProductCategory, CONSUMO, MICROCREDITO, FinancialProduct, FinancialProductCondition, FinancialProductType, CREDIT (+12 more)

### Community 36 - "notblank"
Cohesion: 0.11
Nodes (3): UpdateUserRequest, CooperativeDecisionRequestDto, TestEmailRequest

### Community 37 - "DireccionOnboarding"
Cohesion: 0.09
Nodes (4): ActividadEconomicaRequest, IngresoEgresoRequest, PersonaOnboardingRequest, SolicitudOnboardingRequest

### Community 38 - "org.springframework.context.annotation.Bean"
Cohesion: 0.15
Nodes (4): OpenApiConfig, WebClientConfig, PasswordEncoderConfig, ResendConfig

### Community 39 - ".verifyRegistrationOtp"
Cohesion: 0.17
Nodes (3): OtpAttemptsExceededException, OtpExpiredException, OtpInvalidException

### Community 40 - "postgres"
Cohesion: 0.13
Nodes (14): POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_USER, container_name, environment, image, ports, restart (+6 more)

### Community 42 - "SolicitudCooperativaRepository"
Cohesion: 0.10
Nodes (4): SolicitudCooperativa, CooperativeCreditQueryService, CreditDistributionService, SolicitudCooperativaRepository

### Community 44 - "CreditGuarantorWorkflowService.java"
Cohesion: 0.10
Nodes (5): CreditGuarantorWorkflowService, TypeReference<>, CooperativeOfferDefaultsDto, CreditGuarantorEvaluationDto, CreditGuarantorHistoryItemDto

### Community 45 - "application-prod.yaml"
Cohesion: 0.13
Nodes (14): app, email-enabled, frontend-url, cors, allowed-origins, firebase, service-account-base64, jwt (+6 more)

### Community 46 - ".getCooperatives"
Cohesion: 0.16
Nodes (3): CooperativeListItemResponse, PagedCooperativesResponse, CooperativeSpecification

### Community 48 - "InvestmentService"
Cohesion: 0.12
Nodes (12): InterestPaymentOption, AT_MATURITY, MONTHLY, REINVEST, InvestmentCalculationMethod, MONTHLY_COMPOUNDING, SIMPLE_INTEREST, UNSPECIFIED (+4 more)

### Community 51 - "UserAdminService.java"
Cohesion: 0.16
Nodes (4): ChangeStatusRequest, PagedUsersResponse, UserStatsResponse, UserNotFoundException

### Community 53 - "OnboardingServiceImpl.java"
Cohesion: 0.10
Nodes (4): CreditProcessEvent, CreditProcessEventRepository, CreditReferralPdfService, OnboardingServiceImpl

### Community 56 - "CooperativeInvitation"
Cohesion: 0.09
Nodes (5): InvitationActivationRequest, InvitationDetailsResponse, CooperativeInvitation, CooperativeInvitationRepository, InvitationService

### Community 59 - ".handleBadRequest"
Cohesion: 0.19
Nodes (4): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException

### Community 60 - "CreditGuarantorSubmission"
Cohesion: 0.12
Nodes (9): CreditGuarantorSubmission, CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA, CreditGuarantorSubmissionRepository (+1 more)

### Community 62 - "bigdecimal"
Cohesion: 0.13
Nodes (4): EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO

### Community 64 - "PersonaOnboardingResponse"
Cohesion: 0.17
Nodes (3): ActividadEconomicaResponse, IngresoEgresoResponse, PersonaOnboardingResponse

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 66 - "CreditOfferEmailBuilder"
Cohesion: 0.17
Nodes (3): ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 71 - "InvestmentAcceptanceRecord"
Cohesion: 0.16
Nodes (6): InvestmentAcceptanceRecord, InvestmentAcceptanceRepository, InvestmentAcceptanceRequest, Requirement, InvestmentAcceptanceResponse, Requirement

### Community 72 - "Role"
Cohesion: 0.24
Nodes (7): RecentUserDto, ChangeRoleRequest, InviteUserRequest, Role, ADMIN, CLIENT, COOPERATIVE

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

### Community 106 - "CreditRejectionReason"
Cohesion: 0.11
Nodes (8): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, AuthenticatedRequestResult, CreditService, GuaranteeDecisionRequestDto

### Community 112 - "CreditRequest.java"
Cohesion: 0.11
Nodes (8): CreditRequestType, CREDITO, INVERSION, CreditType, CONSUMO, MICROCREDITO, ClientCreditRequestDto, PublicCreditRequestDto

### Community 114 - "TipoVivienda"
Cohesion: 0.50
Nodes (3): TipoVivienda, ARRENDADA, PROPIA

### Community 118 - ".startRegistrationOtp"
Cohesion: 0.14
Nodes (4): OtpRegistrationStartResponse, PublicRegistrationRequest, OtpRateLimitException, UserAlreadyActiveException

### Community 131 - "InternalCreditController"
Cohesion: 0.11
Nodes (3): LinkClientRequestDto, LinkClientResponseDto, InternalCreditController

### Community 133 - "EstadoGarante"
Cohesion: 0.40
Nodes (4): EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO

## Knowledge Gaps
- **58 isolated node(s):** `CONSUMO`, `MICROCREDITO`, `CONDITIONS_CONFIRMED`, `DECLINED`, `IN_REVIEW` (+53 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 675 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **95 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `CreditRequest`, `lombok.RequiredArgsConstructor`, `InvitationServiceTest.java`, `AuthService.java`, `.disableToken`, `org.junit.jupiter.api.Test`, `org.springframework.stereotype.Service`, `UserDetailResponse`, `PasswordResetToken`, `JwtService`, `lombok`, `UserRepository`, `UserAdminService.java`, `list`, `CooperativeInvitation`, `Role`, `PushNotificationController`, `.findByEmail`, `ActivationToken`, `AdminBootstrapRunner.java`, `InvitationService`, `OnboardingUnificadoResponse`, `PushDeviceToken`, `.startRegistrationOtp`, `UserListItemResponse`?**
  _High betweenness centrality (0.068) - this node is a cross-community bridge._
- **What connects `CONSUMO`, `MICROCREDITO`, `CONDITIONS_CONFIRMED` to the rest of the system?**
  _58 weakly-connected nodes found - possible missing edges._
- **Should `CreditRequest` be split into smaller, more focused modules?**
  _Cohesion score 0.07051282051282051 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboarding` connect `PersonaOnboarding` to `PersonaOnboardingResponse`, `EstadoGarante`, `.prePersist`, `DireccionOnboarding`, `SolicitudOnboarding`, `lombok`, `ActividadEconomica`, `list`, `IngresoEgreso`, `OnboardingServiceImpl.java`, `OnboardingMapper`, `bigdecimal`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.13054187192118227 - nodes in this community are weakly interconnected._
- **Why does `AuthService` connect `AuthService.java` to `jakarta.transaction.Transactional`, `lombok.RequiredArgsConstructor`, `InvitationServiceTest.java`, `NotificationService`, `Cooperative`, `org.springframework.stereotype.Service`, `UserDetailResponse`, `PasswordResetToken`, `JwtService`, `.publicRegister`, `.verifyRegistrationOtp`, `UserRepository`, `UserAdminService.java`, `AuthController`, `OnboardingServiceImpl.java`, `.findByEmail`, `ActivationToken`, `ResetPasswordRequest`, `AdminBootstrapRunner.java`, `CreditRejectionReason`, `ForgotPasswordRequest`, `.startRegistrationOtp`?**
  _High betweenness centrality (0.031) - this node is a cross-community bridge._
- **Should `PersonaOnboarding` be split into smaller, more focused modules?**
  _Cohesion score 0.14736842105263157 - nodes in this community are weakly interconnected._