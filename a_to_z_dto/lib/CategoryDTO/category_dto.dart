class ClsCategoryDto {
  int? categoryID;
  String? categoryName;
  String? categoryImagePath;

  ClsCategoryDto({this.categoryID, this.categoryName, this.categoryImagePath});

  factory ClsCategoryDto.fromJson(Map<String, dynamic> json) {
    return ClsCategoryDto(
      categoryID: json['CategoryID'],
      categoryName: json['CategoryName'],
      categoryImagePath: json['CategoryImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryID': categoryID,
      'CategoryName': categoryName,
      'CategoryImagePath': categoryImagePath,
    };
  }
}
