# Graph Report - dinerup-app  (2026-11-16)

## Corpus Check
- 70 files · ~37,450 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .toml 1)

## Summary
- 453 nodes · 958 edges · 18 communities (13 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `105f90ed`
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
2. `react` - 31 edges
3. `DashboardCooperative()` - 23 edges
4. `lucide-react` - 23 edges
5. `getErrorMessage()` - 20 edges
6. `DashboardClient()` - 16 edges
7. `compilerOptions` - 16 edges
8. `useAuth()` - 14 edges
9. `OnboardingPage()` - 14 edges
10. `compilerOptions` - 14 edges

## Surprising Connections (you probably didn't know these)
- `App()` --calls--> `DashboardClient()`  [EXTRACTED]
  dinerup-app/src/App.tsx → src/pages/DashboardClient.tsx
- `App()` --calls--> `DashboardCooperative()`  [EXTRACTED]
  dinerup-app/src/App.tsx → src/pages/DashboardCooperative.tsx
- `App()` --calls--> `Login()`  [EXTRACTED]
  dinerup-app/src/App.tsx → src/pages/Login.tsx
- `App()` --calls--> `OnboardingPage()`  [EXTRACTED]
  dinerup-app/src/App.tsx → src/pages/OnboardingPage.tsx
- `AuthProvider()` --calls--> `loginRequest()`  [EXTRACTED]
  src/context/AuthContext.tsx → dinerup-app/src/api/auth/auth.api.ts

## Import Cycles
- None detected.

## Communities (18 total, 5 thin omitted)

### Community 0 - "DashboardCooperative.tsx"
Cohesion: 0.06
Nodes (60): CreateCreditRequestPayload, CreditGuarantorHistoryItem, CreditTimelineEvent, decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestTimeline(), getGuarantorHistoryForCooperative() (+52 more)

### Community 1 - "OnboardingPage.tsx"
Cohesion: 0.06
Nodes (52): ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getMyGuarantorProfiles(), getPreRegistrationData(), GuaranteeOnboardingResponse, GuarantorProfileResponse (+44 more)

### Community 2 - "CreditDetailsModal.tsx"
Cohesion: 0.14
Nodes (21): acceptCreditCooperative(), getCreditRequestCooperatives(), getGuarantorHistoryForClient(), CreditCard(), CreditCardProps, statusMap, tipoMap, cooperativeStatus (+13 more)

### Community 3 - "DashboardClient.tsx"
Cohesion: 0.08
Nodes (26): getCooperatives(), createCreditRequest(), getMyCreditRequests(), getFormularioClienteStatus(), CooperativeCard(), CooperativeCardProps, CooperativeLogoMarquee(), cooperatives (+18 more)

### Community 4 - "httpClient"
Cohesion: 0.10
Nodes (39): react-router-dom@^7.9.4, react-router-dom, activateAccount(), activateInvitation(), changeRegistrationEmail(), changeRegistrationEmailOnly(), completeRegistration(), forgotPassword() (+31 more)

### Community 5 - "mockAPI.ts"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "react"
Cohesion: 0.11
Nodes (27): react, AUTH_UNAUTHORIZED_EVENT, emitUnauthorizedEvent(), resetUnauthorizedEventState(), AuthUser, clearStoredAuth(), extractToken(), LEGACY_TOKEN_KEYS (+19 more)

### Community 8 - "compilerOptions"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "PublicCreditRequestModal.tsx"
Cohesion: 0.10
Nodes (25): lucide-react, CooperativesCarousel(), creditTypes, FormData, FormErrors, getInitialFormState(), Input(), InputProps (+17 more)

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

- **Why does `react` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `PublicCreditRequestModal.tsx`, `package.json`?**
  _High betweenness centrality (0.194) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `DashboardCooperative.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.06095481670929241 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `PublicCreditRequestModal.tsx` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `DashboardClient.tsx`, `httpClient`, `package.json`?**
  _High betweenness centrality (0.108) - this node is a cross-community bridge._
- **Should `OnboardingPage.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.05734767025089606 - nodes in this community are weakly interconnected._
- **Why does `Cooperative` connect `DashboardClient.tsx` to `mockAPI.ts`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **Should `CreditDetailsModal.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.13768115942028986 - nodes in this community are weakly interconnected._