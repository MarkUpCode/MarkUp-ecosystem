# Graph Report - app_movil_dinerop  (2026-11-18)

## Corpus Check
- 108 files · ~57,917 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 28 file(s) not represented in the graph (top: .xml 7, (none) 4, .plist 4)

## Summary
- 1931 nodes · 2681 edges · 99 communities (91 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `4164ec4d`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- onboarding_page.dart
- registration_verification_page.dart
- auth_remote_data_source.dart
- auth_controller.dart
- cooperative_partners_view.dart
- onboarding_request.dart
- login_page.dart
- app_colors.dart
- register_page.dart
- welcome_page.dart
- dependencies
- credit_simulator_page.dart
- auth_repository.dart
- requests_page.dart
- dashboard_page.dart
- request_credit_page.dart
- app_text_field.dart
- investment_simulator_page.dart
- secure_token_storage.dart
- app_router.dart
- credit_cooperative_status.dart
- cooperative_logo_marquee.dart
- credit_request_card.dart
- dolarito_widget.dart
- app_exception.dart
- credit_request_payload.dart
- dolarito_state.dart
- investment_registration_page.dart
- app_empty_state.dart
- app_user.dart
- credit_repository.dart
- String?
- State
- .application
- credit_request_cooperative.dart
- splash_page.dart
- login_response.dart
- cooperative_summary.dart
- public_registration_request.dart
- activation_page.dart
- investment_draft_store.dart
- app_shell.dart
- complete_registration_page.dart
- reset_password_page.dart
- package:go_router/go_router.dart
- formatters.dart
- push_notification_service.dart
- forgot_password_page.dart
- authControllerProvider
- onboarding_repository.dart
- package:flutter/material.dart
- providers.dart
- client_credit_request.dart
- api_client.dart
- List
- welcome_identity_view.dart
- ConsumerState
- di.dart
- app_spacing.dart
- app_authenticated_header.dart
- dolarito_service.dart
- onboarding_submission_response.dart
- dashboard_exploration_sections.dart
- cooperative_repository.dart
- onboarding_welcome_experience.dart
- StatelessWidget
- analysis_options.yaml
- build
- MainActivity.kt
- AuthController
- dolaritoProvider
- onboardingWelcomeDismissedProvider
- investment_models.dart
- build
- app_theme.dart
- profile_page.dart
- pre_registration_data.dart
- dolarito_messages.dart
- app_button.dart
- dolarito_provider.dart
- investment_repository.dart
- Color
- dolarito_message.dart
- app_card.dart
- onboarding_status_response.dart
- credit_enums.dart
- VoidCallback?
- app_header.dart
- dart:async
- credit_simulation_draft_store.dart
- step_progress.dart
- investmentRequestsProvider
- notifications_page.dart
- authControllerProvider

## God Nodes (most connected - your core abstractions)
1. `StatelessWidget` - 82 edges
2. `authControllerProvider` - 41 edges
3. `dolaritoServiceProvider` - 27 edges
4. `dependencies` - 15 edges
5. `build` - 12 edges
6. `investmentDraftStoreProvider` - 11 edges
7. `_RegistrationVerificationPageState` - 10 edges
8. `dolaritoProvider` - 9 edges
9. `DashboardPage` - 9 edges
10. `ApiClient` - 8 edges

## Surprising Connections (you probably didn't know these)
- `_CreditOfferCard` --inherits--> `StatelessWidget`  [EXTRACTED]
  lib/features/credit/presentation/credit_simulator_page.dart → lib/shared/widgets/app_authenticated_header.dart
- `_ActivityLoadingState` --inherits--> `StatelessWidget`  [EXTRACTED]
  lib/features/dashboard/presentation/dashboard_page.dart → lib/shared/widgets/app_authenticated_header.dart
- `_DashboardGreeting` --inherits--> `StatelessWidget`  [EXTRACTED]
  lib/features/dashboard/presentation/dashboard_page.dart → lib/shared/widgets/app_authenticated_header.dart
- `_UnavailableFilter` --inherits--> `StatelessWidget`  [EXTRACTED]
  lib/features/notifications/presentation/notifications_page.dart → lib/shared/widgets/app_authenticated_header.dart
- `_ConfirmationRow` --inherits--> `StatelessWidget`  [EXTRACTED]
  lib/features/credit/presentation/investment_simulator_page.dart → lib/shared/widgets/app_authenticated_header.dart

## Import Cycles
- None detected.

## Communities (99 total, 8 thin omitted)

### Community 0 - "onboarding_page.dart"
Cohesion: 0.02
Nodes (97): _acceptedDeclaration, _apellidosController, _availableCantons, _availableParishes, _barrioController, build, _buildAddressStep, _buildBenefit (+89 more)

### Community 1 - "registration_verification_page.dart"
Cohesion: 0.08
Nodes (25): _changeEmail, _codeController, _codeFocusNode, _confirmController, _confirmFocusNode, createState, _currentEmail, dispose (+17 more)

### Community 2 - "auth_remote_data_source.dart"
Cohesion: 0.12
Nodes (13): activate, AuthRemoteDataSource, changeRegistrationEmail, _client, completeRegistration, forgotPassword, login, register (+5 more)

### Community 3 - "auth_controller.dart"
Cohesion: 0.05
Nodes (35): activate, authRemoteDataSourceProvider, _authRepository, authRepositoryProvider, _bootstrap, _bootstrapErrorMessage, changeRegistrationEmail, _clearSessionAfterBootstrapFailure (+27 more)

### Community 4 - "cooperative_partners_view.dart"
Cohesion: 0.04
Nodes (39): _ConfettiPainter, assetPath, CooperativePartner, id, initialPartners, logoUrl, nombre, subtitulo (+31 more)

### Community 5 - "onboarding_request.dart"
Cohesion: 0.05
Nodes (40): actividadEconomica, apellidos, barrio, callePrincipal, calleSecundaria, canton, cedula, conyuge (+32 more)

### Community 6 - "login_page.dart"
Cohesion: 0.06
Nodes (28): buttonBackground, buttonIconColor, buttonText, buttonTextColor, createState, _CreditServiceCard, description, dispose (+20 more)

### Community 7 - "app_colors.dart"
Cohesion: 0.06
Nodes (34): accent, accentSoft, AppColors, background, border, borderSubtle, darkAccent, darkAccentSoft (+26 more)

### Community 8 - "register_page.dart"
Cohesion: 0.06
Nodes (32): _acceptedTerms, _amount, _amountValidator, _buildStep, createState, _creditType, dispose, _email (+24 more)

### Community 9 - "welcome_page.dart"
Cohesion: 0.06
Nodes (28): _autoPlayTimer, build, _cancelAutoPlay, _controller, createState, _currentPage, didUpdateWidget, dispose (+20 more)

### Community 10 - "dependencies"
Cohesion: 0.06
Nodes (35): dependencies, cupertino_icons, dio, firebase_core, firebase_messaging, flutter, flutter_local_notifications, flutter_localizations (+27 more)

### Community 11 - "credit_simulator_page.dart"
Cohesion: 0.06
Nodes (31): creditSimulationDraftStoreProvider, amount, annualRate, conditions, cooperativeId, cooperativeName, creditCategory, description (+23 more)

### Community 12 - "auth_repository.dart"
Cohesion: 0.10
Nodes (16): activate, AuthRepository, changeRegistrationEmail, clearSession, completeRegistration, forgotPassword, login, readSession (+8 more)

### Community 13 - "requests_page.dart"
Cohesion: 0.04
Nodes (41): _accept, _accepting, color, createState, dispose, _filteredRequests, _formatInvestmentDate, _guarantorHistory (+33 more)

### Community 14 - "dashboard_page.dart"
Cohesion: 0.17
Nodes (5): _ActivityLoadingState, _DashboardGreeting, _muted, name, _navy

### Community 15 - "request_credit_page.dart"
Cohesion: 0.07
Nodes (24): _amountController, _cityController, _cityNames, createState, _creditType, dispose, _error, _formKey (+16 more)

### Community 16 - "app_text_field.dart"
Cohesion: 0.07
Nodes (22): build, controller, createState, didUpdateWidget, dispose, enabled, errorAnimationKey, focusNode (+14 more)

### Community 17 - "investment_simulator_page.dart"
Cohesion: 0.04
Nodes (48): _amount, _amountController, _availablePaymentOptions, _availableTermMonths, _ConfirmationRow, createState, _date, _DisclaimerCard (+40 more)

### Community 18 - "secure_token_storage.dart"
Cohesion: 0.10
Nodes (19): clear, onboardingComplete, _onboardingKey, _operationTimeout, readSession, readThemeMode, readToken, readWelcomeSeen (+11 more)

### Community 19 - "app_router.dart"
Cohesion: 0.05
Nodes (11): build, createState, didChangeAppLifecycleState, DineropApp, _DineropAppState, dispose, initState, appRouterProvider (+3 more)

### Community 20 - "credit_cooperative_status.dart"
Cohesion: 0.08
Nodes (25): category, cooperativaId, CreditCooperativeStatus, CreditRequirement, cuotaMensual, description, direccion, estado (+17 more)

### Community 21 - "cooperative_logo_marquee.dart"
Cohesion: 0.10
Nodes (14): build, _buildContent, _buildLogoSet, _controller, createState, didUpdateWidget, dispose, gap (+6 more)

### Community 22 - "credit_request_card.dart"
Cohesion: 0.10
Nodes (16): build, color, compact, CreditRequestCard, description, _DetailChip, from, helperText (+8 more)

### Community 23 - "dolarito_widget.dart"
Cohesion: 0.12
Nodes (12): actionLabel, compact, dismissible, DolaritoWidget, imageSize, message, mood, onAction (+4 more)

### Community 24 - "app_exception.dart"
Cohesion: 0.11
Nodes (13): ApiConfig, _envBaseUrl, _envHostIp, _normalize, resolveBaseUrl, AppErrorMessages, AppException, generic (+5 more)

### Community 25 - "credit_request_payload.dart"
Cohesion: 0.20
Nodes (8): amount, city, CreditRequestPayload, creditType, plazoMeses, province, toJson, type

### Community 26 - "dolarito_state.dart"
Cohesion: 0.05
Nodes (33): ThemeNotifier, assetName, DolaritoMood, explaining, action, actionLabel, dismissible, DolaritoAction (+25 more)

### Community 27 - "investment_registration_page.dart"
Cohesion: 0.05
Nodes (39): _acceptedTerms, _amount, _amountValue, _buildConfirmation, _buildFields, _buildOffers, _busy, _canton (+31 more)

### Community 28 - "app_empty_state.dart"
Cohesion: 0.22
Nodes (7): actionLabel, AppEmptyState, build, icon, message, onAction, title

### Community 29 - "app_user.dart"
Cohesion: 0.13
Nodes (13): AppUserRole, AppUserStatus, email, fromJson, id, isActive, isClient, isPendingActivation (+5 more)

### Community 30 - "credit_repository.dart"
Cohesion: 0.11
Nodes (9): acceptCooperative, _client, createCreditRequest, downloadReferralPdf, loadCatalog, loadGuarantorHistory, loadMyRequests, loadPreApprovedCooperatives (+1 more)

### Community 31 - "String?"
Cohesion: 0.15
Nodes (10): fromJson, message, requestId, status, cooperativasNotificadas, CreditRequestResponse, estado, fromJson (+2 more)

### Community 32 - "State"
Cohesion: 0.15
Nodes (20): CooperativeLogoMarquee, _CooperativeLogoMarqueeState, ActiveCreditCarousel, _ActiveCreditCarouselState, _CelebrationConfetti, _CelebrationConfettiState, DashboardApplicationsSection, _DashboardApplicationsSectionState (+12 more)

### Community 33 - ".application"
Cohesion: 0.15
Nodes (5): Flutter, AppDelegate, RunnerTests, UIKit, XCTest

### Community 34 - "credit_request_cooperative.dart"
Cohesion: 0.14
Nodes (13): cooperativaId, CreditRequestCooperative, cuotaMensual, estado, fechaActualizacion, fromJson, interesTotal, monto (+5 more)

### Community 35 - "splash_page.dart"
Cohesion: 0.17
Nodes (6): _BootstrapError, _BrandMark, build, message, onRetry, main

### Community 36 - "login_response.dart"
Cohesion: 0.29
Nodes (5): AppUser, accessToken, fromJson, LoginResponse, user

### Community 37 - "cooperative_summary.dart"
Cohesion: 0.15
Nodes (11): calificacion, ciudad, CooperativeSummary, direccion, fromJson, id, logoUrl, nombre (+3 more)

### Community 38 - "public_registration_request.dart"
Cohesion: 0.15
Nodes (12): amount, city, creditType, email, firstName, identification, lastName, phone (+4 more)

### Community 39 - "activation_page.dart"
Cohesion: 0.13
Nodes (12): _activate, ActivationPage, _ActivationPageState, createState, _done, _error, initState, _message (+4 more)

### Community 40 - "investment_draft_store.dart"
Cohesion: 0.11
Nodes (17): amount, annualRate, clear, conditionId, cooperativeId, fromJson, interestPaymentOption, _key (+9 more)

### Community 41 - "app_shell.dart"
Cohesion: 0.12
Nodes (11): build, child, icon, index, label, _navigate, _NavigationItem, onTap (+3 more)

### Community 42 - "complete_registration_page.dart"
Cohesion: 0.17
Nodes (11): CompleteRegistrationPage, _CompleteRegistrationPageState, _confirmController, createState, dispose, email, _emailController, _error (+3 more)

### Community 43 - "reset_password_page.dart"
Cohesion: 0.17
Nodes (11): createState, dispose, _error, _formKey, initState, _message, _passwordController, ResetPasswordPage (+3 more)

### Community 44 - "package:go_router/go_router.dart"
Cohesion: 0.05
Nodes (18): _firebaseMessagingBackgroundHandler, initializeApp, initializeDateFormatting, main, null, build, createState, initializeDateFormatting (+10 more)

### Community 45 - "formatters.dart"
Cohesion: 0.18
Nodes (7): _currencyFormatter, _dateFormatter, _dateTimeFormatter, format, formatCurrency, formatDate, formatDateTime

### Community 46 - "push_notification_service.dart"
Cohesion: 0.06
Nodes (26): body, _client, consumePendingOpenedEvent, dispose, _events, _foregroundSubscription, fromData, _handleLocalNotificationResponse (+18 more)

### Community 47 - "forgot_password_page.dart"
Cohesion: 0.20
Nodes (9): createState, dispose, _emailController, _error, ForgotPasswordPage, _ForgotPasswordPageState, _formKey, _message (+1 more)

### Community 48 - "authControllerProvider"
Cohesion: 0.14
Nodes (13): authControllerProvider, build, build, initState, _submit, build, build, build (+5 more)

### Community 49 - "onboarding_repository.dart"
Cohesion: 0.12
Nodes (12): OnboardingPersonRequest, _client, fromJson, GuarantorProfile, id, loadMyGuarantorProfiles, loadPreRegistrationData, loadStatus (+4 more)

### Community 50 - "package:flutter/material.dart"
Cohesion: 0.17
Nodes (7): build, CooperativesPage, build, CreditBureauPage, AppLoader, build, label

### Community 51 - "providers.dart"
Cohesion: 0.13
Nodes (10): cooperativeRepositoryProvider, cooperativesProvider, creditRepositoryProvider, investmentProductsProvider, _refreshWhileObserved, timer, watch, CooperativeRepository (+2 more)

### Community 52 - "client_credit_request.dart"
Cohesion: 0.20
Nodes (9): cantidadSolicitudesEnviadas, ClientCreditRequestSummary, estado, fechaSolicitud, fromJson, monto, motivosRechazo, solicitudId (+1 more)

### Community 53 - "api_client.dart"
Cohesion: 0.20
Nodes (5): ApiClient, _dio, _fieldLabel, _mapError, TokenProvider

### Community 54 - "List"
Cohesion: 0.22
Nodes (7): cantones, EcuadorCanton, EcuadorProvincia, ecuadorProvincias, nombre, parroquias, provincia

### Community 55 - "welcome_identity_view.dart"
Cohesion: 0.05
Nodes (43): _banksFade, _banksSlide, build, createState, dispose, _fadeAnimation, _footerFade, icon (+35 more)

### Community 56 - "ConsumerState"
Cohesion: 0.25
Nodes (6): RegisterPage, _RegisterPageState, _OfferCard, _OfferCardState, WelcomePage, _WelcomePageState

### Community 57 - "di.dart"
Cohesion: 0.12
Nodes (9): apiClientProvider, baseUrl, flutterSecureStorageProvider, secureTokenStorageProvider, storage, SecureTokenStorage, _loadTheme, setThemeMode (+1 more)

### Community 58 - "app_spacing.dart"
Cohesion: 0.22
Nodes (7): AppSpacing, lg, md, sm, xl, xs, xxl

### Community 59 - "app_authenticated_header.dart"
Cohesion: 0.20
Nodes (6): AppAuthenticatedHeader, build, onNotifications, preferredSize, _showHelp, showNotifications

### Community 60 - "dolarito_service.dart"
Cohesion: 0.06
Nodes (28): beforeCreditRequest, creditApplicationMotivation, creditLoadError, creditSimulationNoOffers, creditSimulationOffers, creditSimulationThinking, creditStatus, dashboard (+20 more)

### Community 61 - "onboarding_submission_response.dart"
Cohesion: 0.25
Nodes (6): destinoCredito, estado, fechaCreacion, fromJson, id, OnboardingSubmissionResponse

### Community 62 - "dashboard_exploration_sections.dart"
Cohesion: 0.04
Nodes (52): actionLabel, build, child, color, _colors, _controller, count, createState (+44 more)

### Community 63 - "cooperative_repository.dart"
Cohesion: 0.08
Nodes (24): annualRate, calculationMethod, _client, conditionId, cooperativeId, cooperativeLogoUrl, cooperativeName, description (+16 more)

### Community 64 - "onboarding_welcome_experience.dart"
Cohesion: 0.09
Nodes (19): _attentionTimer, build, createState, didUpdateWidget, dispose, _entry, initState, isFirstWelcome (+11 more)

### Community 65 - "StatelessWidget"
Cohesion: 0.06
Nodes (35): _ConditionLine, _CooperativeLogo, _IntroCard, _SignInToSeeRequests, _ActionTile, _ActivityTile, _ApplicationCard, _ApplicationEmptyState (+27 more)

### Community 66 - "analysis_options.yaml"
Cohesion: 0.50
Nodes (3): include, linter, rules

### Community 74 - "dolaritoProvider"
Cohesion: 0.20
Nodes (10): AppShell, build, LoginPage, build, SplashPage, dolaritoProvider, build, DolaritoStateWidget (+2 more)

### Community 75 - "onboardingWelcomeDismissedProvider"
Cohesion: 0.32
Nodes (7): onboardingWelcomeDismissedProvider, onboardingWelcomeIsFirstProvider, _LoginSheet, _LoginSheetState, _submit, _setPassword, _submit

### Community 76 - "investment_models.dart"
Cohesion: 0.04
Nodes (56): acceptance, acceptanceMessage, agencyAddress, agencyCity, agencyName, amount, annualRate, calculationMethod (+48 more)

### Community 77 - "build"
Cohesion: 0.27
Nodes (11): clientProfileProvider, dashboardCreditRequestsProvider, dashboardOnboardingStatusProvider, build, _loadLocationData, RequestCreditPage, _RequestCreditPageState, build (+3 more)

### Community 78 - "app_theme.dart"
Cohesion: 0.40
Nodes (3): AppTheme, dark, light

### Community 79 - "profile_page.dart"
Cohesion: 0.12
Nodes (13): _ContactCard, data, email, icon, _InfoRow, label, onboardingComplete, onTap (+5 more)

### Community 80 - "pre_registration_data.dart"
Cohesion: 0.20
Nodes (9): city, email, firstName, fromJson, identification, lastName, phone, PreRegistrationData (+1 more)

### Community 81 - "dolarito_messages.dart"
Cohesion: 0.14
Nodes (12): connectionProblem, creditAccepted, creditPending, creditPreApproved, creditRejected, creditReview, DolaritoMessages, guaranteeRequired (+4 more)

### Community 82 - "app_button.dart"
Cohesion: 0.22
Nodes (8): AppButton, AppButtonVariant, build, icon, isLoading, label, onPressed, variant

### Community 83 - "dolarito_provider.dart"
Cohesion: 0.18
Nodes (5): consumeNavigation, dismiss, reset, show, DolaritoService

### Community 84 - "investment_repository.dart"
Cohesion: 0.22
Nodes (6): _client, compareOffers, createPublicRequest, createRequest, getAvailability, loadMyRequests

### Community 85 - "Color"
Cohesion: 0.25
Nodes (5): AppBadge, build, color, label, textColor

### Community 86 - "dolarito_message.dart"
Cohesion: 0.22
Nodes (8): actionLabel, build, compact, dismissible, DolaritoMessage, message, onAction, onDismiss

### Community 87 - "app_card.dart"
Cohesion: 0.25
Nodes (7): AppCard, borderColor, build, child, color, onTap, padding

### Community 88 - "onboarding_status_response.dart"
Cohesion: 0.29
Nodes (6): estadoFormulario, formularioCompleto, fromJson, OnboardingFormStatus, OnboardingStatusResponse, _statusFromString

### Community 89 - "credit_enums.dart"
Cohesion: 0.22
Nodes (8): CreditDecision, creditDecisionToApiValue, CreditRequestStatus, creditRequestStatusFromJson, CreditRequestType, creditRequestTypeFromJson, CreditType, creditTypeFromJson

### Community 90 - "VoidCallback?"
Cohesion: 0.29
Nodes (4): AppErrorView, build, message, onRetry

### Community 91 - "app_header.dart"
Cohesion: 0.29
Nodes (5): AppHeader, build, subtitle, title, trailing

### Community 92 - "dart:async"
Cohesion: 0.20
Nodes (5): InvestmentDraftStore, InvestmentRepository, investmentRepositoryProvider, timer, watch

### Community 93 - "credit_simulation_draft_store.dart"
Cohesion: 0.12
Nodes (14): amount, clear, creditCategory, CreditSimulationDraft, CreditSimulationDraftStore, fromJson, _key, read (+6 more)

### Community 95 - "step_progress.dart"
Cohesion: 0.40
Nodes (4): build, currentStep, StepProgress, totalSteps

### Community 96 - "investmentRequestsProvider"
Cohesion: 0.29
Nodes (7): requestsProvider, build, InvestmentRequestsList, investmentRequestsProvider, build, RequestsPage, _RequestsPageState

### Community 97 - "notifications_page.dart"
Cohesion: 0.25
Nodes (5): build, label, _navy, _teal, _UnavailableFilter

### Community 101 - "authControllerProvider"
Cohesion: 0.13
Nodes (20): onboardingRepositoryProvider, initState, _submit, _loadInvestmentRegistration, _showInvestmentRegistrationMessage, _compare, _compare, initState (+12 more)

## Knowledge Gaps
- **1255 isolated node(s):** `_CreditStatus`, `_navy`, `_teal`, `_muted`, `_line` (+1250 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 1448 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ApiClient` connect `api_client.dart` to `auth_remote_data_source.dart`, `push_notification_service.dart`, `onboarding_repository.dart`, `investment_repository.dart`, `di.dart`, `credit_repository.dart`, `cooperative_repository.dart`?**
  _High betweenness centrality (0.027) - this node is a cross-community bridge._
- **What connects `_CreditStatus`, `_navy`, `_teal` to the rest of the system?**
  _1255 weakly-connected nodes found - possible missing edges._
- **Should `onboarding_page.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.019417475728155338 - nodes in this community are weakly interconnected._
- **Why does `StatelessWidget` connect `StatelessWidget` to `cooperative_partners_view.dart`, `login_page.dart`, `register_page.dart`, `credit_simulator_page.dart`, `dashboard_page.dart`, `investment_simulator_page.dart`, `credit_request_card.dart`, `dolarito_widget.dart`, `app_empty_state.dart`, `splash_page.dart`, `activation_page.dart`, `app_shell.dart`, `package:flutter/material.dart`, `welcome_identity_view.dart`, `app_authenticated_header.dart`, `profile_page.dart`, `app_button.dart`, `Color`, `dolarito_message.dart`, `app_card.dart`, `VoidCallback?`, `app_header.dart`, `step_progress.dart`, `notifications_page.dart`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Should `registration_verification_page.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._
- **Why does `CreditRequestStatus` connect `credit_enums.dart` to `credit_request_cooperative.dart`, `requests_page.dart`, `client_credit_request.dart`, `credit_cooperative_status.dart`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Should `auth_remote_data_source.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.11764705882352941 - nodes in this community are weakly interconnected._