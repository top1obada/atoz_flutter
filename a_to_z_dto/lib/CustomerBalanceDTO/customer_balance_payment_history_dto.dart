class ClsCustomerBalancePaymentHistoryDTO {
  int? requestID;
  DateTime? requestDate;
  int? requestStatus; // Using int since enums are handled differently in Dart
  double? priceAfterDiscount;
  double? balanceValueUsed;

  ClsCustomerBalancePaymentHistoryDTO({
    this.requestID,
    this.requestDate,
    this.requestStatus,
    this.priceAfterDiscount,
    this.balanceValueUsed,
  });

  factory ClsCustomerBalancePaymentHistoryDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsCustomerBalancePaymentHistoryDTO(
      requestID: json['RequestID'] as int?,
      requestDate:
          json['RequestDate'] != null
              ? DateTime.parse(json['RequestDate'] as String)
              : null,
      requestStatus: json['RequestStatus'] as int?,
      priceAfterDiscount:
          json['PriceAfterDiscount'] != null
              ? (json['PriceAfterDiscount'] as num).toDouble()
              : null,
      balanceValueUsed:
          json['BalanceValueUsed'] != null
              ? (json['BalanceValueUsed'] as num).toDouble()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestID': requestID,
      'RequestDate': requestDate?.toIso8601String(),
      'RequestStatus': requestStatus,
      'Price After Discount': priceAfterDiscount,
      'BalanceValueUsed': balanceValueUsed,
    };
  }
}
