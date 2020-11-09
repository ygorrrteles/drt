class BrandModel {
  String brandId;
  String name;
  bool checked;

  BrandModel({this.brandId, this.name, this.checked = false});

  BrandModel.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    name = json['name'];
    checked = json['checked'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_id'] = this.brandId;
    data['name'] = this.name;
    data['checked'] = this.checked;
    return data;
  }
}
