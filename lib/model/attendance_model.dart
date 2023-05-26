// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
class AttendanceModel {
  final String? staffName;
  final Timestamp? timestamp;
  final List? attendance;

  AttendanceModel(
      {this.staffName,
        this.timestamp,this.attendance
      });
  AttendanceModel.fromSnapshot(snapshot)
      : staffName = snapshot?.data()['staff_name'],
      timestamp=snapshot?.data()['timestamp'],
        attendance=snapshot?.data()['attendance'];
  Map<String, dynamic> toJson() => {
  "staff_name": staffName,
  'timestamp':timestamp,
    'attendance':attendance
};
}

class AttendanceList extends GetxController{
   RxString? checkin;
   RxString? checkout;
   RxBool? isPresent;
   String? name;
   String? studentId;
  AttendanceList(
      {this.checkin,
        this.checkout,this.isPresent,this.name,this.studentId,
      });
  factory AttendanceList.fromJson(Map<String, dynamic> json) => AttendanceList(
    name: json['name'],
    checkin: RxString(json['checkin']),
    checkout: RxString(json['checkout']),
    isPresent: RxBool(json['is_present']??false),
    studentId: json['student_id'],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    'checkin':checkin?.value,
    'checkout':checkout?.value,
    'is_present':isPresent?.value,
    'student_id':studentId

  };
}