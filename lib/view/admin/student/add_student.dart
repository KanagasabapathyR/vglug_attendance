import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/controller/common_controller.dart';
import 'package:vglug_attendance/model/student_model.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:vglug_attendance/utils/user_search.dart';

class AddStudent extends StatelessWidget {
  AddStudent(this.classId, this.existingClassStudents);

  String? classId;

  List<StudentModel>? existingClassStudents;

  List<UserModel>? students;

  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController = Get.find();

    return Scaffold(
        appBar: AppBar(

          title: Text("Add Student"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: UserSearchDelegate(students));
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: GetBuilder<CommonController>(
            builder: (controller) {
          return controller.isLoading
              ? Center(child: kLoading)
              : FutureBuilder<QuerySnapshot>(
                  future: attendanceController.getAllStudents(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: kLoading);
                    } else if (snapshot.hasData) {
                      students = snapshot.data?.docs
                          .map((doc) => UserModel.fromSnapshot(doc))
                          .toList();

                      for (var stu in existingClassStudents!) {
                        students?.removeWhere(
                          (element) => element.userId == stu.studentId,
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: students?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    print(commonController
                                        .selectedStudents
                                        .contains(students?[index]));
                                    if (commonController.selectedStudents
                                        .contains(students?[index])) {
                                      print('remove');
                                      commonController.selectedStudents
                                          .remove(students?[index]);
                                    } else {
                                      print('add');
                                      commonController.selectedStudents
                                          .add(students![index]);
                                    }
                                    print(commonController.selectedStudents.length);

                                  },
                                  child: Obx(
                                      ()
                                        => Card(
                                        child: ListTile(
                                          title: Text(
                                              students?[index].userName ?? ""),
                                          trailing: commonController.selectedStudents.contains(students?[index])
                                              ? Icon(Icons.check)
                                              : null,
                                        ),
                                      )

                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(snapshot.error.toString());
                    }
                  });
        }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () async {
            if (commonController.selectedStudents.isNotEmpty) {
              print(commonController.selectedStudents.length);

              await attendanceController.addStudents(
                  students: commonController.selectedStudents,
                  classId: classId);
              // await attendanceController.updateUser(
              //     selectedStudents: commonController.selectedStudents,
              //     classId: classId);
            } else {
              commonController.showToast(message: "Select atleast 1 student");
            }
            commonController.selectedStudents.clear();
          },
        ));
  }
}
