import 'package:a_to_z_dto/FilterDTO/page_filter_dto.dart';

class ClsStoreCategoriesFilterDTO extends ClsPageFilterDTO {
  int? storeID;

  ClsStoreCategoriesFilterDTO({
    this.storeID,

    // Parent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsStoreCategoriesFilterDTO.fromJson(Map<String, dynamic> json) {
    return ClsStoreCategoriesFilterDTO(
      storeID: json['StoreID'],

      // Parent class properties
      pageNumber: json['PageNumber'],
      pageSize: json['PageSize'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({'StoreID': storeID});
    return json;
  }
}
