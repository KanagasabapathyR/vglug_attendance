import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/utils/constants.dart';

import '../model/user_model.dart';

class UserSearchDelegate extends SearchDelegate {
  final List<UserModel>? items;

  UserSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<UserModel> suggestions = query.isEmpty
        ? []
        : items!.where((item) {
            return item.userId!.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      shrinkWrap: true,
      primary: true,
      physics: BouncingScrollPhysics(),
      itemCount: suggestions?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              print(commonController.selectedStudents.contains(suggestions?[index]) );
              if(commonController.selectedStudents.contains(suggestions?[index])  ){
                print('remove');
                commonController.selectedStudents.remove(suggestions?[index]);

              }else{
                print('add');
                commonController.selectedStudents.add(suggestions![index]);

              }
              print(commonController.selectedStudents.length);


            },
            child:  Card(

                  child: Obx(
                      ()=> ListTile(
                title: Text(suggestions?[index].userName ?? ""),
                      trailing: commonController.selectedStudents.contains(suggestions?[index])?
                      Icon(Icons.check)
                          :null,

              ),
                  )),
            );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<UserModel> suggestions = query.isEmpty
        ? []
        : items!.where((item) {
            return item.userId!.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      shrinkWrap: true,
      primary: true,
      physics: BouncingScrollPhysics(),
      itemCount: suggestions?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print(commonController.selectedStudents.contains(suggestions?[index]) );
            if(commonController.selectedStudents.contains(suggestions?[index])  ){
              print('remove');
              commonController.selectedStudents.remove(suggestions?[index]);

            }else{
              print('add');
              commonController.selectedStudents.add(suggestions![index]);

            }
            print(commonController.selectedStudents.length);


          },
          child: Card(
            child: Obx(
                ()=> ListTile(
                title: Text(suggestions?[index].userName ?? ""),
                trailing: commonController.selectedStudents.contains(suggestions?[index])?
                Icon(Icons.check)
                    :null,
              ),
            ),
          ),
        );
      },
    );
  }
}
