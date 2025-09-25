class ClsRequestItemDto {
  int? requestItemID;
  int? requestID;
  int? storeItemID;
  int? count;

  ClsRequestItemDto({
    this.requestItemID,
    this.requestID,
    this.storeItemID,
    this.count,
  });

  factory ClsRequestItemDto.fromJson(Map<String, dynamic> json) {
    return ClsRequestItemDto(
      requestItemID: json['RequestItemID'] as int?,
      requestID: json['RequestID'] as int?,
      storeItemID: json['StoreItemID'] as int?,
      count: json['Count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestItemID': requestItemID,
      'RequestID': requestID,
      'StoreItemID': storeItemID,
      'Count': count,
    };
  }
}
