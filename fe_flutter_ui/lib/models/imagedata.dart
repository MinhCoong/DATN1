class ImageDatas {
  String? name;
  String? data;

  ImageDatas({this.name, this.data});

  ImageDatas.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['data'] = this.data;
    return data;
  }
}
