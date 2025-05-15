import 'package:flutter/material.dart';
import 'package:tiffin_ez_01/screens/tiffin_service_details_screen.dart'; // Corrected import

class AllTiffinServicesScreen extends StatefulWidget {
  const AllTiffinServicesScreen({super.key});

  @override
  State<AllTiffinServicesScreen> createState() => _AllTiffinServicesScreenState();
}

class _AllTiffinServicesScreenState extends State<AllTiffinServicesScreen> {
  int _selectedIndex = 1; // Tiffin is selected by default (index 1)

  // Example list of tiffin services (replace with your actual data source, e.g., Firebase)
  final List<Map<String, dynamic>> tiffinServices = [
    {
      'name': 'Tiffin Service 1',
      'landmark': 'Land Mark 1',
      'ratings': 3.5,
      'price': '200 / 10 Tiffin',
      'activeUsers': 50,
      'imageUrl': '', // Replace with actual image URL if available
    },
    {
      'name': 'Tiffin Service 2',
      'landmark': 'Land Mark 2',
      'ratings': 4.0,
      'price': '250 / 10 Tiffin',
      'activeUsers': 30,
      'imageUrl': '',
    },
    // Add more tiffin services as needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation logic for other tabs
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
      // Already on AllTiffinServicesScreen
        break;
      case 2:
        Navigator.pushNamed(context, '/qr-scanner');
        break;
      case 3:
        Navigator.pushNamed(context, '/orders');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ALL TIFFIN SERVICES :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'SEARCH',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tiffinServices.length,
                itemBuilder: (context, index) {
                  final service = tiffinServices[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to TiffinServiceDetailScreen with the selected service's details
                      Navigator.pushNamed(
                        context,
                        '/tiffin-service-detail',
                        arguments: {
                          'tiffinServiceName': service['name'],
                          'landmark': service['landmark'],
                          'ratings': service['ratings'],
                          'activeUsers': service['activeUsers'],
                          'imageUrl': service['imageUrl'],
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      service['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  service['landmark'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < service['ratings']
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: starIndex < service['ratings']
                                          ? Colors.yellow
                                          : Colors.grey,
                                      size: 16,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Price :',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                service['price'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
}