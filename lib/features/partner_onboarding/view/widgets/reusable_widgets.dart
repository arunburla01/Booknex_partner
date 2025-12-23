import 'package:flutter/material.dart';

class OnboardingTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscureText;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool enabled;

  const OnboardingTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.errorText,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        obscureText: obscureText,
        validator: validator,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }
}

class StepContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? bottomAction;

  const StepContainer({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
          if (bottomAction != null) ...[
            const SizedBox(height: 16),
            bottomAction!,
          ],
        ],
      ),
    );
  }
}

class NavigationButtons extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final String nextLabel;
  final bool isNextEnabled;
  final bool showPrevious;

  const NavigationButtons({
    super.key,
    required this.onPrevious,
    this.onNext,
    this.nextLabel = "Next",
    this.isNextEnabled = true,
    this.showPrevious = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showPrevious)
          Expanded(
            child: OutlinedButton(
              onPressed: onPrevious,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Previous"),
            ),
          ),
        if (showPrevious && onNext != null) const SizedBox(width: 12),
        if (onNext != null)
          Expanded(
            child: ElevatedButton(
              onPressed: isNextEnabled ? onNext : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(nextLabel),
            ),
          ),
      ],
    );
  }
}

class SelectionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? theme.primaryColor.withValues(alpha: 0.05) : null,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.primaryColor : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
