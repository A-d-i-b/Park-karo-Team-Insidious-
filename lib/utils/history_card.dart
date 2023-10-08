import 'package:flutter/material.dart';
import 'package:parkit/Screens/qr_screen.dart';

class HistoryCard extends StatelessWidget {
  HistoryCard({super.key,required this.date,required this.timeSlot,required this.address,required this.slot,required this.name});
  String date;
  List<Widget> timeSlot;
  String address;
  String name;
  List<Widget> slot;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color:Color(0xff8843b7),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Date: ",style:TextStyle(fontSize: 15,color: Colors.black),),
                  Text("$date",style:TextStyle(fontSize: 15,color: Colors.white),),
                ],
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text("Time Slots: ",style:TextStyle(fontSize: 15,color: Colors.black),),
                    Row(
                      children: timeSlot,
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Text("Time: ",style:TextStyle(fontSize: 15,color: Colors.black),),
              //     Text("$timeSlot",style:TextStyle(fontSize: 15,color: Colors.white),),
              //   ],
              // ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Address: ",style:TextStyle(fontSize: 15,color: Colors.black),),
                  Expanded(child: Text("$address",style:TextStyle(fontSize: 15,color: Colors.white),)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Parking Name: ",style:TextStyle(fontSize: 15,color: Colors.black),),
                  Text("$name",style:TextStyle(fontSize: 15,color: Colors.white),),
                ],
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text("Parking Slots: ",style:TextStyle(fontSize: 15,color: Colors.black),),
                    Row(
                      children: slot,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text("QR: ",style:TextStyle(fontSize: 15,color: Colors.black),),
                  TextButton(
                    onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>QRScreen()));
                  }, child: Text("Click here",style:TextStyle(fontSize: 15,color: Colors.white),),)
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
