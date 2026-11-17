# Graph Report - markup-admin  (2026-11-16)

## Corpus Check
- 75 files · ~10,602 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 4 file(s) not represented in the graph (top: .tsbuildinfo 2, (none) 1, .css 1)

## Summary
- 332 nodes · 664 edges · 22 communities (16 shown, 6 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `105f90ed`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- UsersPage.tsx
- package.json
- App.tsx
- react
- UsersTable.tsx
- compilerOptions
- auth-context.tsx
- ProductsPage.tsx
- devDependencies
- main.tsx
- CooperativesPage.tsx
- eslint.config.js
- compilerOptions
- vite
- scripts
- vercel.json
- vite-env.d.ts
- tsconfig.json

## God Nodes (most connected - your core abstractions)
1. `react` - 27 edges
2. `lucide-react` - 21 edges
3. `compilerOptions` - 18 edges
4. `App()` - 15 edges
5. `ProductsPage()` - 12 edges
6. `react-router-dom` - 10 edges
7. `UsersPage()` - 8 edges
8. `useAuth()` - 8 edges
9. `CooperativeWizard()` - 7 edges
10. `CooperativesPage()` - 7 edges

## Surprising Connections (you probably didn't know these)
- `UsersTableProps` --references--> `UserListItem`  [EXTRACTED]
  markup-admin/src/modules/users/components/UsersTable.tsx → markup-admin/src/modules/users/types/user.ts
- `CooperativesPage()` --calls--> `CooperativeWizard()`  [EXTRACTED]
  markup-admin/src/modules/cooperatives/pages/CooperativesPage.tsx → markup-admin/src/modules/cooperatives/components/CooperativeWizard.tsx
- `submit()` --calls--> `createProduct()`  [EXTRACTED]
  markup-admin/src/modules/cooperatives/components/CooperativeWizard.tsx → markup-admin/src/modules/products/api/products.api.ts
- `App()` --calls--> `CooperativesPage()`  [EXTRACTED]
  markup-admin/src/app/App.tsx → markup-admin/src/modules/cooperatives/pages/CooperativesPage.tsx
- `CooperativesTableProps` --references--> `CooperativeListItem`  [EXTRACTED]
  markup-admin/src/modules/cooperatives/components/CooperativesTable.tsx → markup-admin/src/modules/cooperatives/types/cooperative.ts

## Import Cycles
- None detected.

## Communities (22 total, 6 thin omitted)

### Community 0 - "UsersPage.tsx"
Cohesion: 0.09
Nodes (30): lucide-react, ConfirmationModal(), ConfirmationModalProps, Modal(), ModalProps, Pagination(), PaginationProps, useToast() (+22 more)

### Community 1 - "package.json"
Cohesion: 0.09
Nodes (29): dependencies, axios@^1.11.0, class-variance-authority@^0.7.1, clsx@^2.1.1, @hookform/resolvers@^5.2.1, lucide-react@^0.539.0, @radix-ui/react-dialog@^1.1.15, @radix-ui/react-dropdown-menu@^2.1.16 (+21 more)

### Community 2 - "App.tsx"
Cohesion: 0.15
Nodes (19): react-router-dom@^7.8.0, react-router-dom, App(), AuthContext, useAuth(), useTheme(), MainLayout(), menuItems (+11 more)

### Community 3 - "react"
Cohesion: 0.17
Nodes (12): react, Button(), Card(), Input(), LoginBackground(), LoginCard(), LoginCardProps, LoginInput (+4 more)

### Community 4 - "UsersTable.tsx"
Cohesion: 0.15
Nodes (15): Badge(), BadgeProps, IconButton(), IconButtonProps, UserActions(), UserActionsProps, UserAvatar(), UserAvatarProps (+7 more)

### Community 5 - "compilerOptions"
Cohesion: 0.10
Nodes (20): compilerOptions, allowJs, allowSyntheticDefaultImports, baseUrl, esModuleInterop, forceConsistentCasingInFileNames, isolatedModules, jsx (+12 more)

### Community 6 - "auth-context.tsx"
Cohesion: 0.16
Nodes (16): AuthContextValue, DashboardData, getDashboard(), API_BASE_URL, login(), api, clearSession(), getStoredSession() (+8 more)

### Community 7 - "ProductsPage.tsx"
Cohesion: 0.16
Nodes (18): PageHeader(), PageHeaderProps, CooperativeWizard(), submit(), draftProduct(), ProductDraft, addProductConditions(), createProduct() (+10 more)

### Community 8 - "devDependencies"
Cohesion: 0.11
Nodes (18): devDependencies, autoprefixer@^10.4.21, eslint@^9.34.0, postcss@^8.5.6, tailwindcss@^3.4.17, @types/node@^24.3.0, @types/react@^19.1.11, @types/react-dom@^19.1.7 (+10 more)

### Community 9 - "main.tsx"
Cohesion: 0.14
Nodes (14): @tanstack/react-query@^5.85.6, @tanstack/react-query, Toast(), ToastProps, ToastVariant, AuthProvider(), ThemeContext, ThemeContextValue (+6 more)

### Community 10 - "CooperativesPage.tsx"
Cohesion: 0.14
Nodes (20): createCooperative(), deleteCooperative(), getCooperativeById(), getCooperatives(), updateCooperative(), CooperativesFilters(), CooperativesFiltersProps, Card() (+12 more)

### Community 11 - "eslint.config.js"
Cohesion: 0.20
Nodes (8): @eslint/js@^9.34.0, eslint-plugin-react-hooks@^5.2.0, eslint-plugin-react-refresh@^0.4.20, typescript-eslint@^8.39.1, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh, typescript-eslint

### Community 12 - "compilerOptions"
Cohesion: 0.25
Nodes (7): compilerOptions, allowSyntheticDefaultImports, composite, module, moduleResolution, skipLibCheck, include

### Community 13 - "vite"
Cohesion: 0.47
Nodes (3): @vitejs/plugin-react@^5.0.2, vite, @vitejs/plugin-react

### Community 14 - "scripts"
Cohesion: 0.40
Nodes (5): scripts, build, dev, lint, preview

### Community 15 - "vercel.json"
Cohesion: 0.40
Nodes (4): buildCommand, headers, outputDirectory, rewrites

## Knowledge Gaps
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `react` to `UsersPage.tsx`, `package.json`, `App.tsx`, `UsersTable.tsx`, `auth-context.tsx`, `ProductsPage.tsx`, `main.tsx`, `CooperativesPage.tsx`?**
  _High betweenness centrality (0.231) - this node is a cross-community bridge._
- **Should `UsersPage.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.09158186864014801 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `UsersPage.tsx` to `package.json`, `App.tsx`, `react`, `UsersTable.tsx`, `auth-context.tsx`, `ProductsPage.tsx`, `main.tsx`, `CooperativesPage.tsx`?**
  _High betweenness centrality (0.151) - this node is a cross-community bridge._
- **Should `package.json` be split into smaller, more focused modules?**
  _Cohesion score 0.09195402298850575 - nodes in this community are weakly interconnected._
- **Why does `react-router-dom` connect `App.tsx` to `package.json`, `react`, `ProductsPage.tsx`, `main.tsx`, `CooperativesPage.tsx`?**
  _High betweenness centrality (0.052) - this node is a cross-community bridge._
- **Should `App.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.1471264367816092 - nodes in this community are weakly interconnected._
- **Should `UsersTable.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.1471861471861472 - nodes in this community are weakly interconnected._