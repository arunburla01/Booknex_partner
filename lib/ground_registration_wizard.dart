import 'package:flutter/material.dart';
import 'package:booknex_partner/widgets/textformfield.dart';

class GroundRegistrationWizard extends StatefulWidget {
  const GroundRegistrationWizard({super.key});

  @override
  State<GroundRegistrationWizard> createState() =>
      _GroundRegistrationWizardState();
}

class _GroundRegistrationWizardState extends State<GroundRegistrationWizard> {
  int _step = 0;

  // one Form key per step (so Stepper validation works nicely)
  final _keys = List.generate(8, (_) => GlobalKey<FormState>());

  // ✅ 1) Owner
  final _ownerName = TextEditingController();
  final _phonePrimary = TextEditingController();
  final _phoneWhatsapp = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  String _govtIdType = 'Aadhaar';
  final _govtIdNumber = TextEditingController();
  String? _ownerPhotoPath; // placeholder

  // ✅ 2) Ground/Turf
  final _groundName = TextEditingController();
  String _groundType = 'Cricket Ground';
  final _sizeDimensions = TextEditingController();
  final _netsPitches = TextEditingController();
  String _pitchType = 'Turf';
  final _groundDescription = TextEditingController();
  final List<String> _groundPhotoPaths = []; // placeholder

  // ✅ 3) Location
  final _state = TextEditingController();
  final _city = TextEditingController();
  final _area = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  final _landmark = TextEditingController();

  // ✅ 4) Pricing
  final _hourlyMorning = TextEditingController();
  final _hourlyEvening = TextEditingController();
  final _perMatch = TextEditingController();
  final _weekend = TextEditingController();
  final _peakHour = TextEditingController();
  final _nightRate = TextEditingController();

  // ✅ 5) Facilities
  final Map<String, bool> _facilities = {
    'Floodlights': false,
    'Parking': false,
    'Washrooms': false,
    'Changing Rooms': false,
    'Drinking Water': false,
    'Scoreboard': false,
    'Umpire Available': false,
    'Refreshments / Canteen': false,
    'Equipment Rental': false,
    'Bats': false,
    'Stumps': false,
    'Balls': false,
    'Kits': false,
  };

  // ✅ 6) Availability
  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;
  final Set<String> _closedDays = {};
  final _specialDayPricing = TextEditingController();
  final _cancellationRules = TextEditingController();

  // ✅ 7) Bank
  final _accountNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _accountHolder = TextEditingController();
  final _upiId = TextEditingController();
  final _gst = TextEditingController();

  // ✅ 8) Legal
  String? _agreementPdfPath; // placeholder
  bool _termsAccepted = false;
  final _digitalSignature = TextEditingController();

  // --- regex helpers ---
  final _phoneRe = RegExp(r'^\d{10}$');
  final _emailRe = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final _aadhaarRe = RegExp(r'^\d{12}$');
  final _panRe = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  final _ifscRe = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  final _upiRe = RegExp(r'^[\w.\-]{2,}@[a-zA-Z]{2,}$');

