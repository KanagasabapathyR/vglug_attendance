import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/controller/auth_controller.dart';
import 'package:vglug_attendance/model/student_model.dart';

class Student extends StatelessWidget {
   Student();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    AttendanceController attendanceController=Get.find();

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text("VGLUG Foundation"),
                ],
              ),
            ),
            ListTile(title: Text('Profile'),),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                Get.back();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are you sure you want to Sing Out"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("No")),
                          TextButton(
                              onPressed: () {
                                authController.signOut();
                              },
                              child: Text("Yes"))
                        ],
                      );
                    });
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('VGLUG Foundation'),
      ),
      body: Column(
        children: [
          // FutureBuilder<DocumentSnapshot>(
          //   future: attendanceController.getSingleStudent( classId: selectedClassId, year: selectedYear,phoneNumber: FirebaseAuth.instance.currentUser?.phoneNumber),
          //   builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //       if(snapshot.hasData && snapshot.data!.exists) {
          //       StudentModel student = StudentModel.fromSnapshot(snapshot.data);
          //       print(snapshot.data);
          //       return Card(
          //         child: Container(
          //           height: 100,
          //           width: double.infinity,
          //           child: Center(child: Text("name:     " + student.name.toString())),
          //         ),
          //       );
          //     }
          //       else{
          //         return Expanded(child: Center(child: Text('No Data please contact admin')));
          //       }
          //   },
          // ),
        ],
      ),
    );
  }
}
