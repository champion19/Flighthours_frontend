# ============================================
# FlightHours Frontend — Multi-Stage Dockerfile
# ============================================
# Stage 1: Build (Flutter SDK ~2GB)
# Stage 2: Runtime (nginx:alpine ~40MB)
# Final image: ~45MB (only static files + nginx)
# ============================================

# ── Stage 1: Build Flutter Web ──────────────
FROM ghcr.io/cirruslabs/flutter:3.29.2 AS builder

WORKDIR /app

# Copiar pubspec primero para cachear dependencias
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copiar todo el proyecto y compilar para web
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

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
