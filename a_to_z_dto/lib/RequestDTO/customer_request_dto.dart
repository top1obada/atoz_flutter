import 'package:a_to_z_dto/RequestDTO/request_dto.dart';

class ClsCustomerRequestDto {
  int? requestID;
  DateTime? requestDate;
  EnRequestStatus? requestStatus;
  DateTime? completedRequestDate;
  int? storeID;
  String? storeName;
  String? storeTypeName;

  ClsCustomerRequestDto({
    this.requestID,
    this.requestDate,
    this.requestStatus,
    this.completedRequestDate,
    this.storeID,
    this.storeName,
    this.storeTypeName,
  });

  factory ClsCustomerRequestDto.fromJson(Map<String, dynamic> json) {
    return ClsCustomerRequestDto(
      requestID: json['RequestID'] as int?,
      requestDate:
          json['RequestDate'] != null
              ? DateTime.parse(json['RequestDate'] as String)
              : null,
      requestStatus: EnRequestStatus.fromValue(json['RequestStatus']),
      completedRequestDate:
          json['CompletedRequestDate'] != null
              ? DateTime.parse(json['CompletedRequestDate'] as String)
              : null,
      storeID: json['StoreID'] as int?,
      storeName: json['StoreName'] as String?,
      storeTypeName: json['StoreTypeName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestID': requestID,
      'RequestDate': requestDate?.toIso8601String(),
      'RequestStatus': requestStatus?.value,
      'CompletedRequestDate': completedRequestDate?.toIso8601String(),
      'StoreID': storeID,
      'StoreName': storeName,
      'StoreTypeName': storeTypeName,
    };
  }
}
