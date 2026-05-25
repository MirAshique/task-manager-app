import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile picture (avatar with initials)
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?u=${user.email}',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _infoCard(Icons.phone, 'Phone', user.phone),
            const SizedBox(height: 12),
            _infoCard(Icons.web, 'Website', user.website),
            const SizedBox(height: 12),
            _infoCard(Icons.badge, 'User ID', '#${user.id}'),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}