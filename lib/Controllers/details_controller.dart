import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DetailsController extends GetxController{
  final emailcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final vehiclecontroller= TextEditingController();
  RxString otp=''.obs;
  RxString sms=''.obs;
  RxDouble lat=0.0.obs;
  RxDouble lon=0.0.obs;
  RxMap book =<String,dynamic>{}.obs;
  RxMap bookDetails =<String,dynamic>{}.obs;
  RxString name=''.obs;
  RxString address=''.obs;
  RxString date=''.obs;
  RxString time=''.obs;
  List<String> items =[
    '12AM-1AM',
    '1AM-2AM',
    '2AM-3AM',
    '3AM-4AM',
    '4AM-5AM',
    '5AM-6AM',
    '6AM-7AM',
    '7AM-8AM',
    '8AM-9AM',
    '9AM-10AM',
    '10AM-11AM',
    '11AM-12PM',
    '12PM-1PM',
    '1PM-2PM',
    '2PM-3PM',
    '3PM-4PM',
    '4PM-5PM',
    '5PM-6PM',
    '6PM-7PM',
    '7PM-8PM',
    '8PM-9PM',
    '9PM-10PM',
    '10PM-11PM',
    '11PM-12AM',
  ];
  RxString homeName=''.obs;





}