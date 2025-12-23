import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:booknex_partner/features/partner_onboarding/view/widgets/reusable_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationView extends StatelessWidget {
  final OnboardingViewModel vm;

  const LocationView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      title: "Location Details",
      bottomAction: NavigationButtons(
        onPrevious: vm.previousPage,
        onNext: vm.nextPage,
      ),
      children: [
        OnboardingTextFormField(
          label: "Branch / Business Name",
          controller: vm.branchNameController,
          icon: Icons.business,
          errorText: vm.errors['branchName'],
        ),
        OnboardingTextFormField(
          label: "Full Address",
          controller: vm.addressController,
          maxLines: 2,
          icon: Icons.location_on,
          errorText: vm.errors['address'],
        ),
        OnboardingTextFormField(
          label: "Landmark",
          controller: vm.landmarkController,
          icon: Icons.flag,
        ),
        Row(
          children: [
            Expanded(
              child: OnboardingTextFormField(
                label: "Pincode",
                controller: vm.pincodeController,
                keyboardType: TextInputType.number,
                errorText: vm.errors['pincode'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OnboardingTextFormField(
                label: "City",
                controller: vm.cityController,
                errorText: vm.errors['city'],
              ),
            ),
          ],
        ),
        OnboardingTextFormField(
          label: "State",
          controller: vm.stateController,
          errorText: vm.errors['state'],
        ),
        const SizedBox(height: 16),
        if (vm.location.latitude != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Coordinates: ${vm.location.latitude!.toStringAsFixed(4)}, ${vm.location.longitude!.toStringAsFixed(4)}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        OutlinedButton.icon(
          onPressed: () => _showMapPicker(context),
          icon: const Icon(Icons.map),
          label: Text(
            vm.location.latitude == null ? "Set on Map" : "Change Location",
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Parking Available?"),
          value: vm.location.hasParking,
          onChanged: (v) {
            vm.setParking(v);
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  void _showMapPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pick Location",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    vm.location.latitude ?? 12.9716,
                    vm.location.longitude ?? 77.5946,
                  ),
                  zoom: 14,
                ),
                onTap: (LatLng position) {
                  vm.updateCoordinates(position.latitude, position.longitude);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Location set successfully!")),
                  );
                },
                markers: vm.location.latitude != null
                    ? {
                        Marker(
                          markerId: const MarkerId('picked_location'),
                          position: LatLng(
                            vm.location.latitude!,
                            vm.location.longitude!,
                          ),
                        ),
                      }
                    : {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Tap on the map to set the exact location of your turf.",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
