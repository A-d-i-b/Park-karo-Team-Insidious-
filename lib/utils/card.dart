import 'package:flutter/material.dart';


class CustomCard extends StatelessWidget {
  CustomCard({super.key,required this.address,required this.Name,required this.url,required this.func});
  String url;
  String Name;
  String address;
  void Function()? func;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(url,
                      fit: BoxFit.fill,
                      height: 100.0,
                      width: 100.0,
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Name,style: TextStyle(color: Color(0xff8843b7)),),
                        SizedBox(height: 10),
                        Text(address),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
