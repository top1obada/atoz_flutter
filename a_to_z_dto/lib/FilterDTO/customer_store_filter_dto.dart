import 'package:a_to_z_dto/FilterDTO/page_filter_dto.dart';

class ClsCustomerStoresFilterDTO extends ClsPageFilterDTO {
  int? customerID;
  int? distanceInMeters;
  String? storeTypeName;
  ClsCustomerStoresFilterDTO({
    this.customerID,
    this.distanceInMeters,
    // Parent class properties
    super.pageNumber,
    super.pageSize,
    this.storeTypeName,
  });

  factory ClsCustomerStoresFilterDTO.fromJson(Map<String, dynamic> json) {
    return ClsCustomerStoresFilterDTO(
      customerID: json['CustomerID'],
      distanceInMeters: json['DistanceInMeters'],
      // Parent class properties
      pageNumber: json['PageNumber'],
      pageSize: json['PageSize'],
      storeTypeName: json['StoreTypeName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'CustomerID': customerID,
      'DistanceInMeters': distanceInMeters,
      'StoreTypeName': storeTypeName,
    });
    return json;
  }
}
