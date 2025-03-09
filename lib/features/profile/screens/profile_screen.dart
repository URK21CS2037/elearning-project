import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildPreferencesSection(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          child: Icon(Icons.person, size: 50),
        ),
        const SizedBox(height: 16),
        const Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'john.doe@example.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            // TODO: Implement edit profile
          },
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Courses\nCompleted', '12'),
                _buildStatItem('Quizzes\nTaken', '45'),
                _buildStatItem('Average\nScore', '85%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Implement theme toggle
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement language selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          onTap: () {
            // TODO: Implement help & support
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          onTap: () {
            // TODO: Implement privacy policy
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () async {
            await ref.read(authServiceProvider).signOut();
            if (mounted) {
              context.go('/login');
            }
          },
        ),
      ],
    );
  }
} 