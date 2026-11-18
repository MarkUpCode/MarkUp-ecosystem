# Graph Report - dinerup-app  (2026-11-18)

## Corpus Check
- 76 files · ~43,351 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .toml 1)

## Summary
- 497 nodes · 1094 edges · 35 communities (30 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7e59bae2`
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
- react
- compilerOptions
- PublicCreditRequestModal.tsx
- dependencies
- compilerOptions
- credit.ts
- eslint.config.js
- onboarding.api.ts
- creditRequests.api.ts
- GuaranteeOnboardingModal.tsx
- onboarding.ts
- vercel.json
- vite-env.d.ts
- tsconfig.json
- devDependencies
- Step3Address.tsx
- package.json
- useCooperativeLiveUpdates.ts
- Step1Identity.tsx
- Step4Economic.tsx
- scripts
- vite
- Step2PersonalDetails.tsx
- RejectCreditModal.tsx
- RejectGuarantorModal.tsx

## God Nodes (most connected - your core abstractions)
1. `httpClient()` - 52 edges
2. `react` - 35 edges
3. `getErrorMessage()` - 30 edges
4. `DashboardCooperative()` - 25 edges
5. `lucide-react` - 23 edges
6. `DashboardClient()` - 16 edges
7. `compilerOptions` - 16 edges
8. `OnboardingPage()` - 14 edges
9. `App()` - 14 edges
10. `useAuth()` - 14 edges

## Surprising Connections (you probably didn't know these)
- `DashboardCooperative()` --calls--> `CooperativeNotificationCenter()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/cooperative/CooperativeNotificationCenter.tsx
- `DashboardCooperative()` --calls--> `PreApprovalModal()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/credit/PreApprovalModal.tsx
- `DashboardCooperative()` --calls--> `RejectCreditModal()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/credit/RejectCreditModal.tsx
- `DashboardCooperative()` --calls--> `RejectGuarantorModal()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/credit/RejectGuarantorModal.tsx
- `changeRegistrationEmail()` --calls--> `httpClient()`  [EXTRACTED]
  src/api/auth/auth.api.ts → src/api/httpClient.ts

## Import Cycles
- None detected.

## Communities (35 total, 5 thin omitted)

### Community 0 - "DashboardCooperative.tsx"
Cohesion: 0.12
Nodes (32): decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestTimeline(), getGuarantorHistoryForCooperative(), requestGuaranteeForCreditRequest(), Analytics(), ApplicantModal() (+24 more)

### Community 1 - "OnboardingPage.tsx"
Cohesion: 0.20
Nodes (11): ApiError, getPreRegistrationData(), submitOnboarding(), SuccessOnboardingModal(), SuccessOnboardingModalProps, EMPTY_SOLICITANTE, OnboardingPage(), Input() (+3 more)

### Community 2 - "CreditDetailsModal.tsx"
Cohesion: 0.21
Nodes (14): acceptCreditCooperative(), getCreditRequestCooperatives(), getGuarantorHistoryForClient(), CreditCard(), CreditCardProps, statusMap, tipoMap, cooperativeStatus (+6 more)

### Community 3 - "DashboardClient.tsx"
Cohesion: 0.10
Nodes (22): lucide-react, getCooperatives(), createCreditRequest(), CooperativeCard(), CooperativeCardProps, CooperativeLogoMarquee(), cooperatives, Cooperative (+14 more)

### Community 4 - "httpClient"
Cohesion: 0.11
Nodes (35): httpClient(), acceptInvestmentRequest(), addInvestmentRate(), createInvestmentRequest(), FinancialProduct, getCooperativeCreditProducts(), getCooperativeInvestmentProducts(), getCooperativeInvestmentRequests() (+27 more)

### Community 5 - "mockAPI.ts"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "react"
Cohesion: 0.12
Nodes (28): react, loginRequest(), AUTH_UNAUTHORIZED_EVENT, emitUnauthorizedEvent(), resetUnauthorizedEventState(), AuthUser, clearStoredAuth(), extractToken() (+20 more)

### Community 7 - "react"
Cohesion: 0.11
Nodes (32): react-router-dom, activateAccount(), activateInvitation(), changeRegistrationEmail(), completeRegistration(), forgotPassword(), getInvitationDetails(), InvitationDetails (+24 more)

### Community 8 - "compilerOptions"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "PublicCreditRequestModal.tsx"
Cohesion: 0.09
Nodes (31): changeRegistrationEmailOnly(), resendRegistrationOtp(), setRegistrationPassword(), startRegistrationOtp(), verifyRegistrationOtp(), CompleteRegistrationModal(), Field(), Props (+23 more)

### Community 10 - "dependencies"
Cohesion: 0.12
Nodes (16): dependencies, @hookform/resolvers@^5.2.2, lucide-react@^0.344.0, react@^18.3.1, react-dom@^18.3.1, react-hook-form@^7.65.0, react-router-dom@^7.9.4, @supabase/supabase-js@^2.57.4 (+8 more)

### Community 11 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 12 - "credit.ts"
Cohesion: 0.20
Nodes (13): PreApprovalModal(), PreApprovalModalProps, BaseCreditRequest, CooperativeCreditRequest, CooperativeOfferDefaults, CreditRequestCooperative, CreditRequirement, CreditEstado (+5 more)

### Community 13 - "eslint.config.js"
Cohesion: 0.18
Nodes (10): @eslint/js@^9.9.1, eslint-plugin-react-hooks@^5.1.0-rc.0, eslint-plugin-react-refresh@^0.4.11, globals@^15.9.0, typescript-eslint@^8.3.0, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh (+2 more)

### Community 14 - "onboarding.api.ts"
Cohesion: 0.14
Nodes (12): ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getFormularioClienteStatus(), getOnboardingForCooperative(), GuaranteeOnboardingResponse, IngresoEgresoData (+4 more)

### Community 15 - "creditRequests.api.ts"
Cohesion: 0.18
Nodes (10): CreateCreditRequestPayload, CreditGuarantorHistoryItem, CreditTimelineEvent, getMyCreditRequests(), GuaranteeDecision, GuaranteeReviewDecision, GuarantorEvaluation, CreditDecision (+2 more)

### Community 16 - "GuaranteeOnboardingModal.tsx"
Cohesion: 0.23
Nodes (10): getMyGuarantorProfiles(), GuarantorProfileResponse, OnboardingPayload, SolicitanteData, submitGuaranteeOnboarding(), EMPTY_SOLICITANTE, GuaranteeOnboardingModal(), GuaranteeOnboardingModalProps (+2 more)

### Community 17 - "onboarding.ts"
Cohesion: 0.40
Nodes (4): AddressForm, OnboardingFormData, PersonalDetailsForm, PersonalIdentityForm

### Community 18 - "vercel.json"
Cohesion: 0.40
Nodes (4): buildCommand, headers, outputDirectory, rewrites

### Community 24 - "devDependencies"
Cohesion: 0.18
Nodes (11): devDependencies, autoprefixer@^10.4.18, eslint@^9.9.1, postcss@^8.4.35, @types/react@^18.3.5, @types/react-dom@^18.3.0, autoprefixer, eslint (+3 more)

### Community 25 - "Step3Address.tsx"
Cohesion: 0.24
Nodes (9): Canton, ecuadorProvinces, Provincia, Input(), InputProps, Select(), SelectProps, Step3Address() (+1 more)

### Community 26 - "package.json"
Cohesion: 0.22
Nodes (8): tailwindcss@^3.4.1, typescript@^5.5.3, name, private, type, version, tailwindcss, typescript

### Community 27 - "useCooperativeLiveUpdates.ts"
Cohesion: 0.36
Nodes (6): getMyCooperativeRequests(), CooperativeNotificationCenter(), Props, CooperativeNotification, describeRequestChange(), useCooperativeLiveUpdates()

### Community 28 - "Step1Identity.tsx"
Cohesion: 0.38
Nodes (6): Input(), InputProps, Select(), SelectProps, Step1Identity(), Step1IdentityProps

### Community 29 - "Step4Economic.tsx"
Cohesion: 0.38
Nodes (6): Input(), InputProps, Select(), SelectProps, Step4Economic(), Step4EconomicProps

### Community 30 - "scripts"
Cohesion: 0.33
Nodes (6): scripts, build, dev, lint, preview, typecheck

### Community 31 - "vite"
Cohesion: 0.40
Nodes (4): vite@^5.4.2, @vitejs/plugin-react@^4.3.1, vite, @vitejs/plugin-react

### Community 32 - "Step2PersonalDetails.tsx"
Cohesion: 0.50
Nodes (4): Input(), InputProps, Step2PersonalDetails(), Step2PersonalDetailsProps

### Community 33 - "RejectCreditModal.tsx"
Cohesion: 0.50
Nodes (3): RejectCreditModal(), RejectCreditModalProps, rejectionReasons

### Community 34 - "RejectGuarantorModal.tsx"
Cohesion: 0.50
Nodes (3): reasons, RejectGuarantorModal(), RejectGuarantorModalProps

## Knowledge Gaps
- **7 isolated node(s):** `PRE_APROBAR`, `RECHAZAR`, `CREADA`, `ENVIADA`, `PRE_APROBADA` (+2 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 159 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `react` to `DashboardCooperative.tsx`, `RejectCreditModal.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `RejectGuarantorModal.tsx`, `OnboardingPage.tsx`, `react`, `PublicCreditRequestModal.tsx`, `dependencies`, `credit.ts`, `GuaranteeOnboardingModal.tsx`, `package.json`, `useCooperativeLiveUpdates.ts`?**
  _High betweenness centrality (0.201) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `DashboardCooperative.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.11742424242424243 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `DashboardClient.tsx` to `DashboardCooperative.tsx`, `RejectCreditModal.tsx`, `CreditDetailsModal.tsx`, `RejectGuarantorModal.tsx`, `httpClient`, `OnboardingPage.tsx`, `PublicCreditRequestModal.tsx`, `dependencies`, `credit.ts`, `GuaranteeOnboardingModal.tsx`, `package.json`, `useCooperativeLiveUpdates.ts`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Should `DashboardClient.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.0960960960960961 - nodes in this community are weakly interconnected._
- **Why does `httpClient()` connect `httpClient` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `react`, `react`, `PublicCreditRequestModal.tsx`, `onboarding.api.ts`, `creditRequests.api.ts`, `GuaranteeOnboardingModal.tsx`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Should `httpClient` be split into smaller, more focused modules?**
  _Cohesion score 0.11025641025641025 - nodes in this community are weakly interconnected._