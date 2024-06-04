class SosListModel {
  int success;
  String message;
  List<SOSData> dataArray;

  SosListModel({
    required this.success,
    required this.message,
    required this.dataArray,
  });

  factory SosListModel.fromJson(Map<String, dynamic> json) {
    return SosListModel(
      success: json['success'],
      message: json['message'],
      dataArray: List<SOSData>.from(
          json['data_array'].map((data) => SOSData.fromJson(data))),
    );
  }
}

class SOSData {
  int id;
  String reference;
  String uid;
  String name;
  int statusId;
  String status;
  String color;
  List<SOSAction> actions;
  String created;
  String createdAt;
  String startTime;

  SOSData({
    required this.id,
    required this.reference,
    required this.uid,
    required this.name,
    required this.statusId,
    required this.status,
    required this.color,
    required this.actions,
    required this.created,
    required this.createdAt,
    required this.startTime,
  });

  factory SOSData.fromJson(Map<String, dynamic> json) {
    return SOSData(
      id: json['id'] ?? '',
      reference: json['reference'] ?? "",
      uid: json['uid'] ?? "",
      name: json['name'] ?? "",
      statusId: json['status_id'] ?? "",
      status: json['status'] ?? "",
      color: json['color'] ?? "",
      actions: List<SOSAction>.from(
          json['actions'].map((action) => SOSAction.fromJson(action))),
      created: json['created'],
      createdAt: json['created_at'],
      startTime: json['start_time'] ?? "",
    );
  }
}

class SOSAction {
  int id;
  int sosId;
  int statusId;
  String startTime;
  String? endTime;
  String uid;
  int createdBy;
  String createdAt;
  String? updatedAt;
  String? deletedAt;
  List<SOSComment> comments;
  String name;

  SOSAction({
    required this.id,
    required this.sosId,
    required this.statusId,
    required this.startTime,
    required this.endTime,
    required this.uid,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.comments,
    required this.name,
  });

  factory SOSAction.fromJson(Map<String, dynamic> json) {
    return SOSAction(
      id: json['id'],
      sosId: json['sos_id'],
      statusId: json['status_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      uid: json['uid'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      comments: List<SOSComment>.from(
          json['comments'].map((comment) => SOSComment.fromJson(comment))),
      name: json['name'],
    );
  }
}

class SOSComment {
  int id;
  int sosId;
  int statusId;
  int sosActionId;
  String comment;
  String uid;
  int createdBy;
  String createdAt;
  String? updatedAt;
  String? deletedAt;

  SOSComment({
    required this.id,
    required this.sosId,
    required this.statusId,
    required this.sosActionId,
    required this.comment,
    required this.uid,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory SOSComment.fromJson(Map<String, dynamic> json) {
    return SOSComment(
      id: json['id'],
      sosId: json['sos_id'],
      statusId: json['status_id'],
      sosActionId: json['sos_action_id'],
      comment: json['comment'],
      uid: json['uid'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
