-- =====================================================================
-- PROYECTO INMOBILIARIA WEB MVC - DATOS DE PRUEBA (DML)
-- Cumple con el requisito de MÍNIMO 10 REGISTROS POR TABLA PRINCIPAL
-- =====================================================================

USE inmobiliaria_db;

SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- 1. CIUDADES (10 registros)
-- ---------------------------------------------------------------------
INSERT INTO ciudad (id, nombre, departamento) VALUES
(1, 'Bucaramanga', 'Santander'),
(2, 'Floridablanca', 'Santander'),
(3, 'Girón', 'Santander'),
(4, 'Piedecuesta', 'Santander'),
(5, 'Bogotá D.C.', 'Cundinamarca'),
(6, 'Medellín', 'Antioquia'),
(7, 'Cali', 'Valle del Cauca'),
(8, 'Barranquilla', 'Atlántico'),
(9, 'Cartagena', 'Bolívar'),
(10, 'Pereira', 'Risaralda');

-- ---------------------------------------------------------------------
-- 2. TIPOS DE PROPIEDAD (10 registros)
-- ---------------------------------------------------------------------
INSERT INTO tipo_propiedad (id, nombre, descripcion) VALUES
(1, 'Apartamento', 'Vivienda multifamiliar vertical con amenidades compartidas'),
(2, 'Casa', 'Inmueble unifamiliar residencial con patio o jardín'),
(3, 'Penthouse', 'Apartamento de lujo en el último piso con terraza privada'),
(4, 'Local Comercial', 'Espacio a pie de calle o en centro comercial para comercio'),
(5, 'Oficina', 'Espacio corporativo para actividades profesionales y empresariales'),
(6, 'Bodega', 'Espacio industrial o de almacenamiento logístico'),
(7, 'Terreno / Lote', 'Predio sin construir urbanizable o campestre'),
(8, 'Finca Campestre', 'Predio rural con casa de descanso y amplias zonas verdes'),
(9, 'Suite Ejecutiva', 'Apartaestudio amoblado para estadías corporativas'),
(10, 'Consultorio', 'Espacio acondicionado para atención en salud o consultoría');

-- ---------------------------------------------------------------------
-- 3. CARACTERÍSTICAS (10 registros)
-- ---------------------------------------------------------------------
INSERT INTO caracteristica (id, nombre, icono) VALUES
(1, 'Piscina', 'bi-water'),
(2, 'Gimnasio dotado', 'bi-activity'),
(3, 'Ascensor', 'bi-arrow-up-square'),
(4, 'Parqueadero cubierto', 'bi-car-front'),
(5, 'Vigilancia 24/7', 'bi-shield-check'),
(6, 'Zona infantil', 'bi-emoji-smile'),
(7, 'Terraza / Balcón', 'bi-sun'),
(8, 'Zona BBQ', 'bi-fire'),
(9, 'Cancha múltiple', 'bi-dribbble'),
(10, 'Sauna / Jacuzzi', 'bi-droplet');

-- ---------------------------------------------------------------------
-- 4. INMOBILIARIAS (10 registros)
-- ---------------------------------------------------------------------
INSERT INTO inmobiliaria (id, nombre, nit, telefono, correo, direccion, logo_url) VALUES
(1, 'Inmobiliaria Santander Real Estate', '900123456-1', '6076351000', 'contacto@santanderinmobiliaria.com', 'Cra 27 # 36-14, Bucaramanga', 'assets/img/inm-1.png'),
(2, 'Hábitat & Espacios Colombia', '900234567-2', '6076452000', 'gerencia@habitatinmobiliaria.com', 'Calle 48 # 28-30, Bucaramanga', 'assets/img/inm-2.png'),
(3, 'Metro Urbano Propiedades', '900345678-3', '6017891234', 'info@metrourbano.com.co', 'Cra 15 # 93-20, Bogotá', 'assets/img/inm-3.png'),
(4, 'Alianza Andina Raíz', '900456789-4', '6044445566', 'servicio@alianzaandina.com', 'El Poblado Cra 43A # 1-50, Medellín', 'assets/img/inm-4.png'),
(5, 'Cañaveral Luxury Homes', '900567890-5', '6076789012', 'ventas@canaveralluxury.com', 'Autopista Floridablanca # 29-10', 'assets/img/inm-5.png'),
(6, 'Inversiones Cabecera SAS', '900678901-6', '6076554433', 'asesoria@cabecerainmuebles.com', 'Calle 52 # 35-18, Bucaramanga', 'assets/img/inm-6.png'),
(7, 'Caribe Sol Bienes Raíces', '900789012-7', '6053607080', 'info@caribesolinmobiliaria.com', 'Bocagrande Cra 2 # 8-15, Cartagena', 'assets/img/inm-7.png'),
(8, 'Valle Real Inmuebles', '900890123-8', '6028899000', 'contacto@vallereal.com', 'Av. 6 Norte # 22-05, Cali', 'assets/img/inm-8.png'),
(9, 'Eje Cafetero Propiedad Raíz', '900901234-9', '6063334455', 'info@ejeraiz.com', 'Av. Circunvalar # 12-40, Pereira', 'assets/img/inm-9.png'),
(10, 'Puerta de Oro Inmobiliaria', '901012345-0', '6053789000', 'ventas@puertadeoroinm.com', 'Calle 76 # 54-11, Barranquilla', 'assets/img/inm-10.png');

