package com.inmobiliaria.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Conexión centralizada a la base de datos relacional mediante JDBC.
 * Lee la configuración desde db.properties y centraliza el manejo de excepciones de integridad.
 */
public class DatabaseConnection {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());
    private static Properties props = new Properties();

    static {
        try (InputStream input = DatabaseConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
            } else {
                LOGGER.warning("Archivo db.properties no encontrado en classpath. Usando valores por defecto.");
                props.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                props.setProperty("db.url", "jdbc:mysql://localhost:3306/inmobiliaria_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Bogota&characterEncoding=UTF-8");
                props.setProperty("db.user", "root");
                props.setProperty("db.password", "");
            }
            Class.forName(props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver"));
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al inicializar el driver JDBC o cargar db.properties", e);
        }
    }

    /**
     * Obtiene una nueva conexión activa con la base de datos.
     */
    public static Connection getConnection() throws SQLException {
        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user", "root");
        String password = props.getProperty("db.password", "");
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Convierte excepciones técnicas de integridad de SQL en mensajes amigables y comprensibles para el usuario.
     */
    public static String translateSQLException(SQLException ex) {
        if (ex instanceof SQLIntegrityConstraintViolationException || ex.getErrorCode() == 1062) {
            String msg = ex.getMessage();
            if (msg != null) {
                String lower = msg.toLowerCase();
                if (lower.contains("correo") || lower.contains("usuario.correo")) {
                    return "El correo electrónico ya se encuentra registrado en el sistema.";
                } else if (lower.contains("matricula") || lower.contains("matricula_inmobiliaria")) {
                    return "La matrícula inmobiliaria ya pertenece a otra propiedad registrada.";
                } else if (lower.contains("uq_cita") || lower.contains("fecha_hora")) {
                    return "Ya existe una cita programada para esta propiedad exactamente en esa misma fecha y hora.";
                } else if (lower.contains("documento_identidad")) {
                    return "El documento de identidad ingresado ya se encuentra registrado en otro perfil.";
                } else if (lower.contains("favorito") || lower.contains("uq_favorito")) {
                    return "Esta propiedad ya se encuentra guardada en tus favoritos.";
                } else if (lower.contains("usuariorol") || lower.contains("usuario_rol")) {
                    return "El usuario ya tiene asignado dicho rol en el sistema.";
                }
            }
            return "No se pudo guardar la información porque ya existe un registro con datos idénticos.";
        } else if (ex.getErrorCode() == 1451 || ex.getErrorCode() == 1452) {
            return "No es posible realizar esta acción porque el registro está relacionado con otras entidades activas (citas, solicitudes o favoritos).";
        }
        return "Ocurrió un error al procesar la solicitud en la base de datos. Por favor intente más tarde.";
    }
}
