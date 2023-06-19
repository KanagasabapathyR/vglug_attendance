import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/utils/constants.dart';

class AlreadyAdded extends StatelessWidget {
  AlreadyAdded({this.classId, this.attendance, this.atList});
  var classId;
  AttendanceModel? attendance;
  List<AttendanceList>? atList;

  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController = Get.find();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            DateFormat('dd MMM yyyy').format(
              attendance!.timestamp!.toDate(),
            ),
            style: TextStyle(
              fontSize: 18,

            ),
          ),
          Text('Already added, you can update now',
              style: TextStyle(fontSize: 14, color: Colors.red)),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Staff Name"),
                  Text(attendance?.staffName ?? ''),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Text(DateFormat('dd-MMM-yyyy')
          //     .format(attendance.timestamp!.toDate())),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Expanded(child: Text("Students Name")),
          //     Expanded(child: Text("Attendance")),
          //
          //   ],
          // ),
          Card(
            child: Container(
              height: 80,
              child: Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Expanded(child: Center(child: Text('Total'))),
                    Expanded(child: Center(child: Text(attendance!.total.toString()))),
                  ],),
                ),
                Expanded(
                  child: Column(children: [
                    Expanded(child: Center(child: Text('Present'))),
                    Expanded(child: Center(child: Text(attendance!.present.toString()))),
                  ],),
                ),
                Expanded(
                  child: Column(children: [
                    Expanded(child: Center(child: Text('Absent'))),
                    Expanded(child: Center(child: Text(attendance!.absent.toString()))),
                  ],),
                ),

              ],
          ),
            ),),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: atList?.length,
                itemBuilder: (context, index) {
                  // String? checkin=DateFormat('hh:mm').format(atList?[index].checkin);
                  // DateTime? checkout=atList?[index].checkout;

                  // TimeOfDay checkout = attendanceController.getTimeOfDayFromString(
                  //     atList![index].checkout!.value);

                  if (index == 0) {
                    return Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Text(
                              "Students Name",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                            Expanded(
                                child: Center(
                                    child: Text(
                              "Attendance",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ))),
                          ],
                        ),
                        Obx(
                  ()=> Row(
                              // mainAxisAlignment:
                              // MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:20.0),
                                      child: Text(atList?[index].name! ?? ''),
                                    )),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          value:
                                              atList?[index].isPresent?.value,
                                          onChanged: (value) {
                                            atList?[index].isPresent?.value =
                                                value!;
                                            print(atList?[index].isPresent);
                                          }),
                                      // SizedBox(
                                      //   width: 10,
                                      // ),
                                      //   Obx(
                                      //         ()
                                      //     {
                                      //       Rx<TimeOfDay> checkin = Rx(attendanceController.getTimeOfDayFromString(
                                      //           atList![index].checkin!.value));
                                      //       return GestureDetector(
                                      //         onTap: () async {
                                      //           var time = await showTimePicker(
                                      //               context: context,
                                      //               initialTime: TimeOfDay(
                                      //                   hour: checkin.value.hour,
                                      //                   minute: checkin.value.minute));
                                      //           if(time!=null){
                                      //             atList?[index].checkin?.value=time.format(context);
                                      //             print(atList?[index].checkin?.value);
                                      //           }
                                      //
                                      //           print(time?.format(context));
                                      //         },
                                      //         child: Container(
                                      //           height: 35,
                                      //            // width: 63,
                                      //           padding: EdgeInsets.all(8.0),
                                      //           color: Colors.grey[300],
                                      //           child: Text(
                                      //
                                      //             "${checkin!.value.hour} : ${checkin!.value.minute}",
                                      //             textAlign: TextAlign.right,
                                      //             style: TextStyle(
                                      //                 fontWeight: FontWeight.bold),
                                      //           ),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ),
                                      //   SizedBox(
                                      //     width: 10,
                                      //   ),
                                      //   Obx(
                                      //         ()
                                      //         {
                                      //           Rx<TimeOfDay> checkout = Rx(attendanceController.getTimeOfDayFromString(
                                      //               atList![index].checkout!.value));
                                      //           return GestureDetector(
                                      //     onTap: () async {
                                      //       var time = await showTimePicker(
                                      //           context: context,
                                      //           initialTime: TimeOfDay(
                                      //               hour: checkout.value.hour,
                                      //               minute: checkout.value.minute));
                                      //
                                      //       if(time!=null){
                                      //         atList?[index].checkout?.value=time.format(context);
                                      //         print(atList?[index].checkout?.value);
                                      //       }
                                      //
                                      //       print(time?.format(context));
                                      //     },
                                      //     child: Container(
                                      //       height: 35,
                                      //       // width: 63,
                                      //       padding: EdgeInsets.all(8.0),
                                      //       color: Colors.grey[300],
                                      //       child: Text(
                                      //         "${checkout!.value.hour} : ${checkout!.value.minute}",
                                      //         textAlign: TextAlign.right,
                                      //
                                      //         style: TextStyle(
                                      //             fontWeight: FontWeight.bold),
                                      //       ),
                                      //     ),
                                      //   );
                                      // },
                                      //   ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    );
                  }

                  return Obx(
                    () => Row(
                        // mainAxisAlignment:
                        // MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(atList?[index].name! ?? ''),
                              )),
                          Expanded(
                            child: Row(
                              children: [
                                Center(
                                  child: Checkbox(
                                      value: atList?[index].isPresent?.value,
                                      onChanged: (value) {
                                        atList?[index].isPresent?.value =
                                            value!;
                                        print(atList?[index].isPresent);
                                      }),
                                ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                                //   Obx(
                                //         ()
                                //     {
                                //       Rx<TimeOfDay> checkin = Rx(attendanceController.getTimeOfDayFromString(
                                //           atList![index].checkin!.value));
                                //       return GestureDetector(
                                //         onTap: () async {
                                //           var time = await showTimePicker(
                                //               context: context,
                                //               initialTime: TimeOfDay(
                                //                   hour: checkin.value.hour,
                                //                   minute: checkin.value.minute));
                                //           if(time!=null){
                                //             atList?[index].checkin?.value=time.format(context);
                                //             print(atList?[index].checkin?.value);
                                //           }
                                //
                                //           print(time?.format(context));
                                //         },
                                //         child: Container(
                                //           height: 35,
                                //            // width: 63,
                                //           padding: EdgeInsets.all(8.0),
                                //           color: Colors.grey[300],
                                //           child: Text(
                                //
                                //             "${checkin!.value.hour} : ${checkin!.value.minute}",
                                //             textAlign: TextAlign.right,
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.bold),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //   ),
                                //   SizedBox(
                                //     width: 10,
                                //   ),
                                //   Obx(
                                //         ()
                                //         {
                                //           Rx<TimeOfDay> checkout = Rx(attendanceController.getTimeOfDayFromString(
                                //               atList![index].checkout!.value));
                                //           return GestureDetector(
                                //     onTap: () async {
                                //       var time = await showTimePicker(
                                //           context: context,
                                //           initialTime: TimeOfDay(
                                //               hour: checkout.value.hour,
                                //               minute: checkout.value.minute));
                                //
                                //       if(time!=null){
                                //         atList?[index].checkout?.value=time.format(context);
                                //         print(atList?[index].checkout?.value);
                                //       }
                                //
                                //       print(time?.format(context));
                                //     },
                                //     child: Container(
                                //       height: 35,
                                //       // width: 63,
                                //       padding: EdgeInsets.all(8.0),
                                //       color: Colors.grey[300],
                                //       child: Text(
                                //         "${checkout!.value.hour} : ${checkout!.value.minute}",
                                //         textAlign: TextAlign.right,
                                //
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   );
                                // },
                                //   ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ]),
                  );
                },
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
              onPressed: () {
                attendanceController.updateAttendance(
                    classId: classId, atList: atList, attendance: attendance, year: '2023');


              },


              child: Text("Submit")),
        ],
      ),

    );

  }
}
