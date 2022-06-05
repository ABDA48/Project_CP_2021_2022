import 'package:flutter/material.dart';
class PasswordWidget extends StatefulWidget {
  TextEditingController controller;
  bool visibility=false;
  String labelText;
  String hintText;
  bool conf;
  String pass;
  PasswordWidget({required this.visibility,required this.controller,required this.hintText,
  required this.labelText,required this.conf,required this.pass
  });

  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.visibility,
          validator: (val){
            if(val!.length<6){
              return 'Password too short, at least 6';
            }
            if(widget.conf==true && widget.pass!=""){
              if(widget.pass!=val){
                return "password and confirmation does\'t match";
              }
            }
          },
          decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    widget.visibility=!widget.visibility;
                  });
                },
                icon: Icon((widget.visibility==true)?Icons.visibility:Icons.visibility_off),
              )
          ),),
      ),
    );
  }
}