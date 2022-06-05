import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:social_network_ecommerce/utilities/text_Editor.dart';

import '../Controller/firebasecontroller.dart';

class PhoneAuthentification extends StatefulWidget {
  const PhoneAuthentification({Key? key}) : super(key: key);

  @override
  _PhoneAuthentificationState createState() => _PhoneAuthentificationState();
}

class _PhoneAuthentificationState extends State<PhoneAuthentification> {
  late   TextEditingController _phoneEditor;
  late   TextEditingController textController;
   late bool visible_phone ;
   late bool visiblecode;
   late String verification;
  @override
  void initState() {
    // TODO: implement initState
    _phoneEditor=TextEditingController();
    textController=TextEditingController();
    visible_phone =true;
    visiblecode=false;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _phoneEditor.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text("Phone")),
      body: Container(
        padding: EdgeInsets.only(top:100,left: 20,right: 20),
        child: Column(
          children:[
            Visibility(
              visible: visible_phone,
              child: IntlPhoneField(
                controller: _phoneEditor,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'IN',
              onSaved: (value)=>print("Save"),

          ),
            ),
            Visibility( visible:visiblecode,child: MyTextEditor(textController: textController, hintText: "verification code")),
            ElevatedButton(onPressed: (){
              if(visible_phone==true){
                PhoneSingup(_phoneEditor.text);
              }else if(visiblecode==true){
                verifycode(verification);
              }

            }, child:Text("Sing up"))

          ]
        ),
      ),
    );
  }
  PhoneSingup(String phone) async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        visiblecode=true;
setState(() {
  verification=verificationId;
  print("code sent");

});


      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }

  verifycode(String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: textController.text);

    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

}
