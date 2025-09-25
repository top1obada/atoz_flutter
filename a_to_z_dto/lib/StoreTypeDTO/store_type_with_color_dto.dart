class ClsStoreTypeWithColorDto {
  String? storeTypeName;
  String? hexCode;
  int? shade;

  ClsStoreTypeWithColorDto({this.storeTypeName, this.hexCode, this.shade});

  factory ClsStoreTypeWithColorDto.fromJson(Map<String, dynamic> json) {
    return ClsStoreTypeWithColorDto(
      storeTypeName: json['StoreTypeName'] as String?,
      hexCode: json['HexCode'] as String?,
      shade: json['Shade'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'StoreTypeName': storeTypeName, 'HexCode': hexCode, 'Shade': shade};
  }
}
