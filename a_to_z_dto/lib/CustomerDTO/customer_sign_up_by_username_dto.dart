import 'package:a_to_z_dto/CustomerDTO/customer_dto.dart';
import 'package:a_to_z_dto/LoginDTO/native_login_info_dto.dart';
import 'package:a_to_z_dto/PersonDTO/person_dto.dart';

class ClsSignUpCustomerByUserNameDTO {
  ClsPersonDTO? person;
  ClsNativeLoginInfoDTO? nativeLoginInfoDTO;

  ClsSignUpCustomerByUserNameDTO({
    this.person,
    this.nativeLoginInfoDTO,
  });

  factory ClsSignUpCustomerByUserNameDTO.fromJson(Map<String, dynamic> json) {
    return ClsSignUpCustomerByUserNameDTO(
      person: json['Person'] != null ? ClsPersonDTO.fromJson(json['Person']) : null,
      nativeLoginInfoDTO: json['NativeLoginDataDTO'] != null ? ClsNativeLoginInfoDTO
      .fromJson(json['NativeLoginDataDTO']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Person': person?.toJson(),
      'NativeLoginDataDTO': nativeLoginInfoDTO?.toJson(),
    };
  }
}