import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/Welcome_screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/services/guest_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await SupabaseService().initialize();

    // Restore guest session if exists
    final guestService = GuestService();
    await guestService.restoreGuestSession();
    debugPrint("✅ Guest session restoration attempted");
  } catch (e) {
    // Handle error or just print it for now.
    debugPrint("Failed to initialize services: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kraveai',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
