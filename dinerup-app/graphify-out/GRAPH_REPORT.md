# Graph Report - dinerup-app  (2026-11-17)

## Corpus Check
- 72 files · ~38,402 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .toml 1)

## Summary
- 469 nodes · 1010 edges · 23 communities (18 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `49ee4c13`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- DashboardCooperative.tsx
- OnboardingPage.tsx
- CreditDetailsModal.tsx
- react
- httpClient
- mockAPI.ts
- react
- compilerOptions
- PublicCreditRequestModal.tsx
- dependencies
- compilerOptions
- eslint.config.js
- devDependencies
- package.json
- scripts
- onboarding.ts
- vercel.json
- vite-env.d.ts
- tsconfig.json
- vite

## God Nodes (most connected - your core abstractions)
1. `httpClient()` - 44 edges
2. `react` - 32 edges
3. `DashboardCooperative()` - 24 edges
4. `getErrorMessage()` - 24 edges
5. `lucide-react` - 23 edges
6. `DashboardClient()` - 16 edges
7. `compilerOptions` - 16 edges
8. `OnboardingPage()` - 14 edges
9. `useAuth()` - 14 edges
10. `compilerOptions` - 14 edges

## Surprising Connections (you probably didn't know these)
- `DashboardCooperative()` --calls--> `CooperativeInvestmentsPanel()`  [EXTRACTED]
  src/pages/DashboardCooperative.tsx → src/components/investment/CooperativeInvestmentsPanel.tsx
- `DashboardClient()` --calls--> `NewInvestmentModal()`  [EXTRACTED]
  src/pages/DashboardClient.tsx → src/components/investment/NewInvestmentModal.tsx
- `DashboardClient()` --calls--> `getErrorMessage()`  [EXTRACTED]
  src/pages/DashboardClient.tsx → src/api/errors.ts
- `DashboardClient()` --calls--> `CooperativeCard()`  [EXTRACTED]
  src/pages/DashboardClient.tsx → src/components/cooperative/CooperativeCard.tsx
- `DashboardClient()` --calls--> `CooperativeLogoMarquee()`  [EXTRACTED]
  src/pages/DashboardClient.tsx → src/components/cooperative/CooperativeLogoMarquee.tsx

## Import Cycles
- None detected.

## Communities (23 total, 5 thin omitted)

### Community 0 - "DashboardCooperative.tsx"
Cohesion: 0.06
Nodes (60): CreateCreditRequestPayload, CreditGuarantorHistoryItem, CreditTimelineEvent, decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestTimeline(), getGuarantorHistoryForCooperative() (+52 more)

### Community 1 - "OnboardingPage.tsx"
Cohesion: 0.06
Nodes (52): ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getMyGuarantorProfiles(), getPreRegistrationData(), GuaranteeOnboardingResponse, GuarantorProfileResponse (+44 more)

### Community 2 - "CreditDetailsModal.tsx"
Cohesion: 0.14
Nodes (21): acceptCreditCooperative(), getCreditRequestCooperatives(), getGuarantorHistoryForClient(), CreditCard(), CreditCardProps, statusMap, tipoMap, cooperativeStatus (+13 more)

### Community 3 - "react"
Cohesion: 0.07
Nodes (38): lucide-react, react, getCooperatives(), createCreditRequest(), getMyCreditRequests(), getFormularioClienteStatus(), App(), AuthLoadingScreen() (+30 more)

### Community 4 - "httpClient"
Cohesion: 0.09
Nodes (46): activateAccount(), activateInvitation(), changeRegistrationEmail(), changeRegistrationEmailOnly(), completeRegistration(), forgotPassword(), getInvitationDetails(), InvitationDetails (+38 more)

### Community 5 - "mockAPI.ts"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "react"
Cohesion: 0.12
Nodes (27): loginRequest(), AUTH_UNAUTHORIZED_EVENT, emitUnauthorizedEvent(), resetUnauthorizedEventState(), AuthUser, clearStoredAuth(), extractToken(), LEGACY_TOKEN_KEYS (+19 more)

### Community 8 - "compilerOptions"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "PublicCreditRequestModal.tsx"
Cohesion: 0.14
Nodes (18): creditTypes, FormData, FormErrors, getInitialFormState(), Input(), InputProps, isValidEcuadorId(), onlyLetters() (+10 more)

### Community 10 - "dependencies"
Cohesion: 0.13
Nodes (15): dependencies, @hookform/resolvers@^5.2.2, lucide-react@^0.344.0, react@^18.3.1, react-dom@^18.3.1, react-router-dom@^7.9.4, @supabase/supabase-js@^2.57.4, swiper@^12.1.2 (+7 more)

### Community 11 - "compilerOptions"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 13 - "eslint.config.js"
Cohesion: 0.18
Nodes (10): @eslint/js@^9.9.1, eslint-plugin-react-hooks@^5.1.0-rc.0, eslint-plugin-react-refresh@^0.4.11, globals@^15.9.0, typescript-eslint@^8.3.0, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh (+2 more)

### Community 14 - "devDependencies"
Cohesion: 0.15
Nodes (13): devDependencies, autoprefixer@^10.4.18, eslint@^9.9.1, postcss@^8.4.35, tailwindcss@^3.4.1, @types/react@^18.3.5, @types/react-dom@^18.3.0, autoprefixer (+5 more)

### Community 15 - "package.json"
Cohesion: 0.22
Nodes (8): react-hook-form@^7.65.0, typescript@^5.5.3, name, private, type, version, react-hook-form, typescript

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
  These have ≤1 connection - possible missing edges. (Counts symbols only; 151 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `httpClient`, `react`, `PublicCreditRequestModal.tsx`, `dependencies`, `package.json`?**
  _High betweenness centrality (0.192) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `DashboardCooperative.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.06095481670929241 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `react` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `httpClient`, `PublicCreditRequestModal.tsx`, `dependencies`, `package.json`?**
  _High betweenness centrality (0.106) - this node is a cross-community bridge._
- **Should `OnboardingPage.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.05734767025089606 - nodes in this community are weakly interconnected._
- **Why does `httpClient()` connect `httpClient` to `DashboardCooperative.tsx`, `OnboardingPage.tsx`, `CreditDetailsModal.tsx`, `react`, `react`, `PublicCreditRequestModal.tsx`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Should `CreditDetailsModal.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.13768115942028986 - nodes in this community are weakly interconnected._