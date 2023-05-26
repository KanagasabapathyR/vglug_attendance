import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';

class AlreadyAdded extends StatelessWidget {
   AlreadyAdded({this.classId,this.attendance,this.atList});
var classId;
   AttendanceModel? attendance;
   List<AttendanceList>? atList;



   @override
  Widget build(BuildContext context) {
     AttendanceController attendanceController=Get.find();
     return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('Already added you can update now'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Staff Name"),
                    Text(attendance?.staffName ?? ''),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Text(DateFormat('dd-MMM-yyyy')
              //     .format(attendance.timestamp!.toDate())),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Text("Students Name")),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text("Attendance")),
                        Expanded(child: Text("Checkin")),
                        Expanded(child: Text("Checkout")),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: atList?.length,
                  itemBuilder: (context, index) {
                    // String? checkin=DateFormat('hh:mm').format(atList?[index].checkin);
                    // DateTime? checkout=atList?[index].checkout;


                    TimeOfDay checkout = attendanceController.getTimeOfDayFromString(
                        atList![index].checkout!.value);

                    return Obx(
                          () => Row(
                          // mainAxisAlignment:
                          // MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: Text(
                                    atList?[index].name! ?? '')),
                            Expanded(
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: atList?[index]
                                          .isPresent
                                          ?.value,
                                      onChanged: (value) {
                                        atList?[index]
                                            .isPresent
                                            ?.value = value!;
                                        print(atList?[index]
                                            .isPresent);
                                      }),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  Obx(
                                        ()
                                    {
                                      Rx<TimeOfDay> checkin = Rx(attendanceController.getTimeOfDayFromString(
                                          atList![index].checkin!.value));
                                      return GestureDetector(
                                        onTap: () async {
                                          var time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(
                                                  hour: checkin.value.hour,
                                                  minute: checkin.value.minute));
                                          if(time!=null){
                                            atList?[index].checkin?.value=time.format(context);
                                            print(atList?[index].checkin?.value);
                                          }

                                          print(time?.format(context));
                                        },
                                        child: Container(
                                          height: 35,
                                           // width: 63,
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.grey[300],
                                          child: Text(

                                            "${checkin!.value.hour} : ${checkin!.value.minute}",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Obx(
                                        ()
                                        {
                                          Rx<TimeOfDay> checkout = Rx(attendanceController.getTimeOfDayFromString(
                                              atList![index].checkout!.value));
                                          return GestureDetector(
                                    onTap: () async {
                                      var time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: checkout.value.hour,
                                              minute: checkout.value.minute));

                                      if(time!=null){
                                        atList?[index].checkout?.value=time.format(context);
                                        print(atList?[index].checkout?.value);
                                      }

                                      print(time?.format(context));
                                    },
                                    child: Container(
                                      height: 35,
                                      // width: 63,
                                      padding: EdgeInsets.all(8.0),
                                      color: Colors.grey[300],
                                      child: Text(
                                        "${checkout!.value.hour} : ${checkout!.value.minute}",
                                        textAlign: TextAlign.right,

                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    attendanceController.updateAttendance(classId: classId,atList: atList,attendance: attendance);
                  },
                  child: Text("Submit")),
            ],
          ),
        ));
  }
}
