-- =====================================================================
-- MIGRACIÓN 04: TURNO ÚNICO POR INMUEBLE — CITAS ACTIVAS (MYSQL / MARIADB)
-- Propósito:
--   1. Quitar la UNIQUE física (id_propiedad, fecha_hora) que bloqueaba un
--      horario incluso después de cancelar la cita.
--   2. Agregar la columna generada slot_turno: es NULL cuando la cita está
--      CANCELADA. Como las filas NULL nunca colisionan en un índice UNIQUE,
--      un horario cancelado queda liberado y puede volver a reservarse.
--   3. Aplicar UNIQUE(id_propiedad, slot_turno) como barrera de integridad:
--      dos clientes nunca reservan el mismo inmueble en el mismo horario.
-- Motor: MySQL 8.x / MariaDB
-- =====================================================================

-- 1. Eliminar la restricción UNIQUE física sobre (id_propiedad, fecha_hora).
ALTER TABLE cita DROP INDEX uq_cita_propiedad_horario;

-- 2. Columna generada STORED: NULL si la cita está CANCELADA, si no = fecha_hora.
ALTER TABLE cita
    ADD COLUMN slot_turno DATETIME GENERATED ALWAYS AS (IF(estado = 'CANCELADA', NULL, fecha_hora)) STORED;

-- 3. Nueva UNIQUE sobre (id_propiedad, slot_turno).
ALTER TABLE cita ADD UNIQUE KEY uq_cita_slot_turno (id_propiedad, slot_turno);

-- 4. Verificación del esquema resultante.
SHOW CREATE TABLE cita;