# Diccionario de Datos: Sistema Web Inmobiliario MVC

**Motor:** MySQL 8.x / MariaDB  
**Normalización:** Tercera Forma Normal (3FN)  
**Total Entidades:** 16

---

## 1. Catálogos y Parámetros

### 1.1. Tabla: `ciudad`
Almacena las ciudades y departamentos donde la inmobiliaria tiene cobertura de inmuebles.
- `id` (INT, PK, AUTO_INCREMENT): Identificador único de la ciudad.
- `nombre` (VARCHAR(100), NOT NULL): Nombre oficial de la ciudad (Ej: Bucaramanga).
- `departamento` (VARCHAR(100), NOT NULL): Departamento correspondiente (Ej: Santander).
- **Restricción:** `UNIQUE(nombre, departamento)` para evitar duplicidad geográfica.

### 1.2. Tabla: `tipo_propiedad`
Clasificación tipológica de los inmuebles ofrecidos.
- `id` (INT, PK, AUTO_INCREMENT): Identificador único.
- `nombre` (VARCHAR(50), NOT NULL, UNIQUE): Casa, Apartamento, Penthouse, Local, Oficina, etc.
- `descripcion` (VARCHAR(255), NULL): Resumen del destino arquitectónico.

### 1.3. Tabla: `caracteristica`
Catálogo de amenidades y comodidades aplicables a los inmuebles.
- `id` (INT, PK, AUTO_INCREMENT): Identificador único.
- `nombre` (VARCHAR(80), NOT NULL, UNIQUE): Piscina, Gimnasio, Ascensor, BBQ, etc.
- `icono` (VARCHAR(50), DEFAULT 'bi-check-circle'): Clase de icono de Bootstrap Icons.

### 1.4. Tabla: `inmobiliaria`
Agencias inmobiliarias y firmas aliadas que administran propiedades.
- `id` (INT, PK, AUTO_INCREMENT): Identificador único.
- `nombre` (VARCHAR(150), NOT NULL): Razón social de la inmobiliaria.
- `nit` (VARCHAR(30), NOT NULL, UNIQUE): Número de Identificación Tributaria con dígito de verificación.
- `telefono` (VARCHAR(30), NOT NULL): Línea PBX de atención.
- `correo` (VARCHAR(120), NOT NULL, UNIQUE): Correo corporativo.
- `direccion` (VARCHAR(200), NOT NULL): Sede principal.
- `logo_url` (VARCHAR(255)): Ruta o enlace al imagotipo.
- `fecha_registro` (DATETIME, DEFAULT CURRENT_TIMESTAMP): Fecha de afiliación.

---

## 2. Seguridad y Perfiles

