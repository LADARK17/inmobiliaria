package com.inmobiliaria.util;

import com.inmobiliaria.config.DatabaseConnection;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utilidad para carga segura de fotografías a almacenamiento en la nube.
 * Genera URLs públicas permanentes para las propiedades inmobiliarias.
 */
public class CloudUploadUtil {

    private static String cloudName = "dxkjiiswe";
    private static String apiKey = "167357169758268";
    private static String apiSecret = "wcIqMuS43-vzu4H_sTYrwba_Ulo";

    static {
        cargarConfiguracion();
    }

    private static void cargarConfiguracion() {
        try (InputStream is = CloudUploadUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                if (props.containsKey("cloud.name")) cloudName = props.getProperty("cloud.name").trim();
                if (props.containsKey("cloud.apiKey")) apiKey = props.getProperty("cloud.apiKey").trim();
                if (props.containsKey("cloud.apiSecret")) apiSecret = props.getProperty("cloud.apiSecret").trim();
            }
        } catch (Exception e) {
            System.err.println("Aviso: usando configuración por defecto para almacenamiento en la nube: " + e.getMessage());
        }
    }

    /**
     * Sube un archivo binario de imagen al servicio en la nube y retorna la URL segura generada.
     *
     * @param imageBytes Bytes de la imagen
     * @param fileName   Nombre original del archivo
     * @return URL pública segura (HTTPS) de la fotografía
     * @throws Exception Si ocurre un error de red o en la respuesta
     */
    public static String subirImagen(byte[] imageBytes, String fileName) throws Exception {
        if (imageBytes == null || imageBytes.length == 0) {
            throw new IllegalArgumentException("El archivo de imagen no contiene datos.");
        }

        long timestamp = System.currentTimeMillis() / 1000L;
        String stringToSign = "timestamp=" + timestamp + apiSecret;
        String signature = calcularSha1(stringToSign);

        String endpoint = "https://api.cloudinary.com/v1_1/" + cloudName + "/image/upload";
        String boundary = "===Boundary" + System.currentTimeMillis() + "===";

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(30000);

        try (OutputStream outputStream = conn.getOutputStream();
             PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream, StandardCharsets.UTF_8), true)) {

            // Campo api_key
            writer.append("--").append(boundary).append("\r\n");
            writer.append("Content-Disposition: form-data; name=\"api_key\"\r\n\r\n");
            writer.append(apiKey).append("\r\n");
            writer.flush();

            // Campo timestamp
            writer.append("--").append(boundary).append("\r\n");
            writer.append("Content-Disposition: form-data; name=\"timestamp\"\r\n\r\n");
            writer.append(String.valueOf(timestamp)).append("\r\n");
            writer.flush();

            // Campo signature
            writer.append("--").append(boundary).append("\r\n");
            writer.append("Content-Disposition: form-data; name=\"signature\"\r\n\r\n");
            writer.append(signature).append("\r\n");
            writer.flush();

            // Campo file (binario)
            String safeFileName = (fileName != null && !fileName.trim().isEmpty()) ? fileName : "propiedad_" + timestamp + ".jpg";
            writer.append("--").append(boundary).append("\r\n");
            writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"").append(safeFileName).append("\"\r\n");
            writer.append("Content-Type: image/jpeg\r\n\r\n");
            writer.flush();

            outputStream.write(imageBytes);
            outputStream.flush();

            writer.append("\r\n");
            writer.append("--").append(boundary).append("--\r\n");
            writer.flush();
        }

        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode >= 200 && responseCode < 300) ? conn.getInputStream() : conn.getErrorStream();

        StringBuilder responseBody = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                responseBody.append(line);
            }
        }

        if (responseCode >= 200 && responseCode < 300) {
            Pattern pattern = Pattern.compile("\"secure_url\"\\s*:\\s*\"([^\"]+)\"");
            Matcher matcher = pattern.matcher(responseBody.toString());
            if (matcher.find()) {
                return matcher.group(1).replace("\\/", "/");
            }
            throw new IOException("Respuesta del servidor sin URL segura: " + responseBody);
        } else {
            throw new IOException("Error al subir imagen (Código " + responseCode + "): " + responseBody);
        }
    }

    private static String calcularSha1(String input) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-1");
        byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
        StringBuilder hexString = new StringBuilder();
        for (byte b : digest) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }
}
