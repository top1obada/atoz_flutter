import 'package:a_to_z_dto/LocationDTO/user_point_dto.dart';
import 'package:a_to_z_dto/PersonDTO/person_dto.dart';

class ClsPersonWithPointDTO {
  ClsPersonDTO? personDTO;
  ClsUserPointDTO? userPointDTO;

  ClsPersonWithPointDTO({this.personDTO, this.userPointDTO});

  factory ClsPersonWithPointDTO.fromJson(Map<String, dynamic> json) {
    return ClsPersonWithPointDTO(
      personDTO:
          json['PersonDTO'] != null
              ? ClsPersonDTO.fromJson(json['PersonDTO'])
              : null,
      userPointDTO:
          json['UserPointDTO'] != null
              ? ClsUserPointDTO.fromJson(json['UserPointDTO'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PersonDTO': personDTO?.toJson(),
      'UserPointDTO': userPointDTO?.toJson(),
    };
  }
}
