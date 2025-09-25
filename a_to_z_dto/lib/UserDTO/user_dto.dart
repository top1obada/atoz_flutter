enum EnUserRole {
  eCustomer(1);

  final int value;

  const EnUserRole(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnUserRole? fromValue(int? value) {
    if (value == null) return null;
    return EnUserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception('Unknown EnUserRole value: $value'),
    );
  }
}

class ClsUserDTO {
  int? userId;
  int? personId;
  String? userName;
  String? password;
  DateTime? joiningDate;

  ClsUserDTO({
    this.userId,
    this.personId,
    this.userName,
    this.password,
    this.joiningDate,
  });

  factory ClsUserDTO.fromJson(Map<String, dynamic> json) {
    return ClsUserDTO(
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

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'PersonId': personId,
      'UserName': userName,
      'Password': password,
      'JoiningDate': joiningDate?.toIso8601String(),
    };
  }
}
