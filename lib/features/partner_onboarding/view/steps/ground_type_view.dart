import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class GroundTypeView extends StatelessWidget {
  final OnboardingViewModel vm;

  const GroundTypeView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final types = [
      "Big Open Ground",
      "Box Cricket",
      "Nets",
      "Turf",
      "Indoor",
      "Outdoor",
    ];
    return StepContainer(
      title: "What type of ground is this?",
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.selectedGroundType != null ? vm.nextPage : null,
      ),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: types.length,
          itemBuilder: (context, index) {
            final type = types[index];
            return SelectionCard(
              label: type,
              isSelected: vm.selectedGroundType == type,
              onTap: () {
                vm.setGroundType(type);
                vm.nextPage();
              },
            );
          },
        ),
      ],
    );
  }
}
