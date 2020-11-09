class CarModel {
  String id;
  String imageUrl;
  String brandName;
  String modelName;
  int modelYear;
  String fuelType;
  int mileage;
  String transmissionType;
  int price;
  int brandId;
  int colorId;
  bool isFavorite;

  CarModel(
      {this.id,
        this.imageUrl,
        this.brandName,
        this.modelName,
        this.modelYear,
        this.fuelType,
        this.mileage,
        this.transmissionType,
        this.price,
        this.brandId,
        this.colorId,
        this.isFavorite = false
      });

  CarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    brandName = json['brand_name'];
    modelName = json['model_name'];
    modelYear = json['model_year'];
    fuelType = json['fuel_type'];
    mileage = json['mileage'];
    transmissionType = json['transmission_type'];
    price = json['price'];
    brandId = json['brand_id'];
    colorId = json['color_id'];
    isFavorite = json['isFavorite'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['brand_name'] = this.brandName;
    data['model_name'] = this.modelName;
    data['model_year'] = this.modelYear;
    data['fuel_type'] = this.fuelType;
    data['mileage'] = this.mileage;
    data['transmission_type'] = this.transmissionType;
    data['price'] = this.price;
    data['brand_id'] = this.brandId;
    data['color_id'] = this.colorId;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}
