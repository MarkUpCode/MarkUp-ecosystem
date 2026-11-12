# Graph Report - app_movil_dinerop  (2026-11-12)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 1345 nodes · 1791 edges · 74 communities (67 shown, 7 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `79ce61f4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 6
- Community 7
- Community 8
- Community 9
- Community 10
- Community 11
- Community 12
- Community 13
- Community 14
- Community 15
- Community 16
- Community 17
- Community 18
- Community 19
- Community 20
- Community 21
- Community 22
- Community 23
- Community 24
- Community 25
- Community 26
- Community 27
- Community 28
- Community 29
- Community 30
- Community 31
- Community 32
- Community 33
- Community 34
- Community 35
- Community 36
- Community 37
- Community 38
- Community 39
- Community 40
- Community 41
- Community 42
- Community 43
- Community 44
- Community 45
- Community 46
- Community 47
- Community 48
- Community 49
- Community 50
- Community 51
- Community 52
- Community 53
- Community 54
- Community 55
- Community 56
- Community 57
- Community 58
- Community 59
- Community 60
- Community 61
- Community 62
- Community 63
- Community 64
- Community 65
- Community 66
- Community 67
- Community 68
- Community 69

## God Nodes (most connected - your core abstractions)
1. `StatelessWidget` - 55 edges
2. `authControllerProvider` - 36 edges
3. `dependencies` - 14 edges
4. `build` - 8 edges
5. `clientProfileProvider` - 7 edges
6. `ApiClient` - 7 edges
7. `DashboardPage` - 6 edges
8. `build` - 6 edges
9. `_OnboardingPageState` - 5 edges
10. `_WelcomePageState` - 5 edges

## Surprising Connections (you probably didn't know these)
- `_activate` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/activation_page.dart → lib/features/auth/presentation/auth_controller.dart
- `build` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/complete_registration_page.dart → lib/features/auth/presentation/auth_controller.dart
- `initState` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/complete_registration_page.dart → lib/features/auth/presentation/auth_controller.dart
- `build` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/forgot_password_page.dart → lib/features/auth/presentation/auth_controller.dart
- `_submit` --references--> `authControllerProvider`  [EXTRACTED]
  lib/features/auth/presentation/screens/forgot_password_page.dart → lib/features/auth/presentation/auth_controller.dart

## Import Cycles
- None detected.

## Communities (74 total, 7 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.02
Nodes (92): _acceptedDeclaration, _apellidosController, _availableCantons, _availableParishes, _barrioController, build, _buildAddressStep, _buildBenefit (+84 more)

### Community 1 - "Community 1"
Cohesion: 0.05
Nodes (50): authControllerProvider, ActivationPage, _ActivationPageState, CompleteRegistrationPage, _CompleteRegistrationPageState, ForgotPasswordPage, _ForgotPasswordPageState, _LoginSheet (+42 more)

### Community 2 - "Community 2"
Cohesion: 0.05
Nodes (43): _banksFade, _banksSlide, build, createState, dispose, _fadeAnimation, _footerFade, icon (+35 more)

### Community 3 - "Community 3"
Cohesion: 0.04
Nodes (36): activate, authRemoteDataSourceProvider, _authRepository, authRepositoryProvider, _bootstrap, _bootstrapErrorMessage, changeRegistrationEmail, _clearSessionAfterBootstrapFailure (+28 more)

### Community 4 - "Community 4"
Cohesion: 0.05
Nodes (38): assetPath, CooperativePartner, id, initialPartners, logoUrl, nombre, subtitulo, build (+30 more)

### Community 5 - "Community 5"
Cohesion: 0.05
Nodes (40): actividadEconomica, apellidos, barrio, callePrincipal, canton, cedula, conyuge, destinoCredito (+32 more)

