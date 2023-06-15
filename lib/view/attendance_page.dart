import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/controller/common_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/model/student_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:vglug_attendance/view/already_added.dart';
import 'package:vglug_attendance/view/new_add.dart';

class Attendance extends StatefulWidget {
  Attendance({this.classId});
  var classId;

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  Rx<DateTime>? selectedDate = DateTime.now().obs;

  AttendanceModel? attendance;

  List<AttendanceList>? atList;

  DateTime startDate = DateTime(2023, 1, 1);

  DateTime endDate = DateTime(2023, 12, 31);

  List<DateTime> sundays = [];

  RxBool isInit = true.obs;

  RxBool needScroll = true.obs;

  ScrollController scrollController = ScrollController();

  RxInt focusedDayIndex = 0.obs;

  RxInt selectedDayIndex = 0.obs;

  CalendarFormat format = CalendarFormat.week;
  AttendanceController attendanceController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sundays = attendanceController.getSundays(startDate, endDate);
    isInit.value = false;

  }

  @override
  Widget build(BuildContext context) {

    // if (isInit.value) {
    //
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),

      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        // height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: sundays.length,
                itemBuilder: (context, index) {
                  print(sundays.length);
                  var singleSunday = sundays[index];

                  DateTime lastSunday = attendanceController.getNearestSunday(
                      DateTime(DateTime.now().year, DateTime.now().month,
                          DateTime.now().day)
                      //  DateTime(2023,6,5)
                      );

                  focusedDayIndex.value = sundays.indexOf(DateTime(
                      lastSunday.year, lastSunday.month, lastSunday.day));
                  print(focusedDayIndex.value);
                  print(sundays[focusedDayIndex.value]);

                  print(lastSunday.toString());


                  if (needScroll.value) {
                    selectedDate?.value = sundays[focusedDayIndex.value];

                    scrollController.animateTo(focusedDayIndex.value * (70),
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOutCubicEmphasized);
                    needScroll.value = false;
                  }

                  Future.delayed(Duration(seconds: 1),() {
                    attendanceController.getAttendanceFuture.value =
                        attendanceController.getAttendance(
                            classId: widget.classId,
                            selectedDate: selectedDate?.value,
                        year: '2023',
                        );

                  },);


                  return GestureDetector(
                    onTap: () {
                      selectedDate?.value = singleSunday;
                      attendanceController.getAttendanceFuture.value =
                          attendanceController.getAttendance(
                              classId: widget.classId,
                              selectedDate: selectedDate?.value,
                          year: '2023'
                          );

                      selectedDayIndex.value = sundays.indexOf(DateTime(
                        selectedDate!.value.year,
                        selectedDate!.value.month,
                        selectedDate!.value.day,
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => Container(
                          width: 70,
                          decoration: BoxDecoration(
                              color: focusedDayIndex.value == index
                                  ? Colors.black12
                                  : selectedDayIndex.value == index
                                      ? Colors.yellow
                                      : null,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat('dd MMM')
                                  .format(singleSunday)
                                  .toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Obx(
              () {
                return FutureBuilder(
                    future: attendanceController.getAttendanceFuture.value,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(child: Center(child: kLoading));
                      } else if (snapshot.hasData && snapshot.data!.exists) {
                        attendance =
                            AttendanceModel.fromSnapshot(snapshot.data!);
                        atList = attendance?.attendance
                            ?.map((e) => AttendanceList.fromJson(e))
                            .toList();
                        //alreadyadded
                        return Expanded(
                          child: GetBuilder<CommonController>(
                              builder: (controller) {
                            return controller.isLoading
                                ? Center(child: kLoading)
                                : AlreadyAdded(
                                    classId: widget.classId,
                                    attendance: attendance,
                                    atList: atList,
                                  );
                          }),
                        );
                      } else {
                        //newadded

                        return Expanded(
                          child: GetBuilder<CommonController>(
                              builder: (controller) {
                            return controller.isLoading
                                ? Center(child: kLoading)
                                : NewAdd(
                                    classId: widget.classId,
                                    selectedDate: selectedDate,
                                  );
                          }),
                        );
                      }
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TableCalendar(
//                   calendarFormat: format,
//
//                   focusedDay: selectedDate!.value,
//                   firstDay: DateTime(2023),
//                   lastDay: DateTime.now().add(Duration(days: 365)),
//                   onDaySelected: (selectedDay, focusedDay) {
//                     selectedDate!.value = selectedDay;
//                     print(selectedDate!.value);
//                   },
//
//                   // daysOfWeekVisible: false,
//                   currentDay: selectedDate?.value,
//                   // calendarBuilders: CalendarBuilders(
//                   //   // Customize the day cell
//                   //   dowBuilder: (context,date) {
//                   //     if (date.weekday == DateTime.sunday) {
//                   //       // Show only Sundays
//                   //       return Container(
//                   //         decoration: BoxDecoration(
//                   //           color: Colors.yellow, // Customize the color
//                   //           shape: BoxShape.circle,
//                   //         ),
//                   //         child: Center(
//                   //           child: Text(
//                   //             '${date.day}',
//                   //             style: TextStyle(
//                   //               color: Colors.black, // Customize the text color
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       );
//                   //     } else {
//                   //       return Container();
//                   //     }
//                   //   },
//                   //   prioritizedBuilder:  (context,day,date) {
//                   //     if (day.weekday == DateTime.sunday) {
//                   //       // Show only Sundays
//                   //       return Container(
//                   //         decoration: BoxDecoration(
//                   //           color: Colors.yellow, // Customize the color
//                   //           shape: BoxShape.circle,
//                   //         ),
//                   //         child: Center(
//                   //           child: Text(
//                   //             '${date.day}',
//                   //             style: TextStyle(
//                   //               color: Colors.black, // Customize the text color
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       );
//                   //     } else {
//                   //       return Container();
//                   //     }
//                   //   },
//                   // ),
//                 ),

//                          Container(
//                             height: 50,
//                             child: ListView.builder(
//
//                               controller: scrollController,
//                               scrollDirection: Axis.horizontal,
//                               itemCount: sundays.length,
//                               itemBuilder: (context, index) {
//                                 print(sundays.length);
//                                 var singleSunday = sundays[index];
//
//                                DateTime lastSunday=attendanceController.getNearestSunday(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
//
//                                 focusedDayIndex.value=sundays.indexOf(DateTime(lastSunday.year,lastSunday.month,lastSunday.day));
//                                print(focusedDayIndex.value);
//                                print(sundays[focusedDayIndex.value]);
//                                print(lastSunday.toString());
//
//                                if(isInit.value){
//                                  scrollController.animateTo(focusedDayIndex.value * (70), duration: Duration(microseconds: 1000), curve: Curves.bounceIn);
//                                   isInit.value=false;
//                                }
//
//                                 return GestureDetector(
//                                   onTap: () {
//                                     selectedDate?.value = singleSunday;
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(4.0),
//                                     child: Container(
//                                       width: 70,
//                                       decoration: BoxDecoration(
//                                           color: focusedDayIndex.value==index?Colors.black12:null,
//
//                                           border:
//                                               Border.all(color: Colors.black),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Text(
//                                           DateFormat('dd MMM')
//                                               .format(singleSunday)
//                                               .toString(),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
