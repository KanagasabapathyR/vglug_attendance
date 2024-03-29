import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vglug_attendance/controller/admin_home_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
class AttendanceController extends GetxController {
  Rxn<Future?> getAttendanceFuture = Rxn();
  Rxn<Future?> getClass = Rxn();

  //Firebase-methods
  updateAttendance({String? classId, atList, attendance, year}) async {
    commonController.setLoadValue(true);
    var list = [];
    int? present = 0;
    int? absent = 0;
    for (AttendanceList atten in atList!) {
      list.add(AttendanceList(
              studentId: atten.studentId,
              isPresent: atten.isPresent,
              checkout: atten.checkout,
              checkin: atten.checkin,
              name: atten.name)
          .toJson());
      if (atten.isPresent == true) {
        present = present! + 1;
      } else {
        absent = absent! + 1;
      }
    }
    await FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('attendance')
        .doc(DateFormat('dd-MMM-yyy').format(attendance!.timestamp!.toDate()))
        .update({
      'timestamp': attendance!.timestamp!,
      'last_update': Timestamp.now(),
      'attendance': list,
      'present': present,
      'absent': absent,
    }).whenComplete(() {
      commonController.showToast(message: "Updated");
    });

    getAttendanceFuture.value = getAttendance(
        classId: classId,
        selectedDate: attendance!.timestamp!.toDate(),
        year: '2023');

    commonController.setLoadValue(false);
  }

  addAttendance({classId, attendanceList, staffName, date, year}) async {
    commonController.setLoadValue(true);

    var list = [];
    int? present = 0;
    int? absent = 0;

    for (AttendanceList atten in attendanceList) {
      list.add(AttendanceList(
              studentId: atten.studentId,
              isPresent: atten.isPresent,
              checkout: atten.checkout,
              checkin: atten.checkin,
              name: atten.name)
          .toJson());
      if (atten.isPresent == true) {
        present = present! + 1;
      } else {
        absent = absent! + 1;
      }
    }
    await FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('attendance')
        .doc(DateFormat('dd-MMM-yyy').format(date))
      ..set({
        'staff_name': staffName,
        'timestamp': Timestamp.fromDate(date),
        'last_update': Timestamp.now(),
        'attendance': list,
        'present': present,
        'absent': absent,
      }).whenComplete(() {
        commonController.showToast(message: "Attendance added");
      });

    commonController.setLoadValue(false);
  }

  Future<QuerySnapshot> getClassStudents(classId, year) async {
    return await FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('students')
        .get();
  }

  addStudents({students, classId}) async {
    commonController.setLoadValue(true);
    for (var student in students!) {
      print('add stu');
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .collection('students')
          .doc(student.userId)
          .set({
        'student_id': student.userId,
        'student_name': student.userName,
      });
    }
    for (UserModel stu in students) {
      print('update user');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(stu.userId)
          .get()
          .then((data) async {
        UserModel user = UserModel.fromSnapshot(data);
        List userClasses = user.classes ?? [];
        if (!userClasses.contains(classId)) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(stu.userId)
              .update({
            'class': [classId, ...userClasses]
          });
        }



      });
    }
    commonController.setLoadValue(false);
    commonController.showToast(message: 'Students Added');
    Get.back();


  }


  Future<void> addDataFromCSVToFirestore() async {
    final csvData=await rootBundle.loadString('assets/cybersecurity1.csv');
    // String csvData = await File('assets/cybersecurity.csv').readAsString();
    List<List<dynamic>> csvTable =  CsvToListConverter().convert(csvData);
    List<List<dynamic>> data=[];
    data=csvTable;
    print(data.length);
    for(int i=0;i<data.length;i++) {
      // print(data[i]);
     var user= UserModel(
          userName: csvTable[i][1],
          college: csvTable[i][2],
          courseCurrentYear: csvTable[i][3],
          collegeCourse: csvTable[i][4],
          collegeCourseBranch: csvTable[i][5],
          phoneNumber: "+91${csvTable[i][6]}",

          userId: "+91${csvTable[i][6]}",
          userType: 'student'
      ).toJson();

      await FirebaseFirestore.instance.collection('users').doc("+91${csvTable[i][6]}").set(user);

      print(user);

    }
  }



  // updateUser({classId, selectedStudents}) async {
  //
  //   for (UserModel stu in selectedStudents) {
  //     print('update user');
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(stu.userId)
  //         .get()
  //         .then((data) async {
  //       UserModel user = UserModel.fromSnapshot(data);
  //
  //       // print(user.classes?.length);
  //
  //       List userClasses = user.classes ?? [];
  //
  //       if (!userClasses.contains(classId)) {
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(stu.userId)
  //             .update({
  //           'class': [classId, ...userClasses]
  //         });
  //       }
  //
  //       commonController.setLoadValue(false);
  //       commonController.showToast(message: 'Students Added');
  //
  //
  //     });
  //   }
  // }

  // Future<DocumentSnapshot> getSingleStudent({classId, year, phoneNumber}) async {
  //   print(classId);
  //   print(year);
  //   print(phoneNumber);
  //   return await FirebaseFirestore.instance
  //
  //       .collection('classes')
  //       .doc(classId)
  //       .collection('students').doc(phoneNumber)
  //       .get();
  // }

  // addRole({phoneNumber,role, classId, year})async{
  //   commonController.setLoadValue(true);
  //   await FirebaseFirestore.instance.collection('roles').doc(phoneNumber).set({
  //     'role':role,
  //     'phone_number':phoneNumber,
  //     'class_id':classId,
  //     'year':year,
  //   }).whenComplete(() => commonController.setLoadValue(false));
  // }

  getAttendance({classId, selectedDate, year}) async {
    print(selectedDate);
    print(classId);
    return await FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('attendance')
        .doc(DateFormat('dd-MMM-yyy').format(selectedDate).toString())
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllAttendance(
      {classId, year}) async {
    return await FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .collection('attendance').orderBy('timestamp')
        .get();
  }

  getClasses({selectedYear}) async {
    return await FirebaseFirestore.instance
        .collection('classes')
        .where('year', isEqualTo: selectedYear)
        .get();
  }

  getClasss(classId)async{
    return await FirebaseFirestore.instance
        .collection('classes').doc(classId).get();
  }

  Future<DocumentSnapshot>? getUser({id}) {
    return FirebaseFirestore.instance.collection("users").doc(id).get();
  }

  Future<QuerySnapshot> getAllUsers() async {
    return await FirebaseFirestore.instance.collection('users').get();
  }

  Future<QuerySnapshot> getAllStudents() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('user_type', isEqualTo: 'student')
        .get();
  }

//flutter-methods
  List<DateTime> getSundays(DateTime startDate, DateTime endDate) {
    final sundays = <DateTime>[];
    DateTime current = startDate;

    while (current.isBefore(endDate)) {
      if (current.weekday == DateTime.sunday) {
        sundays.add(current);
      }
      current = current.add(Duration(days: 1));
    }

    return sundays;
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

  DateTime getNearestSunday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - DateTime.sunday));
  }
}
