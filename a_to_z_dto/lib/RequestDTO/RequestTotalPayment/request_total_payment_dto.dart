class ClsRequestTotalPaymentDto {
  int? requestID;
  double? totalDue;
  double? discount;
  double? balanceValueUsed;

  ClsRequestTotalPaymentDto({
    this.requestID,
    this.totalDue,
    this.discount,
    this.balanceValueUsed,
  });

  factory ClsRequestTotalPaymentDto.fromJson(Map<String, dynamic> json) {
    return ClsRequestTotalPaymentDto(
      requestID: json['RequestID'] as int?,
      totalDue: json['TotalDue'] as double?,
      discount: json['Discount'] as double?,
      balanceValueUsed: json['BalanceValueUsed'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestID': requestID,
      'TotalDue': totalDue,
      'Discount': discount,
      'BalanceValueUsed': balanceValueUsed,
    };
  }
}
