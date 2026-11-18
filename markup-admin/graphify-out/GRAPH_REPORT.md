# Graph Report - markup-admin  (2026-11-18)

## Corpus Check
- 75 files · ~10,594 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 4 file(s) not represented in the graph (top: .tsbuildinfo 2, (none) 1, .css 1)

## Summary
- 64 nodes · 118 edges · 8 communities (6 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7e59bae2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- InvestmentCalculationSettingsCard
- CooperativesStats.tsx
- CooperativeWizard.tsx
- CooperativesPage
- products.api.ts
- ProductsPage
- ProductsPage.tsx

## God Nodes (most connected - your core abstractions)
1. `ProductsPage()` - 12 edges
2. `saveProduct()` - 6 edges
3. `CooperativesPage()` - 6 edges
4. `InvestmentCalculationSettingsCard()` - 5 edges
5. `CooperativeListItem` - 5 edges
6. `CooperativeWizard()` - 4 edges
7. `updateInvestmentCalculationSetting()` - 4 edges
8. `getProducts()` - 4 edges
9. `createProduct()` - 4 edges
10. `updateProduct()` - 4 edges

## Surprising Connections (you probably didn't know these)
- `CooperativesTableProps` --references--> `CooperativeListItem`  [EXTRACTED]
  src/modules/cooperatives/components/CooperativesTable.tsx → src/modules/cooperatives/types/cooperative.ts
- `CooperativesPage()` --calls--> `CooperativesStats()`  [EXTRACTED]
  src/modules/cooperatives/pages/CooperativesPage.tsx → src/modules/cooperatives/components/CooperativesStats.tsx
- `CooperativesPage()` --calls--> `CooperativeWizard()`  [EXTRACTED]
  src/modules/cooperatives/pages/CooperativesPage.tsx → src/modules/cooperatives/components/CooperativeWizard.tsx
- `InvestmentCalculationSettingsCard()` --calls--> `getInvestmentCalculationSetting()`  [EXTRACTED]
  src/modules/products/pages/ProductsPage.tsx → src/modules/products/api/products.api.ts
- `InvestmentCalculationSettingsCard()` --calls--> `updateInvestmentCalculationSetting()`  [EXTRACTED]
  src/modules/products/pages/ProductsPage.tsx → src/modules/products/api/products.api.ts

## Import Cycles
- None detected.

## Communities (8 total, 2 thin omitted)

### Community 0 - "InvestmentCalculationSettingsCard"
Cohesion: 0.67
Nodes (4): getInvestmentCalculationSetting(), updateInvestmentCalculationSetting(), InvestmentCalculationSettingsCard(), save()

### Community 2 - "CooperativesStats.tsx"
Cohesion: 0.50
Nodes (3): Card(), CooperativesStats(), CooperativesStatsProps

### Community 3 - "CooperativeWizard.tsx"
Cohesion: 0.24
Nodes (8): CooperativesTableProps, initialForm, Cooperative, CooperativeFormData, CooperativeListItem, CooperativesPageResponse, CreateCooperativeRequest, UpdateCooperativeRequest

### Community 4 - "CooperativesPage"
Cohesion: 0.33
Nodes (3): CooperativesTable(), CooperativeWizard(), CooperativesPage()

### Community 6 - "products.api.ts"
Cohesion: 0.25
Nodes (4): FinancialProduct, FinancialProductRequest, InvestmentCalculationMethod, ProductType

### Community 7 - "ProductsPage"
Cohesion: 0.31
Nodes (9): addProductConditions(), createProduct(), getProducts(), updateProduct(), emptyCondition(), ProductsPage(), beginCreate(), loadProducts() (+1 more)

## Knowledge Gaps
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ProductsPage()` connect `ProductsPage` to `InvestmentCalculationSettingsCard`, `ProductsPage.tsx`?**
  _High betweenness centrality (0.104) - this node is a cross-community bridge._
- **Why does `CooperativesPage()` connect `CooperativesPage` to `CooperativesPage.tsx`, `CooperativesStats.tsx`?**
  _High betweenness centrality (0.065) - this node is a cross-community bridge._
- **Why does `CooperativeListItem` connect `CooperativeWizard.tsx` to `CooperativesPage.tsx`, `ProductsPage.tsx`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._