import 'package:booknex_partner/widgets/textformfield.dart';
import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 12;
  bool _isNavigating = false;

  // --- Data State ---
  // Step 2: Sport
  String? _selectedSport;
  // Step 3: Ground Type
  String? _selectedGroundType;
  // Step 4: Number of Grounds
  int _groundCount = 1;
  // Step 5: Ground Details (Simplified for first ground)
  final _groundNameController = TextEditingController();
  final _groundSizeController = TextEditingController();
  String? _selectedPitchType;
  bool _isIndoor = false;
  bool _hasFloodlights = false;
  final _maxPlayersController = TextEditingController();

  // Step 6: Location Details
  final _locationNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  bool _hasParking = false;

  // Step 7: Availability
  final Set<String> _selectedDays = {
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  };
  TimeOfDay? _openingTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay? _closingTime = const TimeOfDay(hour: 22, minute: 0);

  // Step 8: Pricing
  final _priceController = TextEditingController();

  // Step 9: Amenities
  final Map<String, bool> _amenities = {
    "Washroom": false,
    "Drinking Water": false,
    "Changing Room": false,
    "Seating Area": false,
    "Equipment Provided": false,
    "Bowling Machine": false,
    "Canteen / Snacks": false,
  };

  // Step 11: Owner Details
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  bool _whatsappOptIn = true;

  // Step 12: Bank Details
  final _bankAccountHolderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankUpiController = TextEditingController();
  bool _termsAccepted = false;

  void _nextStep() {
    if (_isNavigating) return;
    if (_currentStep < _totalSteps - 1) {
      _isNavigating = true;
      _pageController
          .nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .then((_) => _isNavigating = false);
    }
  }

  void _previousStep() {
    if (_isNavigating) return;
    if (_currentStep > 0) {
      _isNavigating = true;
      _pageController
          .previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .then((_) => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentStep = index),
            children: [
              _buildHookScreen(),
              _buildSportSelectionScreen(),
              _buildGroundTypeScreen(),
              _buildGroundCountScreen(),
              _buildGroundDetailsScreen(),
              _buildLocationDetailsScreen(),
              _buildAvailabilityScreen(),
              _buildPricingScreen(),
              _buildAmenitiesScreen(),
              _buildMediaUploadScreen(),
              _buildOwnerDetailsScreen(),
              _buildBankDetailsScreen(),
            ],
          ),
          // Progress Bar
          Positioned(
            top: 50,
            left: 60,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _totalSteps,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Screen Builders ---

  Widget _buildHookScreen() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.green, // Placeholder for image
            ),
            child: const Center(
              child: Icon(Icons.stadium, size: 100, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Attach your ground with Booknex & start earning",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Make your ground available for online booking in minutes",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text("Get Started"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSportSelectionScreen() {
    final sports = [
      "Cricket",
      "Box Cricket",
      "Football",
      "Practice Nets",
      "Badminton",
      "Other",
    ];
    return _buildSelectionScreen(
      title: "Which sport is this ground for?",
      subtitle: "One sport per flow. You can add more later.",
      items: sports,
      onSelect: (val) {
        setState(() => _selectedSport = val);
        _nextStep();
      },
      selectedValue: _selectedSport,
      showNextButton: false,
    );
  }

  Widget _buildGroundTypeScreen() {
    final types = [
      "Big Open Ground",
      "Box Cricket",
      "Nets",
      "Turf",
      "Indoor",
      "Outdoor",
    ];
    return _buildSelectionScreen(
      title: "What type of ground is this?",
      items: types,
      onSelect: (val) {
        setState(() => _selectedGroundType = val);
        _nextStep();
      },
      selectedValue: _selectedGroundType,
      showNextButton: false,
    );
  }

  Widget _buildSelectionScreen({
    required String title,
    String? subtitle,
    required List<String> items,
    required Function(String) onSelect,
    String? selectedValue,
    bool showNextButton = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedValue == item;
                return InkWell(
                  onTap: () => onSelect(item),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.05)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text("Previous"),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 12),
              if (showNextButton)
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedValue != null ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text("Next"),
                  ),
                )
              else if (selectedValue == null)
                const Expanded(
                  child: SizedBox(
                    height: 56,
                    child: Center(
                      child: Text(
                        "Please select an option",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroundCountScreen() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How many grounds / courts / nets do you have for this sport?",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            "We will set up details for each one next.",
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _countButton(Icons.remove, () {
                  if (_groundCount > 1) setState(() => _groundCount--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "$_groundCount",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _countButton(Icons.add, () {
                  setState(() => _groundCount++);
                }),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text("Previous"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroundDetailsScreen() {
    return _buildScrollableStep(
      title: "Ground Details",
      subtitle: _groundCount > 1 ? "Setting up details for Ground 1" : null,
      children: [
        TextformfieldRUW(
          labelname: "Ground Name / Identifier",
          controller: _groundNameController,
          icon: Icons.badge,
        ),
        TextformfieldRUW(
          labelname: "Ground Size (e.g. 90x50 ft)",
          controller: _groundSizeController,
          icon: Icons.straighten,
        ),
        const SizedBox(height: 16),
        const Text(
          "Pitch / Surface Type",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8,
          children: ["Synthetic Turf", "Natural Grass", "Matting", "Cement"]
              .map((type) {
                final isSelected = _selectedPitchType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (v) =>
                      setState(() => _selectedPitchType = v ? type : null),
                );
              })
              .toList(),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Is this an Indoor ground?"),
          value: _isIndoor,
          onChanged: (v) => setState(() => _isIndoor = v),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text("Flood Lights Available?"),
          value: _hasFloodlights,
          onChanged: (v) => setState(() => _hasFloodlights = v),
          contentPadding: EdgeInsets.zero,
        ),
        TextformfieldRUW(
          labelname: "Maximum Players Allowed",
          controller: _maxPlayersController,
          keyboardType: TextInputType.number,
          icon: Icons.groups,
        ),
      ],
    );
  }

  Widget _buildLocationDetailsScreen() {
    return _buildScrollableStep(
      title: "Location Details",
      children: [
        TextformfieldRUW(
          labelname: "Location Name (Branch)",
          controller: _locationNameController,
          icon: Icons.business,
        ),
        TextformfieldRUW(
          labelname: "Full Address",
          controller: _addressController,
          maxLines: 2,
          icon: Icons.location_on,
        ),
        TextformfieldRUW(
          labelname: "Landmark",
          controller: _landmarkController,
          icon: Icons.flag,
        ),
        Row(
          children: [
            Expanded(
              child: TextformfieldRUW(
                labelname: "Pincode",
                controller: _pincodeController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextformfieldRUW(
                labelname: "City",
                controller: _cityController,
              ),
            ),
          ],
        ),
        TextformfieldRUW(labelname: "State", controller: _stateController),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {}, // Map picker placeholder
          icon: const Icon(Icons.map),
          label: const Text("Set Location on Map"),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text("Parking Available?"),
          value: _hasParking,
          onChanged: (v) => setState(() => _hasParking = v),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildAvailabilityScreen() {
    return _buildScrollableStep(
      title: "Availability & Slots",
      children: [
        const Text(
          "Operating Days",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8,
          children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((
            day,
          ) {
            final isSelected = _selectedDays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (v) {
                setState(() {
                  if (v) {
                    _selectedDays.add(day);
                  } else {
                    _selectedDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _timePickerTile(
                "Opening Time",
                _openingTime,
                (t) => setState(() => _openingTime = t),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _timePickerTile(
                "Closing Time",
                _closingTime,
                (t) => setState(() => _closingTime = t),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.timer),
          title: Text("Slot Duration"),
          trailing: Text(
            "1 Hour (Fixed)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingScreen() {
    return _buildScrollableStep(
      title: "Pricing",
      subtitle: "Simple hourly rates for your ground.",
      children: [
        const SizedBox(height: 40),
        Center(
          child: SizedBox(
            width: 200,
            child: TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                prefixText: "₹ ",
                suffixText: " / hr",
                hintText: "0",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableStep({
    required String title,
    String? subtitle,
    required List<Widget> children,
    String nextButtonText = "Next",
    VoidCallback? onNextPressed,
    bool isNextEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text("Previous"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isNextEnabled
                      ? (onNextPressed ?? _nextStep)
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(nextButtonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timePickerTile(
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

  Widget _countButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed),
    );
  }

  Widget _buildAmenitiesScreen() {
    return _buildScrollableStep(
      title: "Amenities",
      children: _amenities.keys.map((a) {
        return CheckboxListTile(
          title: Text(a),
          value: _amenities[a],
          onChanged: (v) => setState(() => _amenities[a] = v ?? false),
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildMediaUploadScreen() {
    return _buildScrollableStep(
      title: "Media Upload",
      children: [
        _uploadTile("Ground Photo (Required)"),
        _uploadTile("Pitch close-up (Required)"),
        if (_hasFloodlights) _uploadTile("Night View Photo"),
        _uploadTile("Optional Video"),
      ],
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

  Widget _buildOwnerDetailsScreen() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Owner & Business Details",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextformfieldRUW(
              labelname: "Owner / Manager Name",
              controller: _ownerNameController,
            ),
            TextformfieldRUW(
              labelname: "Mobile Number",
              controller: _mobileController,
              keyboardType: TextInputType.phone,
            ),
            CheckboxListTile(
              title: const Text("Send booking & payout updates on WhatsApp"),
              value: _whatsappOptIn,
              onChanged: (v) => setState(() => _whatsappOptIn = v ?? true),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            TextformfieldRUW(
              labelname: "Email ID (Optional)",
              controller: _emailController,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text("Previous"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text("Next"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetailsScreen() {
    return _buildScrollableStep(
      title: "Bank & Payout Details",
      subtitle: "Last step! Tell us where to send your earnings.",
      nextButtonText: "Submit",
      isNextEnabled: _termsAccepted,
      onNextPressed: () {
        // Submit logic
      },
      children: [
        TextformfieldRUW(
          labelname: "Account Holder Name",
          controller: _bankAccountHolderController,
          icon: Icons.person,
        ),
        TextformfieldRUW(
          labelname: "Bank Name",
          controller: _bankNameController,
          icon: Icons.account_balance,
        ),
        TextformfieldRUW(
          labelname: "Account Number",
          controller: _bankAccountNumberController,
          keyboardType: TextInputType.number,
          icon: Icons.numbers,
        ),
        TextformfieldRUW(
          labelname: "IFSC Code",
          controller: _bankIfscController,
          icon: Icons.confirmation_number,
        ),
        TextformfieldRUW(
          labelname: "UPI ID (Optional)",
          controller: _bankUpiController,
          icon: Icons.qr_code,
        ),
        const SizedBox(height: 16),
        const Text(
          "Payouts are processed every Monday for the previous week.",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          value: _termsAccepted,
          onChanged: (v) => setState(() => _termsAccepted = v ?? false),
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
                    onTap: _showTermsModal,
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
    );
  }

  void _showTermsModal() {
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Partner Agreement & Terms",
                      style: TextStyle(
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
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Partner Declaration & Agreement",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTermsSection(
                        "By submitting my ground on Booknex, I confirm and agree to the following:",
                        isIntro: true,
                      ),
                      _buildTermsSection(
                        "1. Ownership & Authority",
                        content:
                            "I confirm that I am the owner of the ground listed on Booknex, or I am legally authorized by the owner to manage and list this ground for bookings.",
                      ),
                      _buildTermsSection(
                        "2. Accuracy of Information",
                        content:
                            "I confirm that all details provided by me, including ground details, location, availability, pricing, photos, and contact information, are true, accurate, and up to date. I understand that providing incorrect or misleading information may result in suspension or removal of my listing.",
                      ),
                      _buildTermsSection(
                        "3. Booking Responsibility",
                        content:
                            "I agree to honor all confirmed bookings made through Booknex and not cancel or deny entry without a valid reason as per platform policies.",
                      ),
                      _buildTermsSection(
                        "4. Pricing Agreement",
                        content:
                            "I understand that the hourly price I set on Booknex is the final price shown to users, and I will not demand additional charges outside the platform.",
                      ),
                      _buildTermsSection(
                        "5. Platform Fees & Payments",
                        content:
                            "I agree that Booknex may charge a platform or service fee as per applicable policies, communicated in advance. Payouts will be processed only to the bank or UPI details provided by me.",
                      ),
                      _buildTermsSection(
                        "6. Cancellations & Refunds",
                        content:
                            "I agree to follow Booknex’s cancellation and refund policies for all bookings.",
                      ),
                      _buildTermsSection(
                        "7. Media Usage Rights",
                        content:
                            "I grant Booknex the right to use uploaded photos and videos of my ground for listing and promotional purposes.",
                      ),
                      _buildTermsSection(
                        "8. Communication Consent",
                        content:
                            "I agree to receive booking, payout, and service-related updates via WhatsApp, SMS, phone calls, or email using my registered contact details.",
                      ),
                      _buildTermsSection(
                        "9. Suspension & Removal",
                        content:
                            "I understand that Booknex reserves the right to suspend or remove my listing in case of repeated complaints, misuse, or policy violations.",
                      ),
                      _buildTermsSection(
                        "10. Liability Disclaimer",
                        content:
                            "I understand that Booknex acts only as a booking platform and is not responsible for on-ground disputes, injuries, or damages at my facility.",
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTermsSection(
    String title, {
    String? content,
    bool isIntro = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isIntro ? 15 : 16,
              fontWeight: isIntro ? FontWeight.normal : FontWeight.bold,
              height: 1.5,
            ),
          ),
          if (content != null) ...[
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _groundNameController.dispose();
    _groundSizeController.dispose();
    _maxPlayersController.dispose();
    _locationNameController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _priceController.dispose();
    _bankAccountHolderController.dispose();
    _bankNameController.dispose();
    _bankAccountNumberController.dispose();
    _bankIfscController.dispose();
    _bankUpiController.dispose();
    super.dispose();
  }
}
