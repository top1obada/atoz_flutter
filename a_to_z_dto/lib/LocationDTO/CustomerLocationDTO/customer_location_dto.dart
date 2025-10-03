class ClsCustomerLocationDTO {
  int? customerID;
  double? latitude;
  double? longitude;
  String? address;
  DateTime? updatedDate;

  ClsCustomerLocationDTO({
    this.customerID,
    this.latitude,
    this.longitude,
    this.address,
    this.updatedDate,
  });

  factory ClsCustomerLocationDTO.fromJson(Map<String, dynamic> json) {
    return ClsCustomerLocationDTO(
      customerID: json['CustomerID'],
      latitude:
          json['Latitude'] != null
              ? (json['Latitude'] as num).toDouble()
              : null,
      longitude:
          json['Longitude'] != null
              ? (json['Longitude'] as num).toDouble()
              : null,
      address: json['Address'],
      updatedDate:
          json['UpdatedDate'] != null
              ? DateTime.parse(json['UpdatedDate'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerID': customerID,
      'Latitude': latitude,
      'Longitude': longitude,
      'Address': address,
      'UpdatedDate': updatedDate?.toIso8601String(),
    };
  }
}
