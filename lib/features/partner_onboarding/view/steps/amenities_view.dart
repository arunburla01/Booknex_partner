import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class AmenitiesView extends StatelessWidget {
  final OnboardingViewModel vm;

  const AmenitiesView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    // Assuming amenities are global or apply to all for now as per previous logic
    final firstGround = vm.grounds.isNotEmpty ? vm.grounds[0] : null;

    return StepContainer(
      title: "Amenities",
      children:
          firstGround?.amenities.keys.map((a) {
            return CheckboxListTile(
              title: Text(a),
              value: firstGround.amenities[a],
              onChanged: (v) {
                vm.setAmenity(a, v ?? false);
              },
              contentPadding: EdgeInsets.zero,
            );
          }).toList() ??
          [],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
    );
  }
}
