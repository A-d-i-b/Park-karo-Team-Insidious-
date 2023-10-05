import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:parkit/Screens/PayScreen.dart';
import 'package:parkit/Screens/slot_screen.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkit/Controllers/fetch_controller.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:parkit/utils/textfield_utils.dart';


class BookingScreen extends StatefulWidget {
  BookingScreen({super.key,required this.lat,required this.lon,required this.address,required this.name});
  double lat;
  double lon;
  String address;
  String name;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final DetailsController detailsController=Get.put(DetailsController());
  final Fetch fetch = Get.put(Fetch());

  TimeOfDay Artime = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay Detime = TimeOfDay(hour: 0, minute: 00);
  DateTime date = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  double totalDistance = 0.0;
  final List<LatLng> routePoints = [];
  bool select = false;
  String selectedItem='10AM-11AM';
  @override
  void initState() {
    super.initState();
    add();
  }
  MaterialBanner MatBanner(ContentType type,String message){
    return MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: 'Oh Hey!!',
        message:
        message,
        contentType: type,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );
  }

  Future<void> add()async {
    String apiKey = '5b3ce3597851110001cf6248d80982513ccf40168effb0dea5316031';
    LatLng origin = LatLng(detailsController.lat.value, detailsController.lon.value);
    LatLng destination = LatLng(widget.lat, widget.lon);
    String apiUrl =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${origin.longitude},${origin.latitude}&end=${destination.longitude},${destination.latitude}';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200){
      final decoded = json.decode(response.body);
      final List<dynamic> coordinates = decoded['features'][0]['geometry']['coordinates'];
      double distance = 0.0;
      setState(() {
        routePoints.clear();
        routePoints.addAll(coordinates.map((coord) => LatLng(coord[1], coord[0])));
        for (int i = 0; i < routePoints.length - 1; i++) {
          distance += getDistance(routePoints[i], routePoints[i + 1]);
        }

        totalDistance = distance / 1000.0;
      });
    }
  }
  double getDistance(LatLng point1, LatLng point2) {
    // Using the Haversine formula to calculate distance between two points
    const double earthRadius = 6371000;

    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = (lat2 - lat1) * (math.pi / 180.0);
    double dLon = (lon2 - lon1) * (math.pi / 180.0);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180.0)) * math.cos(lat2 * (math.pi / 180.0)) * math.sin(dLon / 2) * math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }
  void launchGoogleMapsDirections({required LatLng origin, required LatLng destination}) async {
    final url = "https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor:  Color(0xff8843b7),
        elevation: 5,
        centerTitle: true,
        title: Text("Booking",style: TextStyle(color: Color(0xff8843b7)),),
      ),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xff8843b7),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "\Rs. 100",
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
                      if(detailsController.bookDetails.isNotEmpty&&detailsController.name.value!=widget.name){
                        final materialBanner = MatBanner(ContentType.failure, 'Please Select the Slots');

                        ScaffoldMessenger.of(context)
                          ..hideCurrentMaterialBanner()
                          ..showMaterialBanner(materialBanner);
                        print("Please select the slots");
                      }else if(detailsController.vehiclecontroller.text.isEmpty){
                        final materialBanner = MatBanner(ContentType.warning, 'Please Enter your vehicle number');

                        ScaffoldMessenger.of(context)
                          ..hideCurrentMaterialBanner()
                          ..showMaterialBanner(materialBanner);
                      }else if(detailsController.bookDetails.isEmpty){
                        final materialBanner = MatBanner(ContentType.warning, 'Please Select the slots');

                        ScaffoldMessenger.of(context)
                          ..hideCurrentMaterialBanner()
                          ..showMaterialBanner(materialBanner);
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PayScreen(amount: 100,)));
                      }
                    },
                    child: const Text(
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

                      center: LatLng(detailsController.lat.value, detailsController.lon.value),
                      zoom: 12.0,
                    ),
                    children: [
                      MarkerLayer(
                        anchorPos: AnchorPos.align(AnchorAlign.center),
                        rotate: false,
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: routePoints.isNotEmpty ? LatLng(detailsController.lat.value, detailsController.lon.value) : LatLng(0, 0),
                            builder: (ctx) => const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                          ),
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: routePoints.isNotEmpty ? LatLng(widget.lat, widget.lon) : LatLng(0, 0),
                            builder: (ctx) => const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
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
                ElevatedButton(onPressed: (){
                  launchGoogleMapsDirections(
                    origin: LatLng(detailsController.lat.value, detailsController.lon.value), // Replace with your origin coordinates
                    destination: LatLng(widget.lat, widget.lon), // Replace with your destination coordinates
                  );
                }, child: Text("Open Navigation")),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Distance",style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20),),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: ()async{
                          // await fetch.postData("Monday", "3", "20");
                          print("hello");
                        }, child: Text("${totalDistance.toPrecision(2)} KM"),style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8843b7), // Background color
                      ),),
                    ],
                  ),
                  Spacer(),
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
                            Text("Time Slot",style: TextStyle(fontSize: 20),),
                            DropdownButton<String>(
                                underline: Container( // Use underline property to set border
                                  height: 2,
                                  color: Color(0xff8843b7), // Set the border color
                                ),
                                value: selectedItem,
                                items: detailsController.items.map((String e) {
                                  return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e));
                                }).toList(), onChanged: (String? value){
                              setState(() {
                                selectedItem=value!;
                              });
                            }),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date of Parking",style: TextStyle(fontSize: 20),),
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
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Textfield(controller: detailsController.vehiclecontroller, hint: "Enter your Vehicle Number",),
                SizedBox(height: 30),
                Text("Booking Slots",style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                ElevatedButton(onPressed:(){
                  print(widget.name);
                  if(detailsController.name.value!=widget.name){
                    if(detailsController.bookDetails.isEmpty){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(name: widget.name,time: selectedItem,date:"${date.day}-${date.month}-${date.year}",address: widget.address,)));
                    }else{
                      final materialBanner = MatBanner(ContentType.warning, 'Please Select the slots from one parking area');

                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(materialBanner);
                      print('Please book from one place');
                    }
                  }else if(detailsController.vehiclecontroller.text.isEmpty){
                    final materialBanner = MatBanner(ContentType.warning, 'Please enter the vehicle number');

                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(materialBanner);
                  }else if(detailsController.name.value==''||detailsController.name.value==widget.name){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(name: widget.name,time: selectedItem,date:"${date.day}-${date.month}-${date.year}",address: widget.address,)));
                  }
                }, child: Text("Booking screen"),),
                // ElevatedButton(onPressed: (){
                //   print(detailsController.bookDetails.value);
                // }, child: Text('print details')),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
