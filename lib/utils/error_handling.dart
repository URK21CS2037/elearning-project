class AppErrorHandler {
  static String handleAuthError(Exception error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid email or password';
        case 'Email not confirmed':
          return 'Please verify your email first';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred';
  }

  static String handleAPIError(Exception error) {
    // Handle AI API errors
    if (error is APIException) {
      return 'Failed to connect to service: ${error.message}';
    }
    return 'Service temporarily unavailable';
  }
} 