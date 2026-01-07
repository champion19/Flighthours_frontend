# Cambios Implementados - Flujo de Registro Simplificado

## Fecha: 2026-01-06

---

## FLUJO DE REGISTRO CORRECTO (SIMPLIFICADO)

### Resumen
El `POST /register` ahora envía TODOS los datos del empleado incluyendo BP, airline y active. Ya no se necesita hacer PUT después del login.

### Flujo Implementado

```
┌─────────────────────────────────────────────────────────────────┐
│                     REGISTRO                                    │
├─────────────────────────────────────────────────────────────────┤
│ 1. PersonalInfo → captura: name, email, password, idNumber     │
│ 2. PilotInfo → captura: bp, airline (GET /airlines), fechas    │
│ 3. POST /register → envía TODO (personal + pilot)              │
│ 4. VerificationPage                                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
           (Usuario verifica email en Keycloak)
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                     LOGIN                                       │
├─────────────────────────────────────────────────────────────────┤
│ 5. POST /login → credenciales                                  │
│ 6. Dashboard                                                   │
│ 7. EmployeeProfilePage → GET /employees/me → VER TODO          │
└─────────────────────────────────────────────────────────────────┘
```

---

## ENDPOINTS Y SU PROPÓSITO

| Endpoint | Método | Propósito |
|----------|--------|-----------|
| `/register` | POST | Registrar empleado con TODOS los datos (personal + pilot) |
| `/login` | POST | Autenticar usuario |
| `/employees/me` | GET | Ver perfil del empleado (todos los datos) |
| `/employees/me` | PUT | **SOLO para corregir datos** si el usuario cometió un error |
| `/airlines` | GET | Listar aerolíneas para dropdown en PilotInfo |
| `/airlines/:id` | GET | Obtener detalle de aerolínea |

---

## PAYLOAD DE POST /register

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePassword123",
  "identificationnumber": "123456789",
  "start_date": "2024-01-01",
  "end_date": "2025-01-01",
  "role": "pilot",
  "bp": "BP001",
  "airline": "abc123-obfuscated-id",
  "active": true
}
```

---

## ARCHIVOS MODIFICADOS

### register_datasource.dart
```dart
// ANTES: Solo enviaba datos personales
// AHORA: Envía TODO (personal + pilot)
final payload = {
  'name': employee.name,
  'email': employee.email,
  'password': employee.password,
  'identificationnumber': employee.idNumber,
  'start_date': _formatDate(employee.fechaInicio),
  'end_date': _formatDate(employee.fechaFin),
  'role': employee.role ?? 'pilot',
  'bp': employee.bp ?? '',           // ← NUEVO
  'airline': employee.airline ?? '', // ← NUEVO
  'active': employee.vigente ?? false, // ← NUEVO
};
```

### register_bloc.dart
- Simplificado: ya no guarda "pending pilot data"
- `CompleteRegistrationFlow` → POST /register con TODO → listo

### login_bloc.dart
- Simplificado: ya no verifica ni envía datos pendientes
- Solo: Login → guardar sesión → éxito

### login_state.dart
- Removido: `LoginSyncingPilotData` (ya no necesario)

### login_page.dart
- Simplificado: solo muestra "Signing in..." durante loading

---

## PROPÓSITO DE PUT /employees/me

El endpoint `PUT /employees/me` es **SOLO para correcciones**:

1. Usuario ve sus datos en EmployeeProfilePage
2. Si algo está mal (nombre, bp, airline, fechas)
3. Usuario edita y guarda
4. PUT /employees/me con datos corregidos

**IMPORTANTE:** PUT NO acepta campos vacíos (error 4XX)

---

## AIRLINES ACTIVATE/DEACTIVATE (También implementado)

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/airlines/:id/activate` | PATCH | Activa una aerolínea |
| `/airlines/:id/deactivate` | PATCH | Desactiva una aerolínea |

La página `AirlineListPage` tiene UI para activar/desactivar aerolíneas.

---

## RESUMEN DE ENDPOINTS IMPLEMENTADOS

```
✅ POST   /register           → Registro con TODOS los datos
✅ POST   /login              → Autenticación
✅ GET    /employees/me       → Ver perfil
✅ PUT    /employees/me       → Corregir datos (si hay error)
✅ DELETE /employees/me       → Eliminar cuenta
✅ GET    /airlines           → Listar aerolíneas
✅ GET    /airlines/:id       → Detalle aerolínea
✅ PATCH  /airlines/:id/activate
✅ PATCH  /airlines/:id/deactivate
✅ GET    /airports
✅ GET    /airports/:id
✅ PATCH  /airports/:id/activate
✅ PATCH  /airports/:id/deactivate
✅ POST   /auth/password-reset
```

---

## PRÓXIMOS PASOS PARA PROBAR

1. **Registrar un nuevo usuario** con datos personales + pilot (BP, airline)
2. **Verificar email** en Keycloak
3. **Login** con las credenciales
4. **Ir a EmployeeProfilePage** → debes ver TODOS los datos (incluyendo BP y airline)
5. **Si algo está mal** → editar y guardar con PUT /employees/me
