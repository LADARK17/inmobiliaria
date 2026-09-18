-- =====================================================================
-- MIGRACIÓN 04: TURNO ÚNICO POR INMUEBLE — CITAS ACTIVAS (POSTGRESQL / SUPABASE)
-- Propósito:
--   1. El UNIQUE físico (id_propiedad, fecha_hora) impedía re-agendar un
--      horario después de cancelar una cita (bloqueo permanente del turno).
--   2. Se sustituye por un ÍNDICE ÚNICO PARCIAL que solo aplica a citas
--      ACTIVAS (estado <> 'CANCELADA'), de modo que dos clientes jamás
--      reserven el mismo inmueble en el mismo horario y un turno cancelado
--      quede disponible nuevamente.
-- Motor: PostgreSQL 15+ / Supabase
-- =====================================================================

-- 1. Eliminar la restricción UNIQUE física (si existe) sobre el horario.
ALTER TABLE cita DROP CONSTRAINT IF EXISTS uq_cita_propiedad_horario;

-- 2. Crear el índice único parcial de turno activo.
CREATE UNIQUE INDEX IF NOT EXISTS uq_cita_activa_propiedad_horario
    ON cita (id_propiedad, fecha_hora)
    WHERE estado <> 'CANCELADA';

-- 3. Verificación del esquema resultante.
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'cita'
ORDER BY indexname;