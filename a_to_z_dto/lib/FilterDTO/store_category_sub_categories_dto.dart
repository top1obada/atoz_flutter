import 'package:a_to_z_dto/FilterDTO/store_categories_filter_dto.dart';

class ClsStoreCategorySubCategoriesFilterDTO
    extends ClsStoreCategoriesFilterDTO {
  int? categoryID;

  ClsStoreCategorySubCategoriesFilterDTO({
    this.categoryID,
    // Parent class properties
    super.storeID,
    // Grandparent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsStoreCategorySubCategoriesFilterDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsStoreCategorySubCategoriesFilterDTO(
      categoryID: json['CategoryID'],
      // Parent class properties
      storeID: json['StoreID'],
      // Grandparent class properties
      pageNumber: json['PageNumber'],
      pageSize: json['PageSize'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({'CategoryID': categoryID});
    return json;
  }
}
