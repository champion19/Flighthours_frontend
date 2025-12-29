import 'validators.dart';

/// Validador para correos electrónicos
class EmailValidator extends BaseValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  const EmailValidator({super.customMessage});

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.emailRequired);
    }

    if (!_emailRegex.hasMatch(value!)) {
      return getMessage(ValidationMessages.invalidEmail);
    }

    return null;
  }
}

/// Validador para contraseñas
class PasswordValidator extends BaseValidator {
  final int minLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumber;
  final bool requireSpecialChar;

  const PasswordValidator({
    this.minLength = 8,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireNumber = true,
    this.requireSpecialChar = false,
    super.customMessage,
  });

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.passwordRequired);
    }

    if (value!.length < minLength) {
      return getMessage(ValidationMessages.passwordMinLength);
    }

    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      return getMessage(ValidationMessages.passwordUppercase);
    }

    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      return getMessage(ValidationMessages.passwordLowercase);
    }

    if (requireNumber && !RegExp(r'\d').hasMatch(value)) {
      return getMessage(ValidationMessages.passwordNumber);
    }

    if (requireSpecialChar && !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return getMessage(ValidationMessages.passwordSpecialChar);
    }

    return null;
  }
}

/// Validador para confirmación de contraseñas
class ConfirmPasswordValidator extends BaseValidator {
  final String originalPassword;

  const ConfirmPasswordValidator(this.originalPassword, {super.customMessage});

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return requiredResult;
    }

    if (value != originalPassword) {
      return getMessage(ValidationMessages.passwordMismatch);
    }

    return null;
  }
}

/// Validador para nombres
class NameValidator extends BaseValidator {
  final int minLength;
  final int maxLength;

  const NameValidator({
    this.minLength = 2,
    this.maxLength = 50,
    super.customMessage,
  });

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.nameRequired);
    }

    if (value!.length < minLength) {
      return getMessage(ValidationMessages.minLengthWithValue(minLength));
    }

    if (value.length > maxLength) {
      return getMessage(ValidationMessages.maxLengthWithValue(maxLength));
    }

    // Validar que solo contenga letras y espacios
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
      return getMessage(ValidationMessages.nameInvalid);
    }

    return null;
  }
}

/// Validador para números de identificación
class IdentityValidator extends BaseValidator {
  final int minLength;
  final int maxLength;

  const IdentityValidator({
    this.minLength = 7,
    this.maxLength = 20,
    super.customMessage,
  });

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.identityRequired);
    }

    // Validar que sea un número válido
    if (int.tryParse(value!) == null) {
      return getMessage(ValidationMessages.identityInvalid);
    }

    if (value.length < minLength) {
      return getMessage(ValidationMessages.minLengthWithValue(minLength));
    }

    if (value.length > maxLength) {
      return getMessage(ValidationMessages.maxLengthWithValue(maxLength));
    }

    return null;
  }
}

/// Validador para números de teléfono
class PhoneValidator extends BaseValidator {
  static final RegExp _phoneRegex = RegExp(
    r'^[+]?[0-9]{10,13}$',
  );

  const PhoneValidator({super.customMessage});

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.phoneRequired);
    }

    if (!_phoneRegex.hasMatch(value!)) {
      return getMessage(ValidationMessages.phoneInvalid);
    }

    return null;
  }
}
