import 'package:a_to_z_dto/FilterDTO/page_filter_dto.dart';

class ClsCustomerRequestsFilterDTO extends ClsPageFilterDTO {
  int? customerID;

  ClsCustomerRequestsFilterDTO({
    this.customerID,
    // Parent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsCustomerRequestsFilterDTO.fromJson(Map<String, dynamic> json) {
    return ClsCustomerRequestsFilterDTO(
      customerID: json['CustomerID'] as int?,
      // Parent class properties
      pageNumber: json['PageNumber'] as int?,
      pageSize: json['PageSize'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({'CustomerID': customerID});
    return json;
  }
}
