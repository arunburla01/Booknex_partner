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
        ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: OnboardingTextFormField(
                        label: "Mobile Number",
                        controller: vm.mobileController,
                        keyboardType: TextInputType.phone,
                        icon: Icons.phone,
                        errorText: vm.errors['mobile'],
                        enabled: !vm.isPhoneVerified && !vm.isAuthLoading,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!vm.isPhoneVerified)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: vm.isAuthLoading ? null : vm.sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: vm.isAuthLoading && !vm.isOtpSent
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(vm.isOtpSent ? "Resend" : "Verify"),
                        ),
                      ),
                    if (vm.isPhoneVerified)
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0, right: 8.0),
                        child: Icon(Icons.check_circle, color: Colors.green),
                      ),
                  ],
                ),
                if (vm.isOtpSent) ...[
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: OnboardingTextFormField(
                          label: "Enter 6-digit OTP",
                          controller: vm.otpController,
                          keyboardType: TextInputType.number,
                          icon: Icons.lock_outline,
                          errorText: vm.errors['otp'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: vm.isAuthLoading ? null : vm.verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: vm.isAuthLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Confirm"),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
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
    );
  }
}
