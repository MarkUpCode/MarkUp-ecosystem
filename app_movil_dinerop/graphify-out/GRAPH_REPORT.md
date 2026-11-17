# Graph Report - app_movil_dinerop  (2026-11-16)

## Corpus Check
- 90 files · ~44,581 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 28 file(s) not represented in the graph (top: .xml 7, (none) 4, .plist 4)

## Summary
- 1461 nodes · 1982 edges · 77 communities (69 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `105f90ed`
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
- StatelessWidget
- app_exception.dart
- credit_request_payload.dart
- app.dart
- VoidCallback
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
- Route /login
- app_shell.dart
- complete_registration_page.dart
- reset_password_page.dart
- main.dart
- formatters.dart
- push_notification_service.dart
- forgot_password_page.dart
- authControllerProvider
- profile_page.dart
- package:flutter/material.dart
- providers.dart
- client_credit_request.dart
- api_client.dart
- theme_provider.dart
- app_button.dart
- _navigate
- di.dart
- app_spacing.dart
- app_authenticated_header.dart
- onboarding_submission_response.dart
- dashboard_exploration_sections.dart
- cooperative_repository.dart
- analysis_options.yaml
- auth_remote_data_source.dart
- MainActivity.kt
- AuthController
- package:flutter_riverpod/flutter_riverpod.dart
- ConsumerState
- List
- notifications_page.dart
- clientProfileProvider
- step_progress.dart

## God Nodes (most connected - your core abstractions)
1. `StatelessWidget` - 63 edges
2. `authControllerProvider` - 38 edges
3. `dependencies` - 15 edges
4. `build` - 9 edges
5. `clientProfileProvider` - 7 edges
6. `DashboardPage` - 7 edges
7. `_DineropAppState` - 7 edges
8. `ApiClient` - 7 edges
9. `_OnboardingPageState` - 6 edges
10. `build` - 6 edges

## Surprising Connections (you probably didn't know these)
- `_loadLocationData` --references--> `clientProfileProvider`  [EXTRACTED]
  lib/features/credit/presentation/request_credit_page.dart → app_movil_dinerop/lib/app/providers.dart
- `_RequestCreditPageState` --references--> `clientProfileProvider`  [EXTRACTED]
  lib/features/credit/presentation/request_credit_page.dart → app_movil_dinerop/lib/app/providers.dart
- `DashboardPage` --references--> `authControllerProvider`  [EXTRACTED]
  app_movil_dinerop/lib/features/dashboard/presentation/dashboard_page.dart → lib/features/auth/presentation/auth_controller.dart
- `_DashboardGreeting` --inherits--> `StatelessWidget`  [EXTRACTED]
  app_movil_dinerop/lib/features/dashboard/presentation/dashboard_page.dart → lib/shared/widgets/app_authenticated_header.dart
- `_CreditLoadingState` --inherits--> `StatelessWidget`  [EXTRACTED]
  app_movil_dinerop/lib/features/dashboard/presentation/dashboard_page.dart → lib/shared/widgets/app_authenticated_header.dart

## Import Cycles
- None detected.

## Communities (77 total, 8 thin omitted)

### Community 0 - "onboarding_page.dart"
Cohesion: 0.02
Nodes (99): _acceptedDeclaration, _apellidosController, _availableCantons, _availableParishes, _barrioController, build, _buildAddressStep, _buildBenefit (+91 more)

### Community 1 - "registration_verification_page.dart"
Cohesion: 0.10
Nodes (18): _codeController, _confirmController, createState, _currentEmail, dispose, _editingEmail, email, _emailController (+10 more)

### Community 2 - "welcome_identity_view.dart"
Cohesion: 0.05
Nodes (43): _banksFade, _banksSlide, build, createState, dispose, _fadeAnimation, _footerFade, icon (+35 more)

### Community 3 - "auth_controller.dart"
Cohesion: 0.04
Nodes (36): activate, authRemoteDataSourceProvider, _authRepository, authRepositoryProvider, _bootstrap, _bootstrapErrorMessage, changeRegistrationEmail, _clearSessionAfterBootstrapFailure (+28 more)

### Community 4 - "cooperative_partners_view.dart"
Cohesion: 0.04
Nodes (39): _ConfettiPainter, assetPath, CooperativePartner, id, initialPartners, logoUrl, nombre, subtitulo (+31 more)

### Community 5 - "onboarding_request.dart"
Cohesion: 0.05
Nodes (40): actividadEconomica, apellidos, barrio, callePrincipal, calleSecundaria, canton, cedula, conyuge (+32 more)

### Community 6 - "login_page.dart"
Cohesion: 0.06
Nodes (29): build, buttonBackground, buttonIconColor, buttonText, buttonTextColor, createState, _CreditServiceCard, description (+21 more)

### Community 7 - "app_colors.dart"
Cohesion: 0.06
Nodes (34): accent, accentSoft, AppColors, background, border, borderSubtle, darkAccent, darkAccentSoft (+26 more)

### Community 8 - "register_page.dart"
Cohesion: 0.06
Nodes (34): _acceptedTerms, _amount, _amountValidator, _buildStep, createState, _creditType, dispose, _email (+26 more)

### Community 9 - "welcome_page.dart"
Cohesion: 0.06
Nodes (29): _autoPlayTimer, build, _cancelAutoPlay, _controller, createState, _currentPage, didUpdateWidget, dispose (+21 more)

### Community 10 - "dependencies"
Cohesion: 0.06
Nodes (35): dependencies, cupertino_icons, dio, firebase_core, firebase_messaging, flutter, flutter_local_notifications, flutter_localizations (+27 more)

### Community 11 - "credit_simulator_page.dart"
Cohesion: 0.08
Nodes (25): _amount, _amountController, build, color, createState, _CreditData, _CreditOffer, _CreditOfferCard (+17 more)

### Community 12 - "auth_repository.dart"
Cohesion: 0.12
Nodes (12): activate, AuthRepository, clearSession, completeRegistration, forgotPassword, login, readSession, register (+4 more)

### Community 13 - "requests_page.dart"
Cohesion: 0.05
Nodes (34): creditRepositoryProvider, _accept, _accepting, color, createState, dispose, _filteredRequests, _guarantorHistory (+26 more)

### Community 14 - "dashboard_page.dart"
Cohesion: 0.15
Nodes (6): _ActivityLoadingState, _CreditLoadingState, _DashboardGreeting, _muted, name, _navy

### Community 15 - "request_credit_page.dart"
Cohesion: 0.07
Nodes (24): _amountController, build, _cityController, _cityNames, createState, _creditType, dispose, _error (+16 more)

### Community 16 - "app_text_field.dart"
Cohesion: 0.08
Nodes (21): build, controller, createState, didUpdateWidget, dispose, enabled, errorAnimationKey, hasError (+13 more)

### Community 17 - "investment_simulator_page.dart"
Cohesion: 0.08
Nodes (23): investmentProductsProvider, _amount, _amountController, build, color, createState, dispose, finalValue (+15 more)

### Community 18 - "secure_token_storage.dart"
Cohesion: 0.09
Nodes (19): clear, onboardingComplete, _onboardingKey, _operationTimeout, readSession, readThemeMode, readToken, readWelcomeSeen (+11 more)

### Community 20 - "credit_cooperative_status.dart"
Cohesion: 0.08
Nodes (25): category, cooperativaId, CreditCooperativeStatus, CreditRequirement, cuotaMensual, description, direccion, estado (+17 more)

### Community 21 - "cooperative_logo_marquee.dart"
Cohesion: 0.11
Nodes (14): build, _buildContent, _buildLogoSet, _controller, createState, didUpdateWidget, dispose, gap (+6 more)

### Community 22 - "credit_request_card.dart"
Cohesion: 0.05
Nodes (33): build, color, compact, CreditRequestCard, description, _DetailChip, from, helperText (+25 more)

### Community 23 - "StatelessWidget"
Cohesion: 0.15
Nodes (24): AppShell, _NavigationItem, _InvestmentData, _InvestmentOfferCard, _ActionTile, _ActivityTile, _CreditEmptyState, _CreditStepper (+16 more)

### Community 24 - "app_exception.dart"
Cohesion: 0.11
Nodes (13): ApiConfig, _envBaseUrl, _envHostIp, _normalize, resolveBaseUrl, AppErrorMessages, AppException, generic (+5 more)

### Community 25 - "credit_request_payload.dart"
Cohesion: 0.12
Nodes (16): CreditDecision, creditDecisionToApiValue, CreditRequestStatus, creditRequestStatusFromJson, CreditRequestType, creditRequestTypeFromJson, CreditType, creditTypeFromJson (+8 more)

### Community 26 - "app.dart"
Cohesion: 0.15
Nodes (8): build, createState, didChangeAppLifecycleState, DineropApp, _DineropAppState, dispose, initState, appRouterProvider

### Community 27 - "VoidCallback"
Cohesion: 0.29
Nodes (4): AppErrorView, build, message, onRetry

### Community 28 - "VoidCallback?"
Cohesion: 0.22
Nodes (7): actionLabel, AppEmptyState, build, icon, message, onAction, title

### Community 29 - "app_user.dart"
Cohesion: 0.13
Nodes (13): AppUserRole, AppUserStatus, email, fromJson, id, isActive, isClient, isPendingActivation (+5 more)

### Community 30 - "credit_repository.dart"
Cohesion: 0.12
Nodes (9): acceptCooperative, _client, createCreditRequest, downloadReferralPdf, loadCatalog, loadGuarantorHistory, loadMyRequests, loadPreApprovedCooperatives (+1 more)

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
Cohesion: 0.15
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
Nodes (7): _activate, createState, _done, _error, initState, _message, token

### Community 40 - "Route /login"
Cohesion: 0.29
Nodes (5): build, _submit, build, build, _showSuccessDialog

### Community 41 - "app_shell.dart"
Cohesion: 0.18
Nodes (8): build, child, icon, index, label, onTap, selectedIcon, selectedIndex

### Community 42 - "complete_registration_page.dart"
Cohesion: 0.17
Nodes (11): build, _confirmController, createState, dispose, email, _emailController, _error, _formKey (+3 more)

### Community 43 - "reset_password_page.dart"
Cohesion: 0.12
Nodes (14): email, message, PendingActivationPage, build, createState, dispose, _error, _formKey (+6 more)

### Community 44 - "main.dart"
Cohesion: 0.18
Nodes (5): _firebaseMessagingBackgroundHandler, initializeApp, initializeDateFormatting, main, null

### Community 45 - "formatters.dart"
Cohesion: 0.18
Nodes (7): _currencyFormatter, _dateFormatter, _dateTimeFormatter, format, formatCurrency, formatDate, formatDateTime

### Community 46 - "push_notification_service.dart"
Cohesion: 0.18
Nodes (6): _client, initializeAndRegister, _localNotifications, PushNotificationService, _registerToken, _showForegroundNotification

### Community 47 - "forgot_password_page.dart"
Cohesion: 0.18
Nodes (8): build, createState, dispose, _emailController, _error, _formKey, _message, _submit

### Community 48 - "authControllerProvider"
Cohesion: 0.18
Nodes (12): authControllerProvider, _submit, _submit, build, _changeEmail, _resendCode, _setPassword, _verifyCode (+4 more)

### Community 49 - "profile_page.dart"
Cohesion: 0.04
Nodes (40): OnboardingPersonRequest, estadoFormulario, formularioCompleto, fromJson, OnboardingFormStatus, OnboardingStatusResponse, _statusFromString, city (+32 more)

### Community 50 - "package:flutter/material.dart"
Cohesion: 0.12
Nodes (10): AppTheme, dark, light, build, CooperativesPage, build, CreditBureauPage, AppLoader (+2 more)

### Community 51 - "providers.dart"
Cohesion: 0.11
Nodes (12): cooperativeRepositoryProvider, cooperativesProvider, dashboardCreditRequestsProvider, dashboardOnboardingStatusProvider, _refreshWhileObserved, requestsProvider, timer, watch (+4 more)

### Community 52 - "client_credit_request.dart"
Cohesion: 0.18
Nodes (9): cantidadSolicitudesEnviadas, ClientCreditRequestSummary, estado, fechaSolicitud, fromJson, monto, motivosRechazo, solicitudId (+1 more)

### Community 53 - "api_client.dart"
Cohesion: 0.20
Nodes (5): ApiClient, _dio, _fieldLabel, _mapError, TokenProvider

### Community 54 - "theme_provider.dart"
Cohesion: 0.20
Nodes (5): SecureTokenStorage, _loadTheme, setThemeMode, _storage, ThemeNotifier

### Community 55 - "app_button.dart"
Cohesion: 0.22
Nodes (8): AppButton, AppButtonVariant, build, icon, isLoading, label, onPressed, variant

### Community 57 - "di.dart"
Cohesion: 0.20
Nodes (5): apiClientProvider, baseUrl, flutterSecureStorageProvider, secureTokenStorageProvider, storage

### Community 58 - "app_spacing.dart"
Cohesion: 0.22
Nodes (7): AppSpacing, lg, md, sm, xl, xs, xxl

### Community 59 - "app_authenticated_header.dart"
Cohesion: 0.20
Nodes (6): AppAuthenticatedHeader, build, onNotifications, preferredSize, _showHelp, showNotifications

### Community 61 - "onboarding_submission_response.dart"
Cohesion: 0.25
Nodes (6): destinoCredito, estado, fechaCreacion, fromJson, id, OnboardingSubmissionResponse

### Community 62 - "dashboard_exploration_sections.dart"
Cohesion: 0.05
Nodes (40): build, color, _colors, comingSoon, complete, _controller, createState, _CreditStatus (+32 more)

### Community 63 - "cooperative_repository.dart"
Cohesion: 0.12
Nodes (13): annualRate, _client, cooperativeName, CooperativeRepository, InvestmentProductOffer, loadCooperatives, loadInvestmentCatalog, loadInvestmentProducts (+5 more)

### Community 66 - "analysis_options.yaml"
Cohesion: 0.50
Nodes (3): include, linter, rules

### Community 67 - "auth_remote_data_source.dart"
Cohesion: 0.12
Nodes (12): activate, AuthRemoteDataSource, changeRegistrationEmail, _client, completeRegistration, forgotPassword, login, register (+4 more)

### Community 74 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.18
Nodes (4): initializeDateFormatting, main, requests, widths

### Community 75 - "ConsumerState"
Cohesion: 0.18
Nodes (12): ActivationPage, _ActivationPageState, CompleteRegistrationPage, _CompleteRegistrationPageState, ForgotPasswordPage, _ForgotPasswordPageState, _LoginSheet, _LoginSheetState (+4 more)

### Community 76 - "List"
Cohesion: 0.22
Nodes (7): cantones, EcuadorCanton, EcuadorProvincia, ecuadorProvincias, nombre, parroquias, provincia

### Community 78 - "notifications_page.dart"
Cohesion: 0.25
Nodes (6): build, label, _navy, NotificationsPage, _teal, _UnavailableFilter

### Community 80 - "clientProfileProvider"
Cohesion: 0.25
Nodes (8): clientProfileProvider, themeModeProvider, LoginPage, SplashPage, _loadLocationData, build, ProfilePage, _RequestDetailsSheet

### Community 82 - "step_progress.dart"
Cohesion: 0.40
Nodes (4): build, currentStep, StepProgress, totalSteps

## Knowledge Gaps
- **919 isolated node(s):** `timer`, `cooperativeRepositoryProvider`, `cooperativesProvider`, `_refreshWhileObserved`, `watch` (+914 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 1090 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ApiClient` connect `api_client.dart` to `auth_remote_data_source.dart`, `push_notification_service.dart`, `profile_page.dart`, `di.dart`, `credit_repository.dart`, `cooperative_repository.dart`?**
  _High betweenness centrality (0.031) - this node is a cross-community bridge._
- **What connects `timer`, `cooperativeRepositoryProvider`, `cooperativesProvider` to the rest of the system?**
  _919 weakly-connected nodes found - possible missing edges._
- **Should `onboarding_page.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.018867924528301886 - nodes in this community are weakly interconnected._
- **Why does `StatelessWidget` connect `StatelessWidget` to `welcome_identity_view.dart`, `splash_page.dart`, `cooperative_partners_view.dart`, `login_page.dart`, `register_page.dart`, `VoidCallback`, `reset_password_page.dart`, `credit_simulator_page.dart`, `dashboard_page.dart`, `notifications_page.dart`, `profile_page.dart`, `package:flutter/material.dart`, `step_progress.dart`, `credit_request_card.dart`, `app_button.dart`, `app_authenticated_header.dart`, `VoidCallback?`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Should `registration_verification_page.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._
- **Why does `SecureTokenStorage` connect `theme_provider.dart` to `di.dart`, `secure_token_storage.dart`, `auth_repository.dart`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Should `welcome_identity_view.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.045068027210884355 - nodes in this community are weakly interconnected._