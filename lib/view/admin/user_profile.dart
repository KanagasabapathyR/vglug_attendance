import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';

class UserProfile extends StatelessWidget {
   UserProfile(this.studentId);
      String? studentId;
  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController=Get.find();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot?>(
            future: attendanceController.getUser(id: studentId) ,
            builder: (context,AsyncSnapshot<DocumentSnapshot?> snapshot) {

              if(snapshot.hasData) {
                UserModel? user = UserModel.fromSnapshot(snapshot.data!);

                return Text(user.userId ?? '');
              }else if(snapshot.connectionState==ConnectionState.waiting)
                return kLoading;
              return Text(snapshot.error.toString());
            },)
        ],
      ),
    );
  }
}
