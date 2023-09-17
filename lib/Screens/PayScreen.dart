import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PayScreen extends StatefulWidget {
  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Replace these placeholders with actual values
                String mid = 'your_merchant_id';
                String orderId = 'your_order_id';
                String txnToken = 'transaction_token_from_initiate_transaction_api';
                String amount = '1.00'; // Amount in INR
                bool isStaging = true; // Set to true for staging environment
                String callbackurl =
                    'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
                bool restrictAppInvoke = true; // Set to true for redirection flow

                var response = AllInOneSdk.startTransaction(
                  mid,
                  orderId,
                  amount,
                  txnToken,
                  callbackurl,
                  isStaging,
                  restrictAppInvoke,
                );

                response.then((value) {
                  print(value);
                  setState(() {
                    result = value.toString();
                  });
                }).catchError((onError) {
                  if (onError is PlatformException) {
                    setState(() {
                      result = onError.message! + " \n  " + onError.details.toString();
                    });
                  } else {
                    setState(() {
                      result = onError.toString();
                    });
                  }
                });
              },
              child: Text('Make Payment'),
            ),
            SizedBox(height: 20),
            Text('Payment Result: $result'),
          ],
        ),
      ),
    );
  }
}
