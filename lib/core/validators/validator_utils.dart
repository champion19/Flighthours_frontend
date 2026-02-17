
import 'validators.dart';

/// Clase de utilidades para validaciones comunes.
/// Factory methods que encapsulan la creación de validators
/// alineados con las constantes del backend (SchemaConstants).
class ValidatorUtils {
  /// Crea un validador compuesto para email
  /// Backend: minLength 5, maxLength 150, email format
  static BaseValidator email({String? customMessage}) {
    return EmailValidator(customMessage: customMessage);
  }

  /// Crea un validador compuesto para contraseña (register/change)
  /// Backend: min 8, max 64, uppercase + special required
  static BaseValidator password({
    int minLength = SchemaConstants.passwordMinLength,
    int maxLength = SchemaConstants.passwordMaxLength,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumber = true,
    bool requireSpecialChar = false,
    String? customMessage,
  }) {
    return PasswordValidator(
      minLength: minLength,
      maxLength: maxLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireNumber: requireNumber,
      requireSpecialChar: requireSpecialChar,
      customMessage: customMessage,
    );
  }

  /// Crea un validador para contraseña de login (más permisivo)
  /// Backend: min 1, max 128
  static BaseValidator loginPassword({String? customMessage}) {
    return PasswordValidator(
      minLength: SchemaConstants.loginPasswordMinLength,
      maxLength: SchemaConstants.loginPasswordMaxLength,
      requireUppercase: false,
      requireLowercase: false,
      requireNumber: false,
      requireSpecialChar: false,
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
  /// Backend: min 1, max 50
  static BaseValidator name({
    int minLength = SchemaConstants.nameMinLength,
    int maxLength = SchemaConstants.nameMaxLength,
    String? customMessage,
  }) {
    return NameValidator(
      minLength: minLength,
      maxLength: maxLength,
      customMessage: customMessage,
    );
  }

  /// Crea un validador para identificación
  /// Backend: min 7, max 10, solo dígitos
  static BaseValidator identity({
    int minLength = SchemaConstants.identificationMinLength,
    int maxLength = SchemaConstants.identificationMaxLength,
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
  static BaseValidator regex(RegExp pattern, {String? customMessage}) {
    return RegexValidator(pattern, customMessage: customMessage);
  }

  // ══════════════════════════════════════════════════════════════
  // NUEVOS VALIDATORS ALINEADOS CON BACKEND SCHEMAS
  // ══════════════════════════════════════════════════════════════

  /// Validador para solo dígitos
  static BaseValidator numericOnly({String? customMessage}) {
    return NumericOnlyValidator(customMessage: customMessage);
  }

  /// Matrícula de aeronave: max 7, pattern ^[A-Z0-9-]+$
  static BaseValidator licensePlate({String? customMessage}) {
    return LicensePlateValidator(customMessage: customMessage);
  }

  /// Número de vuelo: required, max 20
  static BaseValidator flightNumber({String? customMessage}) {
    return FlightNumberValidator(customMessage: customMessage);
  }

  /// Nombre del acompañante: max 100, optional
  static BaseValidator companionName({String? customMessage}) {
    return CompanionNameValidator(customMessage: customMessage);
  }

  /// Código Business Partner: max 16, optional
  static BaseValidator bp({String? customMessage}) {
    return BpValidator(customMessage: customMessage);
  }

  /// Pasajeros: integer >= 0, optional
  static BaseValidator passengers({String? customMessage}) {
    return PassengersValidator(customMessage: customMessage);
  }

  /// Campos de hora (HH:MM): optional
  static BaseValidator timeField({String? customMessage}) {
    return TimeFieldValidator(customMessage: customMessage);
  }

  /// Página del libro: integer >= 1, optional
  static BaseValidator bookPage({String? customMessage}) {
    return BookPageValidator(customMessage: customMessage);
  }
}
