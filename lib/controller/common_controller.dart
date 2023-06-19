import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/model/user_model.dart';


class CommonController extends GetxController{

  var isLoading=false;

  RxList selectedStudents=RxList();


  setLoadValue(value){
   isLoading=value;
   update();
 }

 showToast({String? message}){
    Fluttertoast.showToast(
     msg: message!,
     toastLength: Toast.LENGTH_SHORT,
     gravity: ToastGravity.BOTTOM,
     backgroundColor: Colors.black,
     textColor: Colors.white,
   ); }



}