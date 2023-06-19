import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/admin_home_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/model/student_model.dart';

class AdminHome extends StatelessWidget {
   AdminHome({Key? key}) : super(key: key);

  List<StudentModel> students=[];
  List attendance=[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          children: [
           Container(child: Text('Home'),)
          ],
        ),
      ),
    );
  }
}
