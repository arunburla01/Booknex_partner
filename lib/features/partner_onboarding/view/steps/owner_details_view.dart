import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class OwnerDetailsView extends StatelessWidget {
  final OnboardingViewModel vm;

  const OwnerDetailsView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "Owner & Business Details",
      children: [
        OnboardingTextFormField(
          label: "Owner / Manager Name",
          controller: vm.ownerNameController,
          icon: Icons.person,
        ),
        OnboardingTextFormField(
          label: "Mobile Number",
          controller: vm.mobileController,
          keyboardType: TextInputType.phone,
          icon: Icons.phone,
        ),
        CheckboxListTile(
          title: const Text("Send updates on WhatsApp"),
          value: vm.owner.whatsappOptIn,
          onChanged: (v) {
            vm.setWhatsappOptIn(v ?? true);
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        OnboardingTextFormField(
          label: "Email ID (Optional)",
          controller: vm.emailController,
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email,
        ),
      ],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
    );
  }
}
