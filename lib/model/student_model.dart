// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
class StudentModel {
  final String? name;
  final String? studentId;




  StudentModel(
      {this.name,
        this.studentId
       });

  StudentModel.fromSnapshot(snapshot)
      : name = snapshot.data()['name'], studentId=snapshot.data()['student_id'];
// Map<String, dynamic> toJson() => {
//
//   "customer_id": customerId,
//
// };
}

