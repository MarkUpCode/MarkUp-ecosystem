# Graph Report - dinerup-app  (2026-11-16)

## Corpus Check
- 69 files · ~37,033 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .toml 1)

## Summary
- 447 nodes · 939 edges · 19 communities (14 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e0dc7a77`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- DashboardCooperative.tsx
- OnboardingPage.tsx
- CreditDetailsModal.tsx
- DashboardClient.tsx
- httpClient
- mockAPI.ts
- react
- Login.tsx
- compilerOptions
- PublicCreditRequestModal.tsx
- package.json
- compilerOptions
- onboarding.ts
- vercel.json
- vite-env.d.ts
- tsconfig.json

## God Nodes (most connected - your core abstractions)
1. `httpClient()` - 34 edges
2. `react` - 30 edges
3. `lucide-react` - 23 edges
4. `DashboardCooperative()` - 23 edges
5. `getErrorMessage()` - 19 edges
6. `DashboardClient()` - 16 edges
7. `compilerOptions` - 16 edges
8. `useAuth()` - 14 edges
9. `OnboardingPage()` - 14 edges
10. `compilerOptions` - 14 edges

## Surprising Connections (you probably didn't know these)
- `App()` --calls--> `ActivateAccount()`  [EXTRACTED]
  src/App.tsx → src/pages/ActivateAccount.tsx
- `App()` --calls--> `DashboardClient()`  [EXTRACTED]
  src/App.tsx → src/pages/DashboardClient.tsx
- `App()` --calls--> `DashboardCooperative()`  [EXTRACTED]
  src/App.tsx → src/pages/DashboardCooperative.tsx
- `App()` --calls--> `ForgotPassword()`  [EXTRACTED]
  src/App.tsx → src/pages/password/ForgotPassword.tsx
- `App()` --calls--> `ResetPassword()`  [EXTRACTED]
  src/App.tsx → src/pages/password/ResetPassword.tsx

## Import Cycles
- None detected.

## Communities (19 total, 5 thin omitted)

### Community 0 - "DashboardCooperative.tsx"
Cohesion: 0.06
Nodes (58): CreateCreditRequestPayload, CreditGuarantorHistoryItem, CreditTimelineEvent, decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestTimeline(), getGuarantorHistoryForCooperative() (+50 more)

### Community 1 - "OnboardingPage.tsx"
Cohesion: 0.05
Nodes (52): lucide-react, ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getMyGuarantorProfiles(), getPreRegistrationData(), GuaranteeOnboardingResponse (+44 more)

### Community 2 - "CreditDetailsModal.tsx"
Cohesion: 0.14
Nodes (23): acceptCreditCooperative(), getCreditRequestCooperatives(), getGuarantorHistoryForClient(), CreditCard(), CreditCardProps, statusMap, tipoMap, cooperativeStatus (+15 more)

### Community 3 - "DashboardClient.tsx"
Cohesion: 0.09
Nodes (25): getCooperatives(), createCreditRequest(), getMyCreditRequests(), getFormularioClienteStatus(), CooperativeCard(), CooperativeCardProps, CooperativeLogoMarquee(), cooperatives (+17 more)

### Community 4 - "httpClient"
Cohesion: 0.11
Nodes (32): activateAccount(), changeRegistrationEmail(), changeRegistrationEmailOnly(), completeRegistration(), forgotPassword(), loginRequest(), LoginResponse, RegistrationOtpVerifyPayload (+24 more)

### Community 5 - "mockAPI.ts"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "react"
Cohesion: 0.12
Nodes (21): react, AUTH_UNAUTHORIZED_EVENT, emitUnauthorizedEvent(), resetUnauthorizedEventState(), AuthUser, clearStoredAuth(), extractToken(), LEGACY_TOKEN_KEYS (+13 more)

### Community 7 - "Login.tsx"
Cohesion: 0.16
Nodes (19): react-router-dom@^7.9.4, react-router-dom, App(), AuthLoadingScreen(), getDashboardPath(), ProtectedRoute(), PublicOnlyRoute(), CooperativesCarousel() (+11 more)

### Community 8 - "compilerOptions"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "PublicCreditRequestModal.tsx"
Cohesion: 0.18
Nodes (15): creditTypes, FormData, FormErrors, getInitialFormState(), Input(), InputProps, isValidEcuadorId(), onlyLetters() (+7 more)

### Community 10 - "package.json"
Cohesion: 0.05
Nodes (54): dependencies, @hookform/resolvers@^5.2.2, lucide-react@^0.344.0, react@^18.3.1, react-dom@^18.3.1, react-hook-form@^7.65.0, @supabase/supabase-js@^2.57.4, swiper@^12.1.2 (+46 more)

### Community 11 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 17 - "onboarding.ts"
Cohesion: 0.40
Nodes (4): AddressForm, OnboardingFormData, PersonalDetailsForm, PersonalIdentityForm

### Community 18 - "vercel.json"
Cohesion: 0.40
Nodes (4): buildCommand, headers, outputDirectory, rewrites

## Knowledge Gaps
- **7 isolated node(s):** `PRE_APROBAR`, `RECHAZAR`, `CREADA`, `ENVIADA`, `PRE_APROBADA` (+2 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 151 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `Login.tsx`, `PublicCreditRequestModal.tsx`, `package.json`?**
  _High betweenness centrality (0.193) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `DashboardCooperative.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.061072261072261075 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `OnboardingPage.tsx` to `DashboardCooperative.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `react`, `Login.tsx`, `PublicCreditRequestModal.tsx`, `package.json`?**
  _High betweenness centrality (0.111) - this node is a cross-community bridge._
- **Should `OnboardingPage.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.053763440860215055 - nodes in this community are weakly interconnected._
- **Why does `Cooperative` connect `DashboardClient.tsx` to `mockAPI.ts`?**
  _High betweenness centrality (0.051) - this node is a cross-community bridge._
- **Should `CreditDetailsModal.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.1396011396011396 - nodes in this community are weakly interconnected._