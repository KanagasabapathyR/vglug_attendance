import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/view/admin/classes.dart';
import 'package:vglug_attendance/view/admin/home_page.dart';
import 'package:vglug_attendance/view/admin/user_profile.dart';
import 'package:vglug_attendance/view/student/home_page.dart';

class StudentHomeController extends GetxController {
  int currentIndex = 0;

  var currentScreen;
  var currenAppBarText;

  setCurrentScreen() {
    currentScreen = _screens[currentIndex];
    currenAppBarText=_appBarText[currentIndex];
  }

  changeScreen(index) {
    currentIndex = index;
    currentScreen = _screens[currentIndex];
    currenAppBarText=_appBarText[currentIndex];
    update();
  }

  final _screens = [
    StudentHome(),
    // UserProfile(FirebaseAuth.instance.currentUser?.phoneNumber)
  ];

  final _appBarText=[
    "Home",
    // "Profile"

  ];

  // handeBack(currentIndex) {
  //   switch (currentIndex) {
  //     case 0:
  //       changeScreen(0);
  //       break;
  //     case 1:
  //       changeScreen(1);
  //       break;
  //     case 2:
  //       changeScreen(2);
  //       break;
  //     case 3:
  //       changeScreen(3);
  //       break;
  //     case 4:
  //       changeScreen(4);
  //       break;
  //     default:
  //       changeScreen(0);
  //   }
  // }
}
