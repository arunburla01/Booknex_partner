import 'dart:io';
import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class MediaUploadView extends StatelessWidget {
  final OnboardingViewModel vm;

  const MediaUploadView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    // For now, mapping media to the first ground or facility-wide
    final ground = vm.grounds.isNotEmpty ? vm.grounds[0] : null;

    return StepContainer(
      title: "Media Upload",
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
      children: [
        const Text(
          "Upload high-quality photos of your facility to attract more players.",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: () => vm.pickImages(0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_a_photo,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tap to upload photos",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "You can select multiple images",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (ground != null && ground.imagePaths.isNotEmpty)
          _buildImageGrid(ground.imagePaths),
      ],
    );
  }

  Widget _buildImageGrid(List<String> paths) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: paths.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(paths[index]), fit: BoxFit.cover),
        );
      },
    );
  }
}
