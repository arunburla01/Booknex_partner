import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';

class AvailabilityView extends StatelessWidget {
  final OnboardingViewModel vm;
  final int groundIndex;

  const AvailabilityView({
    super.key,
    required this.vm,
    required this.groundIndex,
  });

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "Availability for Ground ${groundIndex + 1}",
      children: [
        const Text(
          "Operating Days",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((
            day,
          ) {
            final isSelected = vm.grounds[groundIndex].operatingDays.contains(
              day,
            );
            return FilterChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (v) {
                vm.toggleOperatingDay(groundIndex, day);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _timePickerTile(
                context,
                "Opening Time",
                vm.grounds[groundIndex].openingTime,
                (t) {
                  vm.setOpeningTime(groundIndex, t);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _timePickerTile(
                context,
                "Closing Time",
                vm.grounds[groundIndex].closingTime,
                (t) {
                  vm.setClosingTime(groundIndex, t);
                },
              ),
            ),
          ],
        ),
      ],
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
    );
  }

  Widget _timePickerTile(
    BuildContext context,
    String label,
    TimeOfDay? time,
    Function(TimeOfDay) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time ?? TimeOfDay.now(),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time?.format(context) ?? "Pick"),
                const Icon(Icons.access_time, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
