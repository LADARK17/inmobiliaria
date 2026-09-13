package com.inmobiliaria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Solicitud {
    private int id;
    private int idCliente;
    private int idPropiedad;
    private String tipoOperacion; // 'COMPRA', 'ARRIENDO'
    private String estado; // 'PENDIENTE', 'EN_REVISION', 'APROBADA', 'RECHAZADA'
    private String observaciones;
    private LocalDateTime fechaSolicitud;
    private LocalDateTime fechaActualizacion;

    // Campos enriquecidos
    private String clienteNombre;
    private String clienteCorreo;
    private String clienteTelefono;
    private String propiedadTitulo;
    private String propiedadMatricula;
    private BigDecimal propiedadPrecio;
    private String propiedadDireccion;
    private String inmobiliariaNombre;

    // Relación 1:N con documentos radicados
    private List<DocumentoSolicitud> documentos = new ArrayList<>();

    public Solicitud() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }
    public String getTipoOperacion() { return tipoOperacion; }
    public void setTipoOperacion(String tipoOperacion) { this.tipoOperacion = tipoOperacion; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
    public LocalDateTime getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(LocalDateTime fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }
    public LocalDateTime getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(LocalDateTime fechaActualizacion) { this.fechaActualizacion = fechaActualizacion; }

    public String getClienteNombre() { return clienteNombre; }
    public void setClienteNombre(String clienteNombre) { this.clienteNombre = clienteNombre; }
    public String getClienteCorreo() { return clienteCorreo; }
    public void setClienteCorreo(String clienteCorreo) { this.clienteCorreo = clienteCorreo; }
    public String getClienteTelefono() { return clienteTelefono; }
    public void setClienteTelefono(String clienteTelefono) { this.clienteTelefono = clienteTelefono; }
    public String getPropiedadTitulo() { return propiedadTitulo; }
    public void setPropiedadTitulo(String propiedadTitulo) { this.propiedadTitulo = propiedadTitulo; }
    public String getPropiedadMatricula() { return propiedadMatricula; }
    public void setPropiedadMatricula(String propiedadMatricula) { this.propiedadMatricula = propiedadMatricula; }
    public BigDecimal getPropiedadPrecio() { return propiedadPrecio; }
    public void setPropiedadPrecio(BigDecimal propiedadPrecio) { this.propiedadPrecio = propiedadPrecio; }
    public String getPropiedadDireccion() { return propiedadDireccion; }
    public void setPropiedadDireccion(String propiedadDireccion) { this.propiedadDireccion = propiedadDireccion; }
    public String getInmobiliariaNombre() { return inmobiliariaNombre; }
    public void setInmobiliariaNombre(String inmobiliariaNombre) { this.inmobiliariaNombre = inmobiliariaNombre; }

    public List<DocumentoSolicitud> getDocumentos() { return documentos; }
    public void setDocumentos(List<DocumentoSolicitud> documentos) { this.documentos = documentos; }
}
