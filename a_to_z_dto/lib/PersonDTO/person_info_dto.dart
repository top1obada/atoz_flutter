class ClsPersonInfoDTO {
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  String? gender;
  String? countryName;

  ClsPersonInfoDTO({
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.countryName,
  });

  factory ClsPersonInfoDTO.fromJson(Map<String, dynamic> json) {
    return ClsPersonInfoDTO(
      firstName: json['FirstName'],
      lastName: json['LastName'],
      birthDate:
          json['BirthDate'] != null
              ? DateTime.parse(json['BirthDate'] as String)
              : null,
      gender: json['Gender'],
      countryName: json['CountryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'BirthDate': birthDate?.toIso8601String(),
      'Gender': gender,
      'CountryName': countryName,
    };
  }
}
