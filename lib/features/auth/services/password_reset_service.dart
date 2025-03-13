import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/supabase.dart';

final passwordResetProvider = Provider<PasswordResetService>(
  (ref) => PasswordResetService(),
);

class PasswordResetService {
  final _client = SupabaseService.client;

  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> resetPassword(String newPassword) async {
    await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<void> verifyEmail(String token) async {
    await _client.auth.verifyOTP(
      token: token,
      type: OtpType.email,
    );
  }
} 