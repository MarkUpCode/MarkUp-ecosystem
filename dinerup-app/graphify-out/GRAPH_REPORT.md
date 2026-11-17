# Graph Report - dinerup-app  (2026-11-17)

## Corpus Check
- 75 files · ~41,514 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .toml 1)

## Summary
- 486 nodes · 1040 edges · 23 communities (18 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `332b3abb`
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
- package.json
- dependencies
- compilerOptions
- eslint.config.js
- devDependencies
- scripts
- onboarding.ts
- vercel.json
- vite-env.d.ts
- tsconfig.json
- vite

## God Nodes (most connected - your core abstractions)
1. `httpClient()` - 47 edges
2. `react` - 34 edges
3. `getErrorMessage()` - 26 edges
4. `DashboardCooperative()` - 23 edges
5. `lucide-react` - 23 edges
6. `compilerOptions` - 16 edges
7. `DashboardClient()` - 15 edges
8. `App()` - 14 edges
9. `PublicCreditRequestModal()` - 14 edges
10. `useAuth()` - 14 edges

## Surprising Connections (you probably didn't know these)
- `Login()` --calls--> `CooperativesCarousel()`  [EXTRACTED]
  src/pages/Login.tsx → src/components/cooperative/CooperativesCarousel.tsx
- `changeRegistrationEmail()` --calls--> `httpClient()`  [EXTRACTED]
  src/api/auth/auth.api.ts → src/api/httpClient.ts
- `completeRegistration()` --calls--> `httpClient()`  [EXTRACTED]
  src/api/auth/auth.api.ts → src/api/httpClient.ts
- `App()` --calls--> `DashboardClient()`  [EXTRACTED]
  src/App.tsx → src/pages/DashboardClient.tsx
- `App()` --calls--> `DashboardCooperative()`  [EXTRACTED]
  src/App.tsx → src/pages/DashboardCooperative.tsx

## Import Cycles
- None detected.

## Communities (23 total, 5 thin omitted)

### Community 0 - "DashboardCooperative.tsx"
Cohesion: 0.06
Nodes (58): CreateCreditRequestPayload, CreditGuarantorHistoryItem, CreditTimelineEvent, decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestTimeline(), getGuarantorHistoryForCooperative() (+50 more)

### Community 1 - "OnboardingPage.tsx"
Cohesion: 0.05
Nodes (53): lucide-react, ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getMyGuarantorProfiles(), getPreRegistrationData(), GuaranteeOnboardingResponse (+45 more)

### Community 2 - "CreditDetailsModal.tsx"
Cohesion: 0.14
Nodes (22): acceptCreditCooperative(), getCreditRequestCooperatives(), getGuarantorHistoryForClient(), CreditCardProps, statusMap, tipoMap, cooperativeStatus, CreditDetailsModal() (+14 more)

### Community 3 - "DashboardClient.tsx"
Cohesion: 0.08
Nodes (25): getCooperatives(), createCreditRequest(), getMyCreditRequests(), getFormularioClienteStatus(), CooperativeCard(), CooperativeCardProps, CooperativeLogoMarquee(), cooperatives (+17 more)

### Community 4 - "httpClient"
Cohesion: 0.15
Nodes (27): httpClient(), acceptInvestmentRequest(), addInvestmentRate(), createInvestmentRequest(), FinancialProduct, getCooperativeInvestmentProducts(), getCooperativeInvestmentRequests(), getInvestmentAvailability() (+19 more)

### Community 5 - "mockAPI.ts"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "react"
Cohesion: 0.11
Nodes (25): loginRequest(), AUTH_UNAUTHORIZED_EVENT, emitUnauthorizedEvent(), resetUnauthorizedEventState(), clearStoredAuth(), extractToken(), LEGACY_TOKEN_KEYS, normalizeToken() (+17 more)

### Community 7 - "react"
Cohesion: 0.05
Nodes (67): react, react-router-dom, activateAccount(), activateInvitation(), changeRegistrationEmail(), changeRegistrationEmailOnly(), completeRegistration(), forgotPassword() (+59 more)

### Community 8 - "compilerOptions"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "package.json"
Cohesion: 0.22
Nodes (8): tailwindcss@^3.4.1, typescript@^5.5.3, name, private, type, version, tailwindcss, typescript

### Community 10 - "dependencies"
Cohesion: 0.12
Nodes (16): dependencies, @hookform/resolvers@^5.2.2, lucide-react@^0.344.0, react@^18.3.1, react-dom@^18.3.1, react-hook-form@^7.65.0, react-router-dom@^7.9.4, @supabase/supabase-js@^2.57.4 (+8 more)

### Community 11 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 13 - "eslint.config.js"
Cohesion: 0.18
Nodes (10): @eslint/js@^9.9.1, eslint-plugin-react-hooks@^5.1.0-rc.0, eslint-plugin-react-refresh@^0.4.11, globals@^15.9.0, typescript-eslint@^8.3.0, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh (+2 more)

### Community 14 - "devDependencies"
Cohesion: 0.18
Nodes (11): devDependencies, autoprefixer@^10.4.18, eslint@^9.9.1, postcss@^8.4.35, @types/react@^18.3.5, @types/react-dom@^18.3.0, autoprefixer, eslint (+3 more)

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

## Knowledge Gaps
- **7 isolated node(s):** `PRE_APROBAR`, `RECHAZAR`, `CREADA`, `ENVIADA`, `PRE_APROBADA` (+2 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 155 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `react`, `package.json`, `dependencies`?**
  _High betweenness centrality (0.202) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `DashboardCooperative.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.05920745920745921 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `OnboardingPage.tsx` to `DashboardCooperative.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `react`, `package.json`, `dependencies`?**
  _High betweenness centrality (0.101) - this node is a cross-community bridge._
- **Should `OnboardingPage.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.05336951605608322 - nodes in this community are weakly interconnected._
- **Why does `httpClient()` connect `httpClient` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `react`, `react`?**
  _High betweenness centrality (0.068) - this node is a cross-community bridge._
- **Should `CreditDetailsModal.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.14461538461538462 - nodes in this community are weakly interconnected._