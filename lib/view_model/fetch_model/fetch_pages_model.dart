class PagesModel {
  final int id;
  final String title;
  final String description;
  final String type;

  PagesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
  });

  factory PagesModel.fromJson(Map<String, dynamic> json) {
    return PagesModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
    };
  }
}

class PagesModelListResponse {
  final int success;
  final String message;
  final List<PagesModel> dataArray;

  PagesModelListResponse({
    required this.success,
    required this.message,
    required this.dataArray,
  });

  factory PagesModelListResponse.fromJson(Map<String, dynamic> json) {
    List<PagesModel> pagesModelsList = List<PagesModel>.from(
      (json['data_array'] as List)
          .map((pagesModelJson) => PagesModel.fromJson(pagesModelJson)),
    );

    return PagesModelListResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      dataArray: pagesModelsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data_array': dataArray.map((pagesModel) => pagesModel.toJson()).toList(),
    };
  }
}
