class ClsSubCategoryItem {
  int? subCategoryItemID;
  String? subCategoryItemTypeName;
  String? subCategoryItemImage;
  int? subCategoryID;
  ClsSubCategoryItem({
    this.subCategoryItemID,
    this.subCategoryItemTypeName,
    this.subCategoryItemImage,
    this.subCategoryID,
  });

  factory ClsSubCategoryItem.fromJson(Map<String, dynamic> json) {
    return ClsSubCategoryItem(
      subCategoryID: json['SubCategoryID'],
      subCategoryItemID: json['SubCategoryItemID'],
      subCategoryItemTypeName: json['SubCategoryItemTypeName'],
      subCategoryItemImage: json['SubCategoryItemImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SubCategoryItemID': subCategoryItemID,
      'SubCategoryItemTypeName': subCategoryItemTypeName,
      'SubCategoryItemImage': subCategoryItemImage,
      'SubCategoryID': subCategoryID,
    };
  }
}
