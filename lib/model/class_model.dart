// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String? className;
  final String? classId;

  ClassModel({
    this.className,
    this.classId,
  });

  ClassModel.fromSnapshot(snapshot)
      : className = snapshot.data()?['class_name'],
        classId = snapshot.data()?['class_id'];

  Map<String, dynamic> toJson() => {
        "class_name": className,
        'status': classId,
      };
}
