import 'package:a_to_z_dto/FilterDTO/store_categories_filter_dto.dart';

class ClsStoreSubCategoryItemItemsFilterDTO
    extends ClsStoreCategoriesFilterDTO {
  int? subCategoryItemID;

  ClsStoreSubCategoryItemItemsFilterDTO({
    this.subCategoryItemID,
    // Parent class properties
    super.storeID,
    // Grandparent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsStoreSubCategoryItemItemsFilterDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsStoreSubCategoryItemItemsFilterDTO(
      subCategoryItemID: json['SubCategoryItemID'],
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
    json.addAll({'SubCategoryItemID': subCategoryItemID});
    return json;
  }
}
