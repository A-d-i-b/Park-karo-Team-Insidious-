import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class Fetch extends GetxController{
  final _response = ''.obs;
  String get response => _response.value;
  Future<dynamic> fetchAlbum() async {
    final response = await http
        .get(Uri(
      scheme: 'http',
      host: '127.0.0.1',
      port: 5000,
    ));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  // Future<void> postData(String data,String data2,String data3) async {
  //   print("post");
  //   final url = Uri.parse('http://127.0.0.1:5000');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = {"day_of_week": data,
  //     "hour_of_day": data2,
  //     "popularity_percent_normal": data3
  //   }; // Replace with your request data
  //
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       // _response.value = 'Success: ${response.body}';
  //       print(response.body);
  //       print("success");
  //     } else {
  //       _response.value = 'Error: ${response.reasonPhrase}';
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     _response.value = 'Error: $e';
  //     print(e);
  //   }
  // }
}