
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:latlong2/latlong.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart ' as vr;
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
    double lat1Rad = vr.radians(lat1);
    double lon1Rad = vr.radians(lon1);
    double lat2Rad = vr.radians(lat2);
    double lon2Rad = vr.radians(lon2);

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                Text("Distance",style: TextStyle(fontSize: 20),),
                SizedBox(height: 10),
                ElevatedButton(
                    onPressed: (){}, child: Text("${distance1.toPrecision(2)} KM"),style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff8843b7), // Background color
                ),),
                SizedBox(height: 20),
                Text("Date Of Parking",style: TextStyle(fontSize: 20),),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xff8843b7),
                      width: 2,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${date.year} / ${date.month} / ${date.day}"),
                  ),
                ),
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
                    }, child: Text("Set")),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    )
                  ),
                  child: Row(
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
