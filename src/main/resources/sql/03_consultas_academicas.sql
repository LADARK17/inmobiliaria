-- =====================================================================
-- PROYECTO INMOBILIARIA WEB MVC - CONSULTAS SQL OBLIGATORIAS
-- Requisito pedagógico: 5 consultas demostrables para sustentación
-- =====================================================================

USE inmobiliaria_db;

-- ---------------------------------------------------------------------
-- CONSULTA 1: INNER JOIN CON 4 TABLAS
-- Caso de uso: Listado del catálogo de propiedades con información completa
-- Tablas: propiedad + ciudad + tipo_propiedad + inmobiliaria
-- ---------------------------------------------------------------------
SELECT 
    p.id AS id_propiedad,
    p.matricula_inmobiliaria,
    p.titulo,
    p.precio,
    p.tipo_operacion,
    p.estado,
    c.nombre AS ciudad,
    c.departamento,
    tp.nombre AS tipo_inmueble,
    inm.nombre AS agencia_responsable,
    inm.telefono AS telefono_contacto,
    inm.correo AS correo_agencia
FROM propiedad p
INNER JOIN ciudad c ON p.id_ciudad = c.id
INNER JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id
INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id
WHERE p.estado != 'INACTIVA'
ORDER BY p.precio DESC;

-- ---------------------------------------------------------------------
-- CONSULTA 2: INNER JOIN CON 3 TABLAS
-- Caso de uso: Auditoría y control de usuarios con sus perfiles y roles activos
-- Tablas: usuario + perfil + usuario_rol + rol
-- ---------------------------------------------------------------------
SELECT 
    u.id AS id_usuario,
    u.correo,
    u.estado AS estado_cuenta,
    CONCAT(per.nombres, ' ', per.apellidos) AS nombre_completo,
    per.documento_identidad,
    per.telefono,
    r.nombre AS nombre_rol,
    ur.fecha_asignacion
FROM usuario u
INNER JOIN perfil per ON u.id = per.id_usuario
INNER JOIN usuario_rol ur ON u.id = ur.id_usuario
INNER JOIN rol r ON ur.id_rol = r.id
ORDER BY u.id ASC, r.nombre ASC;

-- ---------------------------------------------------------------------
-- CONSULTA 3: RELACIÓN MUCHOS A MUCHOS (N:M)
-- Caso de uso: Obtener cada propiedad con la lista concatenada de sus características
-- Tablas: propiedad + propiedad_caracteristica + caracteristica
-- ---------------------------------------------------------------------
SELECT 
    p.id AS id_propiedad,
    p.titulo,
    p.matricula_inmobiliaria,
    COUNT(pc.id_caracteristica) AS total_caracteristicas,
    GROUP_CONCAT(c.nombre ORDER BY c.nombre ASC SEPARATOR ' | ') AS listado_caracteristicas
FROM propiedad p
INNER JOIN propiedad_caracteristica pc ON p.id = pc.id_propiedad
INNER JOIN caracteristica c ON pc.id_caracteristica = c.id
GROUP BY p.id, p.titulo, p.matricula_inmobiliaria
ORDER BY total_caracteristicas DESC;

-- ---------------------------------------------------------------------
-- CONSULTA 4: LEFT JOIN
-- Caso de uso: Encontrar propiedades que NO tienen ninguna cita de visita agendada
-- Tablas: propiedad LEFT JOIN cita (filtrando por cita.id IS NULL)
-- ---------------------------------------------------------------------
SELECT 
    p.id AS id_propiedad,
    p.matricula_inmobiliaria,
    p.titulo,
    p.precio,
    p.tipo_operacion,
    p.estado,
    c.id AS id_cita,
    c.fecha_hora,
    c.estado AS estado_cita
FROM propiedad p
LEFT JOIN cita c ON p.id = c.id_propiedad
WHERE c.id IS NULL AND p.estado = 'DISPONIBLE'
ORDER BY p.id ASC;

-- ---------------------------------------------------------------------
-- CONSULTA 5: GROUP BY + HAVING (REPORTE GERENCIAL)
-- Caso de uso: Ciudades con más de 1 propiedad registrada cuyo promedio
-- de precio en venta supere los $200,000,000 COP
-- Tablas: ciudad + propiedad (con funciones de agregación COUNT, AVG, MIN, MAX)
-- ---------------------------------------------------------------------
SELECT 
    c.nombre AS ciudad,
    c.departamento,
    COUNT(p.id) AS total_inmuebles_venta,
    FORMAT(AVG(p.precio), 2) AS precio_promedio,
    FORMAT(MIN(p.precio), 2) AS precio_minimo,
    FORMAT(MAX(p.precio), 2) AS precio_maximo
FROM ciudad c
INNER JOIN propiedad p ON c.id = p.id_ciudad
WHERE p.tipo_operacion = 'VENTA' AND p.estado != 'INACTIVA'
GROUP BY c.id, c.nombre, c.departamento
HAVING COUNT(p.id) >= 2 AND AVG(p.precio) > 200000000
ORDER BY AVG(p.precio) DESC;
