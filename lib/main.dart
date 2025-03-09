import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/supabase.dart';
import 'config/theme.dart';
import 'config/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment variables
  await dotenv.load();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Supabase
  await SupabaseService.init();
  
  runApp(const ProviderScope(child: AptoraApp()));
}

class AptoraApp extends ConsumerWidget {
  const AptoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Aptora',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
} 