import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class BankDetailsView extends StatelessWidget {
  final OnboardingViewModel vm;

  const BankDetailsView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "Bank & Payout Details",
      subtitle: "Tell us where to send your earnings.",
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
      children: [
        OnboardingTextFormField(
          label: "Account Holder Name",
          controller: vm.bankAccountHolderController,
          icon: Icons.badge,
          errorText: vm.errors['accountHolder'],
        ),
        OnboardingTextFormField(
          label: "Bank Name",
          controller: vm.bankNameController,
          icon: Icons.account_balance,
          errorText: vm.errors['bankName'],
        ),
        OnboardingTextFormField(
          label: "Account Number",
          controller: vm.bankAccountNumberController,
          keyboardType: TextInputType.number,
          icon: Icons.numbers,
          errorText: vm.errors['accountNumber'],
        ),
        OnboardingTextFormField(
          label: "IFSC Code",
          controller: vm.bankIfscController,
          icon: Icons.confirmation_number,
          errorText: vm.errors['ifsc'],
        ),
        OnboardingTextFormField(
          label: "UPI ID (Optional)",
          controller: vm.bankUpiController,
          icon: Icons.qr_code,
        ),
      ],
    );
  }
}
