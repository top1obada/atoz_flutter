import 'package:a_to_z_dto/RequestDTO/request_dto.dart';

class ClsNewRequest {
  final int? requestID;
  final String? storeName;
  final DateTime? requestDate;
  final EnRequestStatus? requestStatus;
  final double? totalPrice;
  final double? discounts;
  final double? customerbalancedUsed;

  ClsNewRequest({
    this.requestID,
    this.storeName,
    this.requestDate,
    this.requestStatus,
    this.totalPrice,
    this.discounts,
    this.customerbalancedUsed,
  });
}
