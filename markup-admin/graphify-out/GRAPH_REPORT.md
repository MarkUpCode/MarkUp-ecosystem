# Graph Report - markup-admin  (2026-11-17)

## Corpus Check
- 75 files · ~11,016 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 4 file(s) not represented in the graph (top: .tsbuildinfo 2, (none) 1, .css 1)

## Summary
- 61 nodes · 116 edges · 9 communities (5 shown, 4 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `290c26aa`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- createProduct
- CooperativesStats.tsx
- CooperativeWizard.tsx
- CooperativesPage
- CooperativesTable.tsx
- products.api.ts
- ProductsPage

## God Nodes (most connected - your core abstractions)
1. `ProductsPage()` - 11 edges
2. `CooperativeWizard()` - 7 edges
3. `createProduct()` - 7 edges
4. `CooperativesPage()` - 6 edges
5. `saveProduct()` - 6 edges
6. `CooperativeListItem` - 5 edges
7. `CooperativesStats()` - 4 edges
8. `CreateCooperativeRequest` - 4 edges
9. `addProductConditions()` - 4 edges
10. `getProducts()` - 4 edges

## Surprising Connections (you probably didn't know these)
- `CooperativesPage()` --calls--> `CooperativesStats()`  [EXTRACTED]
  src/modules/cooperatives/pages/CooperativesPage.tsx → src/modules/cooperatives/components/CooperativesStats.tsx
- `CooperativesTableProps` --references--> `CooperativeListItem`  [EXTRACTED]
  src/modules/cooperatives/components/CooperativesTable.tsx → src/modules/cooperatives/types/cooperative.ts
- `CooperativesPage()` --calls--> `CooperativeWizard()`  [EXTRACTED]
  src/modules/cooperatives/pages/CooperativesPage.tsx → src/modules/cooperatives/components/CooperativeWizard.tsx
- `submit()` --calls--> `createProduct()`  [EXTRACTED]
  src/modules/cooperatives/components/CooperativeWizard.tsx → src/modules/products/api/products.api.ts
- `ProductsPage()` --calls--> `createProduct()`  [EXTRACTED]
  src/modules/products/pages/ProductsPage.tsx → src/modules/products/api/products.api.ts

## Import Cycles
- None detected.

## Communities (9 total, 4 thin omitted)

### Community 0 - "createProduct"
Cohesion: 0.50
Nodes (4): CooperativeWizard(), submit(), draftProduct(), createProduct()

### Community 2 - "CooperativesStats.tsx"
Cohesion: 0.50
Nodes (3): Card(), CooperativesStats(), CooperativesStatsProps

### Community 3 - "CooperativeWizard.tsx"
Cohesion: 0.31
Nodes (6): ProductDraft, Cooperative, CooperativeFormData, CooperativesPageResponse, CreateCooperativeRequest, UpdateCooperativeRequest

### Community 6 - "products.api.ts"
Cohesion: 0.22
Nodes (5): CreditProductCategory, FinancialProduct, FinancialProductRequest, ProductCondition, ProductType

### Community 7 - "ProductsPage"
Cohesion: 0.33
Nodes (8): addProductConditions(), getProducts(), updateProduct(), emptyCondition(), ProductsPage(), beginCreate(), loadProducts(), saveProduct()

## Knowledge Gaps
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ProductsPage()` connect `ProductsPage` to `createProduct`, `ProductsPage.tsx`?**
  _High betweenness centrality (0.107) - this node is a cross-community bridge._
- **Why does `CooperativeWizard()` connect `createProduct` to `CooperativesPage.tsx`, `CooperativeWizard.tsx`, `CooperativesPage`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Why does `createProduct()` connect `createProduct` to `ProductsPage.tsx`, `CooperativeWizard.tsx`, `products.api.ts`, `ProductsPage`?**
  _High betweenness centrality (0.082) - this node is a cross-community bridge._