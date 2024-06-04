class ChartComplaintStatus {
  int success;
  String message;
  List<ChartDataArray> dataArray;

  ChartComplaintStatus(
      {required this.success, required this.message, required this.dataArray});

  factory ChartComplaintStatus.fromJson(Map<String, dynamic> json) {
    return ChartComplaintStatus(
      success: json['success'],
      message: json['message'],
      dataArray: List<ChartDataArray>.from(
          json['data_array'].map((x) => ChartDataArray.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data_array': List<dynamic>.from(dataArray.map((x) => x.toJson())),
    };
  }
}

class ChartDataArray {
  String code;
  String name;
  String color;
  int total;

  ChartDataArray(
      {required this.code,
      required this.name,
      required this.color,
      required this.total});

  factory ChartDataArray.fromJson(Map<String, dynamic> json) {
    return ChartDataArray(
      code: json['code'],
      name: json['name'],
      color: json['color'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'color': color,
      'total': total,
    };
  }
}
