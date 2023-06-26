import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/class_model.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:vglug_attendance/view/widgets/attendance_table.dart';


class StudentHome extends StatefulWidget {
   StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String? phoneNumber=FirebaseAuth.instance.currentUser?.phoneNumber;
  RxList<ClassModel> classes=RxList<ClassModel>();
  RxString? classId=''.obs;



  Future getClasses(phoneNumber) async {
     List userClasses=[];

     await FirebaseFirestore.instance.collection('users').doc(phoneNumber).get().then((value) async {
      UserModel? user = UserModel.fromSnapshot(value);
      print(user.classes?.length);
      userClasses = user.classes ?? [];
    });
    for(var c in userClasses){
      try{
        await FirebaseFirestore.instance
            .collection('classes')
            .doc(c)
            .get()
            .then((data) {
          ClassModel classs = ClassModel.fromSnapshot(data);
          classes.add(classs);
        });

      }catch(e){
        print(e);
      }
    }
    for(var x in classes){
      print('className ${x.className}');
    }
     classId?.value=classes.first.classId!;
  }



  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getClasses(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
     AttendanceController attendanceController=Get.find();
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your class'),
                SizedBox(height: 10,),

                Obx(() => classes.length==1? Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(classes.first.className!,textAlign: TextAlign.start,),
                      ),
                    ],
                  ),):DropdownButtonFormField(
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    borderRadius:  BorderRadius.circular(10),

                    value: classes.isNotEmpty? classes[0].className:null,
                    items: classes.isNotEmpty? classes
                        .map(
                          (e) => DropdownMenuItem(
                        child: Text(e.className ?? ""),
                        value: e.className,
                        onTap: () {
                          print(e.classId);
                          classId?.value=e.classId!;
                          print(classId?.value);
                        },
                      ),
                    ).toList():null,
                    onChanged: (value) {
                      print(classId?.value);
                    })),
                 SizedBox(height: 10,),
                 Text("Attendance"),
                SizedBox(height: 10,),
                Obx(()=> AttendanceTable(attendanceController: attendanceController, classId: classId?.value, studentId: phoneNumber))

              ],
            ),
          ),
        ),
      ),
    );
  }
}
