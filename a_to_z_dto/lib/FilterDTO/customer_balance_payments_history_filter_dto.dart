import 'package:a_to_z_dto/FilterDTO/page_filter_dto.dart';

class ClsCustomerBalancePaymentsHistoryFilterDTO extends ClsPageFilterDTO {
  int? customerID;

  ClsCustomerBalancePaymentsHistoryFilterDTO({
    this.customerID,
    // Parent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsCustomerBalancePaymentsHistoryFilterDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsCustomerBalancePaymentsHistoryFilterDTO(
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
