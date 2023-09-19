import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerCard extends StatelessWidget {
  DrawerCard({super.key,required this.name});
  String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff8843b7),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(name,style: const TextStyle(fontSize: 15),),
          ),
        ),
      ),
    );
  }
}
