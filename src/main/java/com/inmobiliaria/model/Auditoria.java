package com.inmobiliaria.model;

import java.time.LocalDateTime;

public class Auditoria {
    private int id;
    private Integer idUsuario;
    private String usuarioCorreo;
    private String accion;
    private String entidadAfectada;
    private Integer idEntidad;
    private String detalles;
    private String ipOrigen;
    private LocalDateTime fechaHora;

    public Auditoria() {}

    public Auditoria(Integer idUsuario, String accion, String entidadAfectada, Integer idEntidad, String detalles, String ipOrigen) {
        this.idUsuario = idUsuario;
        this.accion = accion;
        this.entidadAfectada = entidadAfectada;
        this.idEntidad = idEntidad;
        this.detalles = detalles;
        this.ipOrigen = ipOrigen;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }
    public String getUsuarioCorreo() { return usuarioCorreo; }
    public void setUsuarioCorreo(String usuarioCorreo) { this.usuarioCorreo = usuarioCorreo; }
    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }
    public String getEntidadAfectada() { return entidadAfectada; }
    public void setEntidadAfectada(String entidadAfectada) { this.entidadAfectada = entidadAfectada; }
    public Integer getIdEntidad() { return idEntidad; }
    public void setIdEntidad(Integer idEntidad) { this.idEntidad = idEntidad; }
    public String getDetalles() { return detalles; }
    public void setDetalles(String detalles) { this.detalles = detalles; }
    public String getIpOrigen() { return ipOrigen; }
    public void setIpOrigen(String ipOrigen) { this.ipOrigen = ipOrigen; }
    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }
}
