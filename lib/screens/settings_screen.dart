import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  final String userName;
  final String phoneNumber;

  const SettingsScreen({
    super.key,
    this.userName = "User Name",
    this.phoneNumber = "xxxxxxxxxx",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Hello, ',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: userName,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Text(
              phoneNumber,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            _buildButton(context, Icons.person, "Update Details"),
            const SizedBox(height: 10),
            _buildButton(context, Icons.headset_mic, "Support / Help"),
            const SizedBox(height: 10),
            _buildButton(context, Icons.system_update, "App Update"),
            const SizedBox(height: 10),
            _buildButton(context, Icons.logout, "Sign out"),
            const Spacer(),
            const Center(
              child: Column(
                children: [
                  Text("TiffinEZ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('"Tiffin made EZ"', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () async {
        if (label == "Update Details") {
          Navigator.pushNamed(context, '/update-profile');
        } else if (label == "Sign out") {
          _showSignOutDialog(context); // Show confirmation dialog
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label clicked')),
          );
        }
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign out failed: $e')),
                );
              }
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
