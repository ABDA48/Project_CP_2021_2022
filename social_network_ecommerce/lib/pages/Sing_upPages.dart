import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/pages/LoginPage.dart';
import 'package:social_network_ecommerce/utilities/Components.dart';
import 'package:social_network_ecommerce/utilities/PasswordWidget.dart';
import 'package:social_network_ecommerce/pages/PhoneAuthentification.dart';
class SingUpPage extends StatefulWidget {
  const SingUpPage({Key? key}) : super(key: key);

  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUpPage> {
  late   TextEditingController _usernameeditor;
  late   TextEditingController _emaileditor;
  late   TextEditingController _nameditor;
  late   TextEditingController _passwordeditor;
  late   TextEditingController _confirmpass;
  late bool _passwordvisibility;
  late bool _confpass=false;
  final _formkey=GlobalKey<FormState>();
   late FirebaseHandler firebaseHandler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameditor=TextEditingController();
    _usernameeditor=TextEditingController();
    _emaileditor=TextEditingController();
    _passwordeditor=TextEditingController();
    _passwordvisibility=false;
    _confpass=false;
    _confirmpass=TextEditingController();
    firebaseHandler=FirebaseHandler();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Assets/register.png'),
          fit: BoxFit.cover,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:Stack(
            children:[
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2,
                  left: 35
              ),

              child: buildHeader('Register  Now ')),

            SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3,
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
                            CreatEditor(_usernameeditor,"write your Username","Username"),
                            SizedBox(height: 10,),
                            CreatEditor(_nameditor, "Write your Name", "Name"),
                            SizedBox(height: 10,),
                            CreatEmail(_emaileditor, "Write your email", "Email"),
                            SizedBox(height: 10,),
                            PasswordWidget(visibility: true,
                              controller: _passwordeditor,labelText: "Password",hintText: "Write your password",conf: false,
                            pass: _passwordeditor.text,
                            ),
                            PasswordWidget(visibility: true, controller:_confirmpass, hintText: "Confirme the password", labelText: "Confiration",conf:true,pass: _passwordeditor.text,),
                            SizedBox(height: 10,),
                            TextButton(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    if(_passwordeditor.text!="" && _passwordeditor.text==_confirmpass.text){
                                        firebaseHandler.SingUp(uname: _usernameeditor.text, email: _emaileditor.text, password: _passwordeditor.text,name: _nameditor.text);
                                    }else{
                                      _confpass=true;
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

                            (_confpass)?Text('Confirmation and Password are not same'):Container(),
                          ],
                        ),
                      )
                  ),
                  /*
                  ElevatedButton.icon(onPressed: (){

                  }, icon:Icon(MdiIcons.google,color: Colors.pinkAccent,),
                      label: Text('Sing with Google')),

                   */
                  ElevatedButton(
                    child: Text("Phone Sign up"),
                    onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>PhoneAuthentification())),
                  ),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Already have an  account ?',style: TextStyle(fontSize: 15)),
                      TextButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginPage()));
                      }, child: Text(
                        'Log in', style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight:FontWeight.bold),))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]) ,
      ),
    );
  }
}
