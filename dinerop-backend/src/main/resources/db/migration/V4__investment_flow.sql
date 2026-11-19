ALTER TABLE financial_products
    ADD COLUMN IF NOT EXISTS calculation_method VARCHAR(30) NOT NULL DEFAULT 'UNSPECIFIED',
    ADD COLUMN IF NOT EXISTS renewal_conditions VARCHAR(2000),
    ADD COLUMN IF NOT EXISTS early_cancellation_conditions VARCHAR(2000),
    ADD COLUMN IF NOT EXISTS target_audience VARCHAR(500);

CREATE TABLE IF NOT EXISTS financial_product_interest_options (
    product_id BIGINT NOT NULL REFERENCES financial_products(id) ON DELETE CASCADE,
    payment_option VARCHAR(20) NOT NULL CHECK (payment_option IN ('MONTHLY', 'AT_MATURITY', 'REINVEST')),
    PRIMARY KEY (product_id, payment_option)
);

CREATE TABLE IF NOT EXISTS investment_requests (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES users(id_user),
    cooperative_id BIGINT NOT NULL REFERENCES cooperativa(id_cooperativa),
    product_id BIGINT NOT NULL REFERENCES financial_products(id),
    condition_id BIGINT NOT NULL REFERENCES financial_product_conditions(id),
    product_name_snapshot VARCHAR(120) NOT NULL,
    product_description_snapshot VARCHAR(2000),
    renewal_conditions_snapshot VARCHAR(2000),
    early_cancellation_snapshot VARCHAR(2000),
    target_audience_snapshot VARCHAR(500),
    client_name_snapshot VARCHAR(200) NOT NULL,
    client_email_snapshot VARCHAR(150) NOT NULL,
    client_phone_snapshot VARCHAR(30),
    amount NUMERIC(20,2) NOT NULL CHECK (amount > 0),
    term_months INTEGER NOT NULL CHECK (term_months > 0),
    interest_payment_option VARCHAR(20) CHECK (interest_payment_option IN ('MONTHLY', 'AT_MATURITY', 'REINVEST')),
    annual_rate_snapshot NUMERIC(7,4) NOT NULL CHECK (annual_rate_snapshot > 0 AND annual_rate_snapshot <= 100),
    condition_minimum_amount_snapshot NUMERIC(20,2) NOT NULL,
    condition_maximum_amount_snapshot NUMERIC(20,2) NOT NULL,
    condition_minimum_term_snapshot INTEGER NOT NULL,
    condition_maximum_term_snapshot INTEGER NOT NULL,
    rate_valid_from_snapshot TIMESTAMPTZ NOT NULL,
    rate_valid_until_snapshot TIMESTAMPTZ,
    calculation_method_snapshot VARCHAR(30) NOT NULL,
    estimated_interest NUMERIC(20,2),
    estimated_total NUMERIC(20,2),
    personal_data_consent BOOLEAN NOT NULL CHECK (personal_data_consent = TRUE),
    consented_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(30) NOT NULL CHECK (status IN ('SUBMITTED', 'IN_REVIEW', 'INFORMATION_REQUIRED', 'CONDITIONS_CONFIRMED', 'DECLINED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_investment_request_client ON investment_requests(client_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_investment_request_cooperative ON investment_requests(cooperative_id, status, created_at DESC);

CREATE TABLE IF NOT EXISTS investment_request_status_events (
    id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL REFERENCES investment_requests(id) ON DELETE CASCADE,
    status VARCHAR(30) NOT NULL CHECK (status IN ('SUBMITTED', 'IN_REVIEW', 'INFORMATION_REQUIRED', 'CONDITIONS_CONFIRMED', 'DECLINED')),
    note VARCHAR(1000),
    changed_by BIGINT NOT NULL REFERENCES users(id_user),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_investment_request_events ON investment_request_status_events(request_id, created_at, id);
