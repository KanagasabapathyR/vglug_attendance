import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/model/student_model.dart';

class NewAdd extends StatelessWidget {
  NewAdd({this.classId, this.selectedDate});
  var classId;
  var selectedDate;

  final _formKey = GlobalKey<FormState>();
  TextEditingController staffNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController = Get.find();

    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('vglug')
            .doc('students')
            .collection(classId)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<StudentModel>? studentList = snapshot.data?.docs
                .map((doc) => StudentModel.fromSnapshot(doc))
                .toList();
            List<AttendanceList>? studentAtList = [];

            return Form(
              key: _formKey,
              child: Expanded(
                  child: Column(
                children: [
                  Text(DateFormat('dd-MMM-yyyy').format(selectedDate!.value)),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(child: Text("Staff Name")),
                        Expanded(
                            child: TextFormField(
                          controller: staffNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Staff Name';
                            }
                            return null;
                          },
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Text(DateFormat('dd-MMM-yyyy')
                  //     .format(attendance.timestamp!.toDate())),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: Text("Students Name")),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: Text("Attendance")),
                            Expanded(child: Text("Checkin")),
                            Expanded(child: Text("Checkout")),
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: studentList?.length,
                      itemBuilder: (context, index) {
                        RxBool? isPresent = false.obs;

                        studentAtList.add(AttendanceList(
                            name: studentList?[index].name,
                            checkin:RxString('10:30 AM'),

                            // RxString(TimeOfDay(hour: 10, minute: 30,)
                            //     .format(context)),
                            checkout: RxString('10:30 AM'),
                            // RxString(TimeOfDay(hour: 10, minute: 30)
                            //     .format(context)),
                            isPresent: false.obs,
                            studentId: ''));

                        return Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  child: Text(studentList?[index].name! ?? '')),
                              Expanded(
                                child: Row(
                                  children: [
                                    Obx(
                                      () => Checkbox(
                                          value: studentAtList[index]
                                              .isPresent
                                              ?.value,
                                          onChanged: (value) {
                                            // isPresent.value=value!;
                                            studentAtList[index]
                                                .isPresent
                                                ?.value = value!;
                                            print(studentAtList[index]
                                                .isPresent
                                                ?.value);
                                          }),
                                    ),
                                    Obx(
                                      () {
                                        Rx<TimeOfDay> checkin = Rx(
                                            attendanceController
                                                .getTimeOfDayFromString(
                                                    studentAtList[index]
                                                        .checkin!
                                                        .value));
                                        return GestureDetector(
                                          onTap: () async {
                                            var time = await showTimePicker(context: context, initialTime: TimeOfDay(hour: checkin.value.hour, minute: checkin.value.minute));
                                            if (time != null) {
                                              studentAtList[index]
                                                  .checkin
                                                  ?.value =
                                                  time!.format(context);
                                              print(studentAtList[index]
                                                  .checkin
                                                  ?.value);
                                              print('success');
                                            }
                                            print(time?.format(context));
                                          },
                                          child: Container(
                                            height: 35,
                                            // width: 63,
                                            padding: EdgeInsets.all(8.0),
                                            color: Colors.grey[300],
                                            child: Text(
                                              "${checkin.value.hour} : ${checkin.value.minute}",
                                              textAlign: TextAlign.right,

                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    //checkout
                                    Obx(
                                      () {
                                        Rx<TimeOfDay> checkout = Rx(
                                            attendanceController
                                                .getTimeOfDayFromString(
                                                    studentAtList[index]
                                                        .checkout!
                                                        .value));
                                        return GestureDetector(
                                          onTap: () async {
                                            var time = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: checkout.value.hour,
                                                    minute:
                                                        checkout.value.minute));

                                            if (time != null) {
                                              studentAtList[index]
                                                      .checkout
                                                      ?.value =
                                                  time!.format(context);
                                              print(studentAtList[index]
                                                  .checkout
                                                  ?.value);
                                              print('success');
                                            }
                                            print(time?.format(context));
                                          },
                                          child: Container(
                                            height: 35,
                                            // width: 63,
                                            padding: EdgeInsets.all(8.0),
                                            color: Colors.grey[300],
                                            child: Obx(() {
                                              return Text(
                                                "${checkout.value.hour} : ${checkout.value.minute}",
                                                textAlign: TextAlign.right,

                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            }),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(studentAtList.length);

                        if (_formKey.currentState!.validate()) {
                          attendanceController.addAttendance(
                              attendanceList: studentAtList,
                              classId: classId,
                              staffName: staffNameController.text,
                              date: selectedDate!.value);
                        }
                      },
                      child: Text("Submit"))
                ],
              )),
            );
          } else {
            return Text('error');
          }
        });
  }
}
