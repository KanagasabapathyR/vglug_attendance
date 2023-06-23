import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/attendance_controller.dart';
import 'package:vglug_attendance/model/attendance_model.dart';

class Charts extends StatefulWidget {
   Charts({this.classId});

   String? classId;

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  List<double> chartData = [];

  int? touchedIndex;

   List<BarChartGroupData> getBarGroups() {
     List<BarChartGroupData> barGroups = [];
     for (int i = 0; i < chartData.length; i++) {
       barGroups.add(
         BarChartGroupData(
           x: i+1,
           barsSpace: 19,
           barRods: [
             BarChartRodData(

               color: Colors.blue,
               width: 16,
               borderRadius: BorderRadius.circular(8),
               backDrawRodData: BackgroundBarChartRodData(
                 // show: true,
                 fromY: chartData.reduce((a, b) => a + b) / chartData.length,
                 // color: Colors.grey,

               ),
               toY: chartData[i],

             ),
           ],
         ),
       );
     }
     return barGroups;
   }

  @override
  Widget build(BuildContext context) {
  AttendanceController attendanceController=Get.find();
   return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: attendanceController.getAllAttendance(classId: widget.classId,year: '2023'),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if(snapshot.hasData){
               List<AttendanceModel>? attendance = snapshot.data?.docs.map((doc) => AttendanceModel.fromSnapshot(doc)).toList();
               for(AttendanceModel atten in attendance!){
                 chartData.add(atten.present!.toDouble());

               }
              }

              return Container(
                height: MediaQuery.of(context).size.height/3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(
                        show: false,
                      ),

                      barGroups: getBarGroups(),
                      minY: 0,
                      maxY: 50,
                      titlesData: FlTitlesData(
                        topTitles:  AxisTitles(axisNameWidget: Text('Week'),),
                        rightTitles: AxisTitles(axisNameWidget: Text('Students(Present)'),),
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
      ),
    );
  }
}
