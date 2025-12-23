import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/terms_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/onboarding_screen.dart';

class PartnerOnboardingModule extends StatelessWidget {
  const PartnerOnboardingModule({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => TermsViewModel()),
      ],
      child: const OnboardingScreen(),
    );
  }
}
