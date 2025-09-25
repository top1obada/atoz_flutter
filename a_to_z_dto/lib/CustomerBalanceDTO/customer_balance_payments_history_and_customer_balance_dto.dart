import 'package:a_to_z_dto/CustomerBalanceDTO/customer_balance_payment_history_dto.dart';

class ClsCustomerBalancePaymentsHistoryAndCustomerBalanceDTO {
  double? customerBalance;
  List<ClsCustomerBalancePaymentHistoryDTO>? customerBalancePaymentHistoryDTOs;

  ClsCustomerBalancePaymentsHistoryAndCustomerBalanceDTO({
    this.customerBalance,
    this.customerBalancePaymentHistoryDTOs,
  });

  factory ClsCustomerBalancePaymentsHistoryAndCustomerBalanceDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsCustomerBalancePaymentsHistoryAndCustomerBalanceDTO(
      customerBalance:
          json['CustomerBalance'] != null
              ? (json['CustomerBalance'] as num).toDouble()
              : null,
      customerBalancePaymentHistoryDTOs:
          json['CustomerBalancePaymentHistoryDTOs'] != null
              ? (json['CustomerBalancePaymentHistoryDTOs'] as List)
                  .map(
                    (item) => ClsCustomerBalancePaymentHistoryDTO.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerBalance': customerBalance,
      'CustomerBalancePaymentHistoryDTOs':
          customerBalancePaymentHistoryDTOs
              ?.map((item) => item.toJson())
              .toList(),
    };
  }
}
