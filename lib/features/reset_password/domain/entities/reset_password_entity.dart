/// Entity representing a successful password reset request
class ResetPasswordEntity {
  final bool success;
  final String code;
  final String message;

  ResetPasswordEntity({
    required this.success,
    required this.code,
    required this.message,
  });
}
