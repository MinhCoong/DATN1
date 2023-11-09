class SliderMrSoai {
  int? id;
  String? imageSlider;
  String? imageFile;
  String? dateAdd;
  bool? status;

  SliderMrSoai(
      {this.id, this.imageSlider, this.imageFile, this.dateAdd, this.status});

  SliderMrSoai.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageSlider = json['imageSlider'];
    imageFile = json['imageFile'];
    dateAdd = json['dateAdd'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageSlider'] = imageSlider;
    data['imageFile'] = imageFile;
    data['dateAdd'] = dateAdd;
    data['status'] = status;
    return data;
  }
}
