import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class GroundCountView extends StatelessWidget {
  final OnboardingViewModel vm;

  const GroundCountView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "How many grounds / courts / nets do you have for this sport?",
      subtitle: "We will set up details for each one next.",
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
      children: [
        const SizedBox(height: 100),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _countButton(Icons.remove, () {
                if (vm.groundCount > 1) {
                  vm.updateGroundCount(vm.groundCount - 1);
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "${vm.groundCount}",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _countButton(
                Icons.add,
                () => vm.updateGroundCount(vm.groundCount + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _countButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed),
    );
  }
}
