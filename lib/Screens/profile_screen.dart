import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name='';
  String email='';
  String number='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameFetch();
  }
  void nameFetch()async{
    await FirebaseFirestore.instance.collection('users').doc("${FirebaseAuth.instance.currentUser?.phoneNumber}").get().then((value) {
      setState(() {
        name=value.get('name')??"";
        email=value.get('email')??"";
        number ="${FirebaseAuth.instance.currentUser?.phoneNumber}";
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(child: Text("Profile",style: TextStyle(fontSize: 20,color: Color(0xff8843b7),fontWeight: FontWeight.bold),)),
                Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle_outlined,size: 100,color: Color(0xff8843b7),),
                        SizedBox(height: 20),
                        Text("$name",style: TextStyle(fontSize: 30,color: Colors.black),),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 40,right: 40),
                  child: Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 25),
                Text("EMAIL",style: TextStyle(fontSize: 20,color: Color(0xff8843b7)),),
                SizedBox(height: 5),
                Text(email,style: TextStyle(fontSize: 20,color: Colors.black),),
                SizedBox(height: 30),
                Text("Number",style: TextStyle(fontSize: 20,color: Color(0xff8843b7)),),
                SizedBox(height: 5),
                Text(number,style: TextStyle(fontSize: 20,color: Colors.black),),
                SizedBox(height: 30),
                ElevatedButton(onPressed: () async{
                  await FirebaseAuth.instance.signOut().then((value) {
                    Get.toNamed('/login');
                  });
                }, child: Text("Log Out")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
