class ComplaintDetailModel {
  final int success;
  final String message;
  final ComplaintDetailData dataArray;

  ComplaintDetailModel({
    required this.success,
    required this.message,
    required this.dataArray,
  });

  factory ComplaintDetailModel.fromJson(Map<String, dynamic> json) {
    return ComplaintDetailModel(
      success: json['success'],
      message: json['message'],
      dataArray: ComplaintDetailData.fromJson(json['data_array']),
    );
  }
}

class ComplaintDetailData {
  final int id;
  final String reference;
  final String category;
  final String subcategory;
  final String description;
  final String type;
  final int statusId;
  final String status;
  final String color;
  final String fellowupName;
  final String fellowupCell;
  final String fellowupLandline;
  final String image;
  final String video;
  final List<ComplaintAction> actions;
  final String created;
  final String createdAt;
  final int priority;
  final int rating;
  final String feedback;
  final String feedbackStatus;

  ComplaintDetailData({
    required this.id,
    required this.reference,
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
    required this.image,
    required this.video,
    required this.actions,
    required this.created,
    required this.createdAt,
    required this.priority,
    required this.rating,
    required this.feedback,
    required this.feedbackStatus,
  });

  factory ComplaintDetailData.fromJson(Map<String, dynamic> json) {
    List<dynamic> actionsList = json['actions'];
    List<ComplaintAction> actions =
        actionsList.map((item) => ComplaintAction.fromJson(item)).toList();

    return ComplaintDetailData(
      id: json['id'],
      reference: json['reference'] ?? "",
      category: json['category'] ?? "",
      subcategory: json['subcategory'] ?? "",
      description: json['description'] ?? "",
      type: json['type'] ?? "",
      statusId: json['status_id'],
      status: json['status'] ?? "",
      color: json['color'],
      fellowupName: json['followup_name'] ?? "",
      fellowupCell: json['followup_cell'] ?? "",
      fellowupLandline: json['followup_landline'] ?? "",
      image: json['image'],
      video: json['video'],
      actions: actions,
      created: json['created'] ?? "",
      createdAt: json['created_at'],
      priority: json['priority'] ?? "",
      rating: json['rating'] ?? "",
      feedback: json['feedback'] ?? "",
      feedbackStatus: json['feedback_status'] ?? "",
    );
  }
}

class ComplaintAction {
  final int id;
  final int complaintId;
  final int statusId;
  final String startTime;
  final String endTime;
  final String uid;
  final dynamic smsFrom;
  final dynamic smsRef;
  final String createdAt;
  final List<Comment> comments;
  final String name;

  ComplaintAction({
    required this.id,
    required this.complaintId,
    required this.statusId,
    required this.startTime,
    required this.endTime,
    required this.uid,
    required this.smsFrom,
    required this.smsRef,
    required this.createdAt,
    required this.comments,
    required this.name,
  });

  factory ComplaintAction.fromJson(Map<String, dynamic> json) {
    List<dynamic> commentsList = json['comments'];
    List<Comment> comments =
        commentsList.map((item) => Comment.fromJson(item)).toList();

    return ComplaintAction(
      id: json['id'],
      complaintId: json['complaint_id'],
      statusId: json['status_id'],
      startTime: json['start_time'],
      endTime: json['end_time'] ?? 'N/A',
      uid: json['uid'],
      smsFrom: json['sms_from'],
      smsRef: json['sms_ref'],
      createdAt: json['created_at'],
      comments: comments,
      name: json['name'],
    );
  }
}

class Comment {
  final int id;
  final int complaintId;
  final int statusId;
  final int complaintActionId;
  final String comment;
  final String uid;
  final String createdAt;

  Comment({
    required this.id,
    required this.complaintId,
    required this.statusId,
    required this.complaintActionId,
    required this.comment,
    required this.uid,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      complaintId: json['complaint_id'],
      statusId: json['status_id'],
      complaintActionId: json['complaint_action_id'],
      comment: json['comment'],
      uid: json['uid'],
      createdAt: json['created_at'],
    );
  }
}
