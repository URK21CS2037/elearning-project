import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) => user != null ? const DashboardScreen() : const LoginScreen(),
      loading: () => const LoadingScreen(),
      error: (error, stack) => ErrorScreen(error: error.toString()),
    );
  }
} 