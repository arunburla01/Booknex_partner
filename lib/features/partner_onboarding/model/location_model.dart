class LocationModel {
  String branchName;
  String address;
  String landmark;
  String city;
  String state;
  String pincode;
  double? latitude;
  double? longitude;
  bool hasParking;

  LocationModel({
    this.branchName = '',
    this.address = '',
    this.landmark = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.latitude,
    this.longitude,
    this.hasParking = false,
  });
}
