import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final _client = SupabaseService.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
      
      if (response.user != null) {
        // Create user profile in database
        await _client.from('profiles').insert({
          'id': response.user!.id,
          'full_name': name,
          'email': email,
        });
      }
      
      return response;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  bool get isAuthenticated => _client.auth.currentUser != null;
} 