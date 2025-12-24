import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:booknex_partner/welcome_page.dart';
import 'package:booknex_partner/features/partner_onboarding/partner_onboarding_module.dart';
import 'package:booknex_partner/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:booknex_partner/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    // We continue so the app doesn't stay on a white screen
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNex Partner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/onboarding': (context) => const PartnerOnboardingModule(),
      },
    );
  }
}
