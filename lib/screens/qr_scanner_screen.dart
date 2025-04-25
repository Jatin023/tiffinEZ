import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert'; // For JSON parsing
import 'payment_screen.dart'; // Import PaymentScreen

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
  String? price;
  String? upiId;
  final TextEditingController _amountController = TextEditingController();

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
      // Navigate to Orders screen (placeholder)
        break;
      case 4:
      // Navigate to Settings screen (placeholder)
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
    price = null;
    upiId = null;
    _amountController.clear(); // Clear TextField to avoid random values

    // Try UPI URL format (e.g., upi://pay?pa=example@upi&pn=TiffinService&am=500)
    try {
      final uri = Uri.parse(qrData);
      if (uri.scheme == 'upi' && uri.host == 'pay') {
        tiffinServiceName = uri.queryParameters['pn']?.trim();
        price = uri.queryParameters['am']?.trim();
        upiId = uri.queryParameters['pa']?.trim();
        print('UPI Parsed - tiffinServiceName: $tiffinServiceName, price: $price, upiId: $upiId');
      }
    } catch (e) {
      print('UPI URL parsing failed: $e');
    }

    // Try colon-separated format (e.g., "TiffinService:500 INR")
    if (tiffinServiceName == null || price == null) {
      try {
        final parts = qrData.split(':');
        if (parts.length == 2) {
          tiffinServiceName = parts[0].trim();
          price = parts[1].trim();
          print('Colon Parsed - tiffinServiceName: $tiffinServiceName, price: $price');
        }
      } catch (e) {
        print('Colon-separated parsing failed: $e');
      }
    }

    // Try comma-separated format (e.g., "TiffinService,500")
    if (tiffinServiceName == null || price == null) {
      try {
        final parts = qrData.split(',');
        if (parts.length == 2) {
          tiffinServiceName = parts[0].trim();
          price = parts[1].trim();
          print('Comma Parsed - tiffinServiceName: $tiffinServiceName, price: $price');
        }
      } catch (e) {
        print('Comma-separated parsing failed: $e');
      }
    }

    // Try JSON format
    if (tiffinServiceName == null || price == null) {
      try {
        final decodedData = jsonDecode(qrData);
        tiffinServiceName = decodedData['tiffinServiceName'] as String?;
        price = decodedData['price'] as String?;
        upiId = decodedData['upiId'] as String?;
        print('JSON Parsed - tiffinServiceName: $tiffinServiceName, price: $price, upiId: $upiId');
      } catch (e) {
        print('JSON parsing failed: $e');
      }
    }

    // Clean and validate the parsed data
    if (tiffinServiceName != null && price != null) {
      // Clean price (remove currency units, spaces, etc.)
      price = price!.replaceAll(RegExp(r'[^0-9]'), '');
      print('Cleaned price: $price');

      // Validate price
      if (price!.isEmpty || int.tryParse(price!) == null || int.parse(price!) <= 0) {
        print('Invalid price: $price');
        price = null; // Invalidate price if not a valid number
      } else {
        // Set valid price as default in TextField
        _amountController.text = price!;
      }

      // Clean tiffinServiceName (remove special characters, extra spaces)
      tiffinServiceName = tiffinServiceName!.trim().replaceAll(RegExp(r'[^\w\s]'), '');

      // Validate tiffinServiceName
      if (tiffinServiceName!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid tiffin service name in QR Code')),
        );
        return;
      }

      // Update UI with parsed data
      setState(() {
        result = BarcodeCapture(barcodes: [Barcode(rawValue: qrData)]);
      });
    } else {
      // If no valid data, keep TextField blank
      _amountController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unsupported QR Code format: $qrData'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _proceedToPayment() {
    final enteredAmount = _amountController.text.trim();

    // Validate entered amount
    if (enteredAmount.isEmpty || int.tryParse(enteredAmount) == null || int.parse(enteredAmount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (tiffinServiceName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            tiffinServiceName: tiffinServiceName!,
            price: enteredAmount, // Use user-entered amount
            upiId: upiId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid QR code data to proceed')),
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
          // Data display with more space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Scanned QR Code Details:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (tiffinServiceName != null)
                          Row(
                            children: [
                              const Icon(Icons.store, size: 20, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tiffin Service: $tiffinServiceName',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        if (upiId != null)
                          Row(
                            children: [
                              const Icon(Icons.payment, size: 20, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'UPI ID: $upiId',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee, size: 20, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Amount (₹)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.currency_rupee, color: Colors.red),
                                ),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        if (tiffinServiceName == null && upiId == null && _amountController.text.isEmpty)
                          const Text(
                            'Scan a QR code',
                            style: TextStyle(fontSize: 16),
                          ),
                        const SizedBox(height: 16),
                        if (tiffinServiceName != null)
                          Center(
                            child: ElevatedButton(
                              onPressed: _proceedToPayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Proceed to Payment',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
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
    _amountController.dispose();
    super.dispose();
  }
}