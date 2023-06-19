// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vglug_attendance/controller/attendance_controller.dart';
// import 'package:vglug_attendance/controller/auth_controller.dart';
// import 'package:vglug_attendance/controller/common_controller.dart';
// import 'package:vglug_attendance/model/class_model.dart';
// import 'package:vglug_attendance/utils/constants.dart';
// import 'package:vglug_attendance/view/student.dart';
//
// class StudentDetail extends StatelessWidget {
//   StudentDetail({this.phoneNumber});
//   String? phoneNumber;
//   RxString? selectedYear = 'Select'.obs;
//   RxString? selectedClassId = ''.obs;
//   Rxn<Future?> getClasses = Rxn();
//
//   List<ClassModel> classList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     AttendanceController attendanceController = Get.find();
//     AuthController authController=Get.find();
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Which year you are studying'),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       child: DropdownButtonFormField(
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide(width: 1))),
//                           value: selectedYear?.value,
//                           items:
//                               ['Select','2023', '2024', '2025', '2026', '2027', '2028']
//                                   .map(
//                                     (e) => DropdownMenuItem(
//                                       child: Text(e),
//                                       value: e,
//                                     ),
//                                   )
//                                   .toList(),
//                           onChanged: (value) {
//                             print(value);
//                             selectedYear?.value = value!;
//                             getClasses.value = attendanceController.getClasses(
//                                 selectedYear: selectedYear?.value);
//                             selectedClassId?.value='';
//                             print(selectedClassId?.value);
//                           }),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     Text('Which class you are studying'),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       child: Obx(
//                         () => FutureBuilder(
//                             future: getClasses.value,
//                             builder: (context, AsyncSnapshot snapshot) {
//                               if (snapshot.hasData) {
//                                 classList = List.from(snapshot.data.docs.map(
//                                     (doc) => ClassModel.fromSnapshot(doc)));
//                                 if(classList.isNotEmpty)
//                                   selectedClassId?.value=classList[0].classId!;
//                               }
//                               print(classList.length);
//
//                               return DropdownButtonFormField(
//                                   decoration: InputDecoration(
//                                       border: OutlineInputBorder(
//                                           borderSide: BorderSide(width: 1))),
//                                   value: classList.isNotEmpty
//                                       ? classList[0].className
//                                       : '',
//                                   items: classList
//                                       .map(
//                                         (e) => DropdownMenuItem(
//                                           child: Text(e.className!),
//                                           value: e.className!,
//                                           onTap: () {
//                                             selectedClassId?.value = e.classId!;
//                                           },
//                                         ),
//                                       )
//                                       .toList(),
//                                   onChanged: (String? value) {});
//                             }),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     ElevatedButton(
//                         onPressed: () {
//                           if (selectedClassId != '' && selectedYear!='Select') {
//
//                             // authController.box.write('classId',selectedClassId?.value);
//                             // authController.box.write('year',selectedYear?.value);
//                             attendanceController.addRole(phoneNumber: phoneNumber,role: 'student',year:selectedYear?.value,classId:  selectedClassId?.value);
//                             Get.offAll(() => Student(
//
//                                 ));
//
//                           } else {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: Text('Please select your class'),
//                                   actions: [
//                                     TextButton(
//                                         onPressed: () {
//                                           Get.back();
//                                         },
//                                         child: Text('Ok')),
//                                   ],
//                                 );
//                               },
//                             );
//                           }
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GetBuilder(
//                                 builder: (CommonController controller) =>
//                                     controller.isLoading
//                                         ? CircularProgressIndicator()
//                                         : Text(
//                                             'Submit',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400,
//                                               // color: const Color(0xffffffff),
//                                             ),
//                                           )),
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
