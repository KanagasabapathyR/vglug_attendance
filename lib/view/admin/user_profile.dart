import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/class_model.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';

class UserProfile extends StatefulWidget {
  UserProfile(this.userId);
  String? userId;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  RxList<ClassModel> classes = RxList<ClassModel>();

  RxString? classId = ''.obs;

  Future getClasses(phoneNumber) async {
    List userClasses = [];
    print(phoneNumber);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(phoneNumber)
        .get()
        .then((value) async {
      print(value.data()?['class']);
      UserModel? user = UserModel.fromSnapshot(value);
      print(user.classes?.length);
      userClasses = user.classes ?? [];
    });
    for (var c in userClasses) {
      try {
        await FirebaseFirestore.instance
            .collection('classes')
            .doc(c)
            .get()
            .then((data) {
          ClassModel classs = ClassModel.fromSnapshot(data);
          classes.add(classs);
        });
      } catch (e) {
        print(e);
      }
    }
    for (var x in classes) {
      print('className ${x.className}');
    }
    if (classes.isNotEmpty) {
      classId?.value = classes[0].classId!;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClasses(widget.userId);
    print('classes length ${classes.length}');
  }

  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController = Get.find();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot?>(
              future: attendanceController.getUser(id: widget.userId),
              builder: (context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
                if (snapshot.hasData) {
                  UserModel? user = UserModel.fromSnapshot(snapshot.data!);

                  if (user.userType == "student") {
                    return Container(
                      child: Column(
                        children: [
                          RowWidget(
                            field: "Name",
                            value: user.userName,
                          ),
                          RowWidget(
                            field: "Phone Number",
                            value: user.phoneNumber,
                          ),
                          RowWidget(
                            field: "Course",
                            value: user.collegeCourse,
                          ),
                          RowWidget(
                            field: "Branch",
                            value: user.collegeCourseBranch,
                          ),
                          RowWidget(
                            field: "Current year",
                            value: user.courseCurrentYear,
                          ),
                          RowWidget(
                            field: "College",
                            value: user.college,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text(user.userId ?? '');
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting)
                  return kLoading;
                return Text(snapshot.error.toString());
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Class'),
                  )),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: classes.length,
                        itemBuilder: (context, index) {
                          print(classes[index].className);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.black26),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // height: 50,
                              // width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      classes[index].className ?? "",
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  const RowWidget({
    super.key,
    this.field,
    this.value,
  });
  final field;
  final value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text(field)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              // height: 50,
              // width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      value ?? "",
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
