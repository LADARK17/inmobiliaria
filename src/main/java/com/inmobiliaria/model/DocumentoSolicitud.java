package com.inmobiliaria.model;

import java.time.LocalDateTime;

public class DocumentoSolicitud {
    private int id;
    private int idSolicitud;
    private String nombreArchivo;
    private String rutaArchivo;
    private String tipoDocumento;
    private String estado; // 'SUBIDO', 'APROBADO', 'RECHAZADO'
    private LocalDateTime fechaSubida;

    public DocumentoSolicitud() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }
    public String getNombreArchivo() { return nombreArchivo; }
    public void setNombreArchivo(String nombreArchivo) { this.nombreArchivo = nombreArchivo; }
    public String getRutaArchivo() { return rutaArchivo; }
    public void setRutaArchivo(String rutaArchivo) { this.rutaArchivo = rutaArchivo; }
    public String getTipoDocumento() { return tipoDocumento; }
    public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public LocalDateTime getFechaSubida() { return fechaSubida; }
    public void setFechaSubida(LocalDateTime fechaSubida) { this.fechaSubida = fechaSubida; }
}
