# Modelo Entidad-Relación y Relacional: Sistema Inmobiliario MVC

Este documento describe la arquitectura lógica y física de datos del sistema inmobiliario, demostrando el cumplimiento estricto de la **Tercera Forma Normal (3FN)** y la implementación de las relaciones requeridas: **1:1**, **1:N** y **N:M**.

---

## 1. Diagrama Entidad-Relación (Mermaid ER)

```mermaid
erDiagram
    CIUDAD ||--o{ PROPIEDAD : "está ubicada en (1:N)"
    TIPO_PROPIEDAD ||--o{ PROPIEDAD : "clasifica a (1:N)"
    INMOBILIARIA ||--o{ PROPIEDAD : "administra (1:N)"
    INMOBILIARIA ||--o{ USUARIO : "emplea agentes (1:N)"
    
    USUARIO ||--|| PERFIL : "posee datos personales (1:1)"
    USUARIO ||--o{ USUARIO_ROL : "tiene asignado (N:M)"
    ROL ||--o{ USUARIO_ROL : "pertenece a (N:M)"
    
    PROPIEDAD ||--o{ IMAGEN_PROPIEDAD : "contiene fotos (1:N)"
    PROPIEDAD ||--o{ PROPIEDAD_CARACTERISTICA : "posee (N:M)"
    CARACTERISTICA ||--o{ PROPIEDAD_CARACTERISTICA : "aplica a (N:M)"
    
    USUARIO ||--o{ FAVORITO : "guarda (1:N)"
    PROPIEDAD ||--o{ FAVORITO : "es guardada en (1:N)"
    
    USUARIO ||--o{ CITA : "agenda visita (1:N)"
    PROPIEDAD ||--o{ CITA : "es visitada en (1:N)"
    
    USUARIO ||--o{ SOLICITUD : "radica trámite (1:N)"
    PROPIEDAD ||--o{ SOLICITUD : "es objeto de (1:N)"
    
    SOLICITUD ||--o{ DOCUMENTO_SOLICITUD : "adjunta expediente (1:N)"
    USUARIO ||--o{ AUDITORIA : "origina eventos (1:N)"

    USUARIO {
        int id PK
        string correo UK "UNIQUE"
        string password_hash
        string estado
        int id_inmobiliaria FK
        datetime fecha_registro
    }

    PERFIL {
        int id PK
        int id_usuario FK,UK "1:1 UNIQUE"
        string nombres
        string apellidos
        string documento_identidad UK "UNIQUE"
        string telefono
        string direccion
        string foto_url
    }

    ROL {
        int id PK
        string nombre UK "UNIQUE"
        string descripcion
    }

    USUARIO_ROL {
        int id_usuario PK,FK
        int id_rol PK,FK
        datetime fecha_asignacion
    }

    PROPIEDAD {
        int id PK
        int id_inmobiliaria FK
        int id_ciudad FK
        int id_tipo_propiedad FK
        string matricula_inmobiliaria UK "UNIQUE"
        string titulo
        decimal precio
        string tipo_operacion
        string estado "DISPONIBLE, INACTIVA..."
    }

    IMAGEN_PROPIEDAD {
        int id PK
        int id_propiedad FK
        string url_imagen
        int orden
        boolean es_principal
    }

    CARACTERISTICA {
        int id PK
        string nombre UK "UNIQUE"
        string icono
    }

    PROPIEDAD_CARACTERISTICA {
        int id_propiedad PK,FK
        int id_caracteristica PK,FK
    }

    CITA {
        int id PK
        int id_cliente FK
        int id_propiedad FK
        datetime fecha_hora "UK con id_propiedad"
        string estado "PENDIENTE, CONFIRMADA..."
    }

    SOLICITUD {
        int id PK
        int id_cliente FK
        int id_propiedad FK
        string tipo_operacion "COMPRA, ARRIENDO"
        string estado "PENDIENTE, APROBADA..."
    }

    DOCUMENTO_SOLICITUD {
        int id PK
        int id_solicitud FK
        string nombre_archivo
        string ruta_archivo
        string tipo_documento
        string estado
    }
```

---

## 2. Justificación Pedagógica de las Relaciones

### 2.1. Relación 1:1 Estricta (`usuario` ↔ `perfil`)
- **Justificación:** Se separan responsabilidades de seguridad (credenciales, contraseña con hash BCrypt y estado de cuenta) de los datos civiles del individuo (nombres, cédula, teléfono, dirección).
- **Garantía en Base de Datos:** La columna `perfil.id_usuario` cuenta con una restricción `UNIQUE` y es `FOREIGN KEY` hacia `usuario(id)`. Esto impide físicamente que un usuario tenga dos perfiles o que un perfil pertenezca a más de un usuario.

### 2.2. Relaciones 1:N Obligatorias
- **`inmobiliaria` → `propiedad`:** Cada propiedad pertenece exclusivamente a una inmobiliaria responsable, pero una inmobiliaria administra múltiples propiedades en cartera.
- **`propiedad` → `imagen_propiedad`:** Una propiedad tiene una galería de múltiples fotografías ordenadas con portada principal, pero cada imagen pertenece a un solo inmueble.
- **`cliente` → `cita`:** Un usuario cliente puede solicitar visitas a diferentes inmuebles en distintos horarios.
- **`solicitud` → `documento_solicitud`:** Un trámite de compra o arriendo exige un expediente de múltiples soportes digitales (cédula, carta laboral, extractos bancarios).

### 2.3. Relaciones N:M Obligatorias
- **`usuario` ↔ `rol` mediante `usuario_rol`:**
  - Un usuario puede tener múltiples roles (por ejemplo, el usuario `admin@inmobiliaria.com` tiene asignado simultáneamente el rol `ADMINISTRADOR` y el rol `AGENTE`).
  - Un rol pertenece a múltiples usuarios.
  - La tabla intermedia utiliza una **llave primaria compuesta** `PRIMARY KEY (id_usuario, id_rol)`, lo que evita a nivel de motor registrar dos veces el mismo rol a la misma persona.
- **`propiedad` ↔ `caracteristica` mediante `propiedad_caracteristica`:**
  - Un inmueble puede contar con piscina, gimnasio y ascensor.
  - Al mismo tiempo, la amenidad "Piscina" está presente en decenas de propiedades.
  - Llave primaria compuesta: `PRIMARY KEY (id_propiedad, id_caracteristica)`.

---

## 3. Justificación de la Tercera Forma Normal (3FN)

1. **Primera Forma Normal (1FN):**
   - Todos los atributos son atómicos (no existen campos multivaluados como listas de características o listas de URLs de fotos separadas por comas en la tabla `propiedad`).
   - Cada tabla cuenta con una Llave Primaria identificadora.
2. **Segunda Forma Normal (2FN):**
   - Cumple 1FN y todos los atributos que no forman parte de la clave primaria dependen de forma funcional completa de la llave primaria. En las tablas con llaves compuestas (`usuario_rol`, `propiedad_caracteristica`), no existen dependencias parciales.
3. **Tercera Forma Normal (3FN):**
   - Cumple 2FN y no existen dependencias transitivas (ningún campo no clave depende funcionalmente de otro campo no clave).
   - Por ejemplo, en `propiedad` no se almacena el nombre del departamento o el nombre de la ciudad; únicamente se almacena `id_ciudad`, delegando la información geográfica a la tabla `ciudad`.
