import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class SportSelectionView extends StatelessWidget {
  final OnboardingViewModel vm;

  const SportSelectionView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final sports = [
      "Cricket",
      "Box Cricket",
      "Football",
      "Practice Nets",
      "Badminton",
      "Other",
    ];
    return StepContainer(
      title: "Which sport is this ground for?",
      subtitle: "One sport per flow. You can add more later.",
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.selectedSport != null ? vm.nextPage : null,
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
          itemCount: sports.length,
          itemBuilder: (context, index) {
            final sport = sports[index];
            return SelectionCard(
              label: sport,
              isSelected: vm.selectedSport == sport,
              onTap: () {
                vm.setSport(sport);
                vm.nextPage();
              },
            );
          },
        ),
      ],
    );
  }
}
