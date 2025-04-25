import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/all_tiffin_services_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/payment_screen.dart'; // Add this import
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load .env file
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  runApp(const TiffinEZApp());
}

class TiffinEZApp extends StatelessWidget {
  const TiffinEZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiffinEZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/splash', // Changed back to /splash for proper flow
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/otp': (context) => const OTPScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/all-tiffin-services': (context) => const AllTiffinServicesScreen(),
        '/qr-scanner': (context) => const QRScannerScreen(),
        '/payment': (context) { // Add this route
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return PaymentScreen(
            tiffinServiceName: args['tiffinServiceName']!,
            price: args['price']!,
          );
        },
      },
    );
  }
}