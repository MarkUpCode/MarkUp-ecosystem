ALTER TABLE financial_products
    ADD COLUMN IF NOT EXISTS credit_category VARCHAR(30);

ALTER TABLE financial_products
    ADD CONSTRAINT ck_financial_product_credit_category
    CHECK (
        (type = 'CREDIT' AND (credit_category IS NULL OR credit_category IN ('CONSUMO', 'MICROCREDITO')))
        OR (type = 'INVESTMENT' AND credit_category IS NULL)
    );
