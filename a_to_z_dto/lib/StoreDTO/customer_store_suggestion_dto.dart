class ClsCustomerStoreSuggestionDTO {
  int? storeID;
  String? storeName;
  String? storeTypeName;
  double? distanceInMeters;
  String? storeImage;
  String? hexCode;
  int? shade;

  ClsCustomerStoreSuggestionDTO({
    this.storeID,
    this.storeName,
    this.storeTypeName,
    this.distanceInMeters,
    this.storeImage,
    this.hexCode,
    this.shade,
  });

  factory ClsCustomerStoreSuggestionDTO.fromJson(Map<String, dynamic> json) {
    return ClsCustomerStoreSuggestionDTO(
      storeID: json['StoreID'],
      storeName: json['StoreName'],
      storeTypeName: json['StoreTypeName'],
      distanceInMeters: json['DistanceInMeters'],
      storeImage: json['StoreImage'],
      hexCode: json['HexCode'],
      shade: json['Shade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StoreID': storeID,
      'HexCode': hexCode,
      'Shade': shade,
      'StoreName': storeName,
      'StoreTypeName': storeTypeName,
      'DistanceInMeters': distanceInMeters,
      'StoreImage': storeImage,
    };
  }
}
