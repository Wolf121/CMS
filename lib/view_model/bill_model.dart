class BillListResponse {
  int success;
  String message;
  List<BillData> dataArray;

  BillListResponse({
    required this.success,
    required this.message,
    required this.dataArray,
  });

  factory BillListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataJsonArray = json['data_array'];
    List<BillData> dataArray =
        dataJsonArray.map((dataJson) => BillData.fromJson(dataJson)).toList();

    return BillListResponse(
      success: json['success'],
      message: json['message'],
      dataArray: dataArray,
    );
  }
}

class BillData {
  String url;

  BillData({
    required this.url,
  });

  factory BillData.fromJson(Map<String, dynamic> json) {
    return BillData(
      url: json['url'],
    );
  }
}
