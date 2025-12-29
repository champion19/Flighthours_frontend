import 'validators.dart';

/// Clase de utilidades para validaciones comunes
class ValidatorUtils {
  /// Crea un validador compuesto para email
  static BaseValidator email({String? customMessage}) {
    return EmailValidator(customMessage: customMessage);
  }

  /// Crea un validador compuesto para contraseña
  static BaseValidator password({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumber = true,
    bool requireSpecialChar = false,
    String? customMessage,
  }) {
    return PasswordValidator(
      minLength: minLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireNumber: requireNumber,
      requireSpecialChar: requireSpecialChar,
      customMessage: customMessage,
    );
  }

  /// Crea un validador para confirmación de contraseña
  static BaseValidator confirmPassword(
    String originalPassword, {
    String? customMessage,
  }) {
    return ConfirmPasswordValidator(
      originalPassword,
      customMessage: customMessage,
    );
  }

  /// Crea un validador para nombres
  static BaseValidator name({
    int minLength = 2,
    int maxLength = 50,
    String? customMessage,
  }) {
    return NameValidator(
      minLength: minLength,
      maxLength: maxLength,
      customMessage: customMessage,
    );
  }

  /// Crea un validador para identificación
  static BaseValidator identity({
    int minLength = 7,
    int maxLength = 20,
    String? customMessage,
  }) {
    return IdentityValidator(
      minLength: minLength,
      maxLength: maxLength,
      customMessage: customMessage,
    );
  }

  /// Crea un validador para teléfono
  static BaseValidator phone({String? customMessage}) {
    return PhoneValidator(customMessage: customMessage);
  }

  /// Crea un validador requerido
  static BaseValidator required({String? customMessage}) {
    return RequiredValidator(customMessage: customMessage);
  }

  /// Crea un validador de longitud mínima
  static BaseValidator minLength(int min, {String? customMessage}) {
    return MinLengthValidator(min, customMessage: customMessage);
  }

  /// Crea un validador de longitud máxima
  static BaseValidator maxLength(int max, {String? customMessage}) {
    return MaxLengthValidator(max, customMessage: customMessage);
  }

  /// Combina múltiples validadores
  static BaseValidator compose(List<BaseValidator> validators) {
    return ValidatorComposer(validators);
  }

  /// Crea un validador personalizado con expresión regular
  static BaseValidator regex(
    RegExp pattern, {
    String? customMessage,
  }) {
    return RegexValidator(pattern, customMessage: customMessage);
  }
}
