# Deploy FlightHours Frontend (Flutter Web) — Dokploy

> **VPS:** Contabo Cloud VPS 20 — `161.97.142.2`
> **Dominio:** `rbsuport.com` (Cloudflare)
> **Dokploy Panel:** `http://161.97.142.2:4000`
> **Backend API:** `https://flighthours-api.rbsuport.com`
> **Frontend URL (objetivo):** `https://flighthours.rbsuport.com`

> [!NOTE]
> El VPS, Docker, Dokploy y Traefik ya están instalados y funcionando (del deploy del backend).
> Solo necesitas los pasos de abajo.

---

## Paso 1 — Agregar DNS en Cloudflare

1. Ir a **Cloudflare Dashboard** → `rbsuport.com` → **DNS → Records**
2. Crear nuevo registro:

| Tipo | Nombre         | Contenido       | Proxy      |
| ---- | -------------- | --------------- | ---------- |
| A    | `flighthours`  | `161.97.142.2`  | ✅ Proxied |

> Esto hará que `flighthours.rbsuport.com` apunte al VPS.
> Traefik (ya instalado) se encargará de rutear al container correcto.

---

## Paso 2 — Hacer Push de los archivos de deploy a GitHub

Antes de configurar Dokploy, los archivos de deploy deben estar en el repo.

En tu Mac, desde el proyecto Flutter:

```bash
cd /Users/emmanuellondonogomez/Documents/project-flutter/flight_hours_app

# Verificar que los archivos nuevos están ahí
ls -la Dockerfile nginx.conf .dockerignore
git diff lib/core/config/config.dart

# Agregar y hacer commit
git add Dockerfile nginx.conf .dockerignore lib/core/config/config.dart
git commit -m "feat: add Docker deploy configuration for Dokploy"

# Push a la rama develop (o la rama que uses)
git push origin develop
```

> [!IMPORTANT]
> Si Dokploy lo configuras con la rama `main`, asegúrate de hacer merge de `develop` a `main` antes del deploy.

---

## Paso 3 — Crear servicio en Dokploy

1. **Abrir Dokploy:** `http://161.97.142.2:4000`
2. Ir a **Projects** → buscar el proyecto **FlightHours** (el mismo donde está el backend)
   - Si no lo encuentras, créalo: **Create Project** → nombre: `FlightHours`
3. Dentro del proyecto, click en **Add Service** → **Application**
4. Configurar:

| Campo         | Valor                                        |
| ------------- | -------------------------------------------- |
| **Name**      | `flighthours-frontend`                       |
| **Provider**  | GitHub                                       |
| **Repository**| `champion19/Flighthours_frontend`            |
| **Branch**    | `develop` (o `main` si ya mergeaste)         |
| **Build Type**| Dockerfile                                   |
| **Dockerfile Path** | `./Dockerfile`                         |

> [!NOTE]
> Si es la primera vez que conectas GitHub con Dokploy, te pedirá autorizar la app de GitHub.
> Ve a **Settings → Git** en Dokploy y conecta tu cuenta de GitHub.

---

## Paso 4 — Configurar Build Args (Variables de entorno de build)

En Dokploy, dentro del servicio `flighthours-frontend`:

1. Ve a la pestaña **Advanced** → **Build Args** (o **Environment** → **Build**)
2. Agrega estas 3 variables:

```
API_HOST=flighthours-api.rbsuport.com
API_PROTOCOL=https
API_PORT=443
```

> [!IMPORTANT]
> Estas son **Build Args** (se usan durante `docker build`), NO Environment Variables normales.
> Se pasan como `--build-arg` al Dockerfile, que a su vez las inyecta al `flutter build web --dart-define=...`.

---

## Paso 5 — Configurar dominio + SSL

1. Dentro de `flighthours-frontend` → pestaña **Domains**
2. Click **Add Domain**
3. Configurar:

| Campo           | Valor                              |
| --------------- | ---------------------------------- |
| **Host**        | `flighthours.rbsuport.com`         |
| **HTTPS**       | ✅ Activado                        |
| **Certificate** | Let's Encrypt                      |
| **Port**        | `80` (el puerto del nginx interno) |

> Traefik generará el certificado SSL automáticamente.

---

## Paso 6 — Deploy 🚀

1. Click en **Deploy** dentro del servicio `flighthours-frontend`
2. Dokploy hará:
   - Clonar el repo desde GitHub
   - Ejecutar el `Dockerfile` (Stage 1: Flutter build web, Stage 2: Nginx)
   - Crear el container con la imagen
   - Configurar Traefik para routear `flighthours.rbsuport.com` → container
   - Generar certificado SSL
3. Esperar a que el build termine (~3-5 minutos, el SDK de Flutter es pesado la primera vez)

> [!WARNING]
> El primer build puede tardar **5-10 minutos** porque descarga el Flutter SDK (~2GB).
> Los builds posteriores serán mucho más rápidos gracias al cache de Docker.

---

## Paso 7 — Verificación

| Check                  | URL / Acción                                           | Esperado                    |
| ---------------------- | ------------------------------------------------------ | --------------------------- |
| Frontend carga         | `https://flighthours.rbsuport.com`                     | Splash screen → Login       |
| SSL válido             | Candado verde en el navegador                          | Certificado Let's Encrypt   |
| Conexión al backend    | Intentar hacer login                                   | Login exitoso               |
| Navegación SPA         | Refrescar en cualquier ruta interna (ej: `/airlines`)  | No muestra 404              |
| Backend health         | `https://flighthours-api.rbsuport.com/flighthours/api/v1/health` | 200 OK          |

---

## Arquitectura Final

```
Internet
    │
    ├── flighthours.rbsuport.com ──────► Traefik (:443) ──► flighthours-frontend (:80 nginx)
    │
    ├── flighthours-api.rbsuport.com ──► Traefik (:443) ──► flighthours-api (:8081)
    │
    ├── flighthours-auth.rbsuport.com ─► Traefik (:443) ──► flighthours-keycloak (:8080)
    │
    └── :4000 ──► Panel Dokploy
```

---

## Deploys posteriores (automáticos)

```
git push origin develop  (o main)
    ↓
GitHub notifica a Dokploy (webhook)
    ↓
Dokploy reconstruye la imagen Docker
    ↓
Reemplaza el contenedor viejo
    ↓
✅ Deploy listo en ~2-3 minutos
```

---

## Troubleshooting

### El build falla con "out of memory"
El Flutter SDK consume mucha RAM. En el VPS con 12GB debería ir bien, pero si falla:
```bash
ssh root@161.97.142.2
# Verificar RAM disponible
free -h
# Limpiar Docker cache
docker system prune -af
```

### Error CORS al conectar con el backend
Si el frontend no puede hacer requests al backend, verificar que el backend tiene CORS configurado para el nuevo dominio `flighthours.rbsuport.com`.

### La app no carga después de refrescar (404)
Verificar que `nginx.conf` está copiado correctamente en el Dockerfile. El `try_files $uri $uri/ /index.html` es esencial para SPA routing.
