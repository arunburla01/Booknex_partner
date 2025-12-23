class BankModel {
  String accountHolderName;
  String bankName;
  String accountNumber;
  String ifscCode;
  String? upiId;

  BankModel({
    this.accountHolderName = '',
    this.bankName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.upiId,
  });
  Map<String, dynamic> toMap() {
    return {
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'upiId': upiId,
    };
  }
}
