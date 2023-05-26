import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vglug_attendance/model/student_model.dart';

class Students extends StatelessWidget {
Students({this.classId});
var classId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('vglug').doc('students').collection(classId).get(),
          builder: (context, snapshot) {
          var students=snapshot.data?.docs.map((doc) => StudentModel.fromSnapshot(doc)).toList();

            return ListView.builder(
              itemCount: students?.length,
              itemBuilder: (context, index) {
              return ListTile(title: Text(students![index].name??''));
            },);
          }
        ),
      ),
    );
  }
}
