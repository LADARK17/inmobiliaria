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

## Base de Datos en Línea (Supabase) y Local (MySQL)

El sistema soporta indistintamente **Supabase (PostgreSQL en la Nube)** y **MySQL Local (XAMPP)** mediante el archivo desacoplado `src/main/resources/db.properties`.

### 1. Conexión Activa en la Nube (Supabase - Proyecto izvgvqqecuztatpflnwy)
El proyecto está configurado y sincronizado directamente con Supabase PostgreSQL:
- **Host del Pooler:** `aws-0-us-west-2.pooler.supabase.com:5432`
- **Usuario:** `postgres.izvgvqqecuztatpflnwy`
- **Base de Datos:** `postgres` (SSL habilitado)
- **Estado Actual:** 16 tablas creadas y pobladas con registros de prueba en Supabase.
- Para reiniciar o re-sembrar la base de datos de Supabase en cualquier momento, basta con ejecutar:
  ```bash
  mvn compile exec:java -Dexec.mainClass="com.inmobiliaria.util.SetupSupabaseDB"
  ```

### 2. Alternar a MySQL Local (XAMPP)
Si se desea trabajar de forma local offline:
1. Inicie el servicio de **MySQL** en el panel de control de XAMPP.
2. Ejecute `src/main/resources/sql/01_ddl_inmobiliaria.sql` y `02_dml_inmobiliaria.sql` en phpMyAdmin.
3. En `src/main/resources/db.properties`, comente las líneas de Supabase y descomente las líneas de MySQL.

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
