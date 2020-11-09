class ColorModel {
  String colorId;
  String name;
  bool checked;

  ColorModel({this.colorId, this.name, this.checked = false});

  ColorModel.fromJson(Map<String, dynamic> json) {
    colorId = json['color_id'];
    name = json['name'];
    checked = json['checked'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color_id'] = this.colorId;
    data['name'] = this.name;
    data['checked'] = this.checked;
    return data;
  }
}
