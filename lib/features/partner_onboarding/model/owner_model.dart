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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      'whatsappOptIn': whatsappOptIn,
    };
  }
}
