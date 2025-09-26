class ClsStoreTypeWithColorDto {
  String? storeTypeName;
  String? hexCode;
  int? shade;
  String? codePoint; // Changed from int? to String?

  ClsStoreTypeWithColorDto({
    this.storeTypeName,
    this.hexCode,
    this.shade,
    this.codePoint,
  });

  factory ClsStoreTypeWithColorDto.fromJson(Map<String, dynamic> json) {
    return ClsStoreTypeWithColorDto(
      storeTypeName: json['StoreTypeName'] as String?,
      hexCode: json['HexCode'] as String?,
      shade: json['Shade'] as int?,
      codePoint: json['CodePoint'] as String?, // Updated to String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StoreTypeName': storeTypeName,
      'HexCode': hexCode,
      'Shade': shade,
      'CodePoint': codePoint,
    };
  }
}
