import 'package:a_to_z_dto/FilterDTO/page_filter_dto.dart';

class ClsCustomerFavoriteStoreFilterDTO extends ClsPageFilterDTO {
  int? customerID;

  ClsCustomerFavoriteStoreFilterDTO({
    this.customerID,

    // Parent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsCustomerFavoriteStoreFilterDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsCustomerFavoriteStoreFilterDTO(
      customerID: json['CustomerID'],

      // Parent class properties
      pageNumber: json['PageNumber'],
      pageSize: json['PageSize'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({'CustomerID': customerID});
    return json;
  }
}
