import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  CustomTextFormFieldWidget({super.key,
        required this.hint,
        required this.controller,
        required this.validation,
        required this.keyBoard,this.maxLines,
        this.onChanged,
  });
  final String hint;
  final String? Function(String?)? validation;
  final TextEditingController? controller;
  final TextInputType? keyBoard;
  int? maxLines=null;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      maxLines: maxLines??1,
      keyboardType: keyBoard,
      controller: controller,
      validator: validation,
      onChanged: onChanged,
      decoration: InputDecoration(
        // errorStyle: TextStyle(color: const Color(0xffffffff),
        //),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 16),
        // fillColor: const Color(0xffF2F2F7),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: const Color(0x4c3c3c43),
        ),
      ),
      style: TextStyle(
        fontSize: 20,
        height: 0.5,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }
}
