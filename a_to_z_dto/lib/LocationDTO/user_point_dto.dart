class ClsUserPointDTO {
  double? latitude;
  double? longitude;

  ClsUserPointDTO({this.latitude, this.longitude});

  factory ClsUserPointDTO.fromJson(Map<String, dynamic> json) {
    return ClsUserPointDTO(
      latitude: json['Latitude']?.toDouble(),
      longitude: json['Longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'Latitude': latitude, 'Longitude': longitude};
  }
}
