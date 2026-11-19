ALTER TABLE users ADD COLUMN IF NOT EXISTS first_name VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_name VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(30);

CREATE TABLE IF NOT EXISTS cooperative_invitations (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id_user),
    token_hash CHAR(64) NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    used BOOLEAN NOT NULL DEFAULT FALSE,
    revoked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_coop_invitation_user ON cooperative_invitations(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS financial_products (
    id BIGSERIAL PRIMARY KEY,
    cooperative_id BIGINT NOT NULL REFERENCES cooperativa(id_cooperativa),
    type VARCHAR(20) NOT NULL CHECK (type IN ('CREDIT', 'INVESTMENT')),
    name VARCHAR(120) NOT NULL,
    description VARCHAR(2000),
    minimum_amount NUMERIC(20,2) NOT NULL CHECK (minimum_amount > 0),
    maximum_amount NUMERIC(20,2) NOT NULL CHECK (maximum_amount >= minimum_amount),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_financial_product_coop ON financial_products(cooperative_id, type, active);

CREATE TABLE IF NOT EXISTS financial_product_conditions (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES financial_products(id),
    minimum_amount NUMERIC(20,2) NOT NULL CHECK (minimum_amount > 0),
    maximum_amount NUMERIC(20,2) NOT NULL CHECK (maximum_amount >= minimum_amount),
    minimum_term_months INTEGER NOT NULL CHECK (minimum_term_months > 0),
    maximum_term_months INTEGER NOT NULL CHECK (maximum_term_months >= minimum_term_months),
    annual_rate NUMERIC(7,4) NOT NULL CHECK (annual_rate > 0 AND annual_rate <= 100),
    valid_from TIMESTAMPTZ NOT NULL,
    valid_until TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (valid_until IS NULL OR valid_until > valid_from)
);
CREATE INDEX IF NOT EXISTS idx_product_condition_validity ON financial_product_conditions(product_id, valid_from, valid_until);
