-- =====================================================================
-- PROYECTO INMOBILIARIA WEB MVC - BASE DE DATOS RELACIONAL
-- Motor: MySQL 8.x / MariaDB (Compatible con XAMPP y servidores en la nube)
-- Modelo Normalizado hasta 3FN (Tercera Forma Normal)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS inmobiliaria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inmobiliaria_db;

-- Desactivar temporalmente revisión de llaves foráneas para reinicio limpio
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS auditoria;
DROP TABLE IF EXISTS documento_solicitud;
DROP TABLE IF EXISTS solicitud;
DROP TABLE IF EXISTS cita;
DROP TABLE IF EXISTS favorito;
DROP TABLE IF EXISTS propiedad_caracteristica;
DROP TABLE IF EXISTS imagen_propiedad;
DROP TABLE IF EXISTS propiedad;
DROP TABLE IF EXISTS caracteristica;
DROP TABLE IF EXISTS perfil;
DROP TABLE IF EXISTS usuario_rol;
DROP TABLE IF EXISTS rol;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS inmobiliaria;
DROP TABLE IF EXISTS tipo_propiedad;
DROP TABLE IF EXISTS ciudad;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================
-- 1. TABLAS CATÁLOGO / PARÁMETROS BÁSICOS
-- =====================================================================

