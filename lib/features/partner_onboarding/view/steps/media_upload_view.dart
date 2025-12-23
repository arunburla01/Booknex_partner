import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class MediaUploadView extends StatelessWidget {
  final OnboardingViewModel vm;

  const MediaUploadView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "Media Upload",
      children: [
        _uploadTile("Ground Photo (Required)"),
        _uploadTile("Pitch close-up (Required)"),
        _uploadTile("Optional Video"),
      ],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
    );
  }

  Widget _uploadTile(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_a_photo, color: Colors.grey),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
