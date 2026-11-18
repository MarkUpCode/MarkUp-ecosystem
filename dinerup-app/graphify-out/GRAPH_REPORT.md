# Graph Report - dinerup-app  (2026-11-18)

## Corpus Check
- 75 files · ~42,011 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .toml 1)

## Summary
- 487 nodes · 1074 edges · 20 communities (15 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2f94400a`
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
- react
- compilerOptions
- package.json
- onboarding.ts
- vercel.json
- vite-env.d.ts
- tsconfig.json

## God Nodes (most connected - your core abstractions)
1. `httpClient()` - 50 edges
2. `react` - 34 edges
3. `getErrorMessage()` - 28 edges
4. `DashboardCooperative()` - 24 edges
5. `lucide-react` - 23 edges
6. `DashboardClient()` - 16 edges
7. `compilerOptions` - 16 edges
8. `react-router-dom` - 14 edges
9. `App()` - 14 edges
10. `PublicCreditRequestModal()` - 14 edges

## Surprising Connections (you probably didn't know these)
- `App()` --calls--> `DashboardClient()`  [EXTRACTED]
  src/App.tsx → src/pages/DashboardClient.tsx
- `App()` --calls--> `DashboardCooperative()`  [EXTRACTED]
  src/App.tsx → src/pages/DashboardCooperative.tsx
- `App()` --calls--> `Login()`  [EXTRACTED]
  src/App.tsx → src/pages/Login.tsx
- `App()` --calls--> `OnboardingPage()`  [EXTRACTED]
  src/App.tsx → src/pages/OnboardingPage.tsx
- `App()` --calls--> `PublicInvestments()`  [EXTRACTED]
  src/App.tsx → src/pages/PublicInvestments.tsx

## Import Cycles
- None detected.

## Communities (20 total, 5 thin omitted)

### Community 0 - "DashboardCooperative.tsx"
Cohesion: 0.06
Nodes (56): CreateCreditRequestPayload, CreditGuarantorHistoryItem, CreditTimelineEvent, decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestTimeline(), getGuarantorHistoryForCooperative() (+48 more)

### Community 1 - "OnboardingPage.tsx"
Cohesion: 0.06
Nodes (52): ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getMyGuarantorProfiles(), getPreRegistrationData(), GuaranteeOnboardingResponse, GuarantorProfileResponse (+44 more)

### Community 2 - "CreditDetailsModal.tsx"
Cohesion: 0.13
Nodes (25): acceptCreditCooperative(), getCreditRequestCooperatives(), getGuarantorHistoryForClient(), CreditCard(), CreditCardProps, statusMap, tipoMap, cooperativeStatus (+17 more)

### Community 3 - "DashboardClient.tsx"
Cohesion: 0.15
Nodes (18): lucide-react, getCooperatives(), createCreditRequest(), getMyCreditRequests(), getFormularioClienteStatus(), CooperativeCard(), CooperativeCardProps, CreditModalSubmitData (+10 more)

### Community 4 - "httpClient"
Cohesion: 0.14
Nodes (26): acceptInvestmentRequest(), addInvestmentRate(), createInvestmentRequest(), FinancialProduct, getCooperativeInvestmentProducts(), getCooperativeInvestmentRequests(), getInvestmentAvailability(), getInvestmentOffers() (+18 more)

### Community 5 - "mockAPI.ts"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "react"
Cohesion: 0.11
Nodes (27): loginRequest(), AUTH_UNAUTHORIZED_EVENT, emitUnauthorizedEvent(), resetUnauthorizedEventState(), AuthUser, clearStoredAuth(), extractToken(), LEGACY_TOKEN_KEYS (+19 more)

### Community 7 - "react"
Cohesion: 0.10
Nodes (42): react-router-dom, activateAccount(), activateInvitation(), changeRegistrationEmail(), changeRegistrationEmailOnly(), completeRegistration(), forgotPassword(), getInvitationDetails() (+34 more)

### Community 8 - "compilerOptions"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "PublicCreditRequestModal.tsx"
Cohesion: 0.14
Nodes (18): creditTypes, FormData, FormErrors, getInitialFormState(), Input(), InputProps, isValidEcuadorId(), onlyLetters() (+10 more)

### Community 10 - "react"
Cohesion: 0.08
Nodes (26): dependencies, @hookform/resolvers@^5.2.2, lucide-react@^0.344.0, react@^18.3.1, react-hook-form@^7.65.0, react-router-dom@^7.9.4, @supabase/supabase-js@^2.57.4, zod@^4.1.12 (+18 more)

### Community 11 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 13 - "package.json"
Cohesion: 0.06
Nodes (43): react-dom@^18.3.1, swiper@^12.1.2, devDependencies, autoprefixer@^10.4.18, eslint@^9.9.1, @eslint/js@^9.9.1, eslint-plugin-react-hooks@^5.1.0-rc.0, eslint-plugin-react-refresh@^0.4.11 (+35 more)

### Community 17 - "onboarding.ts"
Cohesion: 0.40
Nodes (4): AddressForm, OnboardingFormData, PersonalDetailsForm, PersonalIdentityForm

### Community 18 - "vercel.json"
Cohesion: 0.40
Nodes (4): buildCommand, headers, outputDirectory, rewrites

## Knowledge Gaps
- **7 isolated node(s):** `PRE_APROBAR`, `RECHAZAR`, `CREADA`, `ENVIADA`, `PRE_APROBADA` (+2 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 155 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `react`, `react`, `PublicCreditRequestModal.tsx`, `package.json`?**
  _High betweenness centrality (0.197) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `DashboardCooperative.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.0629800307219662 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `DashboardClient.tsx` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `httpClient`, `react`, `PublicCreditRequestModal.tsx`, `react`, `package.json`?**
  _High betweenness centrality (0.098) - this node is a cross-community bridge._
- **Should `OnboardingPage.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.05734767025089606 - nodes in this community are weakly interconnected._
- **Why does `httpClient()` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `react`, `PublicCreditRequestModal.tsx`, `react`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **Should `CreditDetailsModal.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.12643678160919541 - nodes in this community are weakly interconnected._