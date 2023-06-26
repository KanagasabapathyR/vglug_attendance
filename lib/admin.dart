import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/controller/auth_controller.dart';
import 'package:vglug_attendance/controller/admin_home_controller.dart';
import 'package:vglug_attendance/utils/constants.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    AdminHomeController homeController = Get.find();
    homeController.setCurrentScreen();
    AuthController authController = Get.find();
    AttendanceController attendanceController=Get.find();
    return GetBuilder<AdminHomeController>(builder: (controller) {
      return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Text("VGLUG Foundation"),
                  ],
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  controller.changeScreen(0);
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Classes'),
                onTap: () {
                  controller.changeScreen(1);
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Sign Out'),
                onTap: () {
                  Get.back();
                  showDialog(
                      context: context,
                      builder: (context) {


                        if(commonController.isLoading){
                          return kLoading;
                        } else {
                          return AlertDialog(
                          title: Text("Are you sure you want to Sign Out"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("No")),
                            TextButton(
                                onPressed: () {
                                  authController.signOut();
                                },
                                child: Text("Yes"))
                          ],
                        );
                        }
                      });
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(controller.currenAppBarText),
          actions: [
            if (controller.currenAppBarText == 'Classes')
            Container(
              width: 75,
              height: 100,
              child: DropdownButtonFormField(
                value: '2023',
                  items: ['2023', '2024', '2025', '2026', '2027', '2028']
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ),
                      ).toList(),
                  onChanged: (value) {
                  controller.selectedYear?.value=value!;
                  print(controller.selectedYear?.value);
                  attendanceController.getClass.value=attendanceController.getClasses(selectedYear: controller.selectedYear?.value);
                  print(attendanceController.getClass.value);

                  }),
            )
          ],
        ),
        body: controller.currentScreen,
      );
    });
  }
}
