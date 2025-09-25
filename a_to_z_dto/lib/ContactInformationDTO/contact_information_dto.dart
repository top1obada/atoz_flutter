class ClsContactInformationDTO {
  int? contactInformationId;
  String? email;
  String? phoneNumber;

  ClsContactInformationDTO({
    this.contactInformationId,
    this.email,
    this.phoneNumber,
  });

  factory ClsContactInformationDTO.fromJson(Map<String, dynamic> json) {
    return ClsContactInformationDTO(
      contactInformationId: json['ContactInformationID'],
      email: json['Email'],
      phoneNumber: json['PhoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ContactInformationID': contactInformationId,
      'Email': email,
      'PhoneNumber': phoneNumber,
    };
  }
}
