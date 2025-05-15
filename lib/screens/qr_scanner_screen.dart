import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert'; // For JSON parsing
import 'tiffin_update_screen.dart'; // Import the new TiffinUpdateScreen

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  BarcodeCapture? result;
  MobileScannerController controller = MobileScannerController();
  int _selectedIndex = 2; // QR Code is selected by default (index 2)
  String? tiffinServiceName;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/all-tiffin-services');
        break;
      case 2:
      // Already on QRScannerScreen
        break;
      case 3:
        Navigator.pushNamed(context, '/orders_screen');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  void _handleQRCode(String? qrData) {
    if (qrData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid QR Code')),
      );
      return;
    }

    // Log raw QR code data for debugging
    print('Raw QR Code Data: $qrData');

    // Reset previous data
    tiffinServiceName = null;

    // Try UPI URL format (e.g., upi://pay?pa=example@upi&pn=TiffinService)
    try {
      final uri = Uri.parse(qrData);
      if (uri.scheme == 'upi' && uri.host == 'pay') {
        tiffinServiceName = uri.queryParameters['pn']?.trim();
        print('UPI Parsed - tiffinServiceName: $tiffinServiceName');
      }
    } catch (e) {
      print('UPI URL parsing failed: $e');
    }

    // Try colon-separated format (e.g., "TiffinService:500 INR")
    if (tiffinServiceName == null) {
      try {
        final parts = qrData.split(':');
        if (parts.length >= 1) {
          tiffinServiceName = parts[0].trim();
          print('Colon Parsed - tiffinServiceName: $tiffinServiceName');
        }
      } catch (e) {
        print('Colon-separated parsing failed: $e');
      }
    }

    // Try comma-separated format (e.g., "TiffinService,500")
    if (tiffinServiceName == null) {
      try {
        final parts = qrData.split(',');
        if (parts.length >= 1) {
          tiffinServiceName = parts[0].trim();
          print('Comma Parsed - tiffinServiceName: $tiffinServiceName');
        }
      } catch (e) {
        print('Comma-separated parsing failed: $e');
      }
    }

    // Try JSON format
    if (tiffinServiceName == null) {
      try {
        final decodedData = jsonDecode(qrData);
        tiffinServiceName = decodedData['tiffinServiceName'] as String?;
        print('JSON Parsed - tiffinServiceName: $tiffinServiceName');
      } catch (e) {
        print('JSON parsing failed: $e');
      }
    }

    // Clean and validate the parsed data
    if (tiffinServiceName != null) {
      // Clean tiffinServiceName (remove special characters, extra spaces)
      tiffinServiceName = tiffinServiceName!.trim().replaceAll(RegExp(r'[^\w\s]'), '');

      // Validate tiffinServiceName
      if (tiffinServiceName!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid tiffin service name in QR Code')),
        );
        return;
      }

      // Navigate to TiffinUpdateScreen after successful scan
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TiffinUpdateScreen(
            tiffinServiceName: tiffinServiceName!,
            numberOfTiffins: 2, // Hardcoding as per the image
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unsupported QR Code format: $qrData'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/logo.png',
          width: 150,
          height: 50,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Camera with fixed height (chhota size)
          Container(
            height: 300, // Fixed height for camera
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: MobileScanner(
                controller: controller,
                onDetect: (BarcodeCapture barcodeCapture) {
                  _handleQRCode(barcodeCapture.barcodes.first.rawValue);
                },
              ),
            ),
          ),
          // Simple message instead of payment details
          const Expanded(
            child: Center(
              child: Text(
                'Scan a QR code to update tiffin details',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Tiffin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}