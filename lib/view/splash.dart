import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vglug_attendance/controller/auth_controller.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AuthController authController=AuthController();
  final box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(
    //   const Duration(seconds: 2),
    //       () {
    //         Get.offAll(() => authController.isLoggedIn ? RoleSelection() : Login());
    //   },
    // );

  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(size.width);
    print(size.height);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/Vglug Logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
