// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String? className;
  final String? classId;
  final Timestamp? startDate;
  final Timestamp? endDate;

  ClassModel({
    this.className,
    this.classId,
    this.startDate,
    this.endDate,
  });

  ClassModel.fromSnapshot(snapshot)
      : className = snapshot.data()?['class_name'],
        classId = snapshot.data()?['class_id'],
        startDate=snapshot.data()?['start_date'],
        endDate=snapshot.data()?['end_date'];

  Map<String, dynamic> toJson() => {
        "class_name": className,
        'class_id': classId,
        "start_date":startDate,
        "end_date":endDate
      };
}
