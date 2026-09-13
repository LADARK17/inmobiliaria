package com.inmobiliaria.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class SetupSupabaseDB {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-0-us-west-2.pooler.supabase.com:5432/postgres?sslmode=require";
        String user = "postgres.izvgvqqecuztatpflnwy";
        String pass = "ZwwILjIV6ISHIqr6";

        System.out.println("=================================================");
        System.out.println("INICIANDO CONFIGURACIÓN DE BASE DE DATOS EN SUPABASE");
        System.out.println("URL: " + url);
        System.out.println("Usuario: " + user);
        System.out.println("=================================================");

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            System.out.println(">>> 1. Conexión establecida con éxito con Supabase.");

            // 1. Ejecutar DDL
            System.out.println(">>> 2. Ejecutando 01_ddl_supabase_postgres.sql...");
            ejecutarScript(conn, "sql/01_ddl_supabase_postgres.sql");
            System.out.println(">>> DDL ejecutado correctamente. 16 tablas creadas.");

            // 2. Ejecutar DML
            System.out.println(">>> 3. Ejecutando 02_dml_supabase_postgres.sql...");
            ejecutarScript(conn, "sql/02_dml_supabase_postgres.sql");
            System.out.println(">>> DML ejecutado correctamente. Registros insertados.");

            // 3. Verificación
            System.out.println(">>> 4. Verificando conteo de registros por tabla:");
            String[] tablas = {
                "ciudad", "tipo_propiedad", "caracteristica", "inmobiliaria",
                "usuario", "rol", "usuario_rol", "perfil", "propiedad",
                "imagen_propiedad", "propiedad_caracteristica", "favorito",
                "cita", "solicitud", "documento_solicitud", "auditoria"
            };

            try (Statement st = conn.createStatement()) {
                for (String t : tablas) {
                    try (ResultSet rs = st.executeQuery("SELECT count(*) FROM " + t)) {
                        if (rs.next()) {
                            System.out.println("   - Tabla " + String.format("%-25s", t) + ": " + rs.getInt(1) + " registros");
                        }
                    }
                }
            }

            System.out.println("=================================================");
            System.out.println("¡SUPABASE CONFIGURADO Y VERIFICADO EXITOSAMENTE!");
            System.out.println("=================================================");

        } catch (Exception e) {
            System.err.println("Error durante la configuración de Supabase: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void ejecutarScript(Connection conn, String recurso) throws Exception {
        try (InputStream is = SetupSupabaseDB.class.getClassLoader().getResourceAsStream(recurso);
             BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            
            StringBuilder sb = new StringBuilder();
            String linea;
            try (Statement st = conn.createStatement()) {
                while ((linea = reader.readLine()) != null) {
                    String trim = linea.trim();
                    if (trim.startsWith("--") || trim.isEmpty()) {
                        continue;
                    }
                    sb.append(" ").append(trim);
                    if (trim.endsWith(";")) {
                        String sql = sb.toString().trim();
                        if (sql.endsWith(";")) {
                            sql = sql.substring(0, sql.length() - 1);
                        }
                        sb.setLength(0);
                        if (!sql.isEmpty()) {
                            try {
                                st.execute(sql);
                            } catch (Exception e) {
                                System.err.println("Fallo al ejecutar SQL: " + sql);
                                throw e;
                            }
                        }
                    }
                }
            }
        }
    }
}
