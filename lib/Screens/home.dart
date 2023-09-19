import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parkit/Screens/booking_screen.dart';
import 'package:parkit/utils/card.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:parkit/utils/drawer_utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DetailsController detailsController=Get.put(DetailsController());

  final CollectionReference<Map<String, dynamic>> myCollection = FirebaseFirestore.instance.collection('parkings');
  void initState() {
    super.initState();
    getCurrentLocation();

  }
  Future<void> getCurrentLocation() async {
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      final Position position = await geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      detailsController.lat.value = position.latitude;
      detailsController.lon.value= position.longitude;

    } catch (e) {
      print('Error: $e');
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override

  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      drawer: Drawer(
        backgroundColor: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              height: 200,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_outlined,size: 100,color: Color(0xff8843b7),),
                  SizedBox(height: 20),
                  Text("Adib",style: TextStyle(fontSize: 30),),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Divider(
                thickness: 2,
                color: Colors.black,
              ),
            ),
            DrawerCard(name: "Profile",),
            DrawerCard(name: "History",),
            DrawerCard(name: "Help",),
            DrawerCard(name: "Language",),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          _scaffoldKey.currentState!.openDrawer();
        }, icon: const Icon(Icons.menu,color:Color(0xff8843b7) ,),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut().then((value) {
              Get.toNamed('/login');
            });
          }, icon: const Icon(Icons.logout,color: Color(0xff8843b7),))

        ],
        elevation: 5,
        backgroundColor: Colors.white,
        title: const Text("Park Karo",style: TextStyle(color: Color(0xff8843b7)),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(Icons.account_circle_outlined,size: 70,color: Color(0xff8843b7),),
                  ),
                  const SizedBox(width: 5),
                  const Column(
                    children: [
                      Text("Welcome !!",style: TextStyle(fontSize: 15),),
                      SizedBox(
                        height: 5
                      ),
                      Text("Adib",style: TextStyle(fontSize: 25,color: Color(0xff8843b7)),),
                    ],
                  ),
                  ],
              ),
              const SizedBox(height: 50),
              const Text("Parking Areas",style: TextStyle(fontSize: 20),),
              const SizedBox(height: 10),
              Expanded(child: Material(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 10),
                  child: Container(
                    decoration: const BoxDecoration(
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
                          return const Center(child:CircularProgressIndicator()); // Display a loading indicator while waiting for data.
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('No data available'); // Display a message if there are no documents.
                        }

                        // If data is available, create a ListView.builder to display the documents.
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>> document = snapshot.data!.docs[index];
                            // Access the data from the document using document.data().
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                            return CustomCard(address: data['address'], Name: data['name'], url: data['image'],func: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingScreen(lat: data['lat'],lon: data['lon'],address: data['address'],)));
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
