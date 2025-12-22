import 'package:flutter/material.dart';

class TextformfieldRUW extends StatelessWidget {
  final String labelname;
  final TextEditingController controller;

  final RegExp? regexp;
  final String? msg;

  final bool requiredField;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? icon;
  final String? hintText;

  const TextformfieldRUW({
    super.key,
    required this.labelname,
    required this.controller,
    this.regexp,
    this.msg,
    this.requiredField = true,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.icon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: labelname,
          hintText: hintText,
          prefixIcon: icon == null ? null : Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final v = (value ?? '').trim();

          if (requiredField && v.isEmpty) return 'Required';
          if (v.isNotEmpty && regexp != null && !regexp!.hasMatch(v)) {
            return msg ?? 'Invalid';
          }
          return null;
        },
      ),
    );
  }
}
