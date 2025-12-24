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
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
      children: [
        OnboardingTextFormField(
          label: "Owner / Manager Name",
          controller: vm.ownerNameController,
          icon: Icons.person,
          errorText: vm.errors['ownerName'],
        ),
        OnboardingTextFormField(
          label: "Mobile Number",
          controller: vm.mobileController,
          keyboardType: TextInputType.phone,
          icon: Icons.phone,
          errorText: vm.errors['mobile'],
          enabled:
              false, // Mobile number verified at start, so it's read-only here
        ),
        ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            return CheckboxListTile(
              title: const Text("Send updates on WhatsApp"),
              value: vm.owner.whatsappOptIn,
              onChanged: (v) {
                vm.setWhatsappOptIn(v ?? true);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          },
        ),
        OnboardingTextFormField(
          label: "Email ID (Optional)",
          controller: vm.emailController,
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email,
        ),
      ],
    );
  }
}
