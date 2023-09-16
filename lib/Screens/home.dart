import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit/Screens/booking_screen.dart';
import 'package:parkit/utils/card.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CollectionReference<Map<String, dynamic>> myCollection = FirebaseFirestore.instance.collection('parkings');
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    child: Icon(Icons.account_circle_outlined,size: 70,color: Color(0xff8843b7),),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  SizedBox(width: 5),
                  Column(
                    children: [
                      Text("Welcome !!",style: TextStyle(fontSize: 15),),
                      SizedBox(
                        height: 5
                      ),
                      Text("Adib",style: TextStyle(fontSize: 25,color: Color(0xff8843b7)),),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: ()async{
                    await FirebaseAuth.instance.signOut().then((value) {
                      Get.toNamed('/login');
                    });
                  }, icon: Icon(Icons.logout,color: Color(0xff8843b7),))
                ],
              ),
              SizedBox(height: 50),
              Text("Parking Areas",style: TextStyle(fontSize: 20),),
              SizedBox(height: 10),
              Expanded(child: Material(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                  ),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: myCollection.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Display a loading indicator while waiting for data.
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text('No data available'); // Display a message if there are no documents.
                        }

                        // If data is available, create a ListView.builder to display the documents.
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>> document = snapshot.data!.docs[index];
                            // Access the data from the document using document.data().
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                            return CustomCard(address: data['address'], Name: data['name'], url: data['image'],func: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingScreen()));
                            },);
                            //   ListTile(
                            //   title: Text(data['name']), // Access your document fields here.
                            //   subtitle: Text(data['address']),
                            //   // Add more widgets to display other document fields as needed.
                            // );
                          },
                        );
                      },
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      )
    );
  }
}
