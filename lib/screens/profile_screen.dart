import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      _userData = doc.data();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text('No profile data found.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                (_userData!['name'] as String)[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _userData!['name'] ?? '',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_userData!['email'] ?? '',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text('Email',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 12)),
                subtitle: Text(_userData!['email'] ?? ''),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.badge, color: Colors.blue),
                title: const Text('Name',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 12)),
                subtitle: Text(_userData!['name'] ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}