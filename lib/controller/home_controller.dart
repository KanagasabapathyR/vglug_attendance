import 'package:get/get.dart';
import 'package:vglug_attendance/view/classes.dart';
import 'package:vglug_attendance/view/home_page.dart';

class HomeController extends GetxController {
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
    Home(),
    Classes(),
  ];

  final _appBarText=[
    "Home",
    "CLasses"

  ];

  handeBack(currentIndex) {
    switch (currentIndex) {
      case 0:
        changeScreen(0);
        break;
      case 1:
        changeScreen(1);
        break;
      case 2:
        changeScreen(2);
        break;
      case 3:
        changeScreen(3);
        break;
      case 4:
        changeScreen(4);
        break;
      default:
        changeScreen(0);
    }
  }
}
