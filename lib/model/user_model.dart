// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
class UserModel {
  final String? userName;
  final String? college;
  final String? collegeCourse;
  final String? collegeCourseBranch;
  final String? courseCurrentYear;

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
        this.college,
        this.collegeCourse,
        this.collegeCourseBranch,
        this.courseCurrentYear

      });

  UserModel.fromSnapshot(snapshot)
      : userName = snapshot.data()?['user_name'],
        classes=snapshot.data()?['class'],
        userType=snapshot.data()?['user_type'],
        userId=snapshot.data()?['user_id'],
        phoneNumber=snapshot.data()?['phone_number'],
        courseCurrentYear=snapshot.data()?['course_current_year'],
        collegeCourseBranch=snapshot.data()?['college_course_brance'],
        collegeCourse=snapshot.data()?['college_course'],
        college=snapshot.data()?['college'];



  Map<String, dynamic> toJson() => {
  "user_name": userName,
    "class":classes,
    "user_type":userType,
    "user_id":userId,
    "phone_number":phoneNumber,
    'course_current_year':courseCurrentYear,
    "college_course_brance":collegeCourseBranch,
    "college_course":collegeCourse,
    "college":college,
};
}
