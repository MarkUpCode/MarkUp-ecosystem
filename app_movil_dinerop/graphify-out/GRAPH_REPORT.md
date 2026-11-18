# Graph Report - app_movil_dinerop  (2026-11-17)

## Corpus Check
- 107 files · ~54,284 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 28 file(s) not represented in the graph (top: .xml 7, (none) 4, .plist 4)

## Summary
- 1842 nodes · 2532 edges · 104 communities (87 shown, 17 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a434622c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- onboarding_page.dart
- registration_verification_page.dart
- welcome_identity_view.dart
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
- app_exception.dart
- credit_request_payload.dart
- dolarito_state.dart
- investment_registration_page.dart
- VoidCallback?
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
- Route /login
- onboarding_repository.dart
- package:flutter/material.dart
- providers.dart
- client_credit_request.dart
- api_client.dart
- List
- app_button.dart
- ConsumerState
- di.dart
- app_spacing.dart
- app_authenticated_header.dart
- dolarito_service.dart
- onboarding_submission_response.dart
- dashboard_exploration_sections.dart
- cooperative_repository.dart
- app_theme.dart
- StatelessWidget
- analysis_options.yaml
- auth_remote_data_source.dart
- MainActivity.kt
- AuthController
- dolarito_widget.dart
- _navigate
- investment_models.dart
- build
- notifications_page.dart
- profile_page.dart
- build
- dolarito_messages.dart
- step_progress.dart
- dolarito_provider.dart
- investment_repository.dart
- app_card.dart
- dolarito_message.dart
- Color
- ConsumerWidget
- dart:async
- credit_simulation_draft_store.dart
- app_header.dart
- authControllerProvider
- credit_enums.dart

## God Nodes (most connected - your core abstractions)
1. `StatelessWidget` - 78 edges
2. `authControllerProvider` - 43 edges
3. `dolaritoServiceProvider` - 28 edges
4. `dependencies` - 15 edges
5. `build` - 13 edges
6. `investmentDraftStoreProvider` - 11 edges
7. `DashboardPage` - 11 edges
8. `dolaritoProvider` - 11 edges
9. `build` - 9 edges
10. `_OnboardingPageState` - 8 edges

## Surprising Connections (you probably didn't know these)
- `didChangeAppLifecycleState` --references--> `authControllerProvider`  [EXTRACTED]
  lib/app/app.dart → lib/features/auth/presentation/auth_controller.dart
- `build` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/complete_registration_page.dart → lib/features/auth/presentation/auth_controller.dart
- `build` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/forgot_password_page.dart → lib/features/auth/presentation/auth_controller.dart
- `_submit` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/forgot_password_page.dart → lib/features/auth/presentation/auth_controller.dart
- `build` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/reset_password_page.dart → lib/features/auth/presentation/auth_controller.dart

## Import Cycles
- None detected.

## Communities (104 total, 17 thin omitted)

### Community 0 - "onboarding_page.dart"
Cohesion: 0.02
Nodes (97): _acceptedDeclaration, _apellidosController, _availableCantons, _availableParishes, _barrioController, build, _buildAddressStep, _buildBenefit (+89 more)

### Community 1 - "registration_verification_page.dart"
Cohesion: 0.09
Nodes (19): _changeEmail, _codeController, _confirmController, createState, _currentEmail, dispose, _editingEmail, email (+11 more)

### Community 2 - "welcome_identity_view.dart"
Cohesion: 0.05
Nodes (43): _banksFade, _banksSlide, build, createState, dispose, _fadeAnimation, _footerFade, icon (+35 more)

### Community 3 - "auth_controller.dart"
Cohesion: 0.05
Nodes (36): activate, authRemoteDataSourceProvider, _authRepository, authRepositoryProvider, _bootstrap, _bootstrapErrorMessage, changeRegistrationEmail, _clearSessionAfterBootstrapFailure (+28 more)

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
Nodes (29): _autoPlayTimer, build, _cancelAutoPlay, _controller, createState, _currentPage, didUpdateWidget, dispose (+21 more)

### Community 10 - "dependencies"
Cohesion: 0.06
Nodes (35): dependencies, cupertino_icons, dio, firebase_core, firebase_messaging, flutter, flutter_local_notifications, flutter_localizations (+27 more)

### Community 11 - "credit_simulator_page.dart"
Cohesion: 0.06
Nodes (31): creditSimulationDraftStoreProvider, amount, annualRate, conditions, cooperativeId, cooperativeName, creditCategory, description (+23 more)

### Community 12 - "auth_repository.dart"
Cohesion: 0.10
Nodes (17): activate, AuthRepository, changeRegistrationEmail, clearSession, completeRegistration, forgotPassword, login, readSession (+9 more)

### Community 13 - "requests_page.dart"
Cohesion: 0.05
Nodes (36): _accept, _accepting, color, createState, dispose, _filteredRequests, _formatInvestmentDate, _guarantorHistory (+28 more)

### Community 14 - "dashboard_page.dart"
Cohesion: 0.17
Nodes (6): _ActivityLoadingState, _CreditLoadingState, _DashboardGreeting, _muted, name, _navy

### Community 15 - "request_credit_page.dart"
Cohesion: 0.07
Nodes (24): _amountController, _cityController, _cityNames, createState, _creditType, dispose, _error, _formKey (+16 more)

### Community 16 - "app_text_field.dart"
Cohesion: 0.08
Nodes (21): build, controller, createState, didUpdateWidget, dispose, enabled, errorAnimationKey, hasError (+13 more)

### Community 17 - "investment_simulator_page.dart"
Cohesion: 0.05
Nodes (40): _amount, _amountController, _availablePaymentOptions, _availableTermMonths, createState, _date, dispose, _draftNotice (+32 more)

### Community 18 - "secure_token_storage.dart"
Cohesion: 0.10
Nodes (19): clear, onboardingComplete, _onboardingKey, _operationTimeout, readSession, readThemeMode, readToken, readWelcomeSeen (+11 more)

### Community 19 - "app_router.dart"
Cohesion: 0.05
Nodes (10): build, createState, didChangeAppLifecycleState, _DineropAppState, dispose, initState, appRouterProvider, authController (+2 more)

### Community 20 - "credit_cooperative_status.dart"
Cohesion: 0.08
Nodes (25): category, cooperativaId, CreditCooperativeStatus, CreditRequirement, cuotaMensual, description, direccion, estado (+17 more)

### Community 21 - "cooperative_logo_marquee.dart"
Cohesion: 0.10
Nodes (14): build, _buildContent, _buildLogoSet, _controller, createState, didUpdateWidget, dispose, gap (+6 more)

### Community 22 - "credit_request_card.dart"
Cohesion: 0.10
Nodes (16): build, color, compact, CreditRequestCard, description, _DetailChip, from, helperText (+8 more)

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
Cohesion: 0.15
Nodes (12): createState, dispose, _email, _error, _firstName, _formKey, _identification, InvestmentRegistrationPage (+4 more)

### Community 28 - "VoidCallback?"
Cohesion: 0.13
Nodes (11): actionLabel, AppEmptyState, build, icon, message, onAction, title, AppErrorView (+3 more)

### Community 29 - "app_user.dart"
Cohesion: 0.13
Nodes (13): AppUserRole, AppUserStatus, email, fromJson, id, isActive, isClient, isPendingActivation (+5 more)

### Community 30 - "credit_repository.dart"
Cohesion: 0.11
Nodes (10): acceptCooperative, _client, createCreditRequest, downloadReferralPdf, loadCatalog, loadGuarantorHistory, loadMyRequests, loadPreApprovedCooperatives (+2 more)

### Community 31 - "String?"
Cohesion: 0.15
Nodes (10): fromJson, message, PublicRegistrationResponse, requestId, status, cooperativasNotificadas, estado, fromJson (+2 more)

### Community 32 - "State"
Cohesion: 0.22
Nodes (12): CooperativeLogoMarquee, _CooperativeLogoMarqueeState, ActiveCreditCarousel, _ActiveCreditCarouselState, _CelebrationConfetti, _CelebrationConfettiState, _StoryProgressBar, _StoryProgressBarState (+4 more)

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
Cohesion: 0.20
Nodes (8): ActivationPage, _ActivationPageState, createState, _done, _error, initState, _message, token

### Community 40 - "investment_draft_store.dart"
Cohesion: 0.11
Nodes (17): amount, annualRate, clear, conditionId, cooperativeId, fromJson, interestPaymentOption, _key (+9 more)

### Community 41 - "app_shell.dart"
Cohesion: 0.15
Nodes (9): build, child, icon, index, label, _NavigationItem, onTap, selectedIcon (+1 more)

### Community 42 - "complete_registration_page.dart"
Cohesion: 0.15
Nodes (12): build, CompleteRegistrationPage, _CompleteRegistrationPageState, _confirmController, createState, dispose, email, _emailController (+4 more)

### Community 43 - "reset_password_page.dart"
Cohesion: 0.15
Nodes (13): build, createState, dispose, _error, _formKey, initState, _message, _passwordController (+5 more)

### Community 44 - "package:go_router/go_router.dart"
Cohesion: 0.06
Nodes (12): _firebaseMessagingBackgroundHandler, initializeApp, initializeDateFormatting, main, null, initializeDateFormatting, main, requests (+4 more)

### Community 45 - "formatters.dart"
Cohesion: 0.18
Nodes (7): _currencyFormatter, _dateFormatter, _dateTimeFormatter, format, formatCurrency, formatDate, formatDateTime

### Community 46 - "push_notification_service.dart"
Cohesion: 0.06
Nodes (26): body, _client, consumePendingOpenedEvent, dispose, _events, _foregroundSubscription, fromData, _handleLocalNotificationResponse (+18 more)

### Community 47 - "forgot_password_page.dart"
Cohesion: 0.13
Nodes (11): build, createState, dispose, _emailController, _error, _formKey, _message, _submit (+3 more)

### Community 48 - "Route /login"
Cohesion: 0.29
Nodes (5): build, _submit, build, build, _showSuccessDialog

### Community 49 - "onboarding_repository.dart"
Cohesion: 0.06
Nodes (27): OnboardingPersonRequest, estadoFormulario, formularioCompleto, fromJson, OnboardingFormStatus, OnboardingStatusResponse, _statusFromString, city (+19 more)

### Community 50 - "package:flutter/material.dart"
Cohesion: 0.17
Nodes (7): build, CooperativesPage, build, CreditBureauPage, AppLoader, build, label

### Community 51 - "providers.dart"
Cohesion: 0.15
Nodes (8): cooperativeRepositoryProvider, cooperativesProvider, investmentProductsProvider, _refreshWhileObserved, timer, watch, CooperativeRepository, CreditRepository

### Community 52 - "client_credit_request.dart"
Cohesion: 0.20
Nodes (9): cantidadSolicitudesEnviadas, ClientCreditRequestSummary, estado, fechaSolicitud, fromJson, monto, motivosRechazo, solicitudId (+1 more)

### Community 53 - "api_client.dart"
Cohesion: 0.20
Nodes (4): _dio, _fieldLabel, _mapError, TokenProvider

### Community 54 - "List"
Cohesion: 0.22
Nodes (7): cantones, EcuadorCanton, EcuadorProvincia, ecuadorProvincias, nombre, parroquias, provincia

### Community 55 - "app_button.dart"
Cohesion: 0.22
Nodes (8): AppButton, AppButtonVariant, build, icon, isLoading, label, onPressed, variant

### Community 56 - "ConsumerState"
Cohesion: 0.18
Nodes (11): DineropApp, ForgotPasswordPage, _ForgotPasswordPageState, _LoginSheet, _LoginSheetState, RegisterPage, _RegisterPageState, RegistrationVerificationPage (+3 more)

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
Cohesion: 0.07
Nodes (27): beforeCreditRequest, creditApplicationMotivation, creditLoadError, creditSimulationNoOffers, creditSimulationOffers, creditSimulationThinking, creditStatus, dashboard (+19 more)

### Community 61 - "onboarding_submission_response.dart"
Cohesion: 0.25
Nodes (6): destinoCredito, estado, fechaCreacion, fromJson, id, OnboardingSubmissionResponse

### Community 62 - "dashboard_exploration_sections.dart"
Cohesion: 0.04
Nodes (47): _ActionTile, build, color, _colors, complete, _controller, createState, _CreditEmptyState (+39 more)

### Community 63 - "cooperative_repository.dart"
Cohesion: 0.08
Nodes (24): annualRate, calculationMethod, _client, conditionId, cooperativeId, cooperativeLogoUrl, cooperativeName, description (+16 more)

### Community 64 - "app_theme.dart"
Cohesion: 0.40
Nodes (3): AppTheme, dark, light

### Community 65 - "StatelessWidget"
Cohesion: 0.07
Nodes (28): _ConditionLine, _ConfirmationRow, _CooperativeLogo, _DisclaimerCard, _ErrorBanner, _IntroCard, _InvestmentRequestCard, _Metric (+20 more)

### Community 66 - "analysis_options.yaml"
Cohesion: 0.50
Nodes (3): include, linter, rules

### Community 67 - "auth_remote_data_source.dart"
Cohesion: 0.12
Nodes (13): activate, AuthRemoteDataSource, changeRegistrationEmail, _client, completeRegistration, forgotPassword, login, register (+5 more)

### Community 74 - "dolarito_widget.dart"
Cohesion: 0.12
Nodes (12): actionLabel, compact, dismissible, DolaritoWidget, imageSize, message, mood, onAction (+4 more)

### Community 75 - "_navigate"
Cohesion: 0.29
Nodes (3): _navigate, _submit, _actionCallback

### Community 76 - "investment_models.dart"
Cohesion: 0.03
Nodes (57): acceptance, acceptanceMessage, agencyAddress, agencyCity, agencyName, amount, annualRate, calculationMethod (+49 more)

### Community 77 - "build"
Cohesion: 0.25
Nodes (11): clientProfileProvider, dashboardCreditRequestsProvider, dashboardOnboardingStatusProvider, build, _loadLocationData, RequestCreditPage, _RequestCreditPageState, build (+3 more)

### Community 78 - "notifications_page.dart"
Cohesion: 0.25
Nodes (5): build, label, _navy, _teal, _UnavailableFilter

### Community 79 - "profile_page.dart"
Cohesion: 0.13
Nodes (13): _ContactCard, data, email, icon, _InfoRow, label, onboardingComplete, onTap (+5 more)

### Community 80 - "build"
Cohesion: 0.15
Nodes (10): creditRepositoryProvider, requestsProvider, build, build, InvestmentRequestsList, investmentRequestsProvider, build, RequestsPage (+2 more)

### Community 81 - "dolarito_messages.dart"
Cohesion: 0.14
Nodes (12): connectionProblem, creditAccepted, creditPending, creditPreApproved, creditRejected, creditReview, DolaritoMessages, guaranteeRequired (+4 more)

### Community 82 - "step_progress.dart"
Cohesion: 0.40
Nodes (4): build, currentStep, StepProgress, totalSteps

### Community 83 - "dolarito_provider.dart"
Cohesion: 0.17
Nodes (5): consumeNavigation, dismiss, reset, show, DolaritoService

### Community 84 - "investment_repository.dart"
Cohesion: 0.22
Nodes (6): ApiClient, _client, compareOffers, createRequest, getAvailability, loadMyRequests

### Community 85 - "app_card.dart"
Cohesion: 0.25
Nodes (7): AppCard, borderColor, build, child, color, onTap, padding

### Community 86 - "dolarito_message.dart"
Cohesion: 0.22
Nodes (8): actionLabel, build, compact, dismissible, DolaritoMessage, message, onAction, onDismiss

### Community 88 - "Color"
Cohesion: 0.25
Nodes (5): AppBadge, build, color, label, textColor

### Community 90 - "ConsumerWidget"
Cohesion: 0.20
Nodes (10): AppShell, build, LoginPage, build, SplashPage, dolaritoProvider, build, DolaritoStateWidget (+2 more)

### Community 92 - "dart:async"
Cohesion: 0.20
Nodes (5): InvestmentDraftStore, InvestmentRepository, investmentRepositoryProvider, timer, watch

### Community 93 - "credit_simulation_draft_store.dart"
Cohesion: 0.12
Nodes (14): amount, clear, creditCategory, CreditSimulationDraft, CreditSimulationDraftStore, fromJson, _key, read (+6 more)

### Community 94 - "app_header.dart"
Cohesion: 0.29
Nodes (5): AppHeader, build, subtitle, title, trailing

### Community 101 - "authControllerProvider"
Cohesion: 0.09
Nodes (28): authControllerProvider, onboardingRepositoryProvider, _activate, initState, initState, _submit, _submit, _submit (+20 more)

### Community 103 - "credit_enums.dart"
Cohesion: 0.22
Nodes (8): CreditDecision, creditDecisionToApiValue, CreditRequestStatus, creditRequestStatusFromJson, CreditRequestType, creditRequestTypeFromJson, CreditType, creditTypeFromJson

## Knowledge Gaps
- **1187 isolated node(s):** `email`, `_codeController`, `_emailController`, `_passwordController`, `_confirmController` (+1182 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 1381 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `StatelessWidget` connect `StatelessWidget` to `welcome_identity_view.dart`, `cooperative_partners_view.dart`, `login_page.dart`, `register_page.dart`, `credit_simulator_page.dart`, `dashboard_page.dart`, `credit_request_card.dart`, `VoidCallback?`, `splash_page.dart`, `app_shell.dart`, `forgot_password_page.dart`, `package:flutter/material.dart`, `app_button.dart`, `app_authenticated_header.dart`, `dashboard_exploration_sections.dart`, `dolarito_widget.dart`, `notifications_page.dart`, `profile_page.dart`, `step_progress.dart`, `app_card.dart`, `dolarito_message.dart`, `Color`, `ConsumerWidget`, `app_header.dart`?**
  _High betweenness centrality (0.036) - this node is a cross-community bridge._
- **What connects `email`, `_codeController`, `_emailController` to the rest of the system?**
  _1187 weakly-connected nodes found - possible missing edges._
- **Should `onboarding_page.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.019230769230769232 - nodes in this community are weakly interconnected._
- **Why does `ApiClient` connect `investment_repository.dart` to `auth_remote_data_source.dart`, `push_notification_service.dart`, `onboarding_repository.dart`, `api_client.dart`, `di.dart`, `credit_repository.dart`, `cooperative_repository.dart`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **Should `registration_verification_page.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._
- **Why does `AppUser` connect `login_response.dart` to `secure_token_storage.dart`, `auth_controller.dart`, `app_user.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Should `welcome_identity_view.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.04521276595744681 - nodes in this community are weakly interconnected._