
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:parkit/Screens/PayScreen.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as v;
import 'package:flutter/cupertino.dart';
class BookingScreen extends StatefulWidget {
  BookingScreen({super.key,required this.lat,required this.lon,required this.address});
  double lat;
  double lon;
  String address;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final DetailsController detailsController=Get.put(DetailsController());
  double distance1=0.0;
  TimeOfDay Artime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay Detime = TimeOfDay(hour: 0, minute: 0);
  DateTime date = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  final List<LatLng> routePoints = [];
  @override
  void initState() {
    super.initState();
    calculateDistance(detailsController.lat.value, detailsController.lon.value,widget.lat, widget.lon);
    add();
  }

  Future<void> add()async {
    setState(() {
      routePoints.add(LatLng(detailsController.lat.value, detailsController.lon.value));
      routePoints.add(LatLng(widget.lat, widget.lon));
    });

  }
  void calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers (use 3959 for miles)

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = v.radians(lat1);
    double lon1Rad = v.radians(lon1);
    double lat2Rad = v.radians(lat2);
    double lon2Rad =  v.radians(lon2);

    // Haversine formula
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;
    double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculate the distance
    double distance = earthRadius * c;
    setState(() {
      distance1=distance;
    });
     // Distance in kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xff8843b7),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\Rs. Amount",
                    // "\Rs. ${totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PayScreen()));
                    },
                    child: Text(
                      "Proceed to Pay",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onClosing: () {},
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child:FlutterMap(
                    options: MapOptions(
                      center: routePoints.first,
                      zoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      ),
                        PolylineLayer(
                          polylines: [
                          Polyline(
                          points: routePoints,
                          color: Colors.blue,
                          strokeWidth: 4.0,
                        ),]
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text("Address",style: TextStyle(fontSize: 20),),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.add_location_alt,color: Color(0xff8843b7),size: 20,),
                    SizedBox(width: 20),
                    Expanded(child: Text(widget.address,maxLines: 10,textAlign: TextAlign.start,)),
                  ],
                ),
                SizedBox(height: 15),
                Row(children: [
                  Column(
                    children: [
                      Text("Distance",style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20),),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: (){}, child: Text("${distance1.toPrecision(2)} KM"),style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8843b7), // Background color
                      ),),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text("Date Of Parking",style: TextStyle(fontSize: 20),),
                      SizedBox(height: 10),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff8843b7),
                          ),
                          onPressed: ()async{
                            DateTime? newdate= await showDatePicker(context: context, initialDate: date, firstDate: DateTime(1900), lastDate: DateTime(2050));
                            if(newdate != null){
                              setState(() {
                                date = newdate;
                              });
                            }else{
                              return;
                            }
                          }, child: Text("${date.year} / ${date.month} / ${date.day}")),
                    ],
                  ),
                ],),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Arrival Time",style: TextStyle(fontSize: 20),),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(100, 20),
                                  backgroundColor: Color(0xff8843b7),
                                ),
                                onPressed: ()async{
                                  TimeOfDay? newtime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0));
                                  if(newtime != null){
                                    setState(() {
                                      Artime = newtime;
                                    });
                                  }else{
                                    return;
                                  }
                                }, child: Text("${Artime.hour}:${Artime.minute}")),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Departure Time",style: TextStyle(fontSize: 20),),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(100, 20),
                                  backgroundColor: Color(0xff8843b7),
                                ),
                                onPressed: ()async{
                                  TimeOfDay? newtime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0));
                                  if(newtime != null){
                                    setState(() {
                                      Detime = newtime;
                                    });
                                  }else{
                                    return;
                                  }
                                }, child: Text("${Detime.hour}:${Detime.minute}")),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text("Booking Slots",style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Container(
                  child: Image.asset('images/slot.png'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ElevatedButton(onPressed: (){
// Navigator.push(context, MaterialPageRoute(builder: (context)=>PayScreen()));
// }, child: Text("Pay")),