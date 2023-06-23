
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/student_model.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:vglug_attendance/utils/user_search.dart';
import 'package:vglug_attendance/view/admin/student/add_student.dart';
import 'package:vglug_attendance/view/student_profile.dart';

class Students extends StatelessWidget {
  Students({this.classId});
  var classId;
  List<StudentModel>? students;
  Rxn<Future<QuerySnapshot>> classStudents=Rxn();
  RxBool isInit=true.obs;

  @override
  Widget build(BuildContext context) {

    AttendanceController attendanceController = Get.find();


    if(isInit.value){
      classStudents.value=  attendanceController.getClassStudents(classId, '2023');
      isInit.value=false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        actions: [
          IconButton(onPressed: ()async{
            await Get.to(()=>AddStudent(classId,students));
            classStudents.value=attendanceController.getClassStudents(classId, '2023');
            commonController.selectedStudents.value.clear();
          }, icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        child: Obx(
            ()=> FutureBuilder(
              future: classStudents.value,
              builder: (context, snapshot) {
                 students = snapshot.data?.docs
                    .map((doc) => StudentModel.fromSnapshot(doc))
                    .toList();

                return ListView.builder(
                  itemCount: students?.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                                Get.to(()=>StudentProfile(classId: classId,student: students![index]));
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(students?[index].name ?? ''),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
