import 'package:flutter/material.dart';
import 'package:parkit/Screens/home.dart';


class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Booking Details'),
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        }, icon: Icon(Icons.home,color: Colors.white,),),
      ),
      body: Container(
        child: Center(child: Image.asset('images/qr.png')),
      ),
    );
  }
}
