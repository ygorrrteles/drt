import 'dart:collection';

import 'package:dryve_teste/models/brand_model.dart';
import 'package:dryve_teste/models/car_model.dart';
import 'package:dryve_teste/models/color_model.dart';
import 'package:dryve_teste/repository/home_page_repository.dart';
import 'package:dryve_teste/utils/flutter_toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  static HomePageController get to => Get.find();
  final _homePageRepository = Get.find<HomePageRepository>();

  final filterController = TextEditingController().obs;
  final filterMarcas = "".obs;
  final _listCar = <CarModel>[].obs;
  final _listCarFiltered = <CarModel>[].obs;
  final _listColor = <ColorModel>[].obs;
  final _listBrand = <BrandModel>[].obs;
  final appliedFilter = false.obs;
  final _numberFilter = 0.obs;

  List<ColorModel> get listColor => _listColor;

  int get numberFilter => _numberFilter.value;

  List<CarModel> get listCar {
    if (appliedFilter.value) {
      return _listCarFiltered;
    } else {
      return _listCar;
    }
  }

  List<BrandModel> get listBrands {
    if (filterMarcas.value.isEmpty) {
      return _listBrand;
    } else {
      return _listBrand.where((e) => e.name.toLowerCase().contains(filterMarcas.value.trim().toLowerCase())).toList();
    }
  }

  void setFilterMarcas() => filterMarcas.value = HomePageController.to.filterController.value.text;

  void resetFilter() {
    _listColor.update((value) {
      value.forEach((element) {
        element.checked = false;
      });
    });
    _listBrand.update((value) {
      value.forEach((element) {
        element.checked = false;
      });
    });
    appliedFilter.value = false;
    filterController.value.clear();
    setFilterMarcas();
    _numberFilter.value = 0;
    FlutterToastUtils.to.showToast("Filtros removidos");
  }

  void applyFilter() {
    _listCarFiltered.clear();
    appliedFilter.value = false;

    _listColor.forEach((color) {
      if (color.checked == true) {
        appliedFilter.value = true;
        _listCarFiltered.addAll(_listCar.where((car) => car.colorId == int.parse(color.colorId)).toList());
      }
    });
    _listBrand.forEach((brand) {
      if (brand.checked == true) {
        appliedFilter.value = true;
        _listCarFiltered.addAll(_listCar.where((car) => car.brandId == int.parse(brand.brandId)).toList());
      }
    });
    _listCarFiltered.value = LinkedHashSet<CarModel>.from(_listCarFiltered).toList();
    _listCarFiltered.sort((a, b) => a.id.compareTo(b.id));
    Get.back();
    if (appliedFilter.value) {
      FlutterToastUtils.to.showToast("Filtros aplicados");
    }
  }

  void checkBrand(Rx<BrandModel> brand) {
    brand.update((val) {
      val.checked = !val.checked;
      if (val.checked) {
        _numberFilter.value++;
      } else {
        _numberFilter.value--;
      }
    });
  }

  void checkColor(Rx<ColorModel> color) {
    color.update((val) {
      val.checked = !val.checked;
      if (val.checked) {
        _numberFilter.value++;
      } else {
        _numberFilter.value--;
      }
    });
  }

  Future<List<CarModel>> fetchAllCars() async {
    _listCar.value = await _homePageRepository.fetchAllCars();
  }

  Future<List<CarModel>> fetchAllColors() async {
    _listColor.value = await _homePageRepository.fetchAllColors();
  }

  Future<List<CarModel>> fetchAllBrands() async {
    _listBrand.value = await _homePageRepository.fetchAllBrands();
  }

  @override
  void onReady() async {
    fetchAllCars();
    fetchAllColors();
    fetchAllBrands();
    super.onReady();
  }
}
