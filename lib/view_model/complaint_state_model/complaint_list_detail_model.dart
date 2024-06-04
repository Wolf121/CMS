class ComplaintListDetailModel {
  final int success;
  final String message;
  final List<ComplaintListDetailModelItem> dataArray;

  ComplaintListDetailModel({
    required this.success,
    required this.message,
    required this.dataArray,
  });

  factory ComplaintListDetailModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json['data_array'];
    List<ComplaintListDetailModelItem> dataArray = data
        .map((item) => ComplaintListDetailModelItem.fromJson(item))
        .toList();

    return ComplaintListDetailModel(
      success: json['success'],
      message: json['message'],
      dataArray: dataArray,
    );
  }
}

class ComplaintListDetailModelItem {
  final int id;
  final String reference;
  final String uid;
  final String category;
  final String subcategory;
  final String description;
  final String type;
  final int statusId;
  final String status;
  final String color;
  final dynamic fellowupName;
  final dynamic fellowupCell;
  final dynamic fellowupLandline;
  final List<dynamic> actions;
  final String created;
  final String createdAt;
  final int rating;
  final String feedback;
  final int priority;
  final String feedbackStatus;

  ComplaintListDetailModelItem({
    required this.id,
    required this.reference,
    required this.uid,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.type,
    required this.statusId,
    required this.status,
    required this.color,
    required this.fellowupName,
    required this.fellowupCell,
    required this.fellowupLandline,
    required this.actions,
    required this.created,
    required this.createdAt,
    required this.rating,
    required this.feedback,
    required this.priority,
    required this.feedbackStatus,
  });

  factory ComplaintListDetailModelItem.fromJson(Map<String, dynamic> json) {
    return ComplaintListDetailModelItem(
      id: json['id'],
      reference: json['reference'],
      uid: json['uid'],
      category: json['category'],
      subcategory: json['subcategory'],
      description: json['description'],
      type: json['type'],
      statusId: json['status_id'],
      status: json['status'],
      color: json['color'],
      fellowupName: json['fellowup_name'],
      fellowupCell: json['fellowup_cell'],
      fellowupLandline: json['fellowup_landline'],
      actions: List<dynamic>.from(json['actions']),
      created: json['created'],
      createdAt: json['created_at'],
      rating: json['rating'],
      feedback: json['feedback'],
      priority: json['priority'],
      feedbackStatus: json['feedback_status'] ?? "",
    );
  }
}
