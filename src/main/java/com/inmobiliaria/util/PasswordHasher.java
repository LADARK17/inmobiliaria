package com.inmobiliaria.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utilidad de seguridad para hashing y verificación de contraseñas.
 * Implementa el algoritmo BCrypt con salt rounds adaptativo.
 */
public class PasswordHasher {

    private static final int LOG_ROUNDS = 10;

    /**
     * Genera un hash seguro BCrypt a partir de la contraseña en texto plano.
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("La contraseña no puede estar vacía");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(LOG_ROUNDS));
    }

    /**
     * Valida si una contraseña en texto plano coincide con el hash almacenado en base de datos.
     */
    public static boolean check(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.trim().isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}
