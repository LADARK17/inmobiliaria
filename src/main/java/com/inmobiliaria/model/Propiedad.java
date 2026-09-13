package com.inmobiliaria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Representa un inmueble publicado en la plataforma.
 * Incluye datos maestros, relaciones 1:N (imágenes) y N:M (características).
 */
public class Propiedad {
    private int id;
    private int idInmobiliaria;
    private int idCiudad;
    private int idTipoPropiedad;
    private String matriculaInmobiliaria;
    private String titulo;
    private String descripcion;
    private BigDecimal precio;
    private BigDecimal areaM2;
    private int habitaciones;
    private int banos;
    private int estrato;
    private String direccion;
    private boolean destacada;
    private String tipoOperacion; // 'VENTA', 'ARRIENDO'
    private String estado; // 'DISPONIBLE', 'RESERVADA', 'VENDIDA', 'ARRENDADA', 'INACTIVA'
    private LocalDateTime fechaPublicacion;

    // Campos enriquecidos por JOINs para la capa de presentación
    private String ciudadNombre;
    private String departamentoNombre;
    private String tipoPropiedadNombre;
    private String inmobiliariaNombre;
    private String inmobiliariaTelefono;
    private String inmobiliariaCorreo;
    private String imagenPrincipalUrl;

    // Relaciones
    private List<ImagenPropiedad> imagenes = new ArrayList<>(); // 1:N
    private List<Caracteristica> caracteristicas = new ArrayList<>(); // N:M

    public Propiedad() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdInmobiliaria() { return idInmobiliaria; }
    public void setIdInmobiliaria(int idInmobiliaria) { this.idInmobiliaria = idInmobiliaria; }
    public int getIdCiudad() { return idCiudad; }
    public void setIdCiudad(int idCiudad) { this.idCiudad = idCiudad; }
    public int getIdTipoPropiedad() { return idTipoPropiedad; }
    public void setIdTipoPropiedad(int idTipoPropiedad) { this.idTipoPropiedad = idTipoPropiedad; }
    public String getMatriculaInmobiliaria() { return matriculaInmobiliaria; }
    public void setMatriculaInmobiliaria(String matriculaInmobiliaria) { this.matriculaInmobiliaria = matriculaInmobiliaria; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }
    public BigDecimal getAreaM2() { return areaM2; }
    public void setAreaM2(BigDecimal areaM2) { this.areaM2 = areaM2; }
    public int getHabitaciones() { return habitaciones; }
    public void setHabitaciones(int habitaciones) { this.habitaciones = habitaciones; }
    public int getBanos() { return banos; }
    public void setBanos(int banos) { this.banos = banos; }
    public int getEstrato() { return estrato; }
    public void setEstrato(int estrato) { this.estrato = estrato; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    public boolean isDestacada() { return destacada; }
    public void setDestacada(boolean destacada) { this.destacada = destacada; }
    public String getTipoOperacion() { return tipoOperacion; }
    public void setTipoOperacion(String tipoOperacion) { this.tipoOperacion = tipoOperacion; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public LocalDateTime getFechaPublicacion() { return fechaPublicacion; }
    public void setFechaPublicacion(LocalDateTime fechaPublicacion) { this.fechaPublicacion = fechaPublicacion; }

    public String getCiudadNombre() { return ciudadNombre; }
    public void setCiudadNombre(String ciudadNombre) { this.ciudadNombre = ciudadNombre; }
    public String getDepartamentoNombre() { return departamentoNombre; }
    public void setDepartamentoNombre(String departamentoNombre) { this.departamentoNombre = departamentoNombre; }
    public String getTipoPropiedadNombre() { return tipoPropiedadNombre; }
    public void setTipoPropiedadNombre(String tipoPropiedadNombre) { this.tipoPropiedadNombre = tipoPropiedadNombre; }
    public String getInmobiliariaNombre() { return inmobiliariaNombre; }
    public void setInmobiliariaNombre(String inmobiliariaNombre) { this.inmobiliariaNombre = inmobiliariaNombre; }
    public String getInmobiliariaTelefono() { return inmobiliariaTelefono; }
    public void setInmobiliariaTelefono(String inmobiliariaTelefono) { this.inmobiliariaTelefono = inmobiliariaTelefono; }
    public String getInmobiliariaCorreo() { return inmobiliariaCorreo; }
    public void setInmobiliariaCorreo(String inmobiliariaCorreo) { this.inmobiliariaCorreo = inmobiliariaCorreo; }
    public String getImagenPrincipalUrl() { return imagenPrincipalUrl; }
    public void setImagenPrincipalUrl(String imagenPrincipalUrl) { this.imagenPrincipalUrl = imagenPrincipalUrl; }

    public List<ImagenPropiedad> getImagenes() { return imagenes; }
    public void setImagenes(List<ImagenPropiedad> imagenes) { this.imagenes = imagenes; }
    public List<Caracteristica> getCaracteristicas() { return caracteristicas; }
    public void setCaracteristicas(List<Caracteristica> caracteristicas) { this.caracteristicas = caracteristicas; }
}
