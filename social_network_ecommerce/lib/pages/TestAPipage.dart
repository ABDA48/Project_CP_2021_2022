import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';

import '../services/takebrandRecommended.dart';
import '../utilities/Member.dart';
class APIBrand extends StatefulWidget {
  late Member member;
    APIBrand({
    required this.member,
    Key? key}) : super(key: key);

  @override
  _APIBrandState createState() => _APIBrandState();
}

class _APIBrandState extends State<APIBrand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
        ElevatedButton(child: Text("Push"),onPressed:(){
          Map<String,String> body={
            'name':"I crazy about this product",
            'uid':'go'
          };
         // var url = Uri.parse('http://127.0.0.1:8000/');
          Recommended.PostRequestSentiment( body);

        },)
        ,),
    );
  }

}

