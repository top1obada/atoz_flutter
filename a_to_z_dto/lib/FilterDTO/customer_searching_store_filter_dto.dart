import 'package:a_to_z_dto/FilterDTO/page_filter_dto.dart';

class ClsCustomerSearchingStoresFilterDTO extends ClsPageFilterDTO {
  int? customerID;
  String? searchingText;

  ClsCustomerSearchingStoresFilterDTO({
    this.customerID,
    this.searchingText,

    // Parent class properties
    super.pageNumber,
    super.pageSize,
  });

  factory ClsCustomerSearchingStoresFilterDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsCustomerSearchingStoresFilterDTO(
      customerID: json['CustomerID'],
      searchingText: json['SearchingText'],

      // Parent class properties
      pageNumber: json['PageNumber'],
      pageSize: json['PageSize'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({'CustomerID': customerID, 'SearchingText': searchingText});
    return json;
  }
}
