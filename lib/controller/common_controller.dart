import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


class CommonController extends GetxController{

  var isLoading=false;

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