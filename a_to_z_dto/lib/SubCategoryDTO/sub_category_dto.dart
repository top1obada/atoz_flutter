class ClsSubCategoryDTO {
  int? subCategoryID;
  String? subCategoryName;
  String? subCategoryImage;
  int? categoryID;
  ClsSubCategoryDTO({
    this.subCategoryID,
    this.subCategoryName,
    this.subCategoryImage,
    this.categoryID,
  });

  factory ClsSubCategoryDTO.fromJson(Map<String, dynamic> json) {
    return ClsSubCategoryDTO(
      categoryID: json['CategoryID'],
      subCategoryID: json['SubCategoryID'],
      subCategoryName: json['SubCategoryName'],
      subCategoryImage: json['SubCategoryImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SubCategoryID': subCategoryID,
      'SubCategoryName': subCategoryName,
      'SubCategoryImage': subCategoryImage,
      'CategoryID': categoryID,
    };
  }
}
