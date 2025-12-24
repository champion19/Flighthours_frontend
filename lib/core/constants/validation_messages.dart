class ValidationMessages {
  // Form validation messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordTooWeak =
      'Password must contain at least one uppercase, one lowercase and one number';

  // Authentication error messages
  static const String invalidCredentials = 'Invalid email or password';

  // Network/server error messages
  static const String networkError = 'Connection error. Check your internet';
  static const String serverError = 'Server error. Try again later';
  static const String timeoutError = 'Request timed out. Try again';
  static const String genericError = 'An unexpected error occurred';

  // Success messages
  static const String loginSuccess = 'Login successful';
  static const String logoutSuccess = 'Logged out successfully';

  static const String requiredField = 'This field is required';
  static const String invalidFormat = 'Invalid format';

  // Email validations
  static const String invalidEmail = 'Enter a valid email address';
  static const String passwordMinLength =
      'Password must be at least 8 characters';
  static const String passwordUppercase =
      'Must contain at least one uppercase letter';
  static const String passwordLowercase =
      'Must contain at least one lowercase letter';
  static const String passwordNumber = 'Must contain at least one number';
  static const String passwordSpecialChar =
      'Must contain at least one special character';
  static const String passwordMismatch = 'Passwords do not match';

  // Name validations
  static const String nameRequired = 'Name is required';
  static const String nameMinLength = 'Minimum 2 characters';
  static const String nameInvalid = 'Enter a valid name';

  // Identity validations
  static const String identityRequired = 'ID number is required';
  static const String identityInvalid = 'Enter a valid ID number';
  static const String identityMinLength = 'Minimum 7 digits';

  // Phone validations
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Enter a valid phone number';
  static const String phoneFormat = 'Must contain between 10 and 13 digits';

  // Numeric validations
  static const String numberRequired = 'This field must be a number';
  static const String numberInvalid = 'Enter a valid number';

  // Length validations
  static const String minLength = 'Minimum @min characters';
  static const String maxLength = 'Maximum @max characters';
  static const String exactLength = 'Must be exactly @length characters';

  // Helper methods for dynamic messages
  static String minLengthWithValue(int min) => 'Minimum $min characters';
  static String maxLengthWithValue(int max) => 'Maximum $max characters';
  static String exactLengthWithValue(int length) =>
      'Must be exactly $length characters';
  static String rangeLength(int min, int max) =>
      'Must be between $min and $max characters';
}
