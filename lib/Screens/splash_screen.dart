import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit/Screens/home.dart';
import 'package:parkit/Screens/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 5),
          () {
            User? user = FirebaseAuth.instance.currentUser;
            if(user!=null){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            }else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupScreen(),
                ),
              );
            }

      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff210033),
      body: Center(
          child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Image.asset("images/logo2.png"))),
    );
  }
}