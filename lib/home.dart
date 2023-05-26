import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/home_controller.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    HomeController homeController=Get.find();
    homeController.setCurrentScreen();
    return GetBuilder<HomeController>(builder: (controller) {
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
              ListTile(title: Text('Home'),onTap: (){
                controller.changeScreen(0);
                Get.back();
              },),
              ListTile(title: Text('Classes'),onTap: (){
                controller.changeScreen(1);
                Get.back();
              },)
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(controller.currenAppBarText),
        ),
        body: controller.currentScreen,
      );
    });
  }
}
