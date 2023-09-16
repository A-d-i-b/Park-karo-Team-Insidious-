import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:parkit/Screens/otp_screen.dart';
import 'package:parkit/Screens/signup_screen.dart';
import 'package:parkit/utils/textfield_utils.dart';


class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final DetailsController detailsController=Get.put(DetailsController());
  final key=GlobalKey<FormState>();
  final FirebaseAuth auth= FirebaseAuth.instance;
  int load=1;
  MaterialBanner MatBanner(ContentType type,String message){
    return MaterialBanner(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: 'Oh Hey!!',
        message:
        message,
        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: type,
        // to configure for material banner
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );
  }

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
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: SizedBox(
                      height: 200,
                      child: Image.asset('images/logo2.png')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Welcome Back to ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    ),
                    Center(
                      child: Text("ParkIt",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xff8843b7)),),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Form(
                    key: key,
                    child: Column(
                      children: [
                        Textfield(controller:detailsController.phonecontroller , hint: "Phone Number",function: (value){
                          if(value!.isEmpty||!RegExp(r"^(\+\d{1,3}[- ]?)?\d{10}$").hasMatch(value)){
                            return "Enter Correct Phone Number";
                          }else{

                            return null;
                          }
                        },),
                        SizedBox(height: 20),

                      ],
                    )),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:
                  ElevatedButton(onPressed: () async{
                    setState(() {
                      load=2;
                    });
                    print(detailsController.phonecontroller.text);
                    try{
                      await FirebaseFirestore.instance.collection("users").doc(detailsController.phonecontroller.text).get().then((value) async {
                        if(value.get("reg")==true){
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+91${detailsController.phonecontroller.text}',
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {
                              final materialBanner = MatBanner(ContentType.failure, 'Failed to send Otp Please Check Your Number');

                              ScaffoldMessenger.of(context)
                                ..hideCurrentMaterialBanner()
                                ..showMaterialBanner(materialBanner);
                            },
                            codeSent: (String verificationId, int? resendToken) {
                              detailsController.otp.value =verificationId;
                              setState(() {
                                load=1;
                              });
                              final materialBanner = MatBanner(ContentType.success, 'Otp Sent');

                              ScaffoldMessenger.of(context)
                                ..hideCurrentMaterialBanner()
                                ..showMaterialBanner(materialBanner);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(page: 2,)));
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                        }

                      });
                    }catch(e){
                      print(e);
                      setState(() {
                        load=1;
                      });
                      final materialBanner = MaterialBanner(
                        /// need to set following properties for best effect of awesome_snackbar_content
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        forceActionsBelow: true,
                        content: AwesomeSnackbarContent(
                          title: 'Oh Hey!!',
                          message:
                          'Please make a account',
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
                    // _key.currentState!.validate();
                  },style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xff8843b7) ,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),)
                    ),
                    child: load==1?const Text("Sign In",style: TextStyle(fontSize: 20),):const CircularProgressIndicator(color: Colors.white,),),
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account ?",style: TextStyle(fontSize: 13),),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                  }, child: Text("SignUp",style: TextStyle(color: Color(0xff8843b7)),)),
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
