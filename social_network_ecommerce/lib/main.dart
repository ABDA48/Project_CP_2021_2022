import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_network_ecommerce/Controller/MainController.dart';
import 'package:social_network_ecommerce/pages/LoginPage.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
       home:StreamBuilder<User?>(
         stream: FirebaseAuth.instance.userChanges(),
         builder: (BuildContext context,snapshot){
           print("Main data ${snapshot.data?.uid}");
           if(snapshot.hasData){
             print('hasData');
           }
          return(snapshot.hasData)?MainController(uid: snapshot.data!.uid):LoginPage();
         },
       ),
    );
  }
}


