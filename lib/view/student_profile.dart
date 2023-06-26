import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/student_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:vglug_attendance/view/admin/user_profile.dart';

import '../model/attendance_model.dart';
import 'widgets/attendance_table.dart';

class StudentProfile extends StatelessWidget {
  StudentProfile({this.classId, this.student});
  String? classId;
  StudentModel? student;
  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController = Get.find();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
        children: [
            Container(
              child: ListTile(
                title: Text("See Personal Details"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(() => UserProfile(student?.studentId!));
                },
              ),
            ),
            Container(
              child: Column(
                children: [
                  RowWidget(field: "Name", value: student?.name),
                  RowWidget(field: "Student ID", value: student?.studentId),
                ],
              ),
            ),

            Text('Attendance'),
            AttendanceTable(attendanceController: attendanceController, classId: classId, studentId: student?.studentId)
        ],
      ),
          )),
    );
  }
}


class RowWidget extends StatelessWidget {
  const RowWidget({
    super.key,
    this.field,
    this.value,
  });
  final field;
  final value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text(field)),
          Expanded(
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: value,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black45,
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
