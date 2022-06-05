import 'package:flutter/material.dart';
class Heading extends StatefulWidget {

 String text;
  Heading({required this.text});

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 5,
                offset: Offset(10,10)
            )
          ]
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(widget.text,style: TextStyle(fontSize: 30,color: Colors.blue),),
        ),
      ),
    );
  }
}


