// phone_number_random_code_dto.dart
class ClsPhoneNumberRandomCodeDTO {
  String? phoneNumber;
  int? personID;

  ClsPhoneNumberRandomCodeDTO({this.phoneNumber, this.personID});

  factory ClsPhoneNumberRandomCodeDTO.fromJson(Map<String, dynamic> json) {
    return ClsPhoneNumberRandomCodeDTO(
      phoneNumber: json['PhoneNumber'],
      personID: json['PersonID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'PhoneNumber': phoneNumber, 'PersonID': personID};
  }
}