### 2.1. Tabla: `usuario`
Credenciales y estado de autenticación de todos los actores del sistema.
- `id` (INT, PK, AUTO_INCREMENT): Identificador interno del usuario.
- `correo` (VARCHAR(120), NOT NULL, **UNIQUE**): Credencial principal. Impide cuentas duplicadas a nivel de motor.
- `password_hash` (VARCHAR(255), NOT NULL): Hash criptográfico generado mediante algoritmo BCrypt.
- `estado` (ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO'), DEFAULT 'ACTIVO'): Control de acceso al login.
- `id_inmobiliaria` (INT, NULL, FK `inmobiliaria(id)`): Para agentes, indica la agencia a la cual están adscritos.
- `fecha_registro` (DATETIME, DEFAULT CURRENT_TIMESTAMP).

### 2.2. Tabla: `rol`
Perfiles del sistema con sus respectivos niveles de autorización.
- `id` (INT, PK, AUTO_INCREMENT): Identificador del rol.
- `nombre` (VARCHAR(50), NOT NULL, UNIQUE): VISITANTE, CLIENTE, AGENTE, ADMINISTRADOR.
- `descripcion` (VARCHAR(255), NULL): Alcance y privilegios.

### 2.3. Tabla: `usuario_rol` (Relación N:M)
Resuelve la relación muchos a muchos entre usuarios y roles.
- `id_usuario` (INT, NOT NULL, FK `usuario(id)` ON DELETE CASCADE).
- `id_rol` (INT, NOT NULL, FK `rol(id)` ON DELETE RESTRICT).
- `fecha_asignacion` (DATETIME, DEFAULT CURRENT_TIMESTAMP).
- **Llave Primaria:** `PRIMARY KEY (id_usuario, id_rol)`. Evita asignar dos veces el mismo rol.

### 2.4. Tabla: `perfil` (Relación 1:1 Estricta)
Almacena datos personales y de contacto del usuario.
- `id` (INT, PK, AUTO_INCREMENT): Identificador del perfil.
- `id_usuario` (INT, NOT NULL, **UNIQUE**, FK `usuario(id)` ON DELETE CASCADE): Garantiza que ningún usuario tenga más de un perfil.
- `nombres` (VARCHAR(80), NOT NULL).
- `apellidos` (VARCHAR(80), NOT NULL).
- `documento_identidad` (VARCHAR(30), NOT NULL, **UNIQUE**): Cédula de ciudadanía o extranjería única.
- `telefono` (VARCHAR(30), NULL).
- `direccion` (VARCHAR(200), NULL).
- `foto_url` (VARCHAR(255), DEFAULT avatar).

---

## 3. Propiedades e Inmuebles

### 3.1. Tabla: `propiedad`
Entidad principal del negocio inmobiliario.
- `id` (INT, PK, AUTO_INCREMENT): Identificador del inmueble.
- `id_inmobiliaria` (INT, NOT NULL, FK `inmobiliaria(id)`): Relación 1:N.
- `id_ciudad` (INT, NOT NULL, FK `ciudad(id)`): Ubicación.
- `id_tipo_propiedad` (INT, NOT NULL, FK `tipo_propiedad(id)`): Clasificación.
- `matricula_inmobiliaria` (VARCHAR(50), NOT NULL, **UNIQUE**): Folio de matrícula inmobiliaria legal único.
- `titulo` (VARCHAR(150), NOT NULL): Encabezado de publicación.
- `descripcion` (TEXT, NOT NULL): Memoria descriptiva.
- `precio` (DECIMAL(14,2), NOT NULL): Valor en COP.
- `area_m2` (DECIMAL(8,2), DEFAULT 0.00): Superficie total construida.
- `habitaciones` (INT, DEFAULT 0).
- `banos` (INT, DEFAULT 0).
- `estrato` (INT, DEFAULT 3): Estratificación 1 a 6.
- `direccion` (VARCHAR(200), NOT NULL).
- `destacada` (BOOLEAN, DEFAULT FALSE): Bandera para visualización en landing page.
- `tipo_operacion` (ENUM('VENTA', 'ARRIENDO'), NOT NULL).
- `estado` (ENUM('DISPONIBLE', 'RESERVADA', 'VENDIDA', 'ARRENDADA', 'INACTIVA'), DEFAULT 'DISPONIBLE'): Baja lógica implementada con el valor 'INACTIVA'.
- `fecha_publicacion` (DATETIME, DEFAULT CURRENT_TIMESTAMP).

### 3.2. Tabla: `imagen_propiedad` (Relación 1:N)
Galería de fotos asociadas a cada inmueble.
- `id` (INT, PK, AUTO_INCREMENT).
- `id_propiedad` (INT, NOT NULL, FK `propiedad(id)` ON DELETE CASCADE).
- `url_imagen` (VARCHAR(255), NOT NULL): Dirección del archivo fotográfico.
- `orden` (INT, DEFAULT 1): Secuencia de visualización.
- `es_principal` (BOOLEAN, DEFAULT FALSE): Imagen de portada.
- `descripcion` (VARCHAR(150), NULL).

### 3.3. Tabla: `propiedad_caracteristica` (Relación N:M)
Tabla de rompimiento entre propiedades y características.
- `id_propiedad` (INT, NOT NULL, FK `propiedad(id)` ON DELETE CASCADE).
- `id_caracteristica` (INT, NOT NULL, FK `caracteristica(id)` ON DELETE CASCADE).
- **Llave Primaria:** `PRIMARY KEY (id_propiedad, id_caracteristica)`.

---

## 4. Operación: Favoritos, Citas y Solicitudes

### 4.1. Tabla: `favorito`
Inmuebles guardados por los clientes en su lista de seguimiento.
- `id` (INT, PK, AUTO_INCREMENT).
- `id_usuario` (INT, NOT NULL, FK `usuario(id)` ON DELETE CASCADE).
- `id_propiedad` (INT, NOT NULL, FK `propiedad(id)` ON DELETE CASCADE).
- `fecha_agregado` (DATETIME, DEFAULT CURRENT_TIMESTAMP).
- **Restricción:** `UNIQUE (id_usuario, id_propiedad)` para evitar duplicados.

### 4.2. Tabla: `cita`
Agendamiento de visitas presenciales a los inmuebles (cita por turno único).
- `id` (INT, PK, AUTO_INCREMENT).
- `id_cliente` (INT, NOT NULL, FK `usuario(id)` ON DELETE CASCADE).
- `id_propiedad` (INT, NOT NULL, FK `propiedad(id)` ON DELETE CASCADE).
- `fecha_hora` (DATETIME, NOT NULL): Momento pactado.
- `estado` (ENUM('PENDIENTE', 'CONFIRMADA', 'REALIZADA', 'CANCELADA'), DEFAULT 'PENDIENTE').
- `slot_turno` (DATETIME, columna generada STORED): es `NULL` si la cita está `CANCELADA`, si no coincide con `fecha_hora`.
- `comentarios` (VARCHAR(255), NULL).
- `fecha_creacion` (DATETIME, DEFAULT CURRENT_TIMESTAMP).
- **Restricción de turno único:** `UNIQUE (id_propiedad, slot_turno)` impide que dos clientes reserven el mismo inmueble en el mismo horario. Como las filas `NULL` no colisionan en UNIQUE, una cita cancelada **libera** el turno y puede volver a agendarse. En PostgreSQL/Supabase se implementa como índice único parcial `WHERE estado <> 'CANCELADA'`. Además, la aplicación valida la disponibilidad antes del INSERT (`CitaDAO.existeCitaActiva`).

### 4.3. Tabla: `solicitud`
Trámite contractual formal iniciado por un cliente.
- `id` (INT, PK, AUTO_INCREMENT).
- `id_cliente` (INT, NOT NULL, FK `usuario(id)` ON DELETE CASCADE).
- `id_propiedad` (INT, NOT NULL, FK `propiedad(id)` ON DELETE CASCADE).
- `tipo_operacion` (ENUM('COMPRA', 'ARRIENDO'), NOT NULL).
- `estado` (ENUM('PENDIENTE', 'EN_REVISION', 'APROBADA', 'RECHAZADA'), DEFAULT 'PENDIENTE').
- `observaciones` (TEXT, NULL).
- `fecha_solicitud` (DATETIME, DEFAULT CURRENT_TIMESTAMP).
- `fecha_actualizacion` (DATETIME ON UPDATE CURRENT_TIMESTAMP).

### 4.4. Tabla: `documento_solicitud` (Relación 1:N)
Expediente digital de documentos radicados por el cliente.
- `id` (INT, PK, AUTO_INCREMENT).
- `id_solicitud` (INT, NOT NULL, FK `solicitud(id)` ON DELETE CASCADE).
- `nombre_archivo` (VARCHAR(150), NOT NULL).
- `ruta_archivo` (VARCHAR(255), NOT NULL).
- `tipo_documento` (VARCHAR(80), NOT NULL): Cédula, Carta Laboral, Extractos, etc.
- `estado` (ENUM('SUBIDO', 'APROBADO', 'RECHAZADO'), DEFAULT 'SUBIDO').
- `fecha_subida` (DATETIME, DEFAULT CURRENT_TIMESTAMP).

---

## 5. Auditoría del Sistema

### 5.1. Tabla: `auditoria`
Trazabilidad de seguridad de acciones realizadas en el sistema.
- `id` (INT, PK, AUTO_INCREMENT).
- `id_usuario` (INT, NULL, FK `usuario(id)` ON DELETE SET NULL).
- `accion` (VARCHAR(80), NOT NULL): LOGIN, REGISTRO, CREAR_PROPIEDAD, BAJA_LOGICA, etc.
- `entidad_afectada` (VARCHAR(80), NOT NULL).
- `id_entidad` (INT, NULL).
- `detalles` (TEXT, NULL).
- `ip_origen` (VARCHAR(50), NULL).
- `fecha_hora` (DATETIME, DEFAULT CURRENT_TIMESTAMP).
