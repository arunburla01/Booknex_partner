import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class PricingView extends StatelessWidget {
  final OnboardingViewModel vm;

  const PricingView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "Pricing per Hour",
      subtitle: "Set the base price for booking.",
      children: [
        const SizedBox(height: 40),
        OnboardingTextFormField(
          label: "Price (e.g., 1500)",
          controller: vm.priceController,
          keyboardType: TextInputType.number,
          icon: Icons.currency_rupee,
        ),
        const SizedBox(height: 16),
        const Text(
          "Note: This is the starting price for all grounds. No separate day/night pricing at this stage.",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
    );
  }
}