  bool _validateStep(int index) {
    final ok = _keys[index].currentState?.validate() ?? false;

    // extra validations not covered by TextFormField alone:
    if (index == 6) {
      // bank step - additional check: IFSC uppercase
      if (_ifsc.text.trim().isNotEmpty &&
          !_ifscRe.hasMatch(_ifsc.text.trim().toUpperCase())) {
        _showSnack('Enter valid IFSC code');
        return false;
      }
    }

    if (index == 7) {
      if (!_termsAccepted) {
        _showSnack('Please accept Terms to continue');
        return false;
      }
    }

    return ok;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickTime({required bool opening}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;
    setState(() {
      if (opening) {
        _openingTime = picked;
      } else {
        _closingTime = picked;
      }
    });
  }

  void _next() {
    if (_validateStep(_step)) {
      if (_step < 7) setState(() => _step++);
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _submit() {
    // validate all steps
    for (int i = 0; i < 8; i++) {
      final ok = _validateStep(i);
      if (!ok) {
        setState(() => _step = i);
        return;
      }
    }

    // ✅ At this point everything is valid.
    // TODO: build payload and send to API / Firestore etc.
    _showSnack('All details valid. Ready to submit.');
  }

  @override
  void dispose() {
    // owner
    _ownerName.dispose();
    _phonePrimary.dispose();
    _phoneWhatsapp.dispose();
    _email.dispose();
    _address.dispose();
    _govtIdNumber.dispose();

    // ground
    _groundName.dispose();
    _sizeDimensions.dispose();
    _netsPitches.dispose();
    _groundDescription.dispose();

    // location
    _state.dispose();
    _city.dispose();
    _area.dispose();
    _latitude.dispose();
    _longitude.dispose();
    _landmark.dispose();

    // pricing
    _hourlyMorning.dispose();
    _hourlyEvening.dispose();
    _perMatch.dispose();
    _weekend.dispose();
    _peakHour.dispose();
    _nightRate.dispose();

    // availability
    _specialDayPricing.dispose();
    _cancellationRules.dispose();

    // bank
    _accountNumber.dispose();
    _ifsc.dispose();
    _accountHolder.dispose();
    _upiId.dispose();
    _gst.dispose();

    // legal
    _digitalSignature.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ground Registration')),
      body: Stepper(
        currentStep: _step,
        onStepContinue: _step == 7 ? _submit : _next,
        onStepCancel: _back,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(_step == 7 ? 'Submit' : 'Save & Continue'),
              ),
              const SizedBox(width: 12),
              if (_step > 0)
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text('Owner Details'),
            isActive: _step >= 0,
            content: Form(
              key: _keys[0],
              child: Column(
                children: [
                  TextformfieldRUW(
                    labelname: 'Full Name',
                    controller: _ownerName,
                    icon: Icons.person,
                  ),
                  TextformfieldRUW(
                    labelname: 'Phone Number (Primary)',
                    controller: _phonePrimary,
                    keyboardType: TextInputType.phone,
                    regexp: _phoneRe,
                    msg: 'Enter valid 10-digit phone number',
                    icon: Icons.phone,
                  ),
                  TextformfieldRUW(
                    labelname: 'Phone Number (WhatsApp)',
                    controller: _phoneWhatsapp,
                    keyboardType: TextInputType.phone,
                    regexp: _phoneRe,
                    msg: 'Enter valid 10-digit WhatsApp number',
                    icon: Icons.chat,
                  ),
                  TextformfieldRUW(
                    labelname: 'Email Address',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    regexp: _emailRe,
                    msg: 'Enter valid email',
                    icon: Icons.email,
                  ),
                  TextformfieldRUW(
                    labelname: 'Address',
                    controller: _address,
                    maxLines: 3,
                    icon: Icons.location_on,
                  ),
                  DropdownButtonFormField<String>(
                    value: _govtIdType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Government ID Type',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Aadhaar',
                        child: Text('Aadhaar'),
                      ),
                      DropdownMenuItem(value: 'PAN', child: Text('PAN')),
                    ],
                    onChanged: (v) =>
                        setState(() => _govtIdType = v ?? 'Aadhaar'),
                  ),
                  const SizedBox(height: 8),
                  TextformfieldRUW(
                    labelname: 'Government ID Number',
                    controller: _govtIdNumber,
                    keyboardType: TextInputType.text,
                    regexp: _govtIdType == 'Aadhaar' ? _aadhaarRe : _panRe,
                    msg: _govtIdType == 'Aadhaar'
                        ? 'Aadhaar must be 12 digits'
                        : 'PAN format like ABCDE1234F',
                    icon: Icons.badge,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _ownerPhotoPath == null
                          ? 'Owner Photo (optional)'
                          : 'Owner Photo selected',
                    ),
                    subtitle: const Text(
                      'Placeholder: integrate image_picker later',
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        setState(
                          () => _ownerPhotoPath = 'picked/path.jpg',
                        ); // placeholder
                      },
                      child: const Text('Pick'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Step(
            title: const Text('Ground / Turf Details'),
            isActive: _step >= 1,
            content: Form(
              key: _keys[1],
              child: Column(
                children: [
                  TextformfieldRUW(
                    labelname: 'Ground Name',
                    controller: _groundName,
                    icon: Icons.stadium,
                  ),
                  DropdownButtonFormField<String>(
                    value: _groundType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ground Type',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Cricket Ground',
                        child: Text('Cricket Ground'),
                      ),
                      DropdownMenuItem(
                        value: 'Turf (5s / 7s)',
                        child: Text('Turf (5s / 7s)'),
                      ),
                      DropdownMenuItem(
                        value: 'Box Cricket',
                        child: Text('Box Cricket'),
                      ),
                      DropdownMenuItem(
                        value: 'Multi-sports',
                        child: Text('Multi-sports'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _groundType = v ?? 'Cricket Ground'),
                  ),
                  const SizedBox(height: 8),
                  TextformfieldRUW(
                    labelname: 'Size / Dimensions',
                    controller: _sizeDimensions,
                    requiredField: false,
                    icon: Icons.straighten,
                    hintText: 'e.g., 90ft x 50ft',
                  ),
                  TextformfieldRUW(
                    labelname: 'Number of Nets / Pitches',
                    controller: _netsPitches,
                    keyboardType: TextInputType.number,
                    requiredField: false,
                    icon: Icons.confirmation_number,
                    regexp: RegExp(r'^\d*$'),
                    msg: 'Enter a number',
                  ),
                  DropdownButtonFormField<String>(
                    value: _pitchType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pitch Type',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Turf', child: Text('Turf')),
                      DropdownMenuItem(
                        value: 'Matting',
                        child: Text('Matting'),
                      ),
                      DropdownMenuItem(value: 'Cement', child: Text('Cement')),
                      DropdownMenuItem(
                        value: 'Natural Grass',
                        child: Text('Natural Grass'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _pitchType = v ?? 'Turf'),
                  ),
                  const SizedBox(height: 8),
                  TextformfieldRUW(
                    labelname: 'Ground Description',
                    controller: _groundDescription,
                    maxLines: 4,
                    requiredField: false,
                    icon: Icons.description,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Ground Photos (carousel) - ${_groundPhotoPaths.length} selected',
                    ),
                    subtitle: const Text(
                      'Placeholder: integrate multi-image picker later',
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        setState(
                          () => _groundPhotoPaths.add(
                            'picked/ground_${_groundPhotoPaths.length}.jpg',
                          ),
                        );
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Step(
            title: const Text('Location Details'),
            isActive: _step >= 2,
            content: Form(
              key: _keys[2],
              child: Column(
                children: [
                  TextformfieldRUW(
                    labelname: 'State',
                    controller: _state,
                    icon: Icons.map,
                  ),
                  TextformfieldRUW(
                    labelname: 'City',
                    controller: _city,
                    icon: Icons.location_city,
                  ),
                  TextformfieldRUW(
                    labelname: 'Area / Locality',
                    controller: _area,
                    icon: Icons.place,
                  ),
                  TextformfieldRUW(
                    labelname: 'Latitude',
                    controller: _latitude,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    regexp: RegExp(r'^-?\d+(\.\d+)?$'),
                    msg: 'Enter valid latitude',
                    icon: Icons.my_location,
                  ),
                  TextformfieldRUW(
                    labelname: 'Longitude',
                    controller: _longitude,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    regexp: RegExp(r'^-?\d+(\.\d+)?$'),
                    msg: 'Enter valid longitude',
                    icon: Icons.my_location,
                  ),
                  TextformfieldRUW(
                    labelname: 'Landmark (optional)',
                    controller: _landmark,
                    requiredField: false,
                    icon: Icons.flag,
                  ),
                ],
              ),
            ),
          ),

          Step(
            title: const Text('Pricing Details'),
            isActive: _step >= 3,
            content: Form(
              key: _keys[3],
              child: Column(
                children: [
                  TextformfieldRUW(
                    labelname: 'Hourly Rate (Morning)',
                    controller: _hourlyMorning,
                    keyboardType: TextInputType.number,
                    regexp: RegExp(r'^\d+(\.\d+)?$'),
                    msg: 'Enter valid amount',
                    icon: Icons.currency_rupee,
                  ),
                  TextformfieldRUW(
                    labelname: 'Hourly Rate (Evening)',
                    controller: _hourlyEvening,
                    keyboardType: TextInputType.number,
                    regexp: RegExp(r'^\d+(\.\d+)?$'),
                    msg: 'Enter valid amount',
                    icon: Icons.currency_rupee,
                  ),
                  TextformfieldRUW(
                    labelname: 'Per Match Rate',
                    controller: _perMatch,
                    keyboardType: TextInputType.number,
                    requiredField: false,
                    regexp: RegExp(r'^\d+(\.\d+)?$'),
                    msg: 'Enter valid amount',
                    icon: Icons.sports_cricket,
                  ),
                  TextformfieldRUW(
                    labelname: 'Weekend Price',
                    controller: _weekend,
                    keyboardType: TextInputType.number,
                    requiredField: false,
                    regexp: RegExp(r'^\d+(\.\d+)?$'),
                    msg: 'Enter valid amount',
                    icon: Icons.weekend,
                  ),
                  TextformfieldRUW(
                    labelname: 'Peak Hour Price',
                    controller: _peakHour,
                    keyboardType: TextInputType.number,
                    requiredField: false,
                    regexp: RegExp(r'^\d+(\.\d+)?$'),
                    msg: 'Enter valid amount',
                    icon: Icons.trending_up,
                  ),
                  TextformfieldRUW(
                    labelname: 'Night Match Rate (if floodlights)',
                    controller: _nightRate,
                    keyboardType: TextInputType.number,
                    requiredField: false,
                    regexp: RegExp(r'^\d+(\.\d+)?$'),
                    msg: 'Enter valid amount',
                    icon: Icons.nightlight_round,
                  ),
                ],
              ),
            ),
          ),

          Step(
            title: const Text('Facility Details'),
            isActive: _step >= 4,
            content: Form(
              key: _keys[4],
              child: Column(
                children: _facilities.entries.map((e) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(e.key),
                    value: e.value,
                    onChanged: (v) =>
                        setState(() => _facilities[e.key] = v ?? false),
                  );
                }).toList(),
              ),
            ),
          ),

          Step(
            title: const Text('Availability Details'),
            isActive: _step >= 5,
            content: Form(
              key: _keys[5],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => _pickTime(opening: true),
                    child: Text(
                      _openingTime == null
                          ? 'Pick Opening Time'
                          : 'Opening: ${_openingTime!.format(context)}',
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _pickTime(opening: false),
                    child: Text(
                      _closingTime == null
                          ? 'Pick Closing Time'
                          : 'Closing: ${_closingTime!.format(context)}',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Closed Days (optional)'),
                  Wrap(
                    spacing: 8,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .map((d) {
                          final selected = _closedDays.contains(d);
                          return FilterChip(
                            label: Text(d),
                            selected: selected,
                            onSelected: (v) {
                              setState(() {
                                if (v) {
                                  _closedDays.add(d);
                                } else {
                                  _closedDays.remove(d);
                                }
                              });
                            },
                          );
                        })
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  TextformfieldRUW(
                    labelname: 'Special Days Pricing (optional)',
                    controller: _specialDayPricing,
                    requiredField: false,
                    maxLines: 2,
                    icon: Icons.event,
                    hintText: 'e.g., Festival day +20%',
                  ),
                  TextformfieldRUW(
                    labelname: 'Booking Cancellation Rules',
                    controller: _cancellationRules,
                    maxLines: 3,
                    requiredField: false,
                    icon: Icons.rule,
                  ),
                ],
              ),
            ),
          ),

          Step(
            title: const Text('Bank / Payment Details'),
            isActive: _step >= 6,
            content: Form(
              key: _keys[6],
              child: Column(
                children: [
                  TextformfieldRUW(
                    labelname: 'Bank Account Number',
                    controller: _accountNumber,
                    keyboardType: TextInputType.number,
                    regexp: RegExp(r'^\d{6,18}$'),
                    msg: 'Enter valid account number',
                    icon: Icons.account_balance,
                  ),
                  TextformfieldRUW(
                    labelname: 'IFSC Code',
                    controller: _ifsc,
                    keyboardType: TextInputType.text,
                    regexp: _ifscRe,
                    msg: 'Enter valid IFSC (e.g., HDFC0XXXXXX)',
                    icon: Icons.confirmation_number,
                  ),
                  TextformfieldRUW(
                    labelname: 'Account Holder Name',
                    controller: _accountHolder,
                    icon: Icons.person,
                  ),
                  TextformfieldRUW(
                    labelname: 'UPI ID',
                    controller: _upiId,
                    requiredField: false,
                    regexp: _upiRe,
                    msg: 'Enter valid UPI (e.g., name@bank)',
                    icon: Icons.qr_code,
                  ),
                  TextformfieldRUW(
                    labelname: 'GST Number (optional)',
                    controller: _gst,
                    requiredField: false,
                    icon: Icons.receipt_long,
                  ),
                ],
              ),
            ),
          ),

          Step(
            title: const Text('Legal / Agreement'),
            isActive: _step >= 7,
            content: Form(
              key: _keys[7],
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _agreementPdfPath == null
                          ? 'Revenue Sharing Agreement (PDF)'
                          : 'PDF selected',
                    ),
                    subtitle: const Text(
                      'Placeholder: integrate file_picker later',
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        setState(
                          () => _agreementPdfPath = 'picked/agreement.pdf',
                        ); // placeholder
                      },
                      child: const Text('Pick'),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I accept the Terms & Conditions'),
                    value: _termsAccepted,
                    onChanged: (v) =>
                        setState(() => _termsAccepted = v ?? false),
                  ),
                  TextformfieldRUW(
                    labelname: 'Digital Signature (type your full name)',
                    controller: _digitalSignature,
                    icon: Icons.edit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
