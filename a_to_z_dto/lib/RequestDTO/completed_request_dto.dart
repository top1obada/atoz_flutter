import 'package:a_to_z_dto/RequestDTO/RequestItem/request_item_dto.dart';
import 'package:a_to_z_dto/RequestDTO/RequestTotalPayment/request_total_payment_dto.dart';
import 'package:a_to_z_dto/RequestDTO/request_dto.dart';

class ClsCompletedRequestDto {
  ClsRequestDto? requestDTO;
  List<ClsRequestItemDto>? requestItems;
  ClsRequestTotalPaymentDto? requestTotalPaymentDTO;

  ClsCompletedRequestDto({
    this.requestDTO,
    this.requestItems,
    this.requestTotalPaymentDTO,
  });

  factory ClsCompletedRequestDto.fromJson(Map<String, dynamic> json) {
    return ClsCompletedRequestDto(
      requestDTO:
          json['RequestDTO'] != null
              ? ClsRequestDto.fromJson(json['RequestDTO'])
              : null,
      requestItems:
          json['RequestItems'] != null
              ? List<ClsRequestItemDto>.from(
                json['RequestItems'].map((x) => ClsRequestItemDto.fromJson(x)),
              )
              : null,
      requestTotalPaymentDTO:
          json['RequestTotalPaymentDTO'] != null
              ? ClsRequestTotalPaymentDto.fromJson(
                json['RequestTotalPaymentDTO'],
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestDTO': requestDTO?.toJson(),
      'RequestItems':
          requestItems != null
              ? List<dynamic>.from(requestItems!.map((x) => x.toJson()))
              : null,
      'RequestTotalPaymentDTO': requestTotalPaymentDTO?.toJson(),
    };
  }
}
