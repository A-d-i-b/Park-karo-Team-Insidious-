import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:parkit/Screens/navigation_screen.dart';
import 'package:parkit/Screens/signup_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key,required this.page});
  int page;
  final FirebaseAuth auth= FirebaseAuth.instance;
  final DetailsController detailsController =Get.put(DetailsController());
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
                Center(
                  child: SizedBox(
                      height: 300,
                      child: Image.asset('images/otp.png')),
                ),
                Center(child: Text("Verification",style: TextStyle(fontSize: 30,color: Color(0xff8843b7)),),),
                SizedBox(height: 20),
                Pinput(
                   length: 6,
                   onCompleted: (pin) => print(pin),
                  onChanged: (pin){
                     detailsController.sms.value=pin;
                  },
                 ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:
                  ElevatedButton(onPressed: () async{
                    try{
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: detailsController.otp.value, smsCode: detailsController.sms.value);
                    await auth.signInWithCredential(credential);
                    if(page==1){
                      await FirebaseFirestore.instance.collection("users").doc("+91${detailsController.phonecontroller.text}").set({
                        "reg":true,
                        "name":detailsController.namecontroller.text,
                        "email":detailsController.emailcontroller.text,
                      }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen())));
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen()));
                    }

                    }catch(e){
                      print(e);
                      final materialBanner = MaterialBanner(
                        /// need to set following properties for best effect of awesome_snackbar_content
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        forceActionsBelow: true,
                        content: AwesomeSnackbarContent(
                          title: 'Oh Hey!!',
                          message:
                          'Enter Valid Otp',
                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                          contentType: ContentType.failure,
                          // to configure for material banner
                          inMaterialBanner: true,
                        ),
                        actions: const [SizedBox.shrink()],
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(materialBanner);
                    }
                  },
                    child: Text("Verify",style: TextStyle(fontSize: 20),),style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xff8843b7) ,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),)
                    ),),
                ),
                Center(
                  child: TextButton(onPressed: (){
                    page !=1?Get.toNamed('/login'):Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                  },child: Text("Want to edit Number?",style:TextStyle(fontSize: 12,color: Color(0xff8843b7)) ,),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
