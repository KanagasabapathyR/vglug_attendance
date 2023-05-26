import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vglug_attendance/model/attendance_model.dart';

class AttendanceController extends GetxController{
  updateAttendance({String? classId, atList, attendance}) async {
    var list = [];
    for (AttendanceList atten in atList!) {
      list.add(AttendanceList(
          studentId: atten.studentId,
          isPresent: atten.isPresent,
          checkout: atten.checkout,
          checkin: atten.checkin,
          name: atten.name)
          .toJson());
    }
    await FirebaseFirestore.instance
        .collection('vglug')
        .doc('attendance')
        .collection(classId!)
        .doc(DateFormat('dd-MMM-yyy').format(attendance!.timestamp!.toDate()))
        .update({
      'timestamp': attendance!.timestamp!,
      'last_update': Timestamp.now(),
      'attendance': list,
    }).then((value) => print('success'));
  }

  TimeOfDay getTimeOfDayFromString(String timeString) {
    // Split the time string into hours, minutes, and period (AM/PM)
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');

    // Extract the hours and minutes
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Determine the period (AM/PM)
    bool isAM = parts[0].toLowerCase() == 'am';

    // Create the TimeOfDay object
    TimeOfDay timeOfDay = TimeOfDay(hour: hours, minute: minutes);

    // Adjust the hours for PM time
    if (!isAM && hours < 12) {
      timeOfDay = timeOfDay.replacing(hour: hours + 12);
    }

    return timeOfDay;
  }

  addAttendance({classId, attendanceList, staffName, date}) async {
    var list = [];
    for (AttendanceList atten in attendanceList) {
      list.add(AttendanceList(
          studentId: atten.studentId,
          isPresent: atten.isPresent,
          checkout: atten.checkout,
          checkin: atten.checkin,
          name: atten.name)
          .toJson());
    }
    await FirebaseFirestore.instance
        .collection('vglug')
        .doc('attendance')
        .collection(classId)
        .doc(DateFormat('dd-MMM-yyy').format(date))
        .set({
      'staff_name': staffName,
      'timestamp': Timestamp.fromDate(date),
      'last_update': Timestamp.now(),
      'attendance': list,
    });
  }

}