class ClsTokensDTO {
  final String ?jwtToken;
  final String? refreshToken;

  ClsTokensDTO({
    required this.jwtToken,
    required this.refreshToken,
  });

  // Factory constructor for creating from JSON
  factory ClsTokensDTO.fromJson(Map<String, dynamic> json) {
    return ClsTokensDTO(
      jwtToken: json['JwtToken'] as String,
      refreshToken: json['RefreshToken'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'JwtToken': jwtToken,
      'RefreshToken': refreshToken,
    };
  }
}