-- ---------------------------------------------------------------------
-- 5. ROLES (4 perfiles obligatorios)
-- ---------------------------------------------------------------------
INSERT INTO rol (id, nombre, descripcion) VALUES
(1, 'ADMINISTRADOR', 'Control total de usuarios, roles, parámetros del sistema y auditoría'),
(2, 'AGENTE', 'Gestión de propiedades, citas, revisión de solicitudes y reportes de agencia'),
(3, 'CLIENTE', 'Búsqueda, favoritos, solicitud de visitas y radicación de trámites'),
(4, 'VISITANTE', 'Perfil público de consulta sin privilegios de sesión');

-- ---------------------------------------------------------------------
-- 6. USUARIOS (12 registros con hash BCrypt de '123456')
-- Hash BCrypt estándar para '123456': $2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.
-- ---------------------------------------------------------------------
INSERT INTO usuario (id, correo, password_hash, estado, id_inmobiliaria) VALUES
(1, 'admin@inmobiliaria.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', 1),
(2, 'agente.carlos@santander.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', 1),
(3, 'agente.maria@santander.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', 2),
(4, 'agente.andres@habitat.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', 2),
(5, 'cliente.juan@gmail.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', NULL),
(6, 'cliente.laura@hotmail.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', NULL),
(7, 'cliente.pedro@yahoo.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', NULL),
(8, 'cliente.sofia@gmail.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', NULL),
(9, 'cliente.felipe@outlook.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', NULL),
(10, 'cliente.camila@gmail.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', NULL),
(11, 'cliente.diego@gmail.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'ACTIVO', NULL),
(12, 'cliente.paula@gmail.com', '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PpIi0na624b8.', 'INACTIVO', NULL);

-- ---------------------------------------------------------------------
-- 7. USUARIO_ROL (Relación N:M, 13 registros)
-- ---------------------------------------------------------------------
INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(1, 1), -- Admin tiene ROL ADMIN
(1, 2), -- Admin también tiene ROL AGENTE (Demuestra N:M en un solo usuario)
(2, 2), -- Agente Carlos
(3, 2), -- Agente María
(4, 2), -- Agente Andrés
(5, 3), -- Cliente Juan
(6, 3), -- Cliente Laura
(7, 3), -- Cliente Pedro
(8, 3), -- Cliente Sofía
(9, 3), -- Cliente Felipe
(10, 3), -- Cliente Camila
(11, 3), -- Cliente Diego
(12, 3); -- Cliente Paula

-- ---------------------------------------------------------------------
-- 8. PERFIL (Relación 1:1, 12 registros con id_usuario UNIQUE)
-- ---------------------------------------------------------------------
INSERT INTO perfil (id, id_usuario, nombres, apellidos, documento_identidad, telefono, direccion, foto_url) VALUES
(1, 1, 'Alejandro', 'Administrador', 'CC-1098765432', '3157890001', 'Cabecera, Bucaramanga', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'),
(2, 2, 'Carlos', 'Gómez Prada', 'CC-1098765433', '3157890002', 'Sotomayor, Bucaramanga', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
(3, 3, 'María', 'Fernanda Rueda', 'CC-1098765434', '3157890003', 'Cañaveral, Floridablanca', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'),
(4, 4, 'Andrés', 'Felipe Ortiz', 'CC-1098765435', '3157890004', 'El Bosque, Floridablanca', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150'),
(5, 5, 'Juan', 'Pérez Moreno', 'CC-1098765436', '3182221101', 'Provenza, Bucaramanga', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150'),
(6, 6, 'Laura', 'Jiménez Duarte', 'CC-1098765437', '3182221102', 'San Francisco, Bucaramanga', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150'),
(7, 7, 'Pedro', 'Pablo Suárez', 'CC-1098765438', '3182221103', 'El Poblado, Girón', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150'),
(8, 8, 'Sofía', 'Castro Vega', 'CC-1098765439', '3182221104', 'Rincon de Girón', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150'),
(9, 9, 'Felipe', 'Torres Silva', 'CC-1098765440', '3182221105', 'Barroblanco, Piedecuesta', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150'),
(10, 10, 'Camila', 'Vargas Luna', 'CC-1098765441', '3182221106', 'La Castellana, Piedecuesta', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150'),
(11, 11, 'Diego', 'Hernández Ríos', 'CC-1098765442', '3182221107', 'Chicó Norte, Bogotá', 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150'),
(12, 12, 'Paula', 'Morales Jaimes', 'CC-1098765443', '3182221108', 'Laureles, Medellín', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150');

-- ---------------------------------------------------------------------
-- 9. PROPIEDAD (12 registros representativos con matrículas UNIQUE)
-- ---------------------------------------------------------------------
INSERT INTO propiedad (id, id_inmobiliaria, id_ciudad, id_tipo_propiedad, matricula_inmobiliaria, titulo, descripcion, precio, area_m2, habitaciones, banos, estrato, direccion, destacada, tipo_operacion, estado) VALUES
(1, 1, 1, 1, 'MAT-BGA-00101', 'Apartamento Moderno en Cabecera', 'Excelente apartamento iluminado, piso 12, acabados de lujo, balcón panorámico hacia los cerros orientales.', 350000000.00, 95.50, 3, 2, 5, 'Cra 35 # 48-22, Cabecera', TRUE, 'VENTA', 'DISPONIBLE'),
(2, 1, 1, 2, 'MAT-BGA-00102', 'Casa Campestre en Ruitoque Bajo', 'Amplia casa de dos plantas con jardines internos, zona BBQ privada y garaje para 3 vehículos.', 780000000.00, 280.00, 4, 4, 6, 'Condominio Campestre Lote 14', TRUE, 'VENTA', 'DISPONIBLE'),
(3, 2, 2, 1, 'MAT-FLB-00201', 'Apartamento Familiar en Cañaveral', 'Cerca a centros comerciales, conjunto cerrado con club house, piscina y canchas deportivas.', 280000000.00, 78.00, 3, 2, 4, 'Calle 30 # 25-15, Cañaveral', FALSE, 'VENTA', 'DISPONIBLE'),
(4, 2, 2, 4, 'MAT-FLB-00202', 'Local Comercial en Centro Cañaveral', 'Gran flujo peatonal, excelente vitrina comercial, 1 baño privado, mezanine adecuado.', 4500000.00, 45.00, 0, 1, 4, 'Av. Comercial Local 108', FALSE, 'ARRIENDO', 'DISPONIBLE'),
(5, 3, 5, 1, 'MAT-BOG-00301', 'Penthouse de Lujo en Chicó Reservado', 'Vista panorámica 360 grados, chimenea a gas, terraza privada de 60m2 y acabados italianos.', 1250000000.00, 210.00, 3, 4, 6, 'Cra 9 # 94-50, Chicó', TRUE, 'VENTA', 'DISPONIBLE'),
(6, 4, 6, 1, 'MAT-MED-00401', 'Apartamento en El Poblado Castropol', 'Zona exclusiva y tranquila, balcón amplio, cocina abierta tipo americano, excelente inversión.', 520000000.00, 110.00, 2, 3, 6, 'Calle 14 # 30-80, El Poblado', TRUE, 'VENTA', 'DISPONIBLE'),
(7, 1, 3, 2, 'MAT-GIR-00103', 'Casa Colonial Restaurada en Casco Histórico', 'Hermosa arquitectura colonial con comodidades modernas, techos altos en cañabrava y patio empedrado.', 390000000.00, 160.00, 3, 2, 3, 'Calle 28 # 25-10, Casco Antiguo', FALSE, 'VENTA', 'DISPONIBLE'),
(8, 2, 4, 1, 'MAT-PDC-00203', 'Apartamento Económico en Barroblanco', 'Conjunto cerrado con piscina, parque infantil y seguridad 24 horas. Excelente vista.', 165000000.00, 60.00, 3, 2, 3, 'Carrera 8 # 12-40, Piedecuesta', FALSE, 'VENTA', 'DISPONIBLE'),
(9, 3, 5, 5, 'MAT-BOG-00302', 'Oficina Corporativa en Calle 100', 'Piso alto, divisiones modulares, cableado estructurado, recepción y 4 parqueaderos asignados.', 8500000.00, 130.00, 0, 2, 5, 'Calle 100 # 15-20 Piso 8', FALSE, 'ARRIENDO', 'DISPONIBLE'),
(10, 5, 2, 1, 'MAT-FLB-00501', 'Apartamento en Arriendo Bosque Cañaveral', 'Completamente remodelado, cocina integral con horno, closet en todas las habitaciones.', 1900000.00, 82.00, 3, 2, 4, 'Transversal 154 # 32-10', FALSE, 'ARRIENDO', 'RESERVADA'),
(11, 1, 1, 1, 'MAT-BGA-00104', 'Apartamento en Sotomayor (Vendido)', 'Inmueble con excelente ubicación cerca al parque San Pío. Registro de venta exitosa.', 310000000.00, 85.00, 3, 2, 4, 'Calle 45 # 27-30', FALSE, 'VENTA', 'VENDIDA'),
(12, 1, 1, 2, 'MAT-BGA-00105', 'Casa en Terrazas (Inactiva / Baja Lógica)', 'Propiedad retirada temporalmente por remodelaciones integrales de fachada y cubierta.', 420000000.00, 190.00, 4, 3, 4, 'Calle 56 # 45-12', FALSE, 'VENTA', 'INACTIVA');

-- ---------------------------------------------------------------------
-- 10. IMAGEN_PROPIEDAD (Relación 1:N, 15 registros)
-- ---------------------------------------------------------------------
INSERT INTO imagen_propiedad (id, id_propiedad, url_imagen, orden, es_principal, descripcion) VALUES
(1, 1, 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800', 1, TRUE, 'Fachada principal y sala'),
(2, 1, 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800', 2, FALSE, 'Cocina tipo isla integral'),
(3, 1, 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800', 3, FALSE, 'Habitación principal con vista'),
(4, 2, 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800', 1, TRUE, 'Fachada casa campestre'),
(5, 2, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800', 2, FALSE, 'Zona verde y piscina'),
(6, 3, 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800', 1, TRUE, 'Sala comedor Cañaveral'),
(7, 3, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800', 2, FALSE, 'Balcón hacia la reserva natural'),
(8, 4, 'https://images.unsplash.com/photo-1528698827591-e19ccd7bc23d?w=800', 1, TRUE, 'Vitrina comercial amplia'),
(9, 5, 'https://images.unsplash.com/photo-1512915922686-57c11dde9b6b?w=800', 1, TRUE, 'Penthouse terraza privada'),
(10, 6, 'https://images.unsplash.com/photo-1574362848149-11496d93a7c7?w=800', 1, TRUE, 'Apartamento El Poblado sala'),
(11, 7, 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=800', 1, TRUE, 'Patio colonial empedrado'),
(12, 8, 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800', 1, TRUE, 'Conjunto residencial Piedecuesta'),
(13, 9, 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800', 1, TRUE, 'Recepción y oficinas Calle 100'),
(14, 10, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800', 1, TRUE, 'Apartamento Bosque Cañaveral'),
(15, 11, 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800', 1, TRUE, 'Cocina remodelada Sotomayor');

-- ---------------------------------------------------------------------
-- 11. PROPIEDAD_CARACTERISTICA (Relación N:M, 20 registros)
-- ---------------------------------------------------------------------
INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES
(1, 1), -- Apto Cabecera: Piscina
(1, 2), -- Gimnasio
(1, 3), -- Ascensor
(1, 4), -- Parqueadero cubierto
(1, 5), -- Vigilancia 24/7
(2, 1), -- Casa Campestre: Piscina
(2, 4), -- Parqueadero
(2, 7), -- Terraza
(2, 8), -- Zona BBQ
(2, 10), -- Jacuzzi
(3, 1), -- Apto Cañaveral: Piscina
(3, 3), -- Ascensor
(3, 4), -- Parqueadero
(3, 6), -- Zona infantil
(5, 2), -- Penthouse Chicó: Gimnasio
(5, 3), -- Ascensor
(5, 5), -- Vigilancia
(5, 7), -- Terraza
(6, 1), -- Apto Medellín: Piscina
(6, 4); -- Parqueadero

-- ---------------------------------------------------------------------
-- 12. FAVORITO (Relación con UNIQUE(id_usuario, id_propiedad), 10 registros)
-- ---------------------------------------------------------------------
INSERT INTO favorito (id, id_usuario, id_propiedad) VALUES
(1, 5, 1), -- Juan guardó Apto Cabecera
(2, 5, 3), -- Juan guardó Apto Cañaveral
(3, 6, 2), -- Laura guardó Casa Campestre
(4, 6, 5), -- Laura guardó Penthouse Chicó
(5, 7, 1), -- Pedro guardó Apto Cabecera
(6, 7, 7), -- Pedro guardó Casa Colonial Girón
(7, 8, 3), -- Sofía guardó Apto Cañaveral
(8, 8, 8), -- Sofía guardó Apto Piedecuesta
(9, 9, 6), -- Felipe guardó Apto El Poblado
(10, 10, 4); -- Camila guardó Local Comercial

-- ---------------------------------------------------------------------
-- 13. CITA (Visitas con UNIQUE(id_propiedad, fecha_hora), 10 registros)
-- ---------------------------------------------------------------------
INSERT INTO cita (id, id_cliente, id_propiedad, fecha_hora, estado, comentarios) VALUES
(1, 5, 1, '2026-09-20 10:00:00', 'CONFIRMADA', 'Cliente interesado en compra de contado'),
(2, 6, 2, '2026-09-20 15:30:00', 'CONFIRMADA', 'Visita familiar con arquitecto'),
(3, 7, 3, '2026-09-21 09:00:00', 'PENDIENTE', 'Revisión de áreas comunes y parqueadero'),
(4, 8, 1, '2026-09-21 16:00:00', 'PENDIENTE', 'Cliente solicita validar crédito hipotecario previo'),
(5, 9, 6, '2026-09-22 11:00:00', 'CONFIRMADA', 'Visita en Medellín con cónyuge'),
(6, 10, 4, '2026-09-22 14:00:00', 'PENDIENTE', 'Validación de uso de suelo comercial'),
(7, 5, 5, '2026-09-23 10:30:00', 'PENDIENTE', 'Visita a Penthouse en Chicó'),
(8, 6, 7, '2026-09-15 15:00:00', 'REALIZADA', 'Cliente visitó la propiedad colonial en Girón'),
(9, 7, 8, '2026-09-14 16:30:00', 'REALIZADA', 'Se verificaron acabados en Piedecuesta'),
(10, 11, 2, '2026-09-16 10:00:00', 'CANCELADA', 'Cliente no pudo asistir por viaje de trabajo');

-- ---------------------------------------------------------------------
-- 14. SOLICITUD (Trámites compra/arriendo, 10 registros)
-- ---------------------------------------------------------------------
INSERT INTO solicitud (id, id_cliente, id_propiedad, tipo_operacion, estado, observaciones) VALUES
(1, 5, 1, 'COMPRA', 'APROBADA', 'Crédito pre-aprobado Bancolombia por $300 millones y cuota inicial lista'),
(2, 6, 2, 'COMPRA', 'EN_REVISION', 'Pendiente avalúo comercial final y verificación de títulos'),
(3, 10, 4, 'ARRIENDO', 'EN_REVISION', 'Documentos de codeudor con finca raíz en análisis por aseguradora'),
(4, 7, 3, 'COMPRA', 'PENDIENTE', 'Radicada solicitud formal tras visita técnica'),
(5, 8, 8, 'COMPRA', 'PENDIENTE', 'Solicitud de subsidio Mi Casa Ya en trámite'),
(6, 9, 6, 'COMPRA', 'EN_REVISION', 'Verificación de capacidad de pago e ingresos independientes'),
(7, 11, 10, 'ARRIENDO', 'APROBADA', 'Póliza de arrendamiento expedida por Fianza Inmobiliaria'),
(8, 7, 7, 'COMPRA', 'RECHAZADA', 'Capacidad de endeudamiento no cumple con el valor requerido'),
(9, 5, 5, 'COMPRA', 'PENDIENTE', 'Oferta formal radicada sujeta a negociación del 5%'),
(10, 6, 1, 'COMPRA', 'RECHAZADA', 'Inmueble ya se encontraba en proceso de cierre con otro cliente');

-- ---------------------------------------------------------------------
-- 15. DOCUMENTO_SOLICITUD (Relación 1:N con solicitud, 10 registros)
-- ---------------------------------------------------------------------
INSERT INTO documento_solicitud (id, id_solicitud, nombre_archivo, ruta_archivo, tipo_documento, estado) VALUES
(1, 1, 'Cedula_Juan_Perez.pdf', 'uploads/docs/cedula_5.pdf', 'Cédula de Ciudadanía', 'APROBADO'),
(2, 1, 'Carta_Laboral_Juan.pdf', 'uploads/docs/laboral_5.pdf', 'Certificación Laboral', 'APROBADO'),
(3, 1, 'Extractos_Bancarios_Juan.pdf', 'uploads/docs/extractos_5.pdf', 'Extractos Bancarios', 'APROBADO'),
(4, 2, 'Cedula_Laura_Jimenez.pdf', 'uploads/docs/cedula_6.pdf', 'Cédula de Ciudadanía', 'APROBADO'),
(5, 2, 'Declaracion_Renta_Laura.pdf', 'uploads/docs/renta_6.pdf', 'Declaración de Renta', 'SUBIDO'),
(6, 3, 'Camara_Comercio_Local.pdf', 'uploads/docs/camara_10.pdf', 'Cámara de Comercio', 'SUBIDO'),
(7, 3, 'RUT_Camila_Vargas.pdf', 'uploads/docs/rut_10.pdf', 'RUT Comercial', 'APROBADO'),
(8, 4, 'Cedula_Pedro_Suarez.pdf', 'uploads/docs/cedula_7.pdf', 'Cédula de Ciudadanía', 'SUBIDO'),
(9, 6, 'Extractos_Felipe_Torres.pdf', 'uploads/docs/extractos_9.pdf', 'Extractos Bancarios', 'SUBIDO'),
(10, 7, 'Cedula_Diego_Hernandez.pdf', 'uploads/docs/cedula_11.pdf', 'Cédula de Ciudadanía', 'APROBADO');

-- ---------------------------------------------------------------------
-- 16. AUDITORIA (10 registros representativos de trazabilidad)
-- ---------------------------------------------------------------------
INSERT INTO auditoria (id, id_usuario, accion, entidad_afectada, id_entidad, detalles, ip_origen) VALUES
(1, 1, 'LOGIN', 'usuario', 1, 'Inicio de sesión exitoso como ADMINISTRADOR', '127.0.0.1'),
(2, 2, 'CREAR_PROPIEDAD', 'propiedad', 1, 'Publicación de propiedad con matrícula MAT-BGA-00101', '192.168.1.45'),
(3, 2, 'SUBIR_IMAGEN', 'imagen_propiedad', 1, 'Galería asociada a propiedad 1', '192.168.1.45'),
(4, 5, 'REGISTRO', 'usuario', 5, 'Nuevo cliente registrado en la plataforma', '186.28.14.22'),
(5, 5, 'AGENDAR_CITA', 'cita', 1, 'Cita programada para 2026-09-20 10:00:00', '186.28.14.22'),
(6, 2, 'CONFIRMAR_CITA', 'cita', 1, 'Agente confirmó visita presencial', '192.168.1.45'),
(7, 5, 'RADICAR_SOLICITUD', 'solicitud', 1, 'Solicitud de compra iniciada para propiedad 1', '186.28.14.22'),
(8, 2, 'APROBAR_SOLICITUD', 'solicitud', 1, 'Documentos verificados y solicitud aprobada', '192.168.1.45'),
(9, 1, 'MODIFICAR_ESTADO_PROPIEDAD', 'propiedad', 12, 'Baja lógica: Estado cambiado a INACTIVA', '127.0.0.1'),
(10, 1, 'CAMBIAR_ROL', 'usuario_rol', 1, 'Asignación de rol AGENTE a usuario administrador', '127.0.0.1');

SET FOREIGN_KEY_CHECKS = 1;
