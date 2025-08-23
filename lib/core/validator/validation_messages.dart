class ValidationMessages {
  // Mensajes de validación de formularios
  static const String emailRequired = 'El email es requerido';
  static const String emailInvalid = 'Ingresa un email válido';
  static const String passwordRequired = 'La contraseña es requerida';
  static const String passwordTooShort = 'La contraseña debe tener al menos 8 caracteres';
  static const String passwordTooWeak = 'La contraseña debe contener al menos una mayúscula, una minúscula y un número';

  // Mensajes de errores de autenticación
  static const String invalidCredentials = 'Email o contraseña incorrectos';


  // Mensajes de errores de red/servidor
  static const String networkError = 'Error de conexión. Verifica tu internet';
  static const String serverError = 'Error del servidor. Intenta más tarde';
  static const String timeoutError = 'La solicitud tardó demasiado. Intenta nuevamente';
  static const String genericError = 'Ocurrió un error inesperado';

  // Mensajes de éxito
  static const String loginSuccess = 'Inicio de sesión exitoso';
  static const String logoutSuccess = 'Sesión cerrada correctamente';
}
