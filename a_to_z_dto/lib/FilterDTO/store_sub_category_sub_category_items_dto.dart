import 'package:a_to_z_dto/FilterDTO/store_categories_filter_dto.dart';

class ClsStoreSubCategorySubCategoryItemsFilterDTO
    extends ClsStoreCategoriesFilterDTO {
  int? subCategoryID;

  ClsStoreSubCategorySubCategoryItemsFilterDTO({
    this.subCategoryID,
    // Parent class properties
    super.storeID,
    // Grandparent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsStoreSubCategorySubCategoryItemsFilterDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsStoreSubCategorySubCategoryItemsFilterDTO(
      subCategoryID: json['SubCategoryID'],
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
    json.addAll({'SubCategoryID': subCategoryID});
    return json;
  }
}
