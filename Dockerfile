# -----------------------------------------------------------------------------
# DevOps Honors Project - Dockerfile
# Multi-stage build for optimized Docker image
# -----------------------------------------------------------------------------

# -- Stage 1: Build Stage ------------------------------------------------------
FROM maven:3.9.5-eclipse-temurin-17 AS builder
LABEL maintainer="Honors Student"
LABEL project="DevOps Honors Project"

WORKDIR /build

# Copy pom.xml first (caches dependencies layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# -- Stage 2: Runtime Stage ----------------------------------------------------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Install wget for health check
RUN apk add --no-cache wget

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the JAR from builder stage
COPY --from=builder /build/target/devops-honors-project.jar app.jar

# Set correct ownership
RUN chown appuser:appgroup app.jar

USER appuser

# Expose application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/health || exit 1

# Run the application
ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-jar", "app.jar"]
