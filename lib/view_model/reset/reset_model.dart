
class ResetResponseModel {
  int success;
  Map<String, dynamic> message;
  ResetDataArray dataArray;

  ResetResponseModel({
    required this.success,
    required this.message,
    required this.dataArray,
  });

  factory ResetResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetResponseModel(
      success: json['success'],
      message: json['message'],
      dataArray: ResetDataArray.fromJson(json['data_array']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data_array': dataArray.toJson(),
    };
  }
}

class ResetDataArray {
  String msno;
  String phone;
  String digitCode;

  ResetDataArray({
    required this.msno,
    required this.phone,
    required this.digitCode,
  });

  factory ResetDataArray.fromJson(Map<String, dynamic> json) {
    return ResetDataArray(
      msno: json['msno'],
      phone: json['phone'],
      digitCode: json['digitcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msno': msno,
      'phone': phone,
      'digitcode': digitCode,
    };
  }
}
