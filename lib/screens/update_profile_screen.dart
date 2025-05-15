import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final mobileController = TextEditingController();
    final tiffinServiceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Update profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField(nameController, "Name"),
            const SizedBox(height: 15),
            _buildTextField(mobileController, "Mobile Number"),
            const SizedBox(height: 15),
            _buildTextField(tiffinServiceController, "Tiffin Service Name"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Save logic here
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Done", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const Spacer(),
            const Column(
              children: [
                Text("TiffinEZ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text('"Tiffin made EZ"', style: TextStyle(color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: const Icon(Icons.edit, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
