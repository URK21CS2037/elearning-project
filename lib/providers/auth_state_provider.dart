final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState.initial()) {
    // Listen to auth changes
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        state = AuthState.authenticated(data.session!);
      } else if (data.event == AuthChangeEvent.signedOut) {
        state = const AuthState.unauthenticated();
      }
    });
  }
} 