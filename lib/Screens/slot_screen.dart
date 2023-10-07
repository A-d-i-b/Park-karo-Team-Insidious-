import 'package:flutter/material.dart';
import 'package:parkit/utils/slot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:get/get.dart';

final _firebase = FirebaseFirestorePlatform.instance;
class Home extends StatefulWidget {
  Home({super.key,required this.name,required this.date,required this.time,required this.address});
  String name;
  String time;
  String date;
  String address;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DetailsController detailsController = Get.put(DetailsController());
  int lane=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }
  void fetch() async {
    await FirebaseFirestore.instance.collection('parkings').doc(widget.name).get().then((value) {
      setState(() {
        lane =value.get('Slots').length;
      });

    });
  }
  Widget grid(int i){
    return StreamBuilder(stream: _firebase.collection('parkings').doc(widget.name).snapshots(), builder: (c,s){
      if (s.connectionState == ConnectionState.waiting) {
        // Show a loading indicator while waiting for the Future
        return CircularProgressIndicator();
      } else if (s.hasError) {
        // Show an error message if there is an error
        return Text('Error: ${s.error}');
      } else {
        // Show the widget when the Future is complete
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("LANE NO.$i ${s.data?.get('Slots')['lane$i']['floor']}"),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      for(int k=1;k<=s.data?.get('Slots')['lane$i']['row'];k++)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for(int j=1;j<=s.data?.get('Slots')['lane$i']['column'];j++)

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SeatModel(lane: i,i: k,j: j,name: widget.name,date: widget.date,time: widget.time,),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: ()async {
            detailsController.booked.clear();
            return true;
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: StreamBuilder(
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              for(int i=1;i<=lane;i++)
                                grid(i),
                              ElevatedButton(onPressed: (){
                                  detailsController.name.value=widget.name;
                                  detailsController.address.value=widget.address;
                                  Navigator.pop(context);
                              }, child: Text("Confirm")),
                              // ElevatedButton(onPressed: () async {
                              //   if(detailsController.bookDetails.isNotEmpty){
                              //     await FirebaseFirestore.instance.collection('parkings').doc(widget.name).collection('Booked').doc(widget.date).set(
                              //         {
                              //           widget.time:Map<String, dynamic>.from(detailsController.bookDetails.value),
                              //         }, SetOptions(merge: true)
                              //     );
                              //   }
                              //
                              //   }, child: Text("Upload to firebase")),
                            ],
                          ),
                        );
                      }, stream: null,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Return the AlertDialog widget
                          return AlertDialog(
                            title: Text('Times which are not Availabe for Booked Parking slot'),
                            content: Container(
                              height: 400,
                              child: SingleChildScrollView(
                                child: Column(
                                  children:[
                                    if(detailsController.booked.isNotEmpty)
                                      for(int i=0;i<detailsController.booked.length;i++)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("${detailsController.booked.keys.elementAt(i)} : ${detailsController.booked.values.elementAt(i)}"),
                                        ),
                                    if(detailsController.booked.isEmpty)
                                      Text("Nothing to Show"),
                                  ]
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Tap to see Booked Time Slots'),
                  ),
                  // ElevatedButton(onPressed: (){
                  //   print(detailsController.booked);
                  // }, child: Text("print"))
                ],
              ),
            ),
          ),
        )
    );
  }
}
