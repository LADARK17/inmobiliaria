-- =====================================================================
-- PROYECTO INMOBILIARIA WEB MVC - BASE DE DATOS SUPABASE (POSTGRESQL 15+)
-- Compatible con PostgreSQL y pooler de Supabase
-- Modelo Normalizado hasta 3FN (Tercera Forma Normal)
-- =====================================================================

-- Desactivar temporalmente restricciones para reinicio limpio
DROP TABLE IF EXISTS auditoria CASCADE;
DROP TABLE IF EXISTS documento_solicitud CASCADE;
DROP TABLE IF EXISTS solicitud CASCADE;
DROP TABLE IF EXISTS cita CASCADE;
DROP TABLE IF EXISTS favorito CASCADE;
DROP TABLE IF EXISTS propiedad_caracteristica CASCADE;
DROP TABLE IF EXISTS imagen_propiedad CASCADE;
DROP TABLE IF EXISTS propiedad CASCADE;
DROP TABLE IF EXISTS caracteristica CASCADE;
DROP TABLE IF EXISTS perfil CASCADE;
DROP TABLE IF EXISTS usuario_rol CASCADE;
DROP TABLE IF EXISTS rol CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS inmobiliaria CASCADE;
DROP TABLE IF EXISTS tipo_propiedad CASCADE;
DROP TABLE IF EXISTS ciudad CASCADE;

-- =====================================================================
-- 1. TABLAS CATÁLOGO / PARÁMETROS BÁSICOS
-- =====================================================================

CREATE TABLE ciudad (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    CONSTRAINT uq_ciudad_departamento UNIQUE (nombre, departamento)
);

CREATE TABLE tipo_propiedad (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

CREATE TABLE caracteristica (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    icono VARCHAR(50) DEFAULT 'bi-check-circle'
);

CREATE TABLE inmobiliaria (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nit VARCHAR(30) NOT NULL UNIQUE,
    telefono VARCHAR(30) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    direccion VARCHAR(200) NOT NULL,
    logo_url VARCHAR(255) DEFAULT 'assets/img/default-agency.png',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================================
-- 2. TABLAS DE SEGURIDAD Y CONTROL DE ACCESO
-- =====================================================================

CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    correo VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO', 'INACTIVO', 'BLOQUEADO')),
    id_inmobiliaria INT NULL REFERENCES inmobiliaria(id) ON DELETE SET NULL ON UPDATE CASCADE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rol (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

-- RELACIÓN N:M: Usuario <-> Rol
CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    id_rol INT NOT NULL REFERENCES rol(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_rol)
);

-- RELACIÓN 1:1: Usuario <-> Perfil
CREATE TABLE perfil (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    documento_identidad VARCHAR(30) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    direccion VARCHAR(200),
    foto_url VARCHAR(255) DEFAULT 'assets/img/default-avatar.png'
);

-- =====================================================================
-- 3. TABLAS DE PROPIEDADES E INMUEBLES
-- =====================================================================

CREATE TABLE propiedad (
    id SERIAL PRIMARY KEY,
    id_inmobiliaria INT NOT NULL REFERENCES inmobiliaria(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    id_ciudad INT NOT NULL REFERENCES ciudad(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    id_tipo_propiedad INT NOT NULL REFERENCES tipo_propiedad(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    precio NUMERIC(14,2) NOT NULL,
    area_m2 NUMERIC(8,2) DEFAULT 0.00,
    habitaciones INT DEFAULT 0,
    banos INT DEFAULT 0,
    estrato INT DEFAULT 3,
    direccion VARCHAR(200) NOT NULL,
    destacada BOOLEAN DEFAULT FALSE,
    tipo_operacion VARCHAR(20) NOT NULL CHECK (tipo_operacion IN ('VENTA', 'ARRIENDO')),
    estado VARCHAR(20) DEFAULT 'DISPONIBLE' CHECK (estado IN ('DISPONIBLE', 'RESERVADA', 'VENDIDA', 'ARRENDADA', 'INACTIVA')),
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RELACIÓN 1:N: Propiedad -> Imagen_Propiedad
CREATE TABLE imagen_propiedad (
    id SERIAL PRIMARY KEY,
    id_propiedad INT NOT NULL REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE,
    url_imagen VARCHAR(255) NOT NULL,
    orden INT DEFAULT 1,
    es_principal BOOLEAN DEFAULT FALSE,
    descripcion VARCHAR(150)
);

-- RELACIÓN N:M: Propiedad <-> Característica
CREATE TABLE propiedad_caracteristica (
    id_propiedad INT NOT NULL REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE,
    id_caracteristica INT NOT NULL REFERENCES caracteristica(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_propiedad, id_caracteristica)
);

-- =====================================================================
-- 4. TABLAS DE OPERACIÓN: FAVORITOS, CITAS Y TRÁMITES
-- =====================================================================

CREATE TABLE favorito (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    id_propiedad INT NOT NULL REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_favorito_usuario_propiedad UNIQUE (id_usuario, id_propiedad)
);

CREATE TABLE cita (
    id SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    id_propiedad INT NOT NULL REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE,
    fecha_hora TIMESTAMP NOT NULL,
    estado VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'CONFIRMADA', 'REALIZADA', 'CANCELADA')),
    comentarios VARCHAR(255),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Turno único por inmueble SOLO para citas activas (estado <> 'CANCELADA'):
-- garantiza que dos clientes no agenden el mismo inmueble en el mismo horario a nivel BD,
-- pero permite re-reservar un horario cuya cita fue cancelada.
CREATE UNIQUE INDEX uq_cita_activa_propiedad_horario ON cita (id_propiedad, fecha_hora) WHERE estado <> 'CANCELADA';

CREATE TABLE solicitud (
    id SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    id_propiedad INT NOT NULL REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE,
    tipo_operacion VARCHAR(20) NOT NULL CHECK (tipo_operacion IN ('COMPRA', 'ARRIENDO')),
    estado VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'EN_REVISION', 'APROBADA', 'RECHAZADA')),
    observaciones TEXT,
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RELACIÓN 1:N: Solicitud -> Documentos radicados
CREATE TABLE documento_solicitud (
    id SERIAL PRIMARY KEY,
    id_solicitud INT NOT NULL REFERENCES solicitud(id) ON DELETE CASCADE ON UPDATE CASCADE,
    nombre_archivo VARCHAR(150) NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    tipo_documento VARCHAR(80) NOT NULL,
    estado VARCHAR(20) DEFAULT 'SUBIDO' CHECK (estado IN ('SUBIDO', 'APROBADO', 'RECHAZADO')),
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================================
-- 5. TABLA DE AUDITORÍA
-- =====================================================================

CREATE TABLE auditoria (
    id SERIAL PRIMARY KEY,
    id_usuario INT NULL REFERENCES usuario(id) ON DELETE SET NULL ON UPDATE CASCADE,
    accion VARCHAR(80) NOT NULL,
    entidad_afectada VARCHAR(80) NOT NULL,
    id_entidad INT NULL,
    detalles TEXT,
    ip_origen VARCHAR(50),
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices de búsqueda
CREATE INDEX idx_propiedad_busqueda ON propiedad (id_ciudad, id_tipo_propiedad, estado, precio);
CREATE INDEX idx_cita_fecha ON cita (fecha_hora, estado);
CREATE INDEX idx_solicitud_estado ON solicitud (estado);
