# ─────────────────────────────────────────────
# Stage 1: Compilar el proyecto con Maven
# ─────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests -B

# ─────────────────────────────────────────────
# Stage 2: Desplegar en Tomcat 9 (javax.servlet)
# IMPORTANTE: Tomcat 10+ usa jakarta.servlet (incompatible)
# Este proyecto usa javax.servlet 4.0 → requiere Tomcat 9
# ─────────────────────────────────────────────
FROM tomcat:9.0-jdk17-temurin

# Limpiar apps por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar WAR como ROOT (accesible en /)
COPY --from=build /app/target/inmobiliaria.war /usr/local/tomcat/webapps/ROOT.war

# Entrypoint que inyecta credenciales desde env vars
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
