# ============================================
# FlightHours Frontend — Multi-Stage Dockerfile
# ============================================
# Stage 1: Build (Flutter SDK ~2GB)
# Stage 2: Runtime (nginx:alpine ~40MB)
# Final image: ~45MB (only static files + nginx)
# ============================================

# ── Stage 1: Build Flutter Web ──────────────
FROM ghcr.io/cirruslabs/flutter:3.32.0 AS builder

WORKDIR /app

# Copiar pubspec primero para cachear dependencias
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copiar todo el proyecto y compilar para web
# Safe: .dockerignore excludes sensitive files (.git, .env, etc.)
COPY . .

# Build Args para configurar la URL del backend en producción
ARG API_HOST=localhost
ARG API_PROTOCOL=http
ARG API_PORT=8081

RUN flutter build web --release \
  --dart-define=API_HOST=${API_HOST} \
  --dart-define=API_PROTOCOL=${API_PROTOCOL} \
  --dart-define=API_PORT=${API_PORT}

# ── Stage 2: Serve con Nginx (imagen mínima) ─
FROM nginx:alpine

# Copiar archivos estáticos compilados
COPY --from=builder /app/build/web /usr/share/nginx/html

# Configuración de Nginx para SPA (Single Page App)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Run as non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /usr/share/nginx/html \
    && chown -R appuser:appgroup /var/cache/nginx \
    && chown -R appuser:appgroup /var/log/nginx \
    && touch /var/run/nginx.pid \
    && chown -R appuser:appgroup /var/run/nginx.pid

USER appuser

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
