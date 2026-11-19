-- Additive migration. Existing onboarding and credit history is retained.
CREATE TABLE IF NOT EXISTS guarantor_profile (
    id BIGSERIAL PRIMARY KEY,
    client_user_id BIGINT NOT NULL REFERENCES users(id_user),
    persona_id BIGINT NOT NULL REFERENCES persona_onboarding(id),
    cedula VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT uk_guarantor_profile_person UNIQUE (persona_id),
    CONSTRAINT uk_guarantor_profile_owner_cedula UNIQUE (client_user_id, cedula)
);

CREATE INDEX IF NOT EXISTS idx_guarantor_profile_owner
    ON guarantor_profile(client_user_id, updated_at DESC);

-- Existing GARANTE people become reusable profile choices. This does not link
-- old decisions to credits because the legacy event table has no person FK.
INSERT INTO guarantor_profile(client_user_id, persona_id, cedula, created_at, updated_at)
SELECT so.usuario_id, p.id, p.cedula,
       COALESCE(p.fecha_registro, CURRENT_TIMESTAMP),
       COALESCE(p.fecha_registro, CURRENT_TIMESTAMP)
FROM persona_onboarding p
JOIN solicitud_onboarding so ON so.id = p.solicitud_id
WHERE p.rol = 'GARANTE'
  AND so.usuario_id IS NOT NULL
  AND NULLIF(TRIM(p.cedula), '') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM persona_onboarding newer
      JOIN solicitud_onboarding newer_onboarding ON newer_onboarding.id = newer.solicitud_id
      WHERE newer_onboarding.usuario_id = so.usuario_id
        AND newer.rol = 'GARANTE'
        AND newer.cedula = p.cedula
        AND newer.id > p.id
  )
  AND NOT EXISTS (
      SELECT 1 FROM guarantor_profile existing
      WHERE existing.client_user_id = so.usuario_id
        AND existing.cedula = p.cedula
  );

CREATE TABLE IF NOT EXISTS credit_guarantor_submission (
    id BIGSERIAL PRIMARY KEY,
    profile_id BIGINT NOT NULL REFERENCES guarantor_profile(id),
    credit_request_id BIGINT NOT NULL REFERENCES solicitud_credito(id),
    solicitud_cooperativa_id BIGINT NOT NULL REFERENCES solicitud_cooperativa(id),
    attempt_number INTEGER NOT NULL CHECK (attempt_number > 0),
    snapshot_json TEXT NOT NULL,
    status VARCHAR(40) NOT NULL,
    submitted_by BIGINT NOT NULL REFERENCES users(id_user),
    submitted_at TIMESTAMP NOT NULL,
    CONSTRAINT uk_credit_guarantor_attempt UNIQUE (solicitud_cooperativa_id, attempt_number)
);

CREATE INDEX IF NOT EXISTS idx_credit_guarantor_credit ON credit_guarantor_submission(credit_request_id);
CREATE INDEX IF NOT EXISTS idx_credit_guarantor_profile ON credit_guarantor_submission(profile_id);
CREATE INDEX IF NOT EXISTS idx_credit_guarantor_latest ON credit_guarantor_submission(solicitud_cooperativa_id, attempt_number DESC);

CREATE TABLE IF NOT EXISTS credit_guarantor_evaluation (
    id BIGSERIAL PRIMARY KEY,
    submission_id BIGINT NOT NULL REFERENCES credit_guarantor_submission(id),
    decision VARCHAR(40) NOT NULL,
    reasons_json TEXT,
    other_reason TEXT,
    observation TEXT,
    actor_id BIGINT NOT NULL REFERENCES users(id_user),
    actor_role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_guarantor_eval_submission
    ON credit_guarantor_evaluation(submission_id, created_at, id);

ALTER TABLE solicitud_cooperativa_evento
    ADD COLUMN IF NOT EXISTS actor_id BIGINT NULL REFERENCES users(id_user);
ALTER TABLE solicitud_cooperativa_evento
    ADD COLUMN IF NOT EXISTS actor_role VARCHAR(20) NULL;
