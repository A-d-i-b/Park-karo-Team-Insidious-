import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Textfield extends StatelessWidget {
  final controller;
  final String hint;
  String? Function(String?)? function;
  Textfield({super.key,required this.controller,required this.hint,this.function});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:function,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  width: 3,color: Color(0xffd4a6fb)
              )
          ) ,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  width: 3,color: Color(0xff8843b7)
              )
          ),
        errorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                width: 3,color: Colors.red
            )
        ),
      ),
    );
  }
}
