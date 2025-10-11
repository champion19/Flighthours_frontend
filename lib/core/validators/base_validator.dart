import 'validators.dart';

/// Clase base para todos los validadores
abstract class BaseValidator {
  final String? customMessage;

  const BaseValidator({this.customMessage});

  /// Método principal que todas las clases deben implementar
  String? validate(String? value);

  /// Método auxiliar para retornar mensaje personalizado o por defecto
  String? getMessage(String defaultMessage) {
    return customMessage ?? defaultMessage;
  }
}

/// Clase para combinar múltiples validadores
class ValidatorComposer extends BaseValidator {
  final List<BaseValidator> validators;

  const ValidatorComposer(this.validators, {super.customMessage});

  @override
  String? validate(String? value) {
    for (final validator in validators) {
      final result = validator.validate(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

/// Validador para campos requeridos
class RequiredValidator extends BaseValidator {
  const RequiredValidator({super.customMessage});

  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return getMessage(ValidationMessages.requiredField);
    }
    return null;
  }
}

/// Validador para longitud mínima
class MinLengthValidator extends BaseValidator {
  final int minLength;

  const MinLengthValidator(this.minLength, {super.customMessage});

  @override
  String? validate(String? value) {
    if (value == null || value.length < minLength) {
      return getMessage(ValidationMessages.minLengthWithValue(minLength));
    }
    return null;
  }
}

/// Validador para longitud máxima
class MaxLengthValidator extends BaseValidator {
  final int maxLength;

  const MaxLengthValidator(this.maxLength, {super.customMessage});

  @override
  String? validate(String? value) {
    if (value != null && value.length > maxLength) {
      return getMessage(ValidationMessages.maxLengthWithValue(maxLength));
    }
    return null;
  }
}

/// Validador para expresiones regulares
class RegexValidator extends BaseValidator {
  final RegExp pattern;

  const RegexValidator(this.pattern, {super.customMessage});

  @override
  String? validate(String? value) {
    if (value != null && !pattern.hasMatch(value)) {
      return getMessage(ValidationMessages.invalidFormat);
    }
    return null;
  }
}
