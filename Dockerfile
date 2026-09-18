# ─────────────────────────────────────────────
# Stage 1: Compilar el proyecto con Maven
# ─────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copiar pom y descargar dependencias primero (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar código fuente y compilar
COPY src ./src
RUN mvn clean package -DskipTests -B

# ─────────────────────────────────────────────
# Stage 2: Desplegar en Tomcat 10
# ─────────────────────────────────────────────
FROM tomcat:10.1-jdk17-temurin

# Limpiar aplicaciones por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR generado como ROOT (sin prefijo de contexto)
COPY --from=build /app/target/inmobiliaria.war /usr/local/tomcat/webapps/ROOT.war

# Copiar configuración de credenciales (Railway la inyecta como env vars)
# El archivo db.properties se genera en el entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
