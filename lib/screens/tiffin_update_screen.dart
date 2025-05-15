import 'package:flutter/material.dart';

class InMemoryStorage {
  static final Map<String, Map<String, dynamic>> _tiffinServices = {};

  static void updateTiffinService(String tiffinServiceName, int numberOfTiffins) {
    _tiffinServices[tiffinServiceName] = {
      'numberOfTiffins': numberOfTiffins,
      'menuItems': ['Daal Chawal', 'Roti', 'Bhindi'], // Default menu for testing
      'lastUpdated': DateTime.now().toString(),
    };
  }

  static Map<String, dynamic>? getTiffinService(String tiffinServiceName) {
    return _tiffinServices[tiffinServiceName];
  }
}

class TiffinUpdateScreen extends StatefulWidget {
  final String tiffinServiceName;
  final int numberOfTiffins;

  const TiffinUpdateScreen({
    super.key,
    required this.tiffinServiceName,
    required this.numberOfTiffins,
  });

  @override
  State<TiffinUpdateScreen> createState() => _TiffinUpdateScreenState();
}

class _TiffinUpdateScreenState extends State<TiffinUpdateScreen> {
  late int _numberOfTiffins;
  final TextEditingController _tiffinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberOfTiffins = widget.numberOfTiffins;
    _tiffinController.text = _numberOfTiffins.toString();
  }

  @override
  void dispose() {
    _tiffinController.dispose();
    super.dispose();
  }

  void _incrementTiffins() {
    setState(() {
      _numberOfTiffins++;
      _tiffinController.text = _numberOfTiffins.toString();
    });
  }

  void _decrementTiffins() {
    if (_numberOfTiffins > 0) {
      setState(() {
        _numberOfTiffins--;
        _tiffinController.text = _numberOfTiffins.toString();
      });
    }
  }

  void _updateTiffinsFromInput(String value) {
    final newValue = int.tryParse(value) ?? _numberOfTiffins;
    if (newValue >= 0) {
      setState(() {
        _numberOfTiffins = newValue;
      });
    } else {
      setState(() {
        _numberOfTiffins = 0;
        _tiffinController.text = '0';
      });
    }
  }

  void _updateTiffinCount() {
    // Update the in-memory storage
    InMemoryStorage.updateTiffinService(widget.tiffinServiceName, _numberOfTiffins);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tiffin count updated to $_numberOfTiffins successfully'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.tiffinServiceName,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Number of Tiffin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: _decrementTiffins,
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _tiffinController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 16),
                    onChanged: _updateTiffinsFromInput,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.red),
                  onPressed: _incrementTiffins,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTiffinCount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Update',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fastfood, size: 24, color: Colors.black),
                const SizedBox(width: 8),
                const Text(
                  'TiffinEZ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(
                  'TM',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}