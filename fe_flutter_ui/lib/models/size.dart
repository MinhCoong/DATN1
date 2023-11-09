class Size {
  int? id;
  String? sizeName;
  bool? status;

  Size({this.id, this.sizeName, this.status});

  Size.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sizeName = json['sizeName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sizeName'] = sizeName;
    data['status'] = status;
    return data;
  }
}
