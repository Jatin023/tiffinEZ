import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _loading = false;

  Future<void> _verifyAndMockJWT() async {
    setState(() => _loading = true);

    try {
      // ✅ 1. Firebase credential from OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      // ✅ 2. Sign in with Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // ✅ 3. Get Firebase ID token (optional)
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      // ✅ 4. MOCK JWT (replace this when backend ready)
      final fakeJWT = "mock.jwt.token.${DateTime.now().millisecondsSinceEpoch}";

      // ✅ 5. Store JWT in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("jwt_token", fakeJWT);

      // ✅ 6. Navigate to home screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP Verification Failed: $e")),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("OTP sent to ${widget.phoneNumber}"),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _verifyAndMockJWT,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Verify & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
