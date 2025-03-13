import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: settings.isDarkMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleDarkMode();
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Enable push notifications'),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleNotifications();
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(settings.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show language selection dialog
            },
          ),
          ListTile(
            title: const Text('Clear Cache'),
            trailing: const Icon(Icons.delete_outline),
            onTap: () {
              ref.read(settingsProvider.notifier).clearCache();
            },
          ),
        ],
      ),
    );
  }
} 