package com.inmobiliaria.controller;

import com.inmobiliaria.util.CloudUploadUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

@WebServlet(name = "UploadImagenServlet", urlPatterns = {"/upload-imagen", "/agente/upload-imagen"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB en memoria
        maxFileSize = 1024 * 1024 * 15,      // 15 MB por archivo
        maxRequestSize = 1024 * 1024 * 30    // 30 MB por petición total
)
public class UploadImagenServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");

        try {
            Part filePart = req.getPart("foto");
            if (filePart == null) {
                filePart = req.getPart("file");
            }

            if (filePart == null || filePart.getSize() == 0) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\": false, \"mensaje\": \"No se recibió ningún archivo de imagen.\"}");
                return;
            }

            String submittedName = filePart.getSubmittedFileName();
            byte[] bytes;
            try (InputStream is = filePart.getInputStream();
                 ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
                byte[] chunk = new byte[8192];
                int read;
                while ((read = is.read(chunk, 0, chunk.length)) != -1) {
                    buffer.write(chunk, 0, read);
                }
                bytes = buffer.toByteArray();
            }

            String urlPublica = CloudUploadUtil.subirImagen(bytes, submittedName);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"success\": true, \"url\": \"" + urlPublica + "\", \"nombre\": \"" + escapeJson(submittedName) + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Error al procesar la carga de imagen.";
            resp.getWriter().write("{\"success\": false, \"mensaje\": \"" + escapeJson(errorMsg) + "\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }
}
