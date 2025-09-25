import 'package:a_to_z_dto/UserDTO/user_dto.dart';

class ClsCustomerDTO extends ClsUserDTO {
  int? customerId;
  int? permissions;

  ClsCustomerDTO({
    this.customerId,
    this.permissions,
    // Parent class properties
    super.userId,
    super.personId,
    super.userName,
    super.password,
    super.joiningDate,
  });

  factory ClsCustomerDTO.fromJson(Map<String, dynamic> json) {
    return ClsCustomerDTO(
      customerId: json['CustomerId'],
      permissions: json['Permissions'],
      // Parent class properties
      userId: json['UserId'],
      personId: json['PersonId'],
      userName: json['UserName'],
      password: json['Password'],
      joiningDate:
          json['JoiningDate'] != null
              ? DateTime.parse(json['JoiningDate'])
              : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({'CustomerId': customerId, 'Permissions': permissions});
    return json;
  }
}
