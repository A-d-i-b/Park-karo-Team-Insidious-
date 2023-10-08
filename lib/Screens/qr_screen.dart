import 'package:flutter/material.dart';
import 'package:parkit/Screens/navigation_screen.dart';


class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff8843b7),
        title: Text('Booking Details'),
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen()));
        }, icon: Icon(Icons.home,color: Colors.white,),),
      ),
      body: Container(
        child: Center(child: Container(
            height: double.infinity,
            color: Color(0xff210033),
            child: Image.asset('images/qr.png',))),
      ),
    );
  }
}
