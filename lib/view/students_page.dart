import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/student_model.dart';

class Students extends StatelessWidget {
Students({this.classId});
var classId;
  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController=Get.find();
    return Scaffold(
      appBar: AppBar(
         title: Text('Students'),
      ),
      body: Container(
        child: FutureBuilder(
          future:attendanceController.getStudents(classId, '2023'),
          builder: (context, snapshot) {
          var students=snapshot.data?.docs.map((doc) => StudentModel.fromSnapshot(doc)).toList();

            return ListView.builder(
              itemCount: students?.length,
              itemBuilder: (context, index) {
              return Card(child: ListTile(title: Text(students?[index].name??'')));
            },);
          }
        ),
      ),
    );
  }
}
