class ClsRetrivingLoggedInDTO {
  int? personID;
  int? userID;
  int? branchID;
  String? firstName;
  DateTime? joiningDate;

  bool? isAddressInfoConifrmed;
  EnVerifyPhoneNumberMode? verifyPhoneNumberMode;

  ClsRetrivingLoggedInDTO({
    this.personID,
    this.userID,
    this.branchID,
    this.firstName,
    this.joiningDate,

    this.isAddressInfoConifrmed,
    this.verifyPhoneNumberMode,
  });

  // Factory constructor for JSON parsing
  factory ClsRetrivingLoggedInDTO.fromJson(Map<String, dynamic> json) {
    return ClsRetrivingLoggedInDTO(
      personID: json['PersonID'] as int?,
      userID: json['UserID'] as int?,
      branchID: json['BranchID'] as int?,
      firstName: json['FirstName'] as String?,
      joiningDate:
          json['JoiningDate'] != null
              ? (json['JoiningDate'] as DateTime)
              : null,

      isAddressInfoConifrmed: json['IsAddressInfoConifrmed'] as bool?,
      verifyPhoneNumberMode: EnVerifyPhoneNumberMode.fromValue(
        json['VerifyPhoneNumberMode'] as int?,
      ),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'PersonID': personID,
      'UserID': userID,
      'BranchID': branchID,
      'FirstName': firstName,
      'JoiningDate': joiningDate?.toIso8601String(),

      'IsAddressInfoConifrmed': isAddressInfoConifrmed,
      'VerifyPhoneNumberMode': verifyPhoneNumberMode?.value,
    };
  }
}

enum EnVerifyPhoneNumberMode {
  eNotVerified(1),
  eVerifyProcess(2),
  eVerified(3);

  final int value;

  const EnVerifyPhoneNumberMode(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnVerifyPhoneNumberMode? fromValue(int? value) {
    if (value == null) return null;
    return EnVerifyPhoneNumberMode.values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw Exception('Unknown EnVerifyPhoneNumberMode value: $value'),
    );
  }
}
