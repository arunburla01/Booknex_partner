import 'package:flutter/material.dart';
import 'package:booknex_partner/welcome_page.dart';
import 'package:booknex_partner/features/partner_onboarding/partner_onboarding_module.dart';

void main() {
  runApp(const MyApp());
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