### Community 6 - "Community 6"
Cohesion: 0.05
Nodes (29): build, buttonBackground, buttonIconColor, buttonText, buttonTextColor, createState, _CreditServiceCard, description (+21 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (34): accent, accentSoft, AppColors, background, border, borderSubtle, darkAccent, darkAccentSoft (+26 more)

### Community 8 - "Community 8"
Cohesion: 0.06
Nodes (32): _acceptedTerms, _amount, _amountValidator, _buildStep, createState, _creditType, dispose, _email (+24 more)

### Community 9 - "Community 9"
Cohesion: 0.06
Nodes (27): _autoPlayTimer, build, _cancelAutoPlay, _controller, createState, _currentPage, didUpdateWidget, dispose (+19 more)

### Community 10 - "Community 10"
Cohesion: 0.06
Nodes (33): dependencies, cupertino_icons, dio, firebase_core, firebase_messaging, flutter, flutter_local_notifications, flutter_riverpod (+25 more)

### Community 11 - "Community 11"
Cohesion: 0.06
Nodes (30): cantones, EcuadorCanton, EcuadorProvincia, ecuadorProvincias, nombre, parroquias, provincia, _amount (+22 more)

### Community 12 - "Community 12"
Cohesion: 0.07
Nodes (24): activate, AuthRemoteDataSource, changeRegistrationEmail, _client, completeRegistration, forgotPassword, login, register (+16 more)

### Community 13 - "Community 13"
Cohesion: 0.07
Nodes (23): _accept, _accepting, color, createState, dispose, _filteredRequests, label, offer (+15 more)

### Community 14 - "Community 14"
Cohesion: 0.07
Nodes (26): active, child, color, complete, createState, current, delay, description (+18 more)

### Community 15 - "Community 15"
Cohesion: 0.08
Nodes (22): _amountController, build, _cityController, _cityNames, createState, _creditType, dispose, _error (+14 more)

### Community 16 - "Community 16"
Cohesion: 0.08
Nodes (21): build, controller, createState, didUpdateWidget, dispose, enabled, errorAnimationKey, hasError (+13 more)

### Community 17 - "Community 17"
Cohesion: 0.08
Nodes (23): _amount, _amountController, build, color, createState, dispose, finalValue, initState (+15 more)

### Community 18 - "Community 18"
Cohesion: 0.09
Nodes (19): clear, onboardingComplete, _onboardingKey, _operationTimeout, readSession, readThemeMode, readToken, readWelcomeSeen (+11 more)

### Community 20 - "Community 20"
Cohesion: 0.09
Nodes (22): category, cooperativaId, CreditCooperativeStatus, CreditRequirement, cuotaMensual, description, direccion, estado (+14 more)

### Community 21 - "Community 21"
Cohesion: 0.10
Nodes (14): build, _buildContent, _buildLogoSet, _controller, createState, didUpdateWidget, dispose, gap (+6 more)

### Community 22 - "Community 22"
Cohesion: 0.10
Nodes (16): build, color, compact, CreditRequestCard, description, _DetailChip, from, helperText (+8 more)

### Community 23 - "Community 23"
Cohesion: 0.11
Nodes (19): _CreditProgressSection, _CurrentStatusCard, _DashboardContent, _DashboardReveal, _ProfileProgressCard, _ProgressStage, _QuickAction, _RecentRequests (+11 more)

### Community 24 - "Community 24"
Cohesion: 0.11
Nodes (13): ApiConfig, _envBaseUrl, _envHostIp, _normalize, resolveBaseUrl, AppErrorMessages, AppException, generic (+5 more)

### Community 25 - "Community 25"
Cohesion: 0.12
Nodes (16): CreditDecision, creditDecisionToApiValue, CreditRequestStatus, creditRequestStatusFromJson, CreditRequestType, creditRequestTypeFromJson, CreditType, creditTypeFromJson (+8 more)

### Community 26 - "Community 26"
Cohesion: 0.12
Nodes (13): _ContactCard, data, email, icon, _InfoRow, label, onboardingComplete, onTap (+5 more)

### Community 27 - "Community 27"
Cohesion: 0.12
Nodes (12): AppCard, borderColor, build, child, color, onTap, padding, AppHeader (+4 more)

### Community 28 - "Community 28"
Cohesion: 0.14
Nodes (11): actionLabel, AppEmptyState, build, icon, message, onAction, title, AppErrorView (+3 more)

### Community 29 - "Community 29"
Cohesion: 0.13
Nodes (13): AppUserRole, AppUserStatus, email, fromJson, id, isActive, isClient, isPendingActivation (+5 more)

### Community 30 - "Community 30"
Cohesion: 0.13
Nodes (7): acceptCooperative, _client, createCreditRequest, downloadReferralPdf, loadCatalog, loadMyRequests, loadPreApprovedCooperatives

### Community 31 - "Community 31"
Cohesion: 0.14
Nodes (11): fromJson, message, PublicRegistrationResponse, requestId, status, cooperativasNotificadas, CreditRequestResponse, estado (+3 more)

### Community 32 - "Community 32"
Cohesion: 0.21
Nodes (12): CooperativeLogoMarquee, _CooperativeLogoMarqueeState, CreditSimulatorPage, _CreditSimulatorPageState, _DelayedFade, _DelayedFadeState, _StoryProgressBar, _StoryProgressBarState (+4 more)

### Community 33 - "Community 33"
Cohesion: 0.15
Nodes (5): Flutter, AppDelegate, RunnerTests, UIKit, XCTest

### Community 34 - "Community 34"
Cohesion: 0.14
Nodes (13): cooperativaId, CreditRequestCooperative, cuotaMensual, estado, fechaActualizacion, fromJson, interesTotal, monto (+5 more)

### Community 35 - "Community 35"
Cohesion: 0.15
Nodes (6): _BootstrapError, _BrandMark, build, message, onRetry, main

### Community 36 - "Community 36"
Cohesion: 0.19
Nodes (8): build, DineropApp, appRouterProvider, themeModeProvider, LoginPage, SplashPage, ProfilePage, _RequestDetailsSheet

### Community 37 - "Community 37"
Cohesion: 0.15
Nodes (11): calificacion, ciudad, CooperativeSummary, direccion, fromJson, id, logoUrl, nombre (+3 more)

### Community 38 - "Community 38"
Cohesion: 0.15
Nodes (12): amount, city, creditType, email, firstName, identification, lastName, phone (+4 more)

### Community 39 - "Community 39"
Cohesion: 0.17
Nodes (8): _activate, build, createState, _done, _error, initState, _message, token

### Community 40 - "Community 40"
Cohesion: 0.20
Nodes (8): clientProfileProvider, dashboardCreditRequestsProvider, dashboardOnboardingStatusProvider, _navigate, _loadLocationData, build, DashboardPage, build

### Community 41 - "Community 41"
Cohesion: 0.17
Nodes (6): AppShell, build, child, _selectedIndex, build, CooperativesPage

### Community 42 - "Community 42"
Cohesion: 0.17
Nodes (11): build, _confirmController, createState, dispose, email, _emailController, _error, _formKey (+3 more)

### Community 43 - "Community 43"
Cohesion: 0.17
Nodes (11): build, createState, dispose, _error, _formKey, initState, _message, _passwordController (+3 more)

### Community 44 - "Community 44"
Cohesion: 0.18
Nodes (5): _firebaseMessagingBackgroundHandler, initializeApp, initializeDateFormatting, main, null

### Community 45 - "Community 45"
Cohesion: 0.18
Nodes (7): _currencyFormatter, _dateFormatter, _dateTimeFormatter, format, formatCurrency, formatDate, formatDateTime

### Community 46 - "Community 46"
Cohesion: 0.18
Nodes (6): _client, initializeAndRegister, _localNotifications, PushNotificationService, _registerToken, _showForegroundNotification

### Community 47 - "Community 47"
Cohesion: 0.18
Nodes (8): build, createState, dispose, _emailController, _error, _formKey, _message, _submit

### Community 48 - "Community 48"
Cohesion: 0.18
Nodes (7): _submit, build, email, message, PendingActivationPage, build, _showSuccessDialog

### Community 49 - "Community 49"
Cohesion: 0.18
Nodes (6): _client, loadPreRegistrationData, loadStatus, OnboardingRepository, submitClientOnboarding, submitGuarantorOnboarding

### Community 50 - "Community 50"
Cohesion: 0.18
Nodes (7): AppTheme, dark, light, build, currentStep, StepProgress, totalSteps

### Community 51 - "Community 51"
Cohesion: 0.20
Nodes (4): cooperativeRepositoryProvider, cooperativesProvider, watch, CreditRepository

### Community 52 - "Community 52"
Cohesion: 0.20
Nodes (8): cantidadSolicitudesEnviadas, ClientCreditRequestSummary, estado, fechaSolicitud, fromJson, monto, solicitudId, tipo

### Community 53 - "Community 53"
Cohesion: 0.20
Nodes (4): _dio, _fieldLabel, _mapError, TokenProvider

### Community 54 - "Community 54"
Cohesion: 0.20
Nodes (5): SecureTokenStorage, _loadTheme, setThemeMode, _storage, ThemeNotifier

### Community 55 - "Community 55"
Cohesion: 0.20
Nodes (8): AppButton, AppButtonVariant, build, icon, isLoading, label, onPressed, variant

### Community 56 - "Community 56"
Cohesion: 0.20
Nodes (9): city, email, firstName, fromJson, identification, lastName, phone, PreRegistrationData (+1 more)

### Community 57 - "Community 57"
Cohesion: 0.22
Nodes (5): apiClientProvider, baseUrl, flutterSecureStorageProvider, secureTokenStorageProvider, storage

### Community 58 - "Community 58"
Cohesion: 0.22
Nodes (7): AppSpacing, lg, md, sm, xl, xs, xxl

### Community 59 - "Community 59"
Cohesion: 0.25
Nodes (4): AppAuthenticatedHeader, build, preferredSize, _showHelp

### Community 60 - "Community 60"
Cohesion: 0.25
Nodes (5): AppBadge, build, color, label, textColor

### Community 61 - "Community 61"
Cohesion: 0.25
Nodes (6): destinoCredito, estado, fechaCreacion, fromJson, id, OnboardingSubmissionResponse

### Community 62 - "Community 62"
Cohesion: 0.29
Nodes (5): AppUser, accessToken, fromJson, LoginResponse, user

### Community 63 - "Community 63"
Cohesion: 0.29
Nodes (4): ApiClient, _client, CooperativeRepository, loadCooperatives

### Community 64 - "Community 64"
Cohesion: 0.29
Nodes (6): creditRepositoryProvider, requestsProvider, build, RequestsPage, _RequestsPageState, _showDetails

### Community 65 - "Community 65"
Cohesion: 0.29
Nodes (6): estadoFormulario, formularioCompleto, fromJson, OnboardingFormStatus, OnboardingStatusResponse, _statusFromString

### Community 66 - "Community 66"
Cohesion: 0.50
Nodes (3): include, linter, rules

### Community 67 - "Community 67"
Cohesion: 0.50
Nodes (3): AppLoader, build, label

## Knowledge Gaps
- **852 isolated node(s):** `_acceptedDeclaration`, `_apellidosController`, `_availableCantons`, `_availableParishes`, `_barrioController` (+847 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 1006 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SecureTokenStorage` connect `Community 54` to `Community 57`, `Community 18`, `Community 12`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **What connects `_acceptedDeclaration`, `_apellidosController`, `_availableCantons` to the rest of the system?**
  _852 weakly-connected nodes found - possible missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.02040816326530612 - nodes in this community are weakly interconnected._
- **Why does `ApiClient` connect `Community 63` to `Community 12`, `Community 46`, `Community 49`, `Community 53`, `Community 57`, `Community 30`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.05137844611528822 - nodes in this community are weakly interconnected._
- **Why does `StatelessWidget` connect `Community 23` to `Community 2`, `Community 35`, `Community 4`, `Community 67`, `Community 6`, `Community 8`, `Community 41`, `Community 27`, `Community 11`, `Community 28`, `Community 48`, `Community 17`, `Community 50`, `Community 22`, `Community 55`, `Community 26`, `Community 59`, `Community 60`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.04521276595744681 - nodes in this community are weakly interconnected._