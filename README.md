# Sistema Inmobiliario Web MVC

Aplicación web integral para la administración y comercialización inmobiliaria desarrollada bajo la arquitectura **MVC** con **Java EE 8**, **JSP / JSTL**, **JDBC** y **MySQL**, utilizando diseño responsivo con **Bootstrap 5** y metodología ágil **Scrum** (3 Sprints &times; 7 días).

---

## Características Principales

1. **Arquitectura y Tecnologías:**
   - **Backend:** Java EE (Servlets, Filters, JSTL, Sessions).
   - **Vistas:** JSP y fragmentos modulares JSPF con Bootstrap 5.3 e iconos.
   - **Acceso a Datos:** JDBC puro y centralizado en `DatabaseConnection` con carga desacoplada vía `db.properties`.
   - **Seguridad:** Hashing seguro con **BCrypt** y control estricto de accesos mediante `AuthFilter` (Servlet Filter).
   - **Servidor:** Apache Tomcat (Compatible con XAMPP Tomcat y Tomcat 9/10).
   - **Base de Datos:** MySQL 8.x / MariaDB normalizado en **3FN** con 16 tablas.

2. **Modelo Pedagógico de Datos:**
   - **Relación 1:1:** `usuario` &harr; `perfil` con restricción `perfil.id_usuario UNIQUE`.
   - **Relaciones 1:N:** `inmobiliaria` &rarr; `propiedad`, `propiedad` &rarr; `imagen_propiedad`, `cliente` &rarr; `cita`, `solicitud` &rarr; `documento_solicitud`.
   - **Relaciones N:M:** `usuario` &harr; `rol` (`usuario_rol`), `propiedad` &harr; `caracteristica` (`propiedad_caracteristica`).
   - **Restricciones UNIQUE:** Correo de usuario, matrícula inmobiliaria, documento de identidad, y horario de citas `(id_propiedad, fecha_hora)`.
   - **5 Consultas SQL Obligatorias:** Documentadas en `03_consultas_academicas.sql` y demostradas en el módulo de reportes.

3. **Perfiles de Usuario:**
   - **Visitante:** Landing page, buscador rápido, catálogo filtrable y vista previa limitada.
   - **Cliente:** Perfil 1:1, favoritos, agendamiento de visitas, radicación de trámites y carga de documentos.
   - **Agente / Inmobiliaria:** CRUD de propiedades con baja lógica (`INACTIVA`), gestión de citas y revisión de solicitudes.
   - **Administrador:** Métricas globales, gestión de usuarios, asignación de roles N:M, reportes SQL y auditoría.

---

## Credenciales de Demostración

| Rol | Correo Electrónico | Contraseña |
| :--- | :--- | :--- |
| **Administrador** | `admin@inmobiliaria.com` | `123456` |
| **Agente Inmobiliario** | `agente.carlos@santander.com` | `123456` |
| **Cliente** | `cliente.juan@gmail.com` | `123456` |

---

## Instrucciones de Instalación y Ejecución

### 1. Carga de la Base de Datos en MySQL (XAMPP)
1. Inicie el servicio de **MySQL** en el panel de control de XAMPP.
2. Abra **phpMyAdmin** o su cliente SQL favorito y ejecute en orden los siguientes scripts ubicados en `src/main/resources/sql/`:
   - `01_ddl_inmobiliaria.sql`: Creación de la base de datos `inmobiliaria_db` y las 16 tablas con claves y restricciones.
   - `02_dml_inmobiliaria.sql`: Inserción de al menos 10 registros coherentes por tabla y contraseñas cifradas en BCrypt.
   - `03_consultas_academicas.sql`: Consultas pedagógicas obligatorias para la sustentación.

### 2. Configuración de Conexión
Si su servidor MySQL tiene una contraseña distinta a la predeterminada de XAMPP (`root` sin contraseña), edite el archivo:
```properties
src/main/resources/db.properties
```

### 3. Compilación y Despliegue en Tomcat
1. Compile el proyecto y genere el archivo `war`:
   ```bash
   mvn clean package
   ```
2. El archivo `target/inmobiliaria.war` generado puede ser copiado directamente a la carpeta `webapps` de Apache Tomcat (por ejemplo `C:\xampp\tomcat\webapps\inmobiliaria.war`).
3. Inicie Tomcat y acceda desde su navegador a:
   ```
   http://localhost:8080/inmobiliaria/
   ```

---

## Documentación del Proyecto
- [Diccionario de Datos (3FN)](file:///docs/database/diccionario_datos.md)
- [Modelo Entidad-Relación y Relacional (Diagramas Mermaid)](file:///docs/database/modelo_relacional.md)
- [Product Backlog con Historias de Usuario (Scrum)](file:///docs/scrum/product_backlog.md)
- [Sprint 1: Cimientos y Acceso](file:///docs/scrum/sprint-1.md)
- [Sprint 2: Núcleo Inmobiliario](file:///docs/scrum/sprint-2.md)
- [Sprint 3: Operación, Reportes y Cierre](file:///docs/scrum/sprint-3.md)
- [Guía Maestra para la Sustentación](file:///docs/sustentacion_guia.md)
