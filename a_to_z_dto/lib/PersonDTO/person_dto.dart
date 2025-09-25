import 'package:a_to_z_dto/ContactInformationDTO/contact_information_dto.dart';

class ClsPersonDTO {
  int? personId;
  String? firstName;
  String? lastName;
  String? nationality;
  DateTime? birthDate;
  String? gender; // Changed from char to String
  ClsContactInformationDTO? contactInformation;

  ClsPersonDTO({
    this.personId,
    this.firstName,
    this.lastName,
    this.nationality,
    this.birthDate,
    this.gender,
    this.contactInformation,
  });

  factory ClsPersonDTO.fromJson(Map<String, dynamic> json) {
    return ClsPersonDTO(
      personId: json['PersonId'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      nationality: json['Nationality'],
      birthDate: json['BirthDate'] != null ? DateTime.parse(json['BirthDate']) : null,
      gender: json['Gender'],
      contactInformation: json['ContactInformation'] != null 
          ? ClsContactInformationDTO.fromJson(json['ContactInformation']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PersonId': personId,
      'FirstName': firstName,
      'LastName': lastName,
      'Nationality': nationality,
      'BirthDate': birthDate?.toIso8601String(),
      'Gender': gender,
      'ContactInformation': contactInformation?.toJson(),
    };
  }
}