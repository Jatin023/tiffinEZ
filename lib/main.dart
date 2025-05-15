import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/tiffin_update_screen.dart';
import 'screens/all-tiffin-services.dart';
import 'screens/orders_screen.dart';
import 'screens/tiffin_service_details_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/update_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/all-tiffin-services': (context) => const AllTiffinServicesScreen(),
        '/qr-scanner': (context) => const QRScannerScreen(),
        '/tiffin-update': (context) => const TiffinUpdateScreen(
          tiffinServiceName: '',
          numberOfTiffins: 0,
        ),
        '/orders': (context) => const OrdersScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/update-profile': (context) => const UpdateProfileScreen(),
      },
      // ✅ OTP route handled dynamically to pass arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => OTPScreen(
              verificationId: args['verificationId'],
              phoneNumber: args['phoneNumber'],
            ),
          );
        }

        if (settings.name == '/tiffin-service-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => TiffinServiceDetailScreen(
              tiffinServiceName: args['tiffinServiceName'] ?? 'Unknown',
              landmark: args['landmark'] ?? 'Unknown',
              ratings: (args['ratings'] as num?)?.toDouble() ?? 0.0,
              activeUsers: (args['activeUsers'] as num?)?.toInt() ?? 0,
              imageUrl: args['imageUrl'] ?? '',
            ),
          );
        }

        return null; // fallback
      },
    );
  }
}
