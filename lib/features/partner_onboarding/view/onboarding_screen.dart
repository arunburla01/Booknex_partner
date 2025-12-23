import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/hook_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/sport_selection_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/ground_type_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/ground_count_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/ground_details_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/availability_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/location_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/pricing_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/amenities_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/media_upload_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/owner_details_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/bank_details_view.dart';
import 'package:booknex_partner/features/partner_onboarding/view/steps/terms_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: vm.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: vm.updateStep,
            itemCount: vm.totalSteps,
            itemBuilder: (context, index) {
              return _buildStep(index, vm);
            },
          ),
          // Progress Bar
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              children: List.generate(
                vm.totalSteps,
                (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= vm.currentPageIndex
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int index, OnboardingViewModel vm) {
    // Dynamic routing within PageView
    if (index == 0) return HookView(vm: vm);
    if (index == 1) return SportSelectionView(vm: vm);
    if (index == 2) return GroundTypeView(vm: vm);
    if (index == 3) return GroundCountView(vm: vm);

    // Ground repetition logic
    int groundStepsStart = 4;
    int groundStepsEnd = groundStepsStart + (vm.groundCount * 2);

    if (index < groundStepsEnd) {
      int offset = index - groundStepsStart;
      int groundIndex = offset ~/ 2;
      bool isDetails = offset % 2 == 0;
      if (isDetails) {
        return GroundDetailsView(vm: vm, groundIndex: groundIndex);
      } else {
        return AvailabilityView(vm: vm, groundIndex: groundIndex);
      }
    }

    // Static remaining steps
    int remainingOffset = index - groundStepsEnd;
    switch (remainingOffset) {
      case 0:
        return LocationView(vm: vm);
      case 1:
        return PricingView(vm: vm);
      case 2:
        return AmenitiesView(vm: vm);
      case 3:
        return MediaUploadView(vm: vm);
      case 4:
        return OwnerDetailsView(vm: vm);
      case 5:
        return BankDetailsView(vm: vm);
      case 6:
        return TermsView(vm: vm);
      default:
        return const Center(child: Text("Invalid Step"));
    }
  }
}
