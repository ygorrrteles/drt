import 'package:dio/dio.dart';
import 'package:dryve_teste/controllers/dio_controller.dart';
import 'package:dryve_teste/models/brand_model.dart';
import 'package:dryve_teste/models/car_model.dart';
import 'package:dryve_teste/models/color_model.dart';
import 'package:dryve_teste/utils/flutter_toast_utils.dart';
import 'package:dryve_teste/utils/urls.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePageRepository extends GetxController {
  static HomePageRepository get to => Get.find();
  final DioController _dio = Get.find<DioController>();
  GetStorage box = GetStorage();
  final failFetchAllCars = false.obs;

  Future<List<CarModel>> fetchAllCars() async {
    failFetchAllCars.value = false;
    try {
      Response response = await _dio.customDio.get(Urls.CAR_URL);
      List<CarModel> _list = (response.data as List).map((item) => CarModel.fromJson(item)).toList();
      await box.write("listCar", _list);
      FlutterToastUtils.to.showToast("Lista atualizada");
      return _list;
    } catch (e) {
      print(e);
      List<CarModel> _list = (await box.read("listCar") as List ?? new List<CarModel>()).map((item) => CarModel.fromJson(item)).toList();
      FlutterToastUtils.to.showToast("Lista recuperada da memória");
      if(_list.length == 0){
        failFetchAllCars.value = true;
      }
      return  _list ?? [];
    }
  }

  Future<List<ColorModel>> fetchAllColors() async {
    try {
      Response response = await _dio.customDio.get(Urls.COLOR_URL);
      List<ColorModel> _list = (response.data as List).map((item) => ColorModel.fromJson(item)).toList();
      await box.write("listColor", _list);
      return _list;
    } catch (e) {
      print(e);
      List<ColorModel> _list = (await box.read("listColor") as List ?? new List<ColorModel>()).map((item) => ColorModel.fromJson(item)).toList();
      return _list ?? [];
    }
  }

  Future<List<BrandModel>> fetchAllBrands() async {
    try {
      Response response = await _dio.customDio.get(Urls.BRAND_URL);
      List<BrandModel> _list = (response.data as List).map((item) => BrandModel.fromJson(item)).toList();
      await box.write("listBrand", _list);
      return _list;
    } catch (e) {
      print(e);
      List<BrandModel> _list = (await box.read("listBrand") as List ?? new List<BrandModel>()).map((item) => BrandModel.fromJson(item)).toList();
      return _list ?? [];
    }
  }
}
