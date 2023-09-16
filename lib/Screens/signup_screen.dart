import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:parkit/utils/textfield_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey=GlobalKey<FormState>();

  final DetailsController detailsController=Get.put(DetailsController());

  int load=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 30,right: 30),
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Welcome to ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    ),
                    Center(
                      child: Text("ParkIt",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xff8843b7)),),
                    ),
                  ],
                ),
                SizedBox(
                    height:200,
                    child: Image.asset('images/logo2.png')),
                // SizedBox(height: 50),
                Form(
                    key: formkey,
                    child:Column(
                      children: [
                        Textfield(controller: detailsController.emailcontroller, hint: "Email",function: (value){
                          if(value!.isEmpty||!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                            return "Enter Correct Email Address";
                          }else{
                            return null;
                          }
                        },),
                        SizedBox(height: 30),
                        Textfield(controller: detailsController.namecontroller, hint: "Name"),
                        SizedBox(height: 30),
                        Textfield(controller: detailsController.phonecontroller, hint: "Phone Number",function: (value){
                          if(value!.isEmpty||!RegExp(r"^(\+\d{1,3}[- ]?)?\d{10}$").hasMatch(value)){
                            return "Enter Correct Phone number";
                          }else{
                            return null;
                          }
                        },),
                        SizedBox(height: 50),
                      ],
                    ) ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:
                  ElevatedButton(onPressed: () async{
                    if(formkey.currentState!.validate()){
                      try{
                        await FirebaseFirestore.instance.collection("users").doc(detailsController.phonecontroller.text).get().then((value) {
                          if(value.get("reg")==true){
                            final materialBanner = MaterialBanner(
                              /// need to set following properties for best effect of awesome_snackbar_content
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              forceActionsBelow: true,
                              content: AwesomeSnackbarContent(
                                title: 'Oh Hey!!',
                                message:
                                'You alread have a account',
                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                contentType: ContentType.warning,
                                // to configure for material banner
                                inMaterialBanner: true,
                              ),
                              actions: const [SizedBox.shrink()],
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentMaterialBanner()
                              ..showMaterialBanner(materialBanner);
                          }
                        });
                      }catch(e){
                        setState(() {
                          load =2;
                        });
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: '+91${detailsController.phonecontroller.text}',
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            print(e);
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            detailsController.otp.value=verificationId;
                            setState(() {
                              load=1;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(page: 1,)));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      }
                    }

                  },style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xff8843b7) ,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),)
                  ),
                    child: load==1?const Text("Sign Up",style: TextStyle(fontSize: 20),):const CircularProgressIndicator(
                      color: Colors.white,
                    ),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already having account ?",style: TextStyle(fontSize: 13),),
                    TextButton(onPressed: (){
                      Get.toNamed('/login');
                    }, child: Text("Login",style: TextStyle(color: Color(0xff8843b7)),)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
