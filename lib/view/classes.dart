import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/model/attendance_model.dart';
import 'package:vglug_attendance/model/class_model.dart';
import 'package:vglug_attendance/view/single_class.dart';

class Classes extends StatelessWidget {
  const Classes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('vglug')
                        .doc('classes')
                        .collection("2023")
                        .get(),
                    builder: (context, snapshot) {
                      var classes = snapshot.data?.docs
                          .map((doc) => ClassModel.fromSnapshot(doc))
                          .toList();
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }else if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: classes?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(classes![index].className ?? ''),
                                onTap: (){
                                  Get.to(()=>SingleClass( classId:classes?[index].classId,className: classes?[index].className,));
                                },
                              ),
                            );
                          },
                        );

                      }else{
                        return Center(child: Text(snapshot.error.toString()),);
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
