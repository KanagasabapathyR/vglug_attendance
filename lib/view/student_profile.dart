
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/model/student_model.dart';
import 'package:vglug_attendance/view/admin/user_profile.dart';

class StudentProfile extends StatelessWidget {
   StudentProfile(this.student);

  StudentModel student;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              child: ListTile(
                title: Text("See Personal Details"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  Get.to(()=>UserProfile(student.studentId!));
                },
              ),
            ),
            Container(child: Card(
              child: Column(
                children: [
                  Row(children: [
                    Text('Name:     ') ,
                    Text(student.name?? ''),


                  ],),
                  Row(
                    children: [
                      Text('Id:       ')  ,
                      Text(student.studentId?? ''),
                    ],
                  )
                ],
              ),
            ),)
          ],
        )
      ),
    );
  }
}
