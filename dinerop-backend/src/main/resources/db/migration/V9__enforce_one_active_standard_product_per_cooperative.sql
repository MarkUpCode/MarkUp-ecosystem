-- Preserve historical product rows and snapshots, but keep duplicate products
-- out of the active catalogue. Prefer an already active entry, then the oldest.
WITH ranked_products AS (
    SELECT id,
           ROW_NUMBER() OVER (
               PARTITION BY cooperative_id, type, COALESCE(credit_category, 'NO_CREDIT_CATEGORY')
               ORDER BY active DESC, id ASC
           ) AS product_rank
    FROM financial_products
)
UPDATE financial_products product
SET active = FALSE
FROM ranked_products ranked
WHERE ranked.id = product.id
  AND ranked.product_rank > 1
  AND product.active = TRUE;

CREATE UNIQUE INDEX IF NOT EXISTS uq_active_standard_product_per_cooperative
    ON financial_products (
        cooperative_id,
        type,
        (COALESCE(credit_category, 'NO_CREDIT_CATEGORY'))
    )
    WHERE active = TRUE;