-- Tabla Ciudad
CREATE TABLE ciudad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    CONSTRAINT uq_ciudad_departamento UNIQUE (nombre, departamento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Tipo de Propiedad
CREATE TABLE tipo_propiedad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Características de Inmuebles
CREATE TABLE caracteristica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    icono VARCHAR(50) DEFAULT 'bi-check-circle'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Inmobiliaria (Agencias responsables)
CREATE TABLE inmobiliaria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nit VARCHAR(30) NOT NULL UNIQUE,
    telefono VARCHAR(30) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    direccion VARCHAR(200) NOT NULL,
    logo_url VARCHAR(255) DEFAULT 'assets/img/default-agency.png',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 2. TABLAS DE SEGURIDAD Y CONTROL DE ACCESO
-- =====================================================================

-- Tabla Usuario (Credenciales y estado)
-- RESTRICCIÓN OBLIGATORIA: correo UNIQUE
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO') DEFAULT 'ACTIVO',
    id_inmobiliaria INT NULL, -- Si es agente, pertenece a una inmobiliaria (1:N)
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_inmobiliaria FOREIGN KEY (id_inmobiliaria) 
        REFERENCES inmobiliaria(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Rol
CREATE TABLE rol (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RELACIÓN N:M: Usuario <-> Rol (Muchos usuarios pueden tener muchos roles)
-- LLAVE PRIMARIA COMPUESTA Y RESTRICCIÓN PARA EVITAR DUPLICADOS
CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    fecha_asignacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_rol),
    CONSTRAINT fk_usuariorol_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuariorol_rol FOREIGN KEY (id_rol) 
        REFERENCES rol(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RELACIÓN 1:1 ESTRICTA: Usuario <-> Perfil
-- RESTRICCIÓN OBLIGATORIA: id_usuario UNIQUE
CREATE TABLE perfil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    documento_identidad VARCHAR(30) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    direccion VARCHAR(200),
    foto_url VARCHAR(255) DEFAULT 'assets/img/default-avatar.png',
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 3. TABLAS DE PROPIEDADES E INMUEBLES
-- =====================================================================

-- Tabla Propiedad
-- RESTRICCIÓN OBLIGATORIA: matricula_inmobiliaria UNIQUE
-- Baja lógica implementada a través del campo estado ('INACTIVA')
CREATE TABLE propiedad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_inmobiliaria INT NOT NULL,
    id_ciudad INT NOT NULL,
    id_tipo_propiedad INT NOT NULL,
    matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    precio DECIMAL(14,2) NOT NULL,
    area_m2 DECIMAL(8,2) DEFAULT 0.00,
    habitaciones INT DEFAULT 0,
    banos INT DEFAULT 0,
    estrato INT DEFAULT 3,
    direccion VARCHAR(200) NOT NULL,
    destacada BOOLEAN DEFAULT FALSE,
    tipo_operacion ENUM('VENTA', 'ARRIENDO') NOT NULL,
    estado ENUM('DISPONIBLE', 'RESERVADA', 'VENDIDA', 'ARRENDADA', 'INACTIVA') DEFAULT 'DISPONIBLE',
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_propiedad_inmobiliaria FOREIGN KEY (id_inmobiliaria) 
        REFERENCES inmobiliaria(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_ciudad FOREIGN KEY (id_ciudad) 
        REFERENCES ciudad(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_tipo FOREIGN KEY (id_tipo_propiedad) 
        REFERENCES tipo_propiedad(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RELACIÓN 1:N: Propiedad -> Imagen_Propiedad (Galería)
CREATE TABLE imagen_propiedad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    orden INT DEFAULT 1,
    es_principal BOOLEAN DEFAULT FALSE,
    descripcion VARCHAR(150),
    CONSTRAINT fk_imagen_propiedad FOREIGN KEY (id_propiedad) 
        REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RELACIÓN N:M: Propiedad <-> Característica
CREATE TABLE propiedad_caracteristica (
    id_propiedad INT NOT NULL,
    id_caracteristica INT NOT NULL,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    CONSTRAINT fk_propcarac_propiedad FOREIGN KEY (id_propiedad) 
        REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_propcarac_caracteristica FOREIGN KEY (id_caracteristica) 
        REFERENCES caracteristica(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 4. TABLAS DE OPERACIÓN: FAVORITOS, CITAS Y TRÁMITES
-- =====================================================================

-- Tabla Favoritos (Clientes guardan inmuebles)
-- RESTRICCIÓN: UNIQUE(id_usuario, id_propiedad) para evitar duplicados
CREATE TABLE favorito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_propiedad INT NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_favorito_usuario_propiedad UNIQUE (id_usuario, id_propiedad),
    CONSTRAINT fk_favorito_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favorito_propiedad FOREIGN KEY (id_propiedad) 
        REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Citas (Agendamiento de visitas)
-- TURNO ÚNICO POR INMUEBLE: UNIQUE(id_propiedad, slot_turno) impide doble reserva
-- del mismo horario. La columna generada slot_turno es NULL cuando la cita se cancela
-- (las filas NULL no colisionan en UNIQUE), por lo que un horario cancelado queda liberado.
CREATE TABLE cita (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_propiedad INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('PENDIENTE', 'CONFIRMADA', 'REALIZADA', 'CANCELADA') DEFAULT 'PENDIENTE',
    slot_turno DATETIME GENERATED ALWAYS AS (IF(estado = 'CANCELADA', NULL, fecha_hora)) STORED,
    comentarios VARCHAR(255),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_cita_slot_turno UNIQUE (id_propiedad, slot_turno),
    CONSTRAINT fk_cita_cliente FOREIGN KEY (id_cliente) 
        REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cita_propiedad FOREIGN KEY (id_propiedad) 
        REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla Solicitudes (Trámite formal de compra o arriendo)
CREATE TABLE solicitud (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_propiedad INT NOT NULL,
    tipo_operacion ENUM('COMPRA', 'ARRIENDO') NOT NULL,
    estado ENUM('PENDIENTE', 'EN_REVISION', 'APROBADA', 'RECHAZADA') DEFAULT 'PENDIENTE',
    observaciones TEXT,
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente) 
        REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_propiedad FOREIGN KEY (id_propiedad) 
        REFERENCES propiedad(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RELACIÓN 1:N: Solicitud -> Documentos radicados
CREATE TABLE documento_solicitud (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    nombre_archivo VARCHAR(150) NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    tipo_documento VARCHAR(80) NOT NULL, -- Ej: Cédula, Carta Laboral, Extractos
    estado ENUM('SUBIDO', 'APROBADO', 'RECHAZADO') DEFAULT 'SUBIDO',
    fecha_subida DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_doc_solicitud FOREIGN KEY (id_solicitud) 
        REFERENCES solicitud(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- 5. TABLA DE AUDITORÍA
-- =====================================================================

CREATE TABLE auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL,
    accion VARCHAR(80) NOT NULL, -- Ej: LOGIN, CREAR_PROPIEDAD, MODIFICAR_ESTADO
    entidad_afectada VARCHAR(80) NOT NULL,
    id_entidad INT NULL,
    detalles TEXT,
    ip_origen VARCHAR(50),
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
-- ÍNDICES PARA OPTIMIZACIÓN DE BÚSQUEDAS Y REPORTES
-- =====================================================================
CREATE INDEX idx_propiedad_busqueda ON propiedad (id_ciudad, id_tipo_propiedad, estado, precio);
CREATE INDEX idx_cita_fecha ON cita (fecha_hora, estado);
CREATE INDEX idx_solicitud_estado ON solicitud (estado);
