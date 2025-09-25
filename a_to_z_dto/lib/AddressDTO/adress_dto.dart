class ClsAddressDTO {
  int? addressID;
  int? personID;
  String? city;
  String? areaName;
  String? streetNameOrNumber;
  String? buildingName;
  String? importantNotes;

  ClsAddressDTO({
    this.addressID,
    this.personID,
    this.city,
    this.areaName,
    this.streetNameOrNumber,
    this.buildingName,
    this.importantNotes,
  });

  factory ClsAddressDTO.fromJson(Map<String, dynamic> json) {
    return ClsAddressDTO(
      addressID: json['AddressID'],
      personID: json['PersonID'],
      city: json['City'],
      areaName: json['AreaName'],
      streetNameOrNumber: json['StreetNameOrNumber'],
      buildingName: json['BuildingName'],
      importantNotes: json['ImportantNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AddressID': addressID,
      'PersonID': personID,
      'City': city,
      'AreaName': areaName,
      'StreetNameOrNumber': streetNameOrNumber,
      'BuildingName': buildingName,
      'ImportantNotes': importantNotes,
    };
  }
}
