import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/view/attendance_page.dart';
import 'package:vglug_attendance/view/students_page.dart';

class SingleClass extends StatelessWidget {
SingleClass({this.classId,this.className});

var classId;
var className;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(className),),
      body: Container(
        child: Column(
          children: [
            Card(child: ListTile(
              title: Text('Students'),
              onTap: (){
Get.to(()=>Students(classId:classId));
              },
            ),),
            Card(child: ListTile(
              title: Text('Attendance'),
              onTap: (){
                Get.to(()=>Attendance(classId:classId));
              },
            ),)
          ],
        ),
      ),
    );
  }
}
