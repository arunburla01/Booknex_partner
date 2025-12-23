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
  Map<String, dynamic> toMap() {
    return {
      'branchName': branchName,
      'address': address,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'hasParking': hasParking,
    };
  }
}
