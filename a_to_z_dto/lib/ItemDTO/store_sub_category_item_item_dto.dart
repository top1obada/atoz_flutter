class ClsStoreSubCategoryItemItemDTO {
  int? storeItemID;
  int? subCategoryItemID;

  double? price;
  int? count;
  String? notes;
  String? imagepath;
  String? subCategoryItemTypeName;
  double? priceAfterDiscount;
  DateTime? discountEndDate;

  ClsStoreSubCategoryItemItemDTO({
    this.storeItemID,
    this.subCategoryItemID,

    this.price,
    this.count,
    this.notes,
    this.imagepath,
    this.subCategoryItemTypeName,
    this.priceAfterDiscount,
    this.discountEndDate,
  });

  factory ClsStoreSubCategoryItemItemDTO.fromJson(Map<String, dynamic> json) {
    return ClsStoreSubCategoryItemItemDTO(
      storeItemID: json['StoreItemID'] as int?,
      subCategoryItemID: json['SubCategoryItemID'] as int?,

      price: (json['Price'] as num?)?.toDouble(),
      count: json['Count'] as int?,
      notes: json['Notes'] as String?,
      imagepath: json['ImagePath'] as String?,
      subCategoryItemTypeName: json['SubCategoryItemTypeName'] as String?,
      priceAfterDiscount: (json['PriceAfterDiscount'] as num?)?.toDouble(),
      discountEndDate:
          json['DiscountEndDate'] != null
              ? DateTime.parse(
                json['DiscountEndDate'] as String,
              ) // ← Fixed this line
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StoreItemID': storeItemID,
      'SubCategoryItemID': subCategoryItemID,

      'Price': price,
      'Count': count,
      'Notes': notes,
      'ImagePath': imagepath,
      'SubCategoryItemTypeName': subCategoryItemTypeName,
      'PriceAfterDiscount': priceAfterDiscount,
      'DiscountEndDate': discountEndDate?.toIso8601String(),
    };
  }
}
