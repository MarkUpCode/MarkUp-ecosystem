-- Credit events are associated with a credit request (solicitud_id).
-- Some deployments also have this legacy column with NOT NULL, which makes
-- inserts from the application fail because not every event belongs to one
-- cooperative. Keep the column for compatibility, but allow it to be NULL.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'solicitud_cooperativa_evento'
          AND column_name = 'solicitud_cooperativa_id'
    ) THEN
        ALTER TABLE public.solicitud_cooperativa_evento
            ALTER COLUMN solicitud_cooperativa_id DROP NOT NULL;
    END IF;
END $$;
