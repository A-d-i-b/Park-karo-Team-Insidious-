import 'package:flutter/material.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SeatModel extends StatefulWidget {
  SeatModel({super.key,required this.lane,required this.i,required this.j,required this.name,required this.date,required this.time});
  String name;
  int lane;
  int i;
  int j;
  String time;
  String date;
  @override
  State<SeatModel> createState() => _SeatModelState();
}

class _SeatModelState extends State<SeatModel> {
  final DetailsController detailsController =Get.put(DetailsController());
  bool booked=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isBooked();
  }
  bool b= true;
  void isBooked() async{
    try{
      await FirebaseFirestore.instance.collection('parkings').doc(widget.name).collection('Booked').doc(widget.date).get().then((value){
        try{
          if(value.get(widget.time)['${widget.i}${widget.j}lane${widget.lane}']!=null){
            setState(() {
              booked=true;
              b=false;
            });
          }
        }catch(e){
          print("not found");
          print(value.get('10am'));
        }

      });
    }catch(e){
    }


    // if(detailsController.bookDetails['${widget.i}${widget.j}lane${widget.lane}']==true){
    //   setState(() {
    //     b=false;
    //   });
    // }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(booked==true){
          print("done");
        }
        else if(b==true){
          print("Selected");
          setState(() {
            b=false;
          });
          detailsController.bookDetails['${widget.i}${widget.j}lane${widget.lane}']= detailsController.vehiclecontroller.text;
          detailsController.name.value=widget.name;
          detailsController.date.value=widget.date;
          detailsController.time.value=widget.time;
        }else{
          detailsController.bookDetails.remove('${widget.i}${widget.j}lane${widget.lane}');
          setState(() {
            b=true;
          });
        }
      },
      child: Obx(()=>
        Container(
          width: 40,
          height: 40,
          child: booked==true?Image.asset('images/car.png'):detailsController.bookDetails['${widget.i}${widget.j}lane${widget.lane}']!=null?Image.asset('images/Selected.png'):Image.asset('images/empty.png')

        ),
      ),
    );
  }
}

