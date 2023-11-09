class Notifications {
  int? id;
  String? userId;
  String? title;
  String? body;
  String? createdAt;
  bool? status;

  Notifications({this.id, this.userId, this.title, this.body, this.createdAt, this.status});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    body = json['body'];
    createdAt = json['createdAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['body'] = body;
    data['createdAt'] = createdAt;
    data['status'] = status;
    return data;
  }
}
