import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/controller/auth_controller.dart';
import 'package:vglug_attendance/controller/common_controller.dart';
import 'package:vglug_attendance/controller/home_controller.dart';

class Binder extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(AttendanceController());
    Get.put(CommonController());
    Get.put(AuthController());


  }
}