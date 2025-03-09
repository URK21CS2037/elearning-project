import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';

class SupabaseService {
  static late final SupabaseClient client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    client = Supabase.instance.client;
  }

  static User? get currentUser => client.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => 
      client.auth.onAuthStateChange;
} 