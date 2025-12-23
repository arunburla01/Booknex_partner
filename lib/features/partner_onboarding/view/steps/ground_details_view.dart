import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class GroundDetailsView extends StatelessWidget {
  final OnboardingViewModel vm;
  final int groundIndex;

  const GroundDetailsView({
    super.key,
    required this.vm,
    required this.groundIndex,
  });

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "About your Ground ${groundIndex + 1}",
      children: [
        OnboardingTextFormField(
          label: "Ground Name / Identifier",
          controller: vm.groundNameController,
          icon: Icons.badge,
        ),
        OnboardingTextFormField(
          label: "Physical Size (e.g., 90x50 ft)",
          controller: vm.groundSizeController,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 16),
        const Text(
          "Surface Type",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ["Synthetic Turf", "Natural Grass", "Matting", "Cement"]
              .map((type) {
                final isSelected = vm.grounds[groundIndex].surfaceType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (v) {
                    vm.setSurfaceType(groundIndex, v ? type : null);
                  },
                );
              })
              .toList(),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Indoor Ground?"),
          value: vm.grounds[groundIndex].isIndoor,
          onChanged: (v) {
            vm.setIndoor(groundIndex, v);
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text("Flood Lights?"),
          value: vm.grounds[groundIndex].hasFloodlights,
          onChanged: (v) {
            vm.setFloodlights(groundIndex, v);
          },
          contentPadding: EdgeInsets.zero,
        ),
        OnboardingTextFormField(
          label: "Max Players Allowed",
          controller: vm.maxPlayersController,
          keyboardType: TextInputType.number,
          icon: Icons.groups,
        ),
      ],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
    );
  }
}
