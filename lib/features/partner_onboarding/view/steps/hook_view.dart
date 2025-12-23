import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';

class HookView extends StatelessWidget {
  final OnboardingViewModel vm;

  const HookView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.green, // Placeholder for image
            ),
            child: const Center(
              child: Icon(Icons.stadium, size: 100, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Attach your ground with Booknex & start earning",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Join 500+ ground owners. Go live in minutes.",
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: vm.nextPage,
                    child: const Text("Get Started"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
