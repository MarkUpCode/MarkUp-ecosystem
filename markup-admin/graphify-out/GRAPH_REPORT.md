# Graph Report - markup-admin  (2026-11-17)

## Corpus Check
- 75 files · ~10,979 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 4 file(s) not represented in the graph (top: .tsbuildinfo 2, (none) 1, .css 1)

## Summary
- 41 nodes · 69 edges · 5 communities (4 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `332b3abb`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- createProduct
- CooperativeWizard.tsx
- products.api.ts
- ProductsPage

## God Nodes (most connected - your core abstractions)
1. `ProductsPage()` - 11 edges
2. `createProduct()` - 7 edges
3. `saveProduct()` - 6 edges
4. `CooperativeWizard()` - 5 edges
5. `getProducts()` - 4 edges
6. `updateProduct()` - 4 edges
7. `addProductConditions()` - 4 edges
8. `emptyCondition()` - 4 edges
9. `ProductType` - 3 edges
10. `ProductCondition` - 3 edges

## Surprising Connections (you probably didn't know these)
- `submit()` --calls--> `createProduct()`  [EXTRACTED]
  src/modules/cooperatives/components/CooperativeWizard.tsx → src/modules/products/api/products.api.ts
- `ProductsPage()` --calls--> `createProduct()`  [EXTRACTED]
  src/modules/products/pages/ProductsPage.tsx → src/modules/products/api/products.api.ts
- `saveProduct()` --calls--> `createProduct()`  [EXTRACTED]
  src/modules/products/pages/ProductsPage.tsx → src/modules/products/api/products.api.ts
- `CooperativeWizard()` --calls--> `createProduct()`  [EXTRACTED]
  src/modules/cooperatives/components/CooperativeWizard.tsx → src/modules/products/api/products.api.ts
- `ProductsPage()` --calls--> `getProducts()`  [EXTRACTED]
  src/modules/products/pages/ProductsPage.tsx → src/modules/products/api/products.api.ts

## Import Cycles
- None detected.

## Communities (5 total, 1 thin omitted)

### Community 0 - "createProduct"
Cohesion: 0.50
Nodes (4): CooperativeWizard(), submit(), draftProduct(), createProduct()

### Community 3 - "CooperativeWizard.tsx"
Cohesion: 0.29
Nodes (3): ProductDraft, FinancialProductRequest, ProductType

### Community 6 - "products.api.ts"
Cohesion: 0.29
Nodes (3): CreditProductCategory, FinancialProduct, ProductCondition

### Community 7 - "ProductsPage"
Cohesion: 0.33
Nodes (8): addProductConditions(), getProducts(), updateProduct(), emptyCondition(), ProductsPage(), beginCreate(), loadProducts(), saveProduct()

## Knowledge Gaps
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `createProduct()` connect `createProduct` to `ProductsPage.tsx`, `CooperativeWizard.tsx`, `products.api.ts`, `ProductsPage`?**
  _High betweenness centrality (0.162) - this node is a cross-community bridge._
- **Why does `ProductsPage()` connect `ProductsPage` to `createProduct`, `ProductsPage.tsx`?**
  _High betweenness centrality (0.162) - this node is a cross-community bridge._
- **Why does `CooperativeWizard()` connect `createProduct` to `CooperativeWizard.tsx`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._