import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DioController extends GetxController{
  static DioController get to => Get.find();

  final Dio customDio = new Dio()..options.baseUrl = "https://run.mocky.io/v3/";

}