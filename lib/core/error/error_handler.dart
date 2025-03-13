import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String errorMessage = _getErrorMessage(error);
    _showErrorSnackbar(context, errorMessage);
    _logError(error);
  }

  static String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return _handleAuthError(error);
    } else if (error is PostgrestException) {
      return _handleDatabaseError(error);
    } else if (error is NetworkException) {
      return _handleNetworkError(error);
    }
    return 'An unexpected error occurred';
  }

  static String _handleAuthError(AuthException error) {
    switch (error.message) {
      case 'Invalid login credentials':
        return 'Invalid email or password';
      case 'Email not confirmed':
        return 'Please verify your email';
      case 'Password is too weak':
        return 'Password should be at least 8 characters with numbers and symbols';
      default:
        return error.message;
    }
  }

  static String _handleDatabaseError(PostgrestException error) {
    switch (error.code) {
      case '23505': // Unique violation
        return 'This record already exists';
      case '23503': // Foreign key violation
        return 'Related record not found';
      default:
        return 'Database error occurred';
    }
  }

  static String _handleNetworkError(NetworkException error) {
    return 'Network error: Please check your internet connection';
  }

  static void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void _logError(dynamic error) {
    // Implement logging service here
    print('Error: ${error.toString()}');
  }
} 