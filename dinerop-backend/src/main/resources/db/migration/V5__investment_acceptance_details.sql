CREATE TABLE IF NOT EXISTS investment_acceptance_responses (
    id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL UNIQUE REFERENCES investment_requests(id) ON DELETE CASCADE,
    cooperative_id BIGINT NOT NULL REFERENCES cooperativa(id_cooperativa),
    actor_user_id BIGINT NOT NULL REFERENCES users(id_user),
    acceptance_message VARCHAR(2000) NOT NULL,
    confirmed_annual_rate NUMERIC(7,4) CHECK (confirmed_annual_rate > 0 AND confirmed_annual_rate <= 100),
    agency_name VARCHAR(160) NOT NULL,
    agency_address VARCHAR(300) NOT NULL,
    agency_city VARCHAR(120) NOT NULL,
    maps_url VARCHAR(1000),
    contact_phone VARCHAR(40),
    opening_hours VARCHAR(300),
    contact_department VARCHAR(160),
    response_deadline DATE,
    instructions VARCHAR(2000),
    responded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS investment_acceptance_requirements (
    acceptance_id BIGINT NOT NULL REFERENCES investment_acceptance_responses(id) ON DELETE CASCADE,
    display_order INTEGER NOT NULL,
    description VARCHAR(250) NOT NULL,
    mandatory BOOLEAN NOT NULL,
    PRIMARY KEY (acceptance_id, display_order)
);
