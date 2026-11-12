# Graph Report - dinerup-app  (2026-11-12)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 420 nodes · 870 edges · 24 communities (19 shown, 5 thin omitted)
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

## God Nodes (most connected - your core abstractions)
1. `httpClient()` - 31 edges
2. `react` - 26 edges
3. `lucide-react` - 20 edges
4. `DashboardCooperative()` - 19 edges
5. `getErrorMessage()` - 17 edges
6. `DashboardClient()` - 16 edges
7. `compilerOptions` - 16 edges
8. `useAuth()` - 14 edges
9. `OnboardingPage()` - 14 edges
10. `compilerOptions` - 14 edges

## Surprising Connections (you probably didn't know these)
- `CreditCardProps` --references--> `CreditRequest`  [EXTRACTED]
  src/components/credit/CreditCard.tsx → src/types/credit.ts
- `CreditDetailsModalProps` --references--> `CreditRequest`  [EXTRACTED]
  src/components/credit/CreditDetailsModal.tsx → src/types/credit.ts
- `CooperativeCardProps` --references--> `Cooperative`  [EXTRACTED]
  src/components/cooperative/CooperativeCard.tsx → src/types/cooperative.ts
- `getCooperativeOfferDefaults()` --calls--> `httpClient()`  [EXTRACTED]
  src/api/creditRequests.api.ts → src/api/httpClient.ts
- `getCreditRequestTimeline()` --calls--> `httpClient()`  [EXTRACTED]
  src/api/creditRequests.api.ts → src/api/httpClient.ts

## Import Cycles
- None detected.

## Communities (24 total, 5 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.07
Nodes (59): acceptCreditCooperative(), CreateCreditRequestPayload, CreditTimelineEvent, decideCreditRequest(), decideGuaranteeForCreditRequest(), getCooperativeOfferDefaults(), getCreditRequestCooperatives(), getCreditRequestTimeline() (+51 more)

### Community 1 - "Community 1"
Cohesion: 0.06
Nodes (38): ActividadEconomicaData, ClientePerfilUbicacion, DireccionData, FormularioClienteStatus, getOnboardingForCooperative(), GuaranteeOnboardingResponse, IngresoEgresoData, OnboardingCooperativeDetail (+30 more)

### Community 2 - "Community 2"
Cohesion: 0.11
Nodes (29): react, react-router-dom, activateAccount(), forgotPassword(), resetPassword(), getErrorMessage(), getPreRegistrationData(), submitOnboarding() (+21 more)

### Community 3 - "Community 3"
Cohesion: 0.10
Nodes (25): lucide-react, getCooperatives(), createCreditRequest(), getMyCreditRequests(), getFormularioClienteStatus(), CooperativeCard(), CooperativeCardProps, CooperativeLogoMarquee() (+17 more)

### Community 4 - "Community 4"
Cohesion: 0.14
Nodes (23): changeRegistrationEmail(), changeRegistrationEmailOnly(), completeRegistration(), LoginResponse, RegistrationOtpVerifyPayload, RegistrationPasswordPayload, RegistrationStartPayload, resendRegistrationOtp() (+15 more)

### Community 5 - "Community 5"
Cohesion: 0.13
Nodes (21): cooperativesData, Cooperative, CreditRequest, CreditRequestFormData, LoginFormData, RegisterFormData, User, UserType (+13 more)

### Community 6 - "Community 6"
Cohesion: 0.17
Nodes (20): loginRequest(), AUTH_UNAUTHORIZED_EVENT, resetUnauthorizedEventState(), AuthUser, clearStoredAuth(), extractToken(), LEGACY_TOKEN_KEYS, normalizeToken() (+12 more)

### Community 7 - "Community 7"
Cohesion: 0.14
Nodes (12): cooperatives, Cooperative, cooperatives, CooperativesCarousel(), PlatformVisitsCounter(), WelcomePopup(), WelcomePopupProps, FeatureItem() (+4 more)

### Community 8 - "Community 8"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 9 - "Community 9"
Cohesion: 0.18
Nodes (15): creditTypes, FormData, FormErrors, getInitialFormState(), Input(), InputProps, isValidEcuadorId(), onlyLetters() (+7 more)

### Community 10 - "Community 10"
Cohesion: 0.12
Nodes (16): dependencies, @hookform/resolvers@^5.2.2, lucide-react@^0.344.0, react@^18.3.1, react-dom@^18.3.1, react-hook-form@^7.65.0, react-router-dom@^7.9.4, @supabase/supabase-js@^2.57.4 (+8 more)

### Community 11 - "Community 11"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 12 - "Community 12"
Cohesion: 0.18
Nodes (10): @eslint/js@^9.9.1, eslint-plugin-react-hooks@^5.1.0-rc.0, eslint-plugin-react-refresh@^0.4.11, globals@^15.9.0, typescript-eslint@^8.3.0, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh (+2 more)

### Community 13 - "Community 13"
Cohesion: 0.18
Nodes (11): devDependencies, autoprefixer@^10.4.18, eslint@^9.9.1, postcss@^8.4.35, @types/react@^18.3.5, @types/react-dom@^18.3.0, autoprefixer, eslint (+3 more)

### Community 14 - "Community 14"
Cohesion: 0.22
Nodes (8): tailwindcss@^3.4.1, typescript@^5.5.3, name, private, type, version, tailwindcss, typescript

### Community 15 - "Community 15"
Cohesion: 0.33
Nodes (6): scripts, build, dev, lint, preview, typecheck

### Community 16 - "Community 16"
Cohesion: 0.40
Nodes (4): vite@^5.4.2, @vitejs/plugin-react@^4.3.1, vite, @vitejs/plugin-react

### Community 17 - "Community 17"
Cohesion: 0.40
Nodes (4): AddressForm, OnboardingFormData, PersonalDetailsForm, PersonalIdentityForm

### Community 18 - "Community 18"
Cohesion: 0.40
Nodes (4): buildCommand, headers, outputDirectory, rewrites

## Knowledge Gaps
- **7 isolated node(s):** `PRE_APROBAR`, `RECHAZAR`, `CREADA`, `ENVIADA`, `PRE_APROBADA` (+2 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 144 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `Community 2` to `Community 0`, `Community 1`, `Community 3`, `Community 4`, `Community 6`, `Community 7`, `Community 9`, `Community 10`, `Community 14`?**
  _High betweenness centrality (0.186) - this node is a cross-community bridge._
- **What connects `PRE_APROBAR`, `RECHAZAR`, `CREADA` to the rest of the system?**
  _7 weakly-connected nodes found - possible missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06558118498417007 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `Community 3` to `Community 0`, `Community 1`, `Community 2`, `Community 4`, `Community 7`, `Community 9`, `Community 10`, `Community 14`?**
  _High betweenness centrality (0.108) - this node is a cross-community bridge._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.05858585858585859 - nodes in this community are weakly interconnected._
- **Why does `Cooperative` connect `Community 3` to `Community 5`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.11463414634146342 - nodes in this community are weakly interconnected._