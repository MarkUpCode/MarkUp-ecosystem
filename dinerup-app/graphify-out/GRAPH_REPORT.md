# Graph Report - dinerup-app  (2026-11-17)

## Corpus Check
- 73 files · ~40,871 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .toml 1)

## Summary
- 480 nodes · 1021 edges · 29 communities (23 shown, 6 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `797ea025`
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
- creditRequests.api.ts
- eslint.config.js
- devDependencies
- useCooperativeLiveUpdates.ts
- scripts
- onboarding.ts
- vercel.json
- vite-env.d.ts
- tsconfig.json
- vite
- lucide-react
- PreApprovalModal.tsx
- RejectCreditModal.tsx
- RejectGuarantorModal.tsx

## God Nodes (most connected - your core abstractions)
1. `httpClient()` - 45 edges
2. `react` - 33 edges
3. `DashboardCooperative()` - 24 edges
4. `getErrorMessage()` - 24 edges
5. `lucide-react` - 23 edges
6. `DashboardClient()` - 16 edges
7. `compilerOptions` - 16 edges
8. `useAuth()` - 14 edges
9. `compilerOptions` - 14 edges
10. `App()` - 13 edges

## Surprising Connections (you probably didn't know these)
- `DashboardClient()` --calls--> `NewCreditModal()`  [EXTRACTED]
  src/pages/DashboardClient.tsx → src/components/credit/NewCreditModal.tsx
- `DashboardCooperative()` --calls--> `CooperativeNotificationCenter()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/cooperative/CooperativeNotificationCenter.tsx
- `DashboardCooperative()` --calls--> `PreApprovalModal()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/credit/PreApprovalModal.tsx
- `DashboardCooperative()` --calls--> `RejectCreditModal()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/credit/RejectCreditModal.tsx
- `DashboardCooperative()` --calls--> `RejectGuarantorModal()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/credit/RejectGuarantorModal.tsx

## Import Cycles
- None detected.

## Communities (29 total, 6 thin omitted)

### Community 0 - "DashboardCooperative.tsx"
Cohesion: 0.12
Nodes (32): decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestTimeline(), getGuarantorHistoryForCooperative(), requestGuaranteeForCreditRequest(), Analytics(), ApplicantModal() (+24 more)

### Community 1 - "OnboardingPage.tsx"
Cohesion: 0.06
Nodes (53): ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getMyGuarantorProfiles(), getOnboardingForCooperative(), getPreRegistrationData(), GuaranteeOnboardingResponse (+45 more)

### Community 2 - "CreditDetailsModal.tsx"
Cohesion: 0.14
Nodes (23): acceptCreditCooperative(), getCreditRequestCooperatives(), getGuarantorHistoryForClient(), CreditCard(), CreditCardProps, statusMap, tipoMap, cooperativeStatus (+15 more)

### Community 3 - "DashboardClient.tsx"
Cohesion: 0.13
Nodes (15): getCooperatives(), createCreditRequest(), getMyCreditRequests(), getFormularioClienteStatus(), CooperativeCard(), CooperativeCardProps, CooperativeLogoMarquee(), cooperatives (+7 more)

### Community 4 - "httpClient"
Cohesion: 0.09
Nodes (46): activateInvitation(), changeRegistrationEmail(), changeRegistrationEmailOnly(), completeRegistration(), getInvitationDetails(), InvitationDetails, LoginResponse, RegistrationOtpVerifyPayload (+38 more)

### Community 5 - "mockAPI.ts"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "react"
Cohesion: 0.11
Nodes (25): loginRequest(), AUTH_UNAUTHORIZED_EVENT, emitUnauthorizedEvent(), resetUnauthorizedEventState(), clearStoredAuth(), extractToken(), LEGACY_TOKEN_KEYS, normalizeToken() (+17 more)

### Community 7 - "react"
Cohesion: 0.10
Nodes (31): react@^18.3.1, react-router-dom@^7.9.4, react, react-router-dom, activateAccount(), forgotPassword(), resetPassword(), AuthUser (+23 more)

### Community 8 - "compilerOptions"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "PublicCreditRequestModal.tsx"
Cohesion: 0.10
Nodes (24): CreditModalSubmitData, creditTypes, EMPTY_ERRORS, NewCreditModal(), NewCreditModalProps, plazosOptions, creditTypes, FormData (+16 more)

### Community 10 - "dependencies"
Cohesion: 0.15
Nodes (17): dependencies, @hookform/resolvers@^5.2.2, react-dom@^18.3.1, react-hook-form@^7.65.0, @supabase/supabase-js@^2.57.4, swiper@^12.1.2, zod@^4.1.12, name (+9 more)

### Community 11 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 12 - "creditRequests.api.ts"
Cohesion: 0.20
Nodes (9): CreateCreditRequestPayload, CreditGuarantorHistoryItem, CreditTimelineEvent, GuaranteeDecision, GuaranteeReviewDecision, GuarantorEvaluation, CreditDecision, PRE_APROBAR (+1 more)

### Community 13 - "eslint.config.js"
Cohesion: 0.18
Nodes (10): @eslint/js@^9.9.1, eslint-plugin-react-hooks@^5.1.0-rc.0, eslint-plugin-react-refresh@^0.4.11, globals@^15.9.0, typescript-eslint@^8.3.0, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh (+2 more)

### Community 14 - "devDependencies"
Cohesion: 0.13
Nodes (15): devDependencies, autoprefixer@^10.4.18, eslint@^9.9.1, postcss@^8.4.35, tailwindcss@^3.4.1, @types/react@^18.3.5, @types/react-dom@^18.3.0, typescript@^5.5.3 (+7 more)

### Community 15 - "useCooperativeLiveUpdates.ts"
Cohesion: 0.36
Nodes (6): getMyCooperativeRequests(), CooperativeNotificationCenter(), Props, CooperativeNotification, describeRequestChange(), useCooperativeLiveUpdates()

### Community 16 - "scripts"
Cohesion: 0.33
Nodes (6): scripts, build, dev, lint, preview, typecheck

### Community 17 - "onboarding.ts"
Cohesion: 0.40
Nodes (4): AddressForm, OnboardingFormData, PersonalDetailsForm, PersonalIdentityForm

### Community 18 - "vercel.json"
Cohesion: 0.40
Nodes (4): buildCommand, headers, outputDirectory, rewrites

### Community 24 - "vite"
Cohesion: 0.40
Nodes (4): vite@^5.4.2, @vitejs/plugin-react@^4.3.1, vite, @vitejs/plugin-react

### Community 26 - "PreApprovalModal.tsx"
Cohesion: 0.60
Nodes (4): PreApprovalModal(), PreApprovalModalProps, CooperativeOfferDefaults, CreditRequirement

### Community 27 - "RejectCreditModal.tsx"
Cohesion: 0.50
Nodes (3): RejectCreditModal(), RejectCreditModalProps, rejectionReasons

### Community 28 - "RejectGuarantorModal.tsx"
Cohesion: 0.50
Nodes (3): reasons, RejectGuarantorModal(), RejectGuarantorModalProps

## Knowledge Gaps
- **7 isolated node(s):** `PRE_APROBAR`, `RECHAZAR`, `CREADA`, `ENVIADA`, `PRE_APROBADA` (+2 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 155 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `react`, `PublicCreditRequestModal.tsx`, `dependencies`, `useCooperativeLiveUpdates.ts`, `lucide-react`, `PreApprovalModal.tsx`, `RejectCreditModal.tsx`, `RejectGuarantorModal.tsx`?**
  _High betweenness centrality (0.201) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `DashboardCooperative.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.11742424242424243 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `lucide-react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `react`, `PublicCreditRequestModal.tsx`, `dependencies`, `useCooperativeLiveUpdates.ts`, `PreApprovalModal.tsx`, `RejectCreditModal.tsx`, `RejectGuarantorModal.tsx`?**
  _High betweenness centrality (0.103) - this node is a cross-community bridge._
- **Should `OnboardingPage.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.056051587301587304 - nodes in this community are weakly interconnected._
- **Why does `httpClient()` connect `httpClient` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `react`, `react`, `PublicCreditRequestModal.tsx`, `creditRequests.api.ts`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **Should `CreditDetailsModal.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.1396011396011396 - nodes in this community are weakly interconnected._