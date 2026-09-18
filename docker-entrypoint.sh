#!/bin/sh
# ─────────────────────────────────────────────────────────────
# Genera db.properties desde variables de entorno de Railway
# y arranca Tomcat
# ─────────────────────────────────────────────────────────────

DB_PROPS="/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/db.properties"

# Esperar a que el WAR se despliegue (Tomcat lo extrae al inicio)
# Arrancamos Tomcat en background brevemente para que extraiga el WAR
catalina.sh start
sleep 8

# Escribir credenciales desde variables de entorno
mkdir -p "$(dirname $DB_PROPS)"
cat > "$DB_PROPS" <<EOF
# Generado automáticamente por docker-entrypoint.sh
db.driver=${DB_DRIVER:-org.postgresql.Driver}
db.url=${DB_URL}
db.user=${DB_USER}
db.password=${DB_PASSWORD}
db.pool.maxConnections=10
db.pool.timeoutSeconds=10
cloud.name=${CLOUD_NAME}
cloud.apiKey=${CLOUD_API_KEY}
cloud.apiSecret=${CLOUD_API_SECRET}
EOF

echo "✅ db.properties generado correctamente"

# Mantener Tomcat corriendo en foreground
catalina.sh run
