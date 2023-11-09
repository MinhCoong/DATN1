class News {
  int? id;
  String? userId;
  String? title;
  String? newsDate;
  String? image;
  String? imageFile;
  String? description;
  bool? status;

  News({
    this.id,
    this.userId,
    this.title,
    this.newsDate,
    this.image,
    this.imageFile,
    this.description,
    this.status,
  });

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    newsDate = json['newsDate'];
    image = json['image'];
    imageFile = json['imageFile'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['newsDate'] = newsDate;
    data['image'] = image;
    data['imageFile'] = imageFile;
    data['description'] = description;
    data['status'] = status;

    return data;
  }
}
