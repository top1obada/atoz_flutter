enum EnRequestStatus {
  ePending(1),
  eCancled(2),
  eRejected(3),
  eCompleted(4);

  final int value;

  const EnRequestStatus(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnRequestStatus? fromValue(int? value) {
    if (value == null) return null;
    return EnRequestStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception('Unknown EnRequestStatus value: $value'),
    );
  }
}

class ClsRequestDto {
  int? requestID;
  DateTime? requestDate;
  int? requestCustomerID;
  int? storeID;
  EnRequestStatus? requestStatus;
  DateTime? completedDate;

  ClsRequestDto({
    this.requestID,
    this.requestDate,
    this.requestCustomerID,
    this.storeID,
    this.requestStatus,
    this.completedDate,
  });

  factory ClsRequestDto.fromJson(Map<String, dynamic> json) {
    return ClsRequestDto(
      requestID: json['RequestID'],
      requestDate:
          json['RequestDate'] != null
              ? DateTime.parse(json['RequestDate'])
              : null,
      requestCustomerID: json['RequestCustomerID'],
      storeID: json['StoreID'],
      requestStatus: EnRequestStatus.fromValue(json['RequestStatus']),
      completedDate:
          json['CompletedDate'] != null
              ? DateTime.parse(json['CompletedDate'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestID': requestID,
      'RequestDate': requestDate?.toIso8601String(),
      'RequestCustomerID': requestCustomerID,
      'StoreID': storeID,
      'RequestStatus': requestStatus?.value,
      'CompletedDate': completedDate?.toIso8601String(),
    };
  }
}
