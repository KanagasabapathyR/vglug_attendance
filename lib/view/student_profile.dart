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
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: attendanceController.getAllAttendance(classId: classId),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

                  if(snapshot.connectionState==ConnectionState.waiting){
                    return kLoading;
                  }
                  if (snapshot.hasData) {
                    List<AttendanceModel>? attendance = snapshot.data?.docs
                        .map((doc) => AttendanceModel.fromSnapshot(doc))
                        .toList();

                    print(attendance?.length);

                    List<List<AttendanceList>>? atList = [];

                    for (int i = 0; i < attendance!.length; i++) {
                      List<AttendanceList>? list = attendance[i]
                          .attendance
                          ?.map((e) => AttendanceList(
                              name: e['name'],
                              date: attendance[i].timestamp,
                              studentId: e['student_id'],
                              isPresent: RxBool(e['is_present'])
                      ))
                          .toList();
                      atList.add(list!);
                    }

                    List<AttendanceList> selStuAtList = [];

                    for (int i = 0; i < atList.length; i++) {
                      for (int j = 0; j < atList[i].length; j++) {
                        if (student?.studentId == atList[i][j].studentId) {
                          selStuAtList.add(atList[i][j]);
                          // selStuAtList.add(atList[i][j]);
                          print(atList[i][j].studentId);
                        }
                      }
                    }

                    // return DataTable(columns: [DataColumn(label: Text(""))], rows: selStuAtList.map((e) => ), );

                    // print(atList?.length);
                    int total=selStuAtList.length;
                    int present=0;
                    int absent=0;

                    for(var single in selStuAtList){
                      if(single.isPresent!.value){
                        present++;
                      }else {
                        absent++;
                      }
                    }

                    RxBool detailView=false.obs;

                    if(selStuAtList.isNotEmpty)
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1,color: Colors.black26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(children: [
                                    Expanded(child: Center(child: Text('Total Classes'))),
                                    Expanded(child: Center(child: Text(selStuAtList.length.toString()))),
                                  ],),
                                ),
                                Expanded(
                                  child: Column(children: [
                                    Expanded(child: Center(child: Text('Present'))),
                                    Expanded(child: Center(child: Text(present.toString()))),
                                  ],),
                                ),
                                Expanded(
                                  child: Column(children: [
                                    Expanded(child: Center(child: Text('Absent'))),
                                    Expanded(child: Center(child: Text(absent.toString()))),
                                  ],),
                                ),

                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){

                              detailView.value=!detailView.value;
                              print(detailView.value);

                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("See Detail View"),
                                  IconButton(onPressed: (){

                                        detailView.value=!detailView.value;
                                        print(detailView.value);

                                  }, icon: Obx(()=> detailView.value?Icon(Icons.keyboard_arrow_up_outlined):Icon(Icons.keyboard_arrow_down_outlined)))
                                ],
                              ),
                            ),
                          ),

                         Obx(() => detailView.value?DataTable(
                           columns: [
                             DataColumn(
                               label: Text('Date'),
                             ),
                             DataColumn(
                               label: Text('Attendance'),
                             ),
                           ],
                           rows: List<DataRow>.generate(
                             selStuAtList.length,
                                 (index) => DataRow(
                               cells: [
                                 DataCell(
                                   Text(
                                     DateFormat('dd-MMM-yyyy').format(
                                       selStuAtList[index].date!.toDate(),
                                     ),
                                   ),
                                 ),
                                 DataCell(selStuAtList[index].isPresent!.value
                                     ? Text('Present')
                                     : Text('Absent')),
                               ],
                             ),
                           ),
                         ):Container())

                        ],
                      ),
                    );
                    else
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1,color: Colors.black26),
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No Data'),
                          ],
                        ),
                      );


                  }
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.black26),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Data'),
                      ],
                    ),
                  );
                })
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
