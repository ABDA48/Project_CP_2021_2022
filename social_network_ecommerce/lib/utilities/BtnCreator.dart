import 'package:flutter/material.dart';
class BtnCreator extends StatelessWidget {
  String name;
  VoidCallback onPress;
   BtnCreator({required this.name,required this.onPress});

  @override
  Widget build(BuildContext context) {
    return     Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border:Border.all(color: Colors.black),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1,1),
                blurRadius: 1,
                spreadRadius: 1
            )
          ]
      ),
      child: TextButton(
        child: Padding(
          padding:const EdgeInsets.only(left: 70,right: 70,),
          child: Text(name),
        ),
        onPressed:onPress,
      ),
    );
  }
}
