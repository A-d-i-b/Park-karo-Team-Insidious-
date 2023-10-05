import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkit/Controllers/details_controller.dart';
import 'package:flutter/material.dart';
import 'package:parkit/Screens/qr_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:parkit/razor_credentials.dart' as razorCredentials;
import 'package:get/get.dart';
class PayScreen extends StatefulWidget {
  PayScreen({super.key,required this.amount});
  int amount;
  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final _razorpay = Razorpay();
  final DetailsController detailsController = Get.put(DetailsController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async {
    // Do something when payment succeeds
    print(response);
    verifySignature(
      signature: response.signature,
      paymentId: response.paymentId,
      orderId: response.orderId,
    );
    if(detailsController.bookDetails.isNotEmpty){
      await FirebaseFirestore.instance.collection('parkings').doc(detailsController.name.value).collection('Booked').doc(detailsController.date.value).set(
          {
            detailsController.time.value:Map<String, dynamic>.from(detailsController.bookDetails.value),
          }, SetOptions(merge: true)
      );
    }
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc("${FirebaseAuth.instance.currentUser?.phoneNumber}");

    // Get the current history array
    DocumentSnapshot userSnapshot = await userRef.get();


    // Update the 'history' field with the modified array
    try{
      List<Map<String, dynamic>> currentHistory = List<Map<String, dynamic>>.from(userSnapshot['history']);

      // Add the new map to the history array
      currentHistory.add({
        'date': detailsController.date.value,
        'time' : detailsController.time.value,
        'name': detailsController.name.value,
        'address': detailsController.address.value,
        'slots': detailsController.bookDetails.keys,
        'vehicle': detailsController.vehiclecontroller.text,
      });
      await userRef.update({'history': currentHistory});
      detailsController.bookDetails.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>QRScreen()));
    }catch(e){
      List<Map<String, dynamic>> currentHistory = [];

      // Add the new map to the history array
      currentHistory.add({
        'date': detailsController.date.value,
        'time' : detailsController.time.value,
        'name': detailsController.name.value,
        'address': detailsController.address.value,
        'slots': detailsController.bookDetails.keys,
        'vehicle': detailsController.vehiclecontroller.text,
      });
      await userRef.set({'history': currentHistory},SetOptions(merge: true));
      detailsController.bookDetails.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>QRScreen()));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? ''),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
  }

// create order
  void createOrder() async {
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": widget.amount,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openGateway(jsonDecode(res.body)['id']);
    }
    print(res.body);
  }

  openGateway(String orderId) {
    var options = {
      'key': razorCredentials.keyId,
      'amount': widget.amount, //in the smallest currency sub-unit.
      'name': 'Park Karo',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'Park',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'prefill': {
        'contact': '8827563432',
        'email': 'ary@example.com',
      }
    };
    _razorpay.open(options);
  }

  verifySignature({
    String? signature,
    String? paymentId,
    String? orderId,
  }) async {
    Map<String, dynamic> body = {
      'razorpay_signature': signature,
      'razorpay_payment_id': paymentId,
      'razorpay_order_id': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "10.0.2.2", // my ip address , localhost
        "razorpay_signature_verify.php",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                createOrder();
              },
              child: const Text("Pay Rs.100"),
            )
          ],
        ),
      ),
    );
  }


}
