# Graph Report - markup-admin  (2026-11-16)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 307 nodes · 615 edges · 22 communities (16 shown, 6 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `31433c60`
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

## God Nodes (most connected - your core abstractions)
1. `react` - 25 edges
2. `lucide-react` - 20 edges
3. `compilerOptions` - 18 edges
4. `App()` - 16 edges
5. `UsersPage()` - 12 edges
6. `CooperativesPage()` - 9 edges
7. `useAuth()` - 9 edges
8. `isAdminRole()` - 9 edges
9. `LoginPage()` - 9 edges
10. `useCooperatives()` - 8 edges

## Surprising Connections (you probably didn't know these)
- `UsersTableProps` --references--> `UserListItem`  [EXTRACTED]
  src/modules/users/components/UsersTable.tsx → src/modules/users/types/user.ts
- `InviteUserFormProps` --references--> `InviteUserRequest`  [EXTRACTED]
  src/modules/users/components/InviteUserForm.tsx → src/modules/users/types/user.ts
- `InviteUserModalProps` --references--> `InviteUserRequest`  [EXTRACTED]
  src/modules/users/components/InviteUserModal.tsx → src/modules/users/types/user.ts
- `App()` --calls--> `CooperativesPage()`  [EXTRACTED]
  src/app/App.tsx → src/modules/cooperatives/pages/CooperativesPage.tsx
- `CooperativesPage()` --calls--> `useCooperatives()`  [EXTRACTED]
  src/modules/cooperatives/pages/CooperativesPage.tsx → src/modules/cooperatives/hooks/useCooperatives.ts

## Import Cycles
- None detected.

## Communities (22 total, 6 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.11
Nodes (22): lucide-react, ConfirmationModal(), ConfirmationModalProps, Modal(), ModalProps, PageHeader(), PageHeaderProps, Pagination() (+14 more)

### Community 1 - "Community 1"
Cohesion: 0.09
Nodes (31): dependencies, axios@^1.11.0, class-variance-authority@^0.7.1, clsx@^2.1.1, @hookform/resolvers@^5.2.1, lucide-react@^0.539.0, @radix-ui/react-dialog@^1.1.15, @radix-ui/react-dropdown-menu@^2.1.16 (+23 more)

### Community 2 - "Community 2"
Cohesion: 0.15
Nodes (18): react-router-dom@^7.8.0, react-router-dom, App(), AuthContext, useAuth(), useTheme(), MainLayout(), menuItems (+10 more)

### Community 3 - "Community 3"
Cohesion: 0.14
Nodes (17): react, Button(), Card(), Input(), LoginBackground(), LoginCard(), LoginCardProps, LoginInput (+9 more)

### Community 4 - "Community 4"
Cohesion: 0.15
Nodes (16): Badge(), BadgeProps, IconButton(), IconButtonProps, UserActions(), UserActionsProps, UserAvatar(), UserAvatarProps (+8 more)

### Community 5 - "Community 5"
Cohesion: 0.10
Nodes (20): compilerOptions, allowJs, allowSyntheticDefaultImports, baseUrl, esModuleInterop, forceConsistentCasingInFileNames, isolatedModules, jsx (+12 more)

### Community 6 - "Community 6"
Cohesion: 0.22
Nodes (14): AuthContextValue, AuthProvider(), API_BASE_URL, login(), clearSession(), getStoredSession(), getStoredUser(), getToken() (+6 more)

### Community 7 - "Community 7"
Cohesion: 0.23
Nodes (12): changeUserStatus(), getUsers(), inviteUser(), InviteUserForm(), InviteUserFormProps, InviteUserModalProps, useUsers(), ChangeStatusRequest (+4 more)

### Community 8 - "Community 8"
Cohesion: 0.11
Nodes (18): devDependencies, autoprefixer@^10.4.21, eslint@^9.34.0, postcss@^8.5.6, tailwindcss@^3.4.17, @types/node@^24.3.0, @types/react@^19.1.11, @types/react-dom@^19.1.7 (+10 more)

### Community 9 - "Community 9"
Cohesion: 0.16
Nodes (11): Toast(), ToastProps, ToastVariant, ThemeContext, ThemeContextValue, ThemeProvider(), ToastContext, ToastContextValue (+3 more)

### Community 10 - "Community 10"
Cohesion: 0.26
Nodes (13): useToast(), createCooperative(), deleteCooperative(), getCooperatives(), updateCooperative(), CooperativesTableProps, useCooperatives(), Cooperative (+5 more)

### Community 11 - "Community 11"
Cohesion: 0.20
Nodes (8): @eslint/js@^9.34.0, eslint-plugin-react-hooks@^5.2.0, eslint-plugin-react-refresh@^0.4.20, typescript-eslint@^8.39.1, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh, typescript-eslint

### Community 12 - "Community 12"
Cohesion: 0.25
Nodes (7): compilerOptions, allowSyntheticDefaultImports, composite, module, moduleResolution, skipLibCheck, include

### Community 13 - "Community 13"
Cohesion: 0.47
Nodes (3): @vitejs/plugin-react@^5.0.2, vite, @vitejs/plugin-react

### Community 14 - "Community 14"
Cohesion: 0.40
Nodes (5): scripts, build, dev, lint, preview

### Community 15 - "Community 15"
Cohesion: 0.40
Nodes (4): buildCommand, headers, outputDirectory, rewrites

## Knowledge Gaps
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `react` connect `Community 3` to `Community 0`, `Community 1`, `Community 2`, `Community 4`, `Community 6`, `Community 7`, `Community 9`, `Community 10`?**
  _High betweenness centrality (0.233) - this node is a cross-community bridge._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `lucide-react` connect `Community 0` to `Community 1`, `Community 2`, `Community 3`, `Community 4`, `Community 9`?**
  _High betweenness centrality (0.154) - this node is a cross-community bridge._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.08669354838709678 - nodes in this community are weakly interconnected._
- **Why does `react-router-dom` connect `Community 2` to `Community 1`, `Community 3`, `Community 9`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.1471264367816092 - nodes in this community are weakly interconnected._
- **Should `Community 3` be split into smaller, more focused modules?**
  _Cohesion score 0.1402116402116402 - nodes in this community are weakly interconnected._