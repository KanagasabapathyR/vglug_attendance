// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
class StudentModel {
  final String? name;
  final String? studentId;
  final String? phoneNumber;




  StudentModel(
      {this.name,
        this.studentId,
        this.phoneNumber,
       });

  StudentModel.fromSnapshot(snapshot)
      : name = snapshot.data()?['student_name'], studentId=snapshot.data()?['student_id'],phoneNumber=snapshot.data()?['phone_number'];
// Map<String, dynamic> toJson() => {
//
//   "customer_id": customerId,
//
// };
}

