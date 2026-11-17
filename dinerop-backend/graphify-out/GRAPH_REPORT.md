# Graph Report - dinerop-backend  (2026-11-17)

## Corpus Check
- 287 files · ~37,393 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 7 file(s) not represented in the graph (top: (none) 4, .properties 1, .cmd 1)

## Summary
- 1980 nodes · 5155 edges · 144 communities (55 shown, 89 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 348 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `797ea025`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- lombok.Getter
- .getDashboard
- org.springframework.web.bind.annotation.ResponseStatus
- CooperativeAdminService
- jakarta.transaction.Transactional
- PersonaOnboarding
- lombok.RequiredArgsConstructor
- InvitationServiceTest.java
- CooperativeRate
- AuthService.java
- InvestmentRequestStatus
- SecurityActivityTest.java
- EstadoOnboarding
- CooperativeService
- lombok.NoArgsConstructor
- CreditRequestRepository
- FinancialProduct
- Cooperative
- CreditController
- lombok.RequiredArgsConstructor
- SolicitudCooperativaStatus
- org.springframework.stereotype.Service
- PageVisitRepository
- UserDetailResponse
- FinancialProductRequest
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
- notblank
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
- org.springframework.data.jpa.repository.JpaRepository
- IngresoEgreso
- CooperativeInvitation
- OnboardingServiceImpl.java
- .handleBadRequest
- CreditGuarantorSubmission
- PersonaOnboardingResponse
- FirebaseConfig.java
- CreditRequest
- tomcat
- NotificationService
- OnboardingClienteController.java
- PreRegisterRequest
- hikari
- management
- InvestmentAcceptanceRecord
- list
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
- lombok.Data
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
- SolicitudOnboarding
- InvitationService
- org.springframework.http.HttpStatus
- OnboardingUnificadoResponse
- UserPreRegistration
- CreditRequest.java
- CooperativeController
- TipoVivienda
- PushDeviceToken
- ForgotPasswordRequest
- .startRegistrationOtp
- FinancialProductType
- ReferenciaPersonal
- .decideRequest
- InternalCreditController
- EmailVerificationOtp
- LinkClientResponseDto
- LinkClientRequestDto
- AccountNotActiveException
- .getOfferDefaults

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
- `InvestmentAcceptanceRepository` --references--> `InvestmentAcceptanceRecord`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/repository/InvestmentAcceptanceRepository.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentAcceptanceRecord.java
- `InvestmentService` --references--> `InvestmentAcceptanceRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/InvestmentService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/InvestmentAcceptanceRepository.java
- `InvestmentService` --references--> `InvestmentRequestRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/InvestmentService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/InvestmentRequestRepository.java
- `InvestmentService` --references--> `InvestmentRequestStatus`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/InvestmentService.java → src/main/java/com/markup/dinerop/cooperative/domain/entity/InvestmentRequestStatus.java
- `InvestmentService` --references--> `CooperativeRepository`  [EXTRACTED]
  src/main/java/com/markup/dinerop/cooperative/domain/service/InvestmentService.java → src/main/java/com/markup/dinerop/cooperative/domain/repository/CooperativeRepository.java

## Import Cycles
- None detected.

## Communities (144 total, 89 thin omitted)

### Community 0 - "lombok.Getter"
Cohesion: 0.22
Nodes (9): ChangeRegistrationEmailRequest, CompleteRegistrationRequest, OtpRegistrationStartResponse, OtpResendRequest, OtpVerificationRequest, InternalCooperativeDto, InternalOnboardingCompletedRequest, FormularioClienteStatusResponse (+1 more)

### Community 1 - ".getDashboard"
Cohesion: 0.16
Nodes (6): CooperativeStatsDto, CreditStatsDto, DashboardResponseDto, RecentUserDto, UserStatsDto, VisitStatsDto

### Community 2 - "org.springframework.web.bind.annotation.ResponseStatus"
Cohesion: 0.17
Nodes (3): BusinessException, OnboardingExceptionHandler, ResourceNotFoundException

### Community 3 - "CooperativeAdminService"
Cohesion: 0.10
Nodes (7): CreateCooperativeRequest, UpdateCooperativeRequest, CooperativeDetailResponse, CooperativeListItemResponse, CooperativeNotFoundException, CooperativeAdminMapper, CooperativeAdminService

### Community 5 - "PersonaOnboarding"
Cohesion: 0.12
Nodes (7): PersonaOnboarding, RolPersona, CONYUGE_GARANTE, CONYUGE_SOLICITANTE, GARANTE, SOLICITANTE, PersonaOnboardingRepository

### Community 6 - "lombok.RequiredArgsConstructor"
Cohesion: 0.11
Nodes (5): CooperativeAdminController, DashboardController, DashboardService, InternalAuthController, InvitationController

### Community 7 - "InvitationServiceTest.java"
Cohesion: 0.08
Nodes (6): PasswordResetTokenRepository, AuthServiceOtpFlowTest, AuthServiceSecurityActivityTest, InvitationServiceTest, ClientCreditQuerySecurityTest, CreditControllerOnboardingGateTest

### Community 8 - "CooperativeRate"
Cohesion: 0.10
Nodes (7): CooperativeRate, CreditType, CONSUMO, MICROCREDITO, CooperativeRateRepository, CooperativeRateDto, CreateCooperativeDto

### Community 9 - "AuthService.java"
Cohesion: 0.08
Nodes (5): CooperativeRequiredException, OtpAttemptsExceededException, OtpExpiredException, OtpInvalidException, OtpRateLimitException

### Community 10 - "InvestmentRequestStatus"
Cohesion: 0.14
Nodes (9): InvestmentRequestStatus, CONDITIONS_CONFIRMED, DECLINED, IN_REVIEW, INFORMATION_REQUIRED, SUBMITTED, InvestmentRequestStatusEvent, InvestmentRequestStatusEventRepository (+1 more)

### Community 12 - "EstadoOnboarding"
Cohesion: 0.20
Nodes (5): EstadoOnboarding, COMPLETADO, EN_PROCESO, SOLICITANDO_GARANTE, SolicitudOnboardingResponse

### Community 13 - "CooperativeService"
Cohesion: 0.16
Nodes (3): CooperativeService, CooperativeDto, InternalCooperativeController

### Community 14 - "lombok.NoArgsConstructor"
Cohesion: 0.21
Nodes (4): JwtResponse, ClientCreditResponseDto, CooperativeDto, CooperativeStatusItemDto

### Community 15 - "CreditRequestRepository"
Cohesion: 0.15
Nodes (4): CreditRequestStatus, CREADA, ENVIADA, CreditRequestRepository

### Community 16 - "FinancialProduct"
Cohesion: 0.11
Nodes (5): FinancialProduct, FinancialProductCondition, FinancialProductConditionRepository, FinancialProductRepository, FinancialProductServiceTest

### Community 19 - "lombok.RequiredArgsConstructor"
Cohesion: 0.29
Nodes (6): OnboardingService, CompletarFormularioGaranteUseCase, CrearSolicitudConSolicitanteUseCase, ObtenerOnboardingUnificadoUseCase, SolicitarGaranteUseCase, OnboardingCooperativaController

### Community 20 - "SolicitudCooperativaStatus"
Cohesion: 0.20
Nodes (8): SolicitudCooperativaStatus, ACEPTADA, ENVIADA, PRE_APROBADA, RECHAZADA, SOLICITANDO_GARANTE, ActualizarEstadoSolicitudRequest, CooperativeCreditRequestItemDto

### Community 21 - "org.springframework.stereotype.Service"
Cohesion: 0.08
Nodes (10): SolicitudCooperativa, ClientCreditAcceptanceService, ClientCreditCooperativeStatusService, CooperativeCreditDecisionService, CreditDistributionService, CreditService, CreditProcessEventRepository, SolicitudCooperativaRepository (+2 more)

### Community 23 - "UserDetailResponse"
Cohesion: 0.16
Nodes (4): UserAdminController, ChangeStatusRequest, UserDetailResponse, UserAdminService

### Community 24 - "FinancialProductRequest"
Cohesion: 0.17
Nodes (5): InvestmentCalculationMethod, MONTHLY_COMPOUNDING, SIMPLE_INTEREST, UNSPECIFIED, FinancialProductRequest

### Community 26 - "CreditRequirement"
Cohesion: 0.09
Nodes (5): CreditProcessEvent, CreditRequirement, CreditRequirementDto, CreditRequirementRepository, CreditRequirementService

### Community 27 - "ReferenciaPersonal"
Cohesion: 0.17
Nodes (5): TipoReferencia, FAMILIAR, PERSONAL, ReferenciaRequest, ReferenciaPersonalResponse

### Community 35 - "FinancialProductService"
Cohesion: 0.11
Nodes (6): FinancialProductAdminController, FinancialProductService, FinancialProductConditionRequest, Condition, FinancialProductResponse, FinancialProductController

### Community 37 - "DireccionOnboarding"
Cohesion: 0.05
Nodes (8): DireccionOnboarding, ActividadEconomicaRequest, DireccionRequest, IngresoEgresoRequest, PersonaOnboardingRequest, SolicitudOnboardingRequest, DireccionOnboardingResponse, DireccionOnboardingRepository

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
Cohesion: 0.17
Nodes (9): InterestPaymentOption, AT_MATURITY, MONTHLY, REINVEST, InvestmentService, CreateInvestmentRequest, InvestmentAvailabilityResponse, InvestmentOfferResponse (+1 more)

### Community 50 - "ActividadEconomica"
Cohesion: 0.17
Nodes (3): ActividadEconomica, ActividadEconomicaResponse, ActividadEconomicaRepository

### Community 51 - "UserAdminService.java"
Cohesion: 0.11
Nodes (11): ChangeRoleRequest, PagedUsersResponse, UserListItemResponse, UserStatsResponse, UserNotFoundException, UserAdminMapper, InviteUserRequest, Role (+3 more)

### Community 54 - "org.springframework.data.jpa.repository.JpaRepository"
Cohesion: 0.11
Nodes (4): InvestmentAcceptanceRepository, InvestmentRequestRepository, PageVisit, PageVisitRepository

### Community 55 - "IngresoEgreso"
Cohesion: 0.17
Nodes (3): IngresoEgreso, IngresoEgresoResponse, IngresoEgresoRepository

### Community 56 - "CooperativeInvitation"
Cohesion: 0.08
Nodes (4): InvitationActivationRequest, InvitationDetailsResponse, CooperativeInvitation, CooperativeInvitationRepository

### Community 58 - "OnboardingServiceImpl.java"
Cohesion: 0.10
Nodes (3): OnboardingServiceImpl, GuarantorProfile, GuarantorProfileRepository

### Community 59 - ".handleBadRequest"
Cohesion: 0.19
Nodes (4): ApiErrorResponse, AdminGlobalExceptionHandler, InvalidUserRoleException, UserAlreadyExistsException

### Community 62 - "PersonaOnboardingResponse"
Cohesion: 0.15
Nodes (9): EstadoFormulario, COMPLETO, PENDIENTE, SOLICITADO, EstadoGarante, ACEPTADO, EN_REVISION, RECHAZADO (+1 more)

### Community 65 - "tomcat"
Cohesion: 0.22
Nodes (9): server, port, tomcat, max, min-spare, accept-count, connection-timeout, max-connections (+1 more)

### Community 66 - "NotificationService"
Cohesion: 0.07
Nodes (6): TestEmailController, NotificationService, ActivationEmailBuilder, CreditOfferEmailBuilder, EmailTemplate, EmailTemplateEngine

### Community 69 - "hikari"
Cohesion: 0.25
Nodes (8): hikari, connection-test-query, connection-timeout, idle-timeout, max-lifetime, maximum-pool-size, minimum-idle, pool-name

### Community 70 - "management"
Cohesion: 0.25
Nodes (8): health, web, include, show-details, management, endpoint, endpoints, exposure

### Community 71 - "InvestmentAcceptanceRecord"
Cohesion: 0.20
Nodes (3): InvestmentAcceptanceRecord, Requirement, InvestmentRequest

### Community 73 - "list"
Cohesion: 0.26
Nodes (3): UserPreRegistrationRepository, CooperativeCreditQueryService, SolicitudOnboardingRepository

### Community 79 - "flyway"
Cohesion: 0.18
Nodes (11): baseline-description, baseline-on-migrate, baseline-version, enabled, ddl-auto, hibernate, open-in-view, show-sql (+3 more)

### Community 80 - "hibernate"
Cohesion: 0.25
Nodes (8): format_sql, generate_statistics, jdbc, order_inserts, order_updates, batch_size, properties, hibernate

### Community 81 - "level"
Cohesion: 0.33
Nodes (6): com.markup.dinerop, com.zaxxer.hikari, org.hibernate, org.springframework, root, level

### Community 84 - "lombok.Data"
Cohesion: 0.24
Nodes (5): LoginRequest, LoginResponse, UserInfo, SendEmailDto, TestEmailRequest

### Community 85 - "spring"
Cohesion: 0.25
Nodes (7): name, enabled, active, spring, application, flyway, profiles

### Community 87 - "datasource"
Cohesion: 0.40
Nodes (5): driver-class-name, password, url, username, datasource

### Community 88 - "CreditGuarantorStatus"
Cohesion: 0.17
Nodes (6): CreditGuarantorStatus, ACEPTADO, CORRECCION_SOLICITADA, EN_REVISION, RECHAZADO, SOLICITUD_RECHAZADA

### Community 89 - "com.markup.dinerop.auth.entity.User"
Cohesion: 0.10
Nodes (7): InvestmentAcceptanceRequest, Requirement, InvestmentAcceptanceResponse, Requirement, InvestmentRequestResponse, StatusEvent, CooperativeInvestmentController

### Community 106 - "CreditRejectionReason"
Cohesion: 0.18
Nodes (6): CreditRejectionReason, BURO_DEL_CREDITO, CAPACIDAD_DE_PAGO, OTROS, TIEMPO_DE_NEGOCIO, GuaranteeDecisionRequestDto

### Community 112 - "CreditRequest.java"
Cohesion: 0.11
Nodes (8): CreditRequestType, CREDITO, INVERSION, CreditType, CONSUMO, MICROCREDITO, ClientCreditRequestDto, PublicCreditRequestDto

### Community 114 - "TipoVivienda"
Cohesion: 0.50
Nodes (3): TipoVivienda, ARRENDADA, PROPIA

### Community 118 - ".startRegistrationOtp"
Cohesion: 0.15
Nodes (4): UserAlreadyActiveException, EmailVerificationOtpRepository, AuthService, PublicCreditRequestResult

### Community 119 - "FinancialProductType"
Cohesion: 0.50
Nodes (3): FinancialProductType, CREDIT, INVESTMENT

## Knowledge Gaps
- **56 isolated node(s):** `CONDITIONS_CONFIRMED`, `DECLINED`, `IN_REVIEW`, `INFORMATION_REQUIRED`, `SUBMITTED` (+51 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 668 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **89 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `User` to `.getDashboard`, `jakarta.transaction.Transactional`, `InvitationServiceTest.java`, `AuthService.java`, `.disableToken`, `lombok.RequiredArgsConstructor`, `org.springframework.stereotype.Service`, `UserDetailResponse`, `PasswordResetToken`, `JwtService`, `lombok`, `UserRepository`, `UserAdminService.java`, `org.springframework.data.jpa.repository.JpaRepository`, `CooperativeInvitation`, `PushNotificationController`, `ActivationToken`, `AdminBootstrapRunner.java`, `InvitationService`, `OnboardingUnificadoResponse`, `PushDeviceToken`, `.startRegistrationOtp`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **What connects `CONDITIONS_CONFIRMED`, `DECLINED`, `IN_REVIEW` to the rest of the system?**
  _56 weakly-connected nodes found - possible missing edges._
- **Should `CooperativeAdminService` be split into smaller, more focused modules?**
  _Cohesion score 0.09615384615384616 - nodes in this community are weakly interconnected._
- **Why does `AuthService` connect `.startRegistrationOtp` to `jakarta.transaction.Transactional`, `lombok.RequiredArgsConstructor`, `InvitationServiceTest.java`, `AuthService.java`, `CreditRequestRepository`, `Cooperative`, `lombok.RequiredArgsConstructor`, `org.springframework.stereotype.Service`, `UserDetailResponse`, `PasswordResetToken`, `JwtService`, `.publicRegister`, `UserRepository`, `UserAdminService.java`, `AuthController`, `OnboardingServiceImpl.java`, `NotificationService`, `list`, `lombok.Data`, `ActivationToken`, `AdminBootstrapRunner.java`, `ForgotPasswordRequest`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **Should `PersonaOnboarding` be split into smaller, more focused modules?**
  _Cohesion score 0.11688311688311688 - nodes in this community are weakly interconnected._
- **Why does `PersonaOnboarding` connect `PersonaOnboarding` to `ReferenciaPersonal`, `DireccionOnboarding`, `list`, `OnboardingMapper`, `SolicitudOnboarding`, `lombok`, `ActividadEconomica`, `IngresoEgreso`, `OnboardingServiceImpl.java`, `PersonaOnboardingResponse`?**
  _High betweenness centrality (0.027) - this node is a cross-community bridge._
- **Should `lombok.RequiredArgsConstructor` be split into smaller, more focused modules?**
  _Cohesion score 0.10574712643678161 - nodes in this community are weakly interconnected._