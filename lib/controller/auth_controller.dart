import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vglug_attendance/controller/common_controller.dart';
import 'package:vglug_attendance/admin.dart';
import 'package:vglug_attendance/model/user_model.dart';
import 'package:vglug_attendance/utils/constants.dart';
import 'package:vglug_attendance/view/admin/home_page.dart';
import 'package:vglug_attendance/view/auth/login.dart';
import 'package:vglug_attendance/view/auth/otpverify.dart';
import 'package:vglug_attendance/student.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();
  // String? phoneNumber=FirebaseAuth.instance.currentUser?.phoneNumber;

  @override
  void onInit() {
    super.onInit();
    _navigateBasedOnLogin();
  }

  Future<void> _navigateBasedOnLogin() async {
    bool? loggedIn;
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        loggedIn = false;
      } else {
        loggedIn = true;
      }
    });

    await Future.delayed(Duration(seconds: 2));

    if (loggedIn!) {
      UserModel user=await getUser(phoneNumber: FirebaseAuth.instance.currentUser?.phoneNumber);



      print(user.userType);
      if(user.userType=="admin") {
        Get.offAll(() => Admin());
      } else if(user.userType=='student') {
        Get.offAll(()=>Student());
      }else if(user.userType==null){
        // Get.offAll(()=>StudentDetail(phoneNumber: FirebaseAuth.instance.currentUser?.phoneNumber,));
        showDialog(context: Get.context!, builder: (context) {
          return AlertDialog(
           title: Text("User not found.  Please contact Admin"),
            actions: [
              TextButton(child: Text('Ok'), onPressed: (){
                _auth.signOut();
                Get.offAll(Login());
              },),
            ],
          );
        },);
        print('user not found');
    }
    } else {
      Get.offAll(() => Login());
    }
  }

  Future<UserModel> getUser({phoneNumber}) async {
    print('userTable');
    print(phoneNumber);
    try {
      var data = await FirebaseFirestore.instance
          .collection("users")
          .doc(phoneNumber)
          .get();
      if(data.exists) {

        UserModel user=UserModel.fromSnapshot(data);
        return user;
      }else{
        return UserModel();
      }

    } catch (e) {
      return UserModel();
    }
  }



  Future<void> verifyPhoneNumber(String phoneNumber) async {
    CommonController commonController = Get.find();
    commonController.setLoadValue(true);
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) {
        commonController.setLoadValue(false);
        commonController.showToast(message: "OTP sent to your mobile number");
      },
      verificationFailed: (FirebaseAuthException e) {
        commonController.setLoadValue(false);
        commonController.showToast(message: e.message.toString());
        print(e);
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Verification code sent to $phoneNumber');
        commonController.setLoadValue(false);
        Get.to(() => OtpVerify(), arguments: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timed out
        commonController.setLoadValue(false);
      },
    );
  }

  Future<void> signInWithPhoneAuthCredential(
      PhoneAuthCredential credential) async {
    commonController.setLoadValue(true);

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      // Sign-in success, navigate to home screen
      if (userCredential.user != null) {

        commonController.setLoadValue(false);
        User? fuser = userCredential.user;
        UserModel user=await getUser(phoneNumber: fuser?.phoneNumber);
        print(user.userType);
        if(user.userType=="admin") {
          Get.offAll(() => Admin());
        } else if(user.userType=='student') {
          Get.offAll(()=>Student());
        }else if(user.userType==null){
          // Get.offAll(()=>StudentDetail(phoneNumber: user?.phoneNumber,));
          showDialog(context: Get.context!, builder: (context) {
            return AlertDialog(
              title: Text("User not found.  Please contact Admin"),
              actions: [
                TextButton(child: Text('Ok'), onPressed: (){
                  _auth.signOut();
                  // Get.back();
                  Get.offAll(Login());

                },),
              ],
            );
          },);
          print('user is not found');
        }

        print(fuser?.phoneNumber);
      }
    } on FirebaseAuthException catch (e) {
      commonController.setLoadValue(false);
      commonController.setLoadValue(false);
      commonController.showToast(message: e.message.toString());
      if (e.code == 'invalid-verification-code') {
        print('The verification code entered is not valid');
      }
      // Handle other errors here
    } catch (e) {
      commonController.setLoadValue(false);
    }
  }

  Future<void> verifyOTP(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    signInWithPhoneAuthCredential(credential);
  }

  signOut() async {
    commonController.setLoadValue(true);
    await _auth.signOut();
    FirebaseAuth.instance.currentUser?.reload();
    _navigateBasedOnLogin();
    commonController.setLoadValue(false);


  }
}
