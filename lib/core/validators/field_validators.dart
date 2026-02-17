
import 'validators.dart';

/// Validador para correos electrónicos
/// Backend: email maxLength 150, minLength 5, format email
class EmailValidator extends BaseValidator {
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  const EmailValidator({super.customMessage});

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.emailRequired);
    }

    if (value!.length > SchemaConstants.emailMaxLength) {
      return getMessage(
        ValidationMessages.maxLengthWithValue(SchemaConstants.emailMaxLength),
      );
    }

    if (!_emailRegex.hasMatch(value)) {
      return getMessage(ValidationMessages.invalidEmail);
    }

    return null;
  }
}

/// Validador para contraseñas
/// Backend: register/change_password → min 8, max 64, 1 uppercase, 1 special
///          login → min 1, max 128
class PasswordValidator extends BaseValidator {
  final int minLength;
  final int maxLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumber;
  final bool requireSpecialChar;

  const PasswordValidator({
    this.minLength = SchemaConstants.passwordMinLength,
    this.maxLength = SchemaConstants.passwordMaxLength,
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

    if (value.length > maxLength) {
      return getMessage(ValidationMessages.maxLengthWithValue(maxLength));
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

    if (requireSpecialChar &&
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
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
/// Backend: name maxLength 50, minLength 1, pattern .*\S.*
class NameValidator extends BaseValidator {
  final int minLength;
  final int maxLength;

  const NameValidator({
    this.minLength = SchemaConstants.nameMinLength,
    this.maxLength = SchemaConstants.nameMaxLength,
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
/// Backend: identificationNumber minLength 7, maxLength 10, pattern ^[0-9]+$
class IdentityValidator extends BaseValidator {
  final int minLength;
  final int maxLength;

  const IdentityValidator({
    this.minLength = SchemaConstants.identificationMinLength,
    this.maxLength = SchemaConstants.identificationMaxLength,
    super.customMessage,
  });

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.identityRequired);
    }

    // Solo dígitos (alineado con backend pattern: ^[0-9]+$)
    if (!SchemaConstants.digitsOnlyPattern.hasMatch(value!)) {
      return getMessage(ValidationMessages.numericOnly);
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
  static final RegExp _phoneRegex = RegExp(r'^[+]?[0-9]{10,13}$');

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

/// Validador para solo dígitos (reutilizable)
/// Acepta strings que contengan únicamente caracteres 0-9
class NumericOnlyValidator extends BaseValidator {
  const NumericOnlyValidator({super.customMessage});

  @override
  String? validate(String? value) {
    if (value != null &&
        value.isNotEmpty &&
        !SchemaConstants.digitsOnlyPattern.hasMatch(value)) {
      return getMessage(ValidationMessages.numericOnly);
    }
    return null;
  }
}

/// Validador para matrículas de aeronave
/// Backend: license_plate maxLength 7, pattern ^[A-Z0-9-]+$
class LicensePlateValidator extends BaseValidator {
  const LicensePlateValidator({super.customMessage});

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.licensePlateRequired);
    }

    if (value!.length > SchemaConstants.licensePlateMaxLength) {
      return getMessage(
        ValidationMessages.licensePlateMaxLength(
          SchemaConstants.licensePlateMaxLength,
        ),
      );
    }

    if (!SchemaConstants.licensePlatePattern.hasMatch(value)) {
      return getMessage(ValidationMessages.licensePlateInvalid);
    }

    return null;
  }
}

/// Validador para número de vuelo
/// Backend: flight_number minLength 1, maxLength 20
class FlightNumberValidator extends BaseValidator {
  const FlightNumberValidator({super.customMessage});

  @override
  String? validate(String? value) {
    final requiredResult = const RequiredValidator().validate(value);
    if (requiredResult != null) {
      return getMessage(ValidationMessages.flightNumberRequired);
    }

    if (value!.length > SchemaConstants.flightNumberMaxLength) {
      return getMessage(
        ValidationMessages.maxLengthWithValue(
          SchemaConstants.flightNumberMaxLength,
        ),
      );
    }

    return null;
  }
}

/// Validador para nombre de acompañante
/// Backend: companion_name maxLength 100 (optional)
class CompanionNameValidator extends BaseValidator {
  const CompanionNameValidator({super.customMessage});

  @override
  String? validate(String? value) {
    if (value != null &&
        value.length > SchemaConstants.companionNameMaxLength) {
      return getMessage(ValidationMessages.companionNameTooLong);
    }
    return null;
  }
}

/// Validador para código Business Partner (bp)
/// Backend: bp maxLength 16 (optional)
class BpValidator extends BaseValidator {
  const BpValidator({super.customMessage});

  @override
  String? validate(String? value) {
    if (value != null && value.length > SchemaConstants.bpMaxLength) {
      return getMessage(ValidationMessages.bpTooLong);
    }
    return null;
  }
}

/// Validador para número de pasajeros
/// Backend: passengers integer >= 0
class PassengersValidator extends BaseValidator {
  const PassengersValidator({super.customMessage});

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional field
    }

    final parsed = int.tryParse(value);
    if (parsed == null || parsed < SchemaConstants.passengersMinimum) {
      return getMessage(ValidationMessages.passengersInvalid);
    }

    return null;
  }
}

/// Validador para campos de hora (HH:MM)
/// Backend: pattern ^\d{2}:\d{2}$
/// Usado por: out_time, takeoff_time, landing_time, in_time,
///            air_time, block_time, duty_time
class TimeFieldValidator extends BaseValidator {
  const TimeFieldValidator({super.customMessage});

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional field
    }

    if (!SchemaConstants.timePattern.hasMatch(value)) {
      return getMessage(ValidationMessages.timeFormatInvalid);
    }

    return null;
  }
}

/// Validador para página del libro (book_page)
/// Backend: integer >= 1
class BookPageValidator extends BaseValidator {
  const BookPageValidator({super.customMessage});

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional field
    }

    final parsed = int.tryParse(value);
    if (parsed == null || parsed < SchemaConstants.bookPageMinimum) {
      return getMessage(ValidationMessages.bookPageInvalid);
    }

    return null;
  }
}
