import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/model/class_model.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';


class StudentHome extends StatefulWidget {
   StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String? phoneNumber=FirebaseAuth.instance.currentUser?.phoneNumber;
  RxList<ClassModel> classes=RxList<ClassModel>();

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
  }


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getClasses(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your classes'),
              SizedBox(height: 10,),
              Obx(
              ()=> DropdownButtonFormField(
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    borderRadius:  BorderRadius.circular(10),
                    
                    value: classes.isNotEmpty? classes[0].className:null,
                    items: classes.isNotEmpty? classes
                        .map(
                          (e) => DropdownMenuItem(
                        child: Text(e.className ?? ""),
                        value: e.className,
                            onTap: () {
                              print(e.className);
                            },
                      ),
                    ).toList():null,
                    onChanged: (value) {

                    }),
              ),

             // FutureBuilder(
             //      future: FirebaseFirestore.instance.collection('users').doc(phoneNumber).get(),
             //      builder: (context, snapshot) {
             //        if(snapshot.connectionState==ConnectionState.waiting)
             //          return kLoading;
             //        else if(snapshot.hasData){
             //          UserModel? user = UserModel.fromSnapshot(snapshot.data);
             //          print(user.classes?.length);
             //          List userClasses = user.classes ?? [];
             //
             //          getClasses(userClasses);
             //
             //          Future.delayed(Duration(seconds: 1));
             //
             //          return FutureBuilder(
             //            future: FirebaseFirestore.instance.collection('classes').doc(c).get(),
             //            builder: (context, snapshot) {
             //              return Container(
             //                child: Text(classes[0].className ?? ""),
             //
             //                // DropdownButtonFormField(
             //                //     value: '',
             //                //     items: classes
             //                //         .map(
             //                //           (e) => DropdownMenuItem(
             //                //         child: Text(e.className ?? ""),
             //                //         value: e,
             //                //             onTap: () {
             //                //               print(e.className);
             //                //             },
             //                //       ),
             //                //     ).toList(),
             //                //     onChanged: (value) {
             //                //
             //                //     }),
             //              );
             //            }
             //          );
             //        }
             //        else{
             //          return Text(snapshot.error.toString());
             //        }
             //
             //
             //      }
             //    ),

            ],
          ),
        ),
      ),
    );
  }
}
