import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/terms_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class TermsView extends StatelessWidget {
  final OnboardingViewModel vm;

  const TermsView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final termsVm = context.watch<TermsViewModel>();

    return StepContainer(
      title: "Declaration & Terms",
      subtitle: "Final step to get started.",
      children: [
        const SizedBox(height: 40),
        CheckboxListTile(
          value: vm.terms.isAccepted,
          onChanged: (v) => vm.toggleTerms(v),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 13),
              children: [
                const TextSpan(text: "I have read and agree to the "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () => _showTermsModal(context, termsVm),
                    child: Text(
                      "Partner Agreement, Terms of Service, and Privacy Policy",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: " of Booknex."),
              ],
            ),
          ),
        ),
      ],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.terms.isAccepted
            ? () {
                // Final Submit action
                print("Submitting Final Partner Onboarding Data...");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Onboarding Submitted Successfully!"),
                  ),
                );
                Navigator.of(context).pushReplacementNamed('/');
              }
            : null,
        nextLabel: "Submit",
        isNextEnabled: vm.terms.isAccepted,
      ),
    );
  }

  void _showTermsModal(BuildContext context, TermsViewModel termsVm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      termsVm.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Please read carefully:",
                        style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...termsVm.terms.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${entry.key + 1}. ",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.black26,
                child: ElevatedButton(
                  onPressed: () {
                    vm.toggleTerms(true);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text("I Accept"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
