class ClsPageFilterDTO {
  int? pageNumber;
  int? pageSize;

  ClsPageFilterDTO({
    this.pageNumber,
    this.pageSize,
  });

  factory ClsPageFilterDTO.fromJson(Map<String, dynamic> json) {
    return ClsPageFilterDTO(
      pageNumber: json['PageNumber'] as int?,
      pageSize: json['PageSize'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
  }
}