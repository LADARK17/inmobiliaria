package com.inmobiliaria.model;

import java.time.LocalDateTime;

public class Cita {
    private int id;
    private int idCliente;
    private int idPropiedad;
    private LocalDateTime fechaHora;
    private String estado; // 'PENDIENTE', 'CONFIRMADA', 'REALIZADA', 'CANCELADA'
    private String comentarios;
    private LocalDateTime fechaCreacion;

    // Campos enriquecidos para visualización
    private String clienteNombre;
    private String clienteCorreo;
    private String clienteTelefono;
    private String propiedadTitulo;
    private String propiedadMatricula;
    private String propiedadDireccion;
    private String inmobiliariaNombre;

    public Cita() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }
    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getComentarios() { return comentarios; }
    public void setComentarios(String comentarios) { this.comentarios = comentarios; }
    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }

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
    public String getPropiedadDireccion() { return propiedadDireccion; }
    public void setPropiedadDireccion(String propiedadDireccion) { this.propiedadDireccion = propiedadDireccion; }
    public String getInmobiliariaNombre() { return inmobiliariaNombre; }
    public void setInmobiliariaNombre(String inmobiliariaNombre) { this.inmobiliariaNombre = inmobiliariaNombre; }
}
