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


  static const String requiredField = 'Este campo es requerido';
  static const String invalidFormat = 'Formato inválido';

  // Validaciones de email
  static const String invalidEmail = 'Ingresa un correo electrónico válido';
  static const String passwordMinLength = 'La contraseña debe tener al menos 8 caracteres';
  static const String passwordUppercase = 'Debe contener al menos una mayúscula';
  static const String passwordLowercase = 'Debe contener al menos una minúscula';
  static const String passwordNumber = 'Debe contener al menos un número';
  static const String passwordSpecialChar = 'Debe contener al menos un carácter especial';
  static const String passwordMismatch = 'Las contraseñas no coinciden';

  // Validaciones de nombre
  static const String nameRequired = 'El nombre es requerido';
  static const String nameMinLength = 'Mínimo 2 caracteres';
  static const String nameInvalid = 'Ingresa un nombre válido';

  // Validaciones de identificación
  static const String identityRequired = 'El número de identificación es requerido';
  static const String identityInvalid = 'Ingresa un número de identificación válido';
  static const String identityMinLength = 'Mínimo 7 dígitos';

  // Validaciones de teléfono
  static const String phoneRequired = 'El número de teléfono es requerido';
  static const String phoneInvalid = 'Ingresa un número de teléfono válido';
  static const String phoneFormat = 'Debe contener entre 10 y 13 dígitos';

  // Validaciones numéricas
  static const String numberRequired = 'Este campo debe ser un número';
  static const String numberInvalid = 'Ingresa un número válido';

  // Validaciones de longitud
  static const String minLength = 'Mínimo @min caracteres';
  static const String maxLength = 'Máximo @max caracteres';
  static const String exactLength = 'Debe tener exactamente @length caracteres';

  // Métodos auxiliares para mensajes dinámicos
  static String minLengthWithValue(int min) => 'Mínimo $min caracteres';
  static String maxLengthWithValue(int max) => 'Máximo $max caracteres';
  static String exactLengthWithValue(int length) => 'Debe tener exactamente $length caracteres';
  static String rangeLength(int min, int max) => 'Debe tener entre $min y $max caracteres';
}

