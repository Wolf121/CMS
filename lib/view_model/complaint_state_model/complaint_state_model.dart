
class ComplaintStatus {
  final int success;
  final String message;
  final List<ComplaintStatusItem> dataArray;

  ComplaintStatus(
      {required this.success, required this.message, required this.dataArray});

  factory ComplaintStatus.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json['data_array'];
    List<ComplaintStatusItem> dataArray =
        data.map((item) => ComplaintStatusItem.fromJson(item)).toList();

    return ComplaintStatus(
      success: json['success'],
      message: json['message'],
      dataArray: dataArray,
    );
  }
}

class ComplaintStatusItem {
  final String code;
  final String name;
  final String color;
  final int total;

  ComplaintStatusItem(
      {required this.code,
      required this.name,
      required this.color,
      required this.total});

  factory ComplaintStatusItem.fromJson(Map<String, dynamic> json) {
    return ComplaintStatusItem(
      code: json['code'],
      name: json['name'],
      color: json['color'],
      total: json['total'],
    );
  }
}
