import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkit/utils/history_card.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(child: Text("History",style: TextStyle(fontSize: 20,color: Color(0xff8843b7),fontWeight: FontWeight.bold),)),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc("${FirebaseAuth.instance.currentUser?.phoneNumber}").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Display a loading indicator while data is being fetched
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Document does not exist'); // Handle case where the document does not exist
                  }

                  // Access the 'history' field
                  try{
                    List<Map<String, dynamic>> history = List<Map<String, dynamic>>.from(snapshot.data!['history']);
                    List<Widget> slot=[];

                    return ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        for(int i=0;i<history[index]['slots'].length;i++){
                          slot.add(Text("${history[index]['slots'][i]}, ",style:TextStyle(fontSize: 15,color: Colors.white)));
                        }
                        // Build a ListTile for each history item
                        return HistoryCard(date: history[index]['date'], timeSlot:history[index]['time'], address: history[index]['address'], slot: slot,name: history[index]['name'],);
                        // return ListTile(
                        //   title: Text('Date: ${history[index]['date']}'),
                        //   subtitle: Text('Name: ${history[index]['name']}, Time: ${history[index]['time']}'),
                        // );
                      },
                    );

                  }catch(e){
                    return const Center(
                      child: Text("Nothing to show",style: TextStyle(fontSize: 30),),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
