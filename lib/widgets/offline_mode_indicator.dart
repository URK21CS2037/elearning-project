import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/offline_service.dart';

class OfflineModeIndicator extends ConsumerWidget {
  const OfflineModeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);

    if (isOnline) return const SizedBox.shrink();

    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          const Text(
            'Offline Mode - Some features may be limited',
            style: TextStyle(color: Colors.white),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => ref.read(offlineServiceProvider).syncWithServer(),
            child: const Text(
              'Sync',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 