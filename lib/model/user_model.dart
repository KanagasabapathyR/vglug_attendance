// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
class UserModel {
  final String? userName;
  final List? classes;
  final String? phoneNumber;
  final String? userType;
  final String? userId;




  UserModel(
      {this.userName,
        this.classes,
        this.phoneNumber,
        this.userType,
        this.userId,

      });

  UserModel.fromSnapshot(snapshot)
      : userName = snapshot.data()?['user_name'],
        classes=snapshot.data()?['class'],
        userType=snapshot.data()?['user_type'],
        userId=snapshot.data()?['user_id'],
        phoneNumber=snapshot.data()?['phone_number'];
// Map<String, dynamic> toJson() => {
//
//   "customer_id": customerId,
//
// };
}



class ClassList extends GetxController{
  RxString? classId;
  RxString? className;

  RxString? year;
  ClassList(
      {this.classId,
        this.year,
        this.className,
      });
  factory ClassList.fromJson(Map<String, dynamic> json) => ClassList(

    classId: RxString(json['class_id']),
    className: RxString(json['class_name']),

    year: RxString(json['year']),

  );

  Map<String, dynamic> toJson() => {
    'class_id':classId?.value,
    'year':year?.value,
    'class_name':className
  };
}