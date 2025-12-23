import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booknex_partner/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _codeSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                _codeSent ? "Verify OTP" : "Register with Phone",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _codeSent
                    ? "Enter the 6-digit code sent to ${_phoneController.text}"
                    : "Enter your phone number to get started.",
              ),
              const SizedBox(height: 48),
              if (!_codeSent)
                OnboardingTextFormField(
                  label: "Phone Number",
                  controller: _phoneController,
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                )
              else
                OnboardingTextFormField(
                  label: "OTP Code",
                  controller: _otpController,
                  icon: Icons.lock_clock,
                  keyboardType: TextInputType.number,
                ),
              if (authVm.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    authVm.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authVm.isLoading
                      ? null
                      : () async {
                          if (!_codeSent) {
                            await authVm.verifyPhone(
                              _phoneController.text,
                              onCodeSent: (id) {
                                setState(() => _codeSent = true);
                              },
                              onError: (err) {
                                // Error handled by ViewModel/UI
                              },
                            );
                          } else {
                            final success = await authVm.confirmOtp(
                              _otpController.text,
                            );
                            if (success && mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/onboarding',
                              );
                            }
                          }
                        },
                  child: authVm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_codeSent ? "Verify OTP" : "Send OTP"),
                ),
              ),
              if (_codeSent)
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _codeSent = false),
                    child: const Text("Edit Phone Number"),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
