import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class LocationView extends StatelessWidget {
  final OnboardingViewModel vm;

  const LocationView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "Location Details",
      children: [
        OnboardingTextFormField(
          label: "Branch / Business Name",
          controller: vm.branchNameController,
          icon: Icons.business,
        ),
        OnboardingTextFormField(
          label: "Full Address",
          controller: vm.addressController,
          maxLines: 2,
          icon: Icons.location_on,
        ),
        OnboardingTextFormField(
          label: "Landmark",
          controller: vm.landmarkController,
          icon: Icons.flag,
        ),
        Row(
          children: [
            Expanded(
              child: OnboardingTextFormField(
                label: "Pincode",
                controller: vm.pincodeController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OnboardingTextFormField(
                label: "City",
                controller: vm.cityController,
              ),
            ),
          ],
        ),
        OnboardingTextFormField(label: "State", controller: vm.stateController),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {}, // Map picker placeholder
          icon: const Icon(Icons.map),
          label: const Text("Set on Map"),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Parking Available?"),
          value: vm.location.hasParking,
          onChanged: (v) {
            vm.setParking(v);
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
    );
  }
}
