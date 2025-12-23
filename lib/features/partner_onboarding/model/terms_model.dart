class TermsModel {
  bool isAccepted;
  final String declarationTitle = "Partner Declaration & Agreement";
  final List<String> termsSummary = [
    "I confirm that I am the owner or authorized manager of the ground.",
    "All information provided is accurate and true.",
    "I agree to honor all confirmed bookings made through Booknex.",
    "The hourly price set is final; no extra charges will be demanded.",
    "Booknex may charge a platform fee as per policy.",
    "I agree to follow cancellation and refund policies.",
    "I grant Booknex rights to use uploaded media for promotion.",
    "I consent to receiving updates via WhatsApp, SMS, and Email.",
    "Booknex reserves the right to suspend listings for violations.",
    "Booknex is a platform and not liable for on-ground disputes.",
  ];

  TermsModel({this.isAccepted = false});
}
