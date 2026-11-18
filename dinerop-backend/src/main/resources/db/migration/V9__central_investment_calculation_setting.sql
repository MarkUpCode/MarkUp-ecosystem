CREATE TABLE IF NOT EXISTS investment_calculation_settings (
    id BIGINT PRIMARY KEY CHECK (id = 1),
    calculation_method VARCHAR(30) NOT NULL DEFAULT 'UNSPECIFIED',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO investment_calculation_settings (id, calculation_method)
VALUES (1, 'UNSPECIFIED')
ON CONFLICT (id) DO NOTHING;
