import 'package:dryve_teste/controllers/dio_controller.dart';
import 'package:dryve_teste/controllers/home_page_controller.dart';
import 'package:dryve_teste/repository/home_page_repository.dart';
import 'package:dryve_teste/utils/flutter_toast_utils.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut<DioController>(() => DioController());
    Get.lazyPut<HomePageRepository>(() => HomePageRepository());
    Get.lazyPut<FlutterToastUtils>(() => FlutterToastUtils());
  }
}