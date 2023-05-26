import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/model/student_model.dart';
import 'package:vglug_attendance/view/already_added.dart';
import 'package:vglug_attendance/view/new_add.dart';

class Attendance extends StatelessWidget {
  Attendance({this.classId});
  var classId;
  Rx<DateTime>? selectedDate = DateTime.now().obs;
  AttendanceModel? attendance;
  List<AttendanceList>? atList;



  CalendarFormat format = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Obx(
              () => Container(
                child: TableCalendar(
                  calendarFormat: format,

                  focusedDay: selectedDate!.value,
                  firstDay: DateTime(2023),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  onDaySelected: (selectedDay, focusedDay) {
                    selectedDate!.value = selectedDay;
                    print(selectedDate!.value);
                  },

                  // daysOfWeekVisible: false,
                  currentDay: selectedDate?.value,
                  // calendarBuilders: CalendarBuilders(
                  //   // Customize the day cell
                  //   dowBuilder: (context,date) {
                  //     if (date.weekday == DateTime.sunday) {
                  //       // Show only Sundays
                  //       return Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.yellow, // Customize the color
                  //           shape: BoxShape.circle,
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             '${date.day}',
                  //             style: TextStyle(
                  //               color: Colors.black, // Customize the text color
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       return Container();
                  //     }
                  //   },
                  //   prioritizedBuilder:  (context,day,date) {
                  //     if (day.weekday == DateTime.sunday) {
                  //       // Show only Sundays
                  //       return Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.yellow, // Customize the color
                  //           shape: BoxShape.circle,
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             '${date.day}',
                  //             style: TextStyle(
                  //               color: Colors.black, // Customize the text color
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       return Container();
                  //     }
                  //   },
                  // ),
                ),
              ),
            ),
            Obx(
              () => FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('vglug')
                      .doc('attendance')
                      .collection(classId)
                      .doc(DateFormat('dd-MMM-yyy')
                          .format(selectedDate!.value)
                          .toString())
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData && snapshot.data!.exists) {
                      attendance = AttendanceModel.fromSnapshot(snapshot.data!);

                      atList = attendance?.attendance
                          ?.map((e) => AttendanceList.fromJson(e))
                          .toList();
                      return AlreadyAdded(classId: classId,attendance: attendance,atList: atList,);
                    } else {
                      return NewAdd(classId: classId,selectedDate: selectedDate,);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
