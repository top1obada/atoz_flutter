class ClsStoreSubCategoryItemItemDTO {
  int? storeItemID;
  int? subCategoryItemID;
  int? itemID;
  double? price;
  int? count;
  String? description;
  String? itemImage;
  String? subCategoryItemTypeName;
  double? priceAfterDiscount;
  DateTime? discountEndDate;

  ClsStoreSubCategoryItemItemDTO({
    this.storeItemID,
    this.subCategoryItemID,
    this.itemID,
    this.price,
    this.count,
    this.description,
    this.itemImage,
    this.subCategoryItemTypeName,
    this.priceAfterDiscount,
    this.discountEndDate,
  });

  factory ClsStoreSubCategoryItemItemDTO.fromJson(Map<String, dynamic> json) {
    return ClsStoreSubCategoryItemItemDTO(
      storeItemID: json['StoreItemID'] as int?,
      subCategoryItemID: json['SubCategoryItemID'] as int?,
      itemID: json['ItemID'] as int?,
      price: (json['Price'] as num?)?.toDouble(),
      count: json['Count'] as int?,
      description: json['Description'] as String?,
      itemImage: json['ItemImage'] as String?,
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
      'ItemID': itemID,
      'Price': price,
      'Count': count,
      'Description': description,
      'ItemImage': itemImage,
      'SubCategoryItemTypeName': subCategoryItemTypeName,
      'PriceAfterDiscount': priceAfterDiscount,
      'DiscountEndDate': discountEndDate?.toIso8601String(),
    };
  }
}
