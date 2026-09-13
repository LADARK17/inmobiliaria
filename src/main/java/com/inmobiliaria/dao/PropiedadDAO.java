package com.inmobiliaria.dao;

import com.inmobiliaria.config.DatabaseConnection;
import com.inmobiliaria.model.*;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PropiedadDAO {

    public List<Propiedad> listarDestacadas(int limit) throws SQLException {
        String sql = "SELECT p.*, c.nombre AS ciudad_nombre, c.departamento AS depto_nombre, " +
                     "tp.nombre AS tipo_nombre, inm.nombre AS inmobiliaria_nombre, " +
                     "img.url_imagen AS img_principal " +
                     "FROM propiedad p " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id " +
                     "INNER JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "LEFT JOIN imagen_propiedad img ON p.id = img.id_propiedad AND img.es_principal = TRUE " +
                     "WHERE p.destacada = TRUE AND p.estado = 'DISPONIBLE' " +
                     "ORDER BY p.id DESC LIMIT ?";

        List<Propiedad> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapPropiedadConDetalles(rs));
                }
            }
        }
        return lista;
    }

    public List<Propiedad> buscarConFiltros(Integer idCiudad, Integer idTipo, BigDecimal precioMin, 
                                            BigDecimal precioMax, String tipoOperacion, 
                                            List<Integer> idCaracteristicas) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT p.*, c.nombre AS ciudad_nombre, c.departamento AS depto_nombre, " +
            "tp.nombre AS tipo_nombre, inm.nombre AS inmobiliaria_nombre, " +
            "(SELECT img.url_imagen FROM imagen_propiedad img WHERE img.id_propiedad = p.id ORDER BY img.es_principal DESC, img.orden ASC LIMIT 1) AS img_principal " +
            "FROM propiedad p " +
            "INNER JOIN ciudad c ON p.id_ciudad = c.id " +
            "INNER JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id " +
            "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
            "WHERE p.estado != 'INACTIVA' "
        );

        List<Object> params = new ArrayList<>();

        if (idCiudad != null && idCiudad > 0) {
            sql.append(" AND p.id_ciudad = ? ");
            params.add(idCiudad);
        }
        if (idTipo != null && idTipo > 0) {
            sql.append(" AND p.id_tipo_propiedad = ? ");
            params.add(idTipo);
        }
        if (tipoOperacion != null && !tipoOperacion.trim().isEmpty()) {
            sql.append(" AND p.tipo_operacion = ? ");
            params.add(tipoOperacion.trim().toUpperCase());
        }
        if (precioMin != null && precioMin.compareTo(BigDecimal.ZERO) > 0) {
            sql.append(" AND p.precio >= ? ");
            params.add(precioMin);
        }
        if (precioMax != null && precioMax.compareTo(BigDecimal.ZERO) > 0) {
            sql.append(" AND p.precio <= ? ");
            params.add(precioMax);
        }
        if (idCaracteristicas != null && !idCaracteristicas.isEmpty()) {
            sql.append(" AND p.id IN (SELECT pc.id_propiedad FROM propiedad_caracteristica pc WHERE pc.id_caracteristica IN (");
            for (int i = 0; i < idCaracteristicas.size(); i++) {
                sql.append(i == 0 ? "?" : ", ?");
                params.add(idCaracteristicas.get(i));
            }
            sql.append(") GROUP BY pc.id_propiedad HAVING COUNT(DISTINCT pc.id_caracteristica) = ?) ");
            params.add(idCaracteristicas.size());
        }

        sql.append(" ORDER BY p.id DESC");

        List<Propiedad> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapPropiedadConDetalles(rs));
                }
            }
        }
        return lista;
    }

    public Propiedad obtenerPorId(int idPropiedad) throws SQLException {
        String sql = "SELECT p.*, c.nombre AS ciudad_nombre, c.departamento AS depto_nombre, " +
                     "tp.nombre AS tipo_nombre, inm.nombre AS inmobiliaria_nombre, " +
                     "inm.telefono AS inm_telefono, inm.correo AS inm_correo " +
                     "FROM propiedad p " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id " +
                     "INNER JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "WHERE p.id = ?";

        Propiedad prop = null;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    prop = mapPropiedadConDetalles(rs);
                    prop.setInmobiliariaTelefono(rs.getString("inm_telefono"));
                    prop.setInmobiliariaCorreo(rs.getString("inm_correo"));
                    cargarImagenes(conn, prop);
                    cargarCaracteristicas(conn, prop);
                }
            }
        }
        return prop;
    }

    public List<Propiedad> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = "SELECT p.*, c.nombre AS ciudad_nombre, c.departamento AS depto_nombre, " +
                     "tp.nombre AS tipo_nombre, inm.nombre AS inmobiliaria_nombre, " +
                     "(SELECT img.url_imagen FROM imagen_propiedad img WHERE img.id_propiedad = p.id ORDER BY img.es_principal DESC LIMIT 1) AS img_principal " +
                     "FROM propiedad p " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id " +
                     "INNER JOIN tipo_propiedad tp ON p.id_tipo_propiedad = tp.id " +
                     "INNER JOIN inmobiliaria inm ON p.id_inmobiliaria = inm.id " +
                     "WHERE p.id_inmobiliaria = ? " +
                     "ORDER BY p.id DESC";

        List<Propiedad> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idInmobiliaria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapPropiedadConDetalles(rs));
                }
            }
        }
        return lista;
    }

    public boolean insertar(Propiedad p, List<Integer> idCaracteristicas, List<String> imagenesUrls) throws SQLException {
        String sqlPropiedad = "INSERT INTO propiedad (id_inmobiliaria, id_ciudad, id_tipo_propiedad, matricula_inmobiliaria, " +
                              "titulo, descripcion, precio, area_m2, habitaciones, banos, estrato, direccion, destacada, tipo_operacion, estado) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlCarac = "INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES (?, ?)";
        String sqlImg = "INSERT INTO imagen_propiedad (id_propiedad, url_imagen, orden, es_principal) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int idProp;
            try (PreparedStatement psP = conn.prepareStatement(sqlPropiedad, Statement.RETURN_GENERATED_KEYS)) {
                psP.setInt(1, p.getIdInmobiliaria());
                psP.setInt(2, p.getIdCiudad());
                psP.setInt(3, p.getIdTipoPropiedad());
                psP.setString(4, p.getMatriculaInmobiliaria());
                psP.setString(5, p.getTitulo());
                psP.setString(6, p.getDescripcion());
                psP.setBigDecimal(7, p.getPrecio());
                psP.setBigDecimal(8, p.getAreaM2());
                psP.setInt(9, p.getHabitaciones());
                psP.setInt(10, p.getBanos());
                psP.setInt(11, p.getEstrato());
                psP.setString(12, p.getDireccion());
                psP.setBoolean(13, p.isDestacada());
                psP.setString(14, p.getTipoOperacion());
                psP.setString(15, p.getEstado() != null ? p.getEstado() : "DISPONIBLE");
                psP.executeUpdate();

                try (ResultSet keys = psP.getGeneratedKeys()) {
                    if (keys.next()) {
                        idProp = keys.getInt(1);
                        p.setId(idProp);
                    } else {
                        throw new SQLException("Error al recuperar el ID de la propiedad creada.");
                    }
                }
            }

            if (idCaracteristicas != null && !idCaracteristicas.isEmpty()) {
                try (PreparedStatement psC = conn.prepareStatement(sqlCarac)) {
                    for (int idCar : idCaracteristicas) {
                        psC.setInt(1, idProp);
                        psC.setInt(2, idCar);
                        psC.addBatch();
                    }
                    psC.executeBatch();
                }
            }

            if (imagenesUrls != null && !imagenesUrls.isEmpty()) {
                try (PreparedStatement psI = conn.prepareStatement(sqlImg)) {
                    int orden = 1;
                    for (String url : imagenesUrls) {
                        if (url != null && !url.trim().isEmpty()) {
                            psI.setInt(1, idProp);
                            psI.setString(2, url.trim());
                            psI.setInt(3, orden);
                            psI.setBoolean(4, orden == 1);
                            psI.addBatch();
                            orden++;
                        }
                    }
                    psI.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignored */ }
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { /* ignored */ }
            }
        }
    }

    public boolean actualizar(Propiedad p, List<Integer> idCaracteristicas) throws SQLException {
        String sql = "UPDATE propiedad SET id_ciudad = ?, id_tipo_propiedad = ?, matricula_inmobiliaria = ?, " +
                     "titulo = ?, descripcion = ?, precio = ?, area_m2 = ?, habitaciones = ?, banos = ?, " +
                     "estrato = ?, direccion = ?, destacada = ?, tipo_operacion = ?, estado = ? " +
                     "WHERE id = ?";

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, p.getIdCiudad());
                ps.setInt(2, p.getIdTipoPropiedad());
                ps.setString(3, p.getMatriculaInmobiliaria());
                ps.setString(4, p.getTitulo());
                ps.setString(5, p.getDescripcion());
                ps.setBigDecimal(6, p.getPrecio());
                ps.setBigDecimal(7, p.getAreaM2());
                ps.setInt(8, p.getHabitaciones());
                ps.setInt(9, p.getBanos());
                ps.setInt(10, p.getEstrato());
                ps.setString(11, p.getDireccion());
                ps.setBoolean(12, p.isDestacada());
                ps.setString(13, p.getTipoOperacion());
                ps.setString(14, p.getEstado());
                ps.setInt(15, p.getId());
                ps.executeUpdate();
            }

            if (idCaracteristicas != null) {
                try (PreparedStatement psDel = conn.prepareStatement("DELETE FROM propiedad_caracteristica WHERE id_propiedad = ?")) {
                    psDel.setInt(1, p.getId());
                    psDel.executeUpdate();
                }

                if (!idCaracteristicas.isEmpty()) {
                    try (PreparedStatement psIns = conn.prepareStatement("INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES (?, ?)")) {
                        for (int idCar : idCaracteristicas) {
                            psIns.setInt(1, p.getId());
                            psIns.setInt(2, idCar);
                            psIns.addBatch();
                        }
                        psIns.executeBatch();
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignored */ }
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { /* ignored */ }
            }
        }
    }

    /**
     * Baja lógica obligatoria: no elimina el registro físico para preservar integridad de citas y trámites.
     */
    public boolean bajaLogica(int idPropiedad) throws SQLException {
        String sql = "UPDATE propiedad SET estado = 'INACTIVA' WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Ciudad> listarCiudades() throws SQLException {
        List<Ciudad> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, departamento FROM ciudad ORDER BY nombre ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Ciudad(rs.getInt("id"), rs.getString("nombre"), rs.getString("departamento")));
            }
        }
        return lista;
    }

    public List<TipoPropiedad> listarTiposPropiedad() throws SQLException {
        List<TipoPropiedad> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion FROM tipo_propiedad ORDER BY nombre ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new TipoPropiedad(rs.getInt("id"), rs.getString("nombre"), rs.getString("descripcion")));
            }
        }
        return lista;
    }

    public List<Caracteristica> listarCaracteristicas() throws SQLException {
        List<Caracteristica> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, icono FROM caracteristica ORDER BY nombre ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Caracteristica(rs.getInt("id"), rs.getString("nombre"), rs.getString("icono")));
            }
        }
        return lista;
    }

    public List<Inmobiliaria> listarInmobiliarias() throws SQLException {
        List<Inmobiliaria> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, nit, telefono, correo, direccion, logo_url FROM inmobiliaria ORDER BY nombre ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Inmobiliaria in = new Inmobiliaria();
                in.setId(rs.getInt("id"));
                in.setNombre(rs.getString("nombre"));
                in.setNit(rs.getString("nit"));
                in.setTelefono(rs.getString("telefono"));
                in.setCorreo(rs.getString("correo"));
                in.setDireccion(rs.getString("direccion"));
                in.setLogoUrl(rs.getString("logo_url"));
                lista.add(in);
            }
        }
        return lista;
    }

    private void cargarImagenes(Connection conn, Propiedad p) throws SQLException {
        String sql = "SELECT id, id_propiedad, url_imagen, orden, es_principal, descripcion " +
                     "FROM imagen_propiedad WHERE id_propiedad = ? ORDER BY orden ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<ImagenPropiedad> imgs = new ArrayList<>();
                while (rs.next()) {
                    imgs.add(new ImagenPropiedad(
                        rs.getInt("id"),
                        rs.getInt("id_propiedad"),
                        rs.getString("url_imagen"),
                        rs.getInt("orden"),
                        rs.getBoolean("es_principal"),
                        rs.getString("descripcion")
                    ));
                }
                p.setImagenes(imgs);
            }
        }
    }

    private void cargarCaracteristicas(Connection conn, Propiedad p) throws SQLException {
        String sql = "SELECT c.id, c.nombre, c.icono " +
                     "FROM caracteristica c " +
                     "INNER JOIN propiedad_caracteristica pc ON c.id = pc.id_caracteristica " +
                     "WHERE pc.id_propiedad = ? ORDER BY c.nombre ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getId());
            try (ResultSet rs = ps.executeQuery()) {
                List<Caracteristica> caracs = new ArrayList<>();
                while (rs.next()) {
                    caracs.add(new Caracteristica(rs.getInt("id"), rs.getString("nombre"), rs.getString("icono")));
                }
                p.setCaracteristicas(caracs);
            }
        }
    }

    private Propiedad mapPropiedadConDetalles(ResultSet rs) throws SQLException {
        Propiedad p = new Propiedad();
        p.setId(rs.getInt("id"));
        p.setIdInmobiliaria(rs.getInt("id_inmobiliaria"));
        p.setIdCiudad(rs.getInt("id_ciudad"));
        p.setIdTipoPropiedad(rs.getInt("id_tipo_propiedad"));
        p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setAreaM2(rs.getBigDecimal("area_m2"));
        p.setHabitaciones(rs.getInt("habitaciones"));
        p.setBanos(rs.getInt("banos"));
        p.setEstrato(rs.getInt("estrato"));
        p.setDireccion(rs.getString("direccion"));
        p.setDestacada(rs.getBoolean("destacada"));
        p.setTipoOperacion(rs.getString("tipo_operacion"));
        p.setEstado(rs.getString("estado"));
        Timestamp ts = rs.getTimestamp("fecha_publicacion");
        if (ts != null) p.setFechaPublicacion(ts.toLocalDateTime());

        p.setCiudadNombre(rs.getString("ciudad_nombre"));
        p.setDepartamentoNombre(rs.getString("depto_nombre"));
        p.setTipoPropiedadNombre(rs.getString("tipo_nombre"));
        p.setInmobiliariaNombre(rs.getString("inmobiliaria_nombre"));

        try {
            p.setImagenPrincipalUrl(rs.getString("img_principal"));
        } catch (SQLException ignored) {
            p.setImagenPrincipalUrl("https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800");
        }
        if (p.getImagenPrincipalUrl() == null || p.getImagenPrincipalUrl().isEmpty()) {
            p.setImagenPrincipalUrl("https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800");
        }
        return p;
    }
}
