import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/pages/Sing_upPages.dart';
import 'package:social_network_ecommerce/utilities/Components.dart';
import 'package:social_network_ecommerce/utilities/PasswordWidget.dart';
 class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emaileditor;
  late TextEditingController _passwordeditor;
  late bool _passwordvisibility;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emaileditor = TextEditingController();
    _passwordeditor = TextEditingController();
    _passwordvisibility = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
       image: DecorationImage(
         image: AssetImage('Assets/login.png'),
         fit: BoxFit.cover
       )
     ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children:[
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15,
              left: 35
              ),

                child: buildHeader('Login')),
            SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4,

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formkey,
                    child: Container(
                      child: Column(
                        children: [
                          CreatEmail(_emaileditor, "Enter your email", "Email"),
                          SizedBox(height: 10,),
                          PasswordWidget(visibility: true,
                              pass: _passwordeditor.text,
                              conf: false,
                              controller: _passwordeditor,labelText: "Password",
                            hintText: "Write your password",),
                          SizedBox(height: 10,),
                          TextButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                   if(_emaileditor.text!="" && _passwordeditor.text!=""){


                                      SingIn(email:_emaileditor.text, password:_passwordeditor.text);


                                   }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 50),
                                  child: Text('Submit', style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),),
                                ),
                              )),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account ?',style: TextStyle(fontSize: 15),),
                              TextButton(onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SingUpPage()));
                              }, child: Text(
                                'Sing up', style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
    ]),
      ),
    );
  }
  Future<User?> SingIn({required String email,required String password}) async{
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      final u = userCredential.user;
      return u;
    }on FirebaseAuthException catch(e){
      print(e.message);
     ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text(e.message.toString()))
     );
    }

  }

}





