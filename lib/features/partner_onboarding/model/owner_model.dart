class OwnerModel {
  String name;
  String mobile;
  String? email;
  bool whatsappOptIn;

  OwnerModel({
    this.name = '',
    this.mobile = '',
    this.email,
    this.whatsappOptIn = true,
  });

  // Add copyWith and fromJson/toJson if needed later for production robustness
}
