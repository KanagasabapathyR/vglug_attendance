import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/model/student_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:vglug_attendance/view/widgets/customtextformfield.dart';

class NewAdd extends StatefulWidget {
  NewAdd({this.classId, this.selectedDate});
  var classId;
  var selectedDate;

  @override
  State<NewAdd> createState() => _NewAddState();
}

class _NewAddState extends State<NewAdd> {
  RxBool isInit=true.obs;

  Rxn<Future<QuerySnapshot>?> getStudentsFuture=Rxn();

  final _formKey = GlobalKey<FormState>();

  TextEditingController staffNameController = TextEditingController();
  AttendanceController attendanceController = Get.find();
  List<AttendanceList>? studentAtList=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentsFuture.value=attendanceController.getClassStudents(widget.classId,'2023');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
            future: getStudentsFuture.value,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: kLoading,
                );
              } else if (snapshot.hasData ) {
                List<StudentModel>? studentList = snapshot.data?.docs
                    .map((doc) => StudentModel.fromSnapshot(doc))
                    .toList();
                if(isInit.value){
                  for(int i=0;i<studentList!.length;i++){
                    studentAtList?.add(AttendanceList(
                        name: studentList[i].name,
                        checkin: RxString('10:30 AM'),
                        checkout: RxString('10:30 AM'),
                        isPresent: false.obs,
                        studentId: studentList[i].studentId));
                  }
                    isInit.value=false;
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                  Text(DateFormat('dd MMM yyyy')
                      .format(widget.selectedDate!.value), style: TextStyle(
                    fontSize: 18,
                  ),),
                     if(studentAtList!.isEmpty)
                       Expanded(child: Center(child: Text("No Students"))),

                      if(studentAtList!.isNotEmpty) 
                        Container(
                          height: 500,
                          child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                             Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0,
                                horizontal: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Enter Staff Name'),
                                  SizedBox(height: 5,),
                                  CustomTextFormFieldWidget(hint: 'Staff Name', controller: staffNameController, validation: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Staff Name';
                                    }
                                    return null;
                                  }, keyBoard: TextInputType.text),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(),
                                    // shrinkWrap: true,
                                    itemCount: studentList?.length,
                                    itemBuilder: (context, index) {


                                      if(index==0){
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(child: Text("Students Name",style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.w600),)),
                                                Expanded(child: Center(child: Text("Attendance",style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.w600),))),

                                              ],
                                            ),
                                            Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(

                                                        studentList?[index].name ?? '',
                                                        textAlign: TextAlign.left,
                                                      )),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Center(
                                                          child: Obx(
                                                                  () => Checkbox(
                                                                  value: studentAtList?[index]
                                                                      .isPresent
                                                                      ?.value,
                                                                  onChanged: (value) {
                                                                    // isPresent.value=value!;
                                                                    studentAtList?[index]
                                                                        .isPresent
                                                                        ?.value = value!;
                                                                    print(studentAtList?[index]
                                                                        .isPresent
                                                                        ?.value);
                                                                  })
                                                          ),
                                                        ),
                                                        // Obx(
                                                        //   () {
                                                        //     Rx<TimeOfDay> checkin = Rx(
                                                        //         attendanceController
                                                        //             .getTimeOfDayFromString(
                                                        //                 studentAtList[index]
                                                        //                     .checkin!
                                                        //                     .value));
                                                        //     return GestureDetector(
                                                        //       onTap: () async {
                                                        //         var time = await showTimePicker(
                                                        //             context: context,
                                                        //             initialTime: TimeOfDay(
                                                        //                 hour:
                                                        //                     checkin.value.hour,
                                                        //                 minute: checkin
                                                        //                     .value.minute));
                                                        //         if (time != null) {
                                                        //           studentAtList[index]
                                                        //                   .checkin
                                                        //                   ?.value =
                                                        //               time!.format(context);
                                                        //           print(studentAtList[index]
                                                        //               .checkin
                                                        //               ?.value);
                                                        //           print('success');
                                                        //         }
                                                        //         print(time?.format(context));
                                                        //       },
                                                        //       child: Container(
                                                        //         height: 35,
                                                        //         // width: 63,
                                                        //         padding: EdgeInsets.all(8.0),
                                                        //         color: Colors.grey[300],
                                                        //         child: Text(
                                                        //           "${checkin.value.hour} : ${checkin.value.minute}",
                                                        //           textAlign: TextAlign.right,
                                                        //           style: TextStyle(
                                                        //               fontWeight:
                                                        //                   FontWeight.bold),
                                                        //         ),
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        // ),
                                                        // SizedBox(
                                                        //   width: 10,
                                                        // ),
                                                        // //checkout
                                                        // Obx(
                                                        //   () {
                                                        //     Rx<TimeOfDay> checkout = Rx(
                                                        //         attendanceController
                                                        //             .getTimeOfDayFromString(
                                                        //                 studentAtList[index]
                                                        //                     .checkout!
                                                        //                     .value));
                                                        //     return GestureDetector(
                                                        //       onTap: () async {
                                                        //         var time = await showTimePicker(
                                                        //             context: context,
                                                        //             initialTime: TimeOfDay(
                                                        //                 hour:
                                                        //                     checkout.value.hour,
                                                        //                 minute: checkout
                                                        //                     .value.minute));
                                                        //
                                                        //         if (time != null) {
                                                        //           studentAtList[index]
                                                        //                   .checkout
                                                        //                   ?.value =
                                                        //               time!.format(context);
                                                        //           print(studentAtList[index]
                                                        //               .checkout
                                                        //               ?.value);
                                                        //           print('success');
                                                        //         }
                                                        //         print(time?.format(context));
                                                        //       },
                                                        //       child: Container(
                                                        //         height: 35,
                                                        //         // width: 63,
                                                        //         padding: EdgeInsets.all(8.0),
                                                        //         color: Colors.grey[300],
                                                        //         child: Obx(() {
                                                        //           return Text(
                                                        //             "${checkout.value.hour} : ${checkout.value.minute}",
                                                        //             textAlign: TextAlign.right,
                                                        //             style: TextStyle(
                                                        //                 fontWeight:
                                                        //                     FontWeight.bold),
                                                        //           );
                                                        //         }),
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ])
                                          ],
                                        );
                                      }


                                      return Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    studentList?[index].name ?? '')),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,

                                                children: [
                                                  Center(
                                                    child: Obx(
                                                          () => Checkbox(
                                                          value: studentAtList?[index]
                                                              .isPresent
                                                              ?.value,
                                                          onChanged: (value) {
                                                            // isPresent.value=value!;
                                                            studentAtList?[index]
                                                                .isPresent
                                                                ?.value = value!;
                                                            print(studentAtList?[index]
                                                                .isPresent
                                                                ?.value);
                                                          }),
                                                    ),
                                                  ),
                                                  // Obx(
                                                  //   () {
                                                  //     Rx<TimeOfDay> checkin = Rx(
                                                  //         attendanceController
                                                  //             .getTimeOfDayFromString(
                                                  //                 studentAtList[index]
                                                  //                     .checkin!
                                                  //                     .value));
                                                  //     return GestureDetector(
                                                  //       onTap: () async {
                                                  //         var time = await showTimePicker(
                                                  //             context: context,
                                                  //             initialTime: TimeOfDay(
                                                  //                 hour:
                                                  //                     checkin.value.hour,
                                                  //                 minute: checkin
                                                  //                     .value.minute));
                                                  //         if (time != null) {
                                                  //           studentAtList[index]
                                                  //                   .checkin
                                                  //                   ?.value =
                                                  //               time!.format(context);
                                                  //           print(studentAtList[index]
                                                  //               .checkin
                                                  //               ?.value);
                                                  //           print('success');
                                                  //         }
                                                  //         print(time?.format(context));
                                                  //       },
                                                  //       child: Container(
                                                  //         height: 35,
                                                  //         // width: 63,
                                                  //         padding: EdgeInsets.all(8.0),
                                                  //         color: Colors.grey[300],
                                                  //         child: Text(
                                                  //           "${checkin.value.hour} : ${checkin.value.minute}",
                                                  //           textAlign: TextAlign.right,
                                                  //           style: TextStyle(
                                                  //               fontWeight:
                                                  //                   FontWeight.bold),
                                                  //         ),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                  // SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                  // //checkout
                                                  // Obx(
                                                  //   () {
                                                  //     Rx<TimeOfDay> checkout = Rx(
                                                  //         attendanceController
                                                  //             .getTimeOfDayFromString(
                                                  //                 studentAtList[index]
                                                  //                     .checkout!
                                                  //                     .value));
                                                  //     return GestureDetector(
                                                  //       onTap: () async {
                                                  //         var time = await showTimePicker(
                                                  //             context: context,
                                                  //             initialTime: TimeOfDay(
                                                  //                 hour:
                                                  //                     checkout.value.hour,
                                                  //                 minute: checkout
                                                  //                     .value.minute));
                                                  //
                                                  //         if (time != null) {
                                                  //           studentAtList[index]
                                                  //                   .checkout
                                                  //                   ?.value =
                                                  //               time!.format(context);
                                                  //           print(studentAtList[index]
                                                  //               .checkout
                                                  //               ?.value);
                                                  //           print('success');
                                                  //         }
                                                  //         print(time?.format(context));
                                                  //       },
                                                  //       child: Container(
                                                  //         height: 35,
                                                  //         // width: 63,
                                                  //         padding: EdgeInsets.all(8.0),
                                                  //         color: Colors.grey[300],
                                                  //         child: Obx(() {
                                                  //           return Text(
                                                  //             "${checkout.value.hour} : ${checkout.value.minute}",
                                                  //             textAlign: TextAlign.right,
                                                  //             style: TextStyle(
                                                  //                 fontWeight:
                                                  //                     FontWeight.bold),
                                                  //           );
                                                  //         }),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                             // Spacer(),
                             ElevatedButton(
                                onPressed: () {
                                  print(studentAtList?.length);

                                  if (_formKey.currentState!.validate() && studentAtList!.isNotEmpty) {
                                    attendanceController.addAttendance(
                                      attendanceList: studentAtList,
                                      classId: widget.classId,
                                      staffName: staffNameController.text,
                                      date: widget.selectedDate!.value,
                                      year: '2023',
                                    );
                                    attendanceController.getAttendanceFuture.value= attendanceController.getAttendance(classId: widget.classId,selectedDate: widget.selectedDate?.value,year: '2023');
                                  }
                                },
                                child: Text("Submit"))
                          ],
                      ),
                        ),


                    ],
                  ),
                );
              } else {
                if(snapshot.hasError)
                  return Center(child: Text(snapshot.error.toString()));
                else return SizedBox();
              }
            });

  }
}
