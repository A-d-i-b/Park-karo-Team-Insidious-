import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(
        child: ElevatedButton(onPressed: ()async{
          await FirebaseAuth.instance.signOut().then((value) {
            Get.toNamed('/login');
          });
        }, child: Text("SignOut")),
      ),
    );
  }
}
