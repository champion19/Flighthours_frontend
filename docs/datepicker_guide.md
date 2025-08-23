# Uso de showDatePicker con TextFormField en Flutter

Esta es una guía sobre cómo implementar un selector de fechas (Date Picker) en un campo de formulario de texto (`TextFormField`) en Flutter.

### 1. ¿Qué es el Date Picker en un TextFormField?

En Flutter, un `TextFormField` por sí solo es solo un campo para escribir texto. **No tiene un selector de fechas (Date Picker) integrado.**

Lo que hacemos es **conectar** un `TextFormField` con el diálogo de selección de fecha que Flutter ya nos ofrece (`showDatePicker`).

En resumen: El "Date Picker en un TextFormField" no es un solo widget, sino una **combinación de dos elementos**:
1.  Un **`TextFormField`** que se usa para *mostrar* la fecha seleccionada.
2.  El diálogo **`showDatePicker`** que se lanza para que el usuario *elija* la fecha.

### 2. ¿Qué hace?

Su propósito es ofrecer una experiencia de usuario (UX) mucho mejor y más segura para seleccionar fechas:

*   **Evita Errores de Formato:** Impide que el usuario escriba la fecha en un formato incorrecto (ej: "10/05/2024", "10-Mayo-2024", "10/5/24").
*   **Garantiza Fechas Válidas:** Asegura que el usuario solo pueda seleccionar fechas que existen (nadie podrá elegir un 30 de febrero).
*   **Mejora la Usabilidad:** Es mucho más fácil y rápido tocar una fecha en un calendario que escribirla manualmente, sobre todo en móviles.
*   **Apariencia Nativa:** El diálogo del calendario se ve como los calendarios nativos de Android (Material Design) o de iOS (Cupertino), dando una sensación familiar al usuario.

### 3. ¿Cómo funciona? (El Flujo)

El proceso se resume en estos pasos:

1.  **Crear el `TextFormField`:** Lo pones en tu UI. Para que el usuario no pueda escribir en él, es una **muy buena práctica** hacerlo de solo lectura (`readOnly: true`).
2.  **Añadir un `TextEditingController`:** Este controlador nos permite cambiar el texto del `TextFormField` mediante código.
3.  **Detectar el Toque (`onTap`):** Usamos el evento `onTap` del `TextFormField`. Cuando el usuario toque el campo (como si fuera a escribir), en lugar de abrir el teclado, nosotros lanzaremos el selector de fechas.
4.  **Lanzar `showDatePicker`:** Dentro de `onTap`, llamamos a la función `showDatePicker()`. Esta función es `async`, lo que significa que tenemos que "esperar" (`await`) a que el usuario seleccione una fecha o cierre el diálogo.
5.  **Recibir la Fecha:** `showDatePicker` devuelve un `Future<DateTime>`. Esto significa que en el futuro nos dará un objeto de tipo `DateTime` si el usuario elige una fecha, o nos dará `null` si presiona "Cancelar".
6.  **Formatear y Mostrar:** Si recibimos un `DateTime` (no es `null`), lo formateamos a un `String` legible (ej: "19 de julio de 2025"). Para esto, se recomienda usar el paquete `intl`.
7.  **Actualizar el Controlador:** Finalmente, actualizamos el texto del controlador (`_controller.text = fechaFormateada;`), y el `TextFormField` mostrará la fecha que el usuario eligió.

---

### 4. Ejemplo de Código Completo

Primero, debes agregar el paquete de internacionalización a tu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.19.0 # O la versión más reciente
```

Luego, ejecuta `flutter pub get` en tu terminal.

Ahora, el código del widget:

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa el paquete para formatear fechas

class DatePickerFormField extends StatefulWidget {
  const DatePickerFormField({super.key});

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  // Controlador para manejar el texto del TextFormField
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se destruye
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo de Date Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _dateController, // 1. Asignar el controlador
          readOnly: true, // 2. Hacer el campo de solo lectura
          decoration: const InputDecoration(
            labelText: 'Fecha de nacimiento',
            hintText: 'Seleccione una fecha',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today), // Icono para indicar que es un campo de fecha
          ),
          onTap: () async { // 3. Detectar el toque en el campo
            // Prevenir que el teclado aparezca
            FocusScope.of(context).requestFocus(FocusNode());

            // 4. Lanzar showDatePicker
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // Fecha inicial
              firstDate: DateTime(1900),   // Fecha mínima seleccionable
              lastDate: DateTime.now(),    // Fecha máxima seleccionable
            );

            // 5. Recibir la fecha y actualizar el campo
            if (pickedDate != null) {
              // 6. Formatear la fecha a un String legible
              String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

              // 7. Actualizar el texto del controlador
              setState(() {
                _dateController.text = formattedDate;
              });
            }
          },
        ),
      ),
    );
  }
}
```
