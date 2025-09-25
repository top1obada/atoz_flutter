
class ClsNativeLoginInfoDTO {
  String? userName;
  String? password;

  ClsNativeLoginInfoDTO({
    this.userName,
    this.password,
  });

  factory ClsNativeLoginInfoDTO.fromJson(Map<String, dynamic> json) {
    return ClsNativeLoginInfoDTO(
      userName: json['UserName'],
      password: json['Password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserName': userName,
      'Password': password,
    };
  }
}