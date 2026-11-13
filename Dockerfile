
# ETAPA 1: Compilar la aplicacion Java con Maven
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /workspace

# Copiar la configuracion Maven
COPY pom.xml .

# Descargar dependencias
RUN mvn dependency:go-offline -B

# Copiar codigo fuente
COPY src ./src

# Compilar y ejecutar pruebas
RUN mvn clean package -B

# ETAPA 2: Imagen de ejecucion
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copiar el JAR generado en la etapa anterior
COPY --from=build /workspace/target/*.jar app.jar

EXPOSE 8080

# Iniciar la aplicacion
ENTRYPOINT ["java", "-jar", "app.jar"]
