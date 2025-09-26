class ClsStoreTypeWithColorDto {
  String? storeTypeName;
  String? hexCode;
  int? shade;
  int? codePoint; // Added codePoint field

  ClsStoreTypeWithColorDto({
    this.storeTypeName,
    this.hexCode,
    this.shade,
    this.codePoint, // Added to constructor
  });

  factory ClsStoreTypeWithColorDto.fromJson(Map<String, dynamic> json) {
    return ClsStoreTypeWithColorDto(
      storeTypeName: json['StoreTypeName'] as String?,
      hexCode: json['HexCode'] as String?,
      shade: json['Shade'] as int?,
      codePoint: json['CodePoint'] as int?, // Added from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StoreTypeName': storeTypeName,
      'HexCode': hexCode,
      'Shade': shade,
      'CodePoint': codePoint, // Added to JSON
    };
  }
}
