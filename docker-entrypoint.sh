#!/bin/sh
# ─────────────────────────────────────────────────────────────
# Genera db.properties desde variables de entorno de Railway
# y arranca Tomcat (UNA SOLA VEZ en foreground)
# ─────────────────────────────────────────────────────────────

set -e

CATALINA_HOME=/usr/local/tomcat
WEBAPPS_DIR="$CATALINA_HOME/webapps/ROOT"
DB_PROPS="$WEBAPPS_DIR/WEB-INF/classes/db.properties"

echo "⏳ Extrayendo WAR..."
# Extraer el WAR manualmente antes de iniciar Tomcat
mkdir -p "$WEBAPPS_DIR"
cd "$WEBAPPS_DIR"
jar -xf "$CATALINA_HOME/webapps/ROOT.war"
rm -f "$CATALINA_HOME/webapps/ROOT.war"

echo "📝 Escribiendo db.properties..."
mkdir -p "$(dirname $DB_PROPS)"
cat > "$DB_PROPS" <<EOF
# Generado por docker-entrypoint.sh desde variables de Railway
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

echo "✅ db.properties listo"
echo "🚀 Iniciando Tomcat en puerto 8080..."

# Iniciar Tomcat en foreground (UNA SOLA VEZ)
exec "$CATALINA_HOME/bin/catalina.sh" run
