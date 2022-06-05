import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/text_Editor.dart';

import '../utilities/Post.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
class BuyPage extends StatefulWidget {
  Post post;
  Member member;
  BuyPage({required this.post,required this.member,Key? key});

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  late TextEditingController AddressEditor;

  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddressEditor=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buy"),),
      body:  Container(
        child: SingleChildScrollView(
          child: Column(
            children:[ CreditCardWidget(
              cardNumber: "123456565",
              expiryDate: "date",
              cardHolderName: "cardHolderName",
              cvvCode: "code",
              showBackView: true, onCreditCardWidgetChange: (CreditCardBrand ) {  }, //true when you want to show cvv(back) view
            ),

              CreditCardForm(
                formKey: formKey, // Required
                onCreditCardModelChange: onCreditCardModelChange, // Required
                themeColor: Colors.red,
                obscureCvv: true,
                obscureNumber: true,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardNumberDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: const TextStyle(color: Colors.blue),
                  labelStyle: const TextStyle(color: Colors.blue),
                  labelText: 'Card number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ), cvvCode:cvvCode , cardNumber:cardNumber, expiryDate:expiryDate, cardHolderName:cardHolderName,
              ),
              MyTextEditor(textController: AddressEditor, hintText: "Address"),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  primary: const Color(0xff1b447b),
                ),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: const Text(
                    'Validate',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'halter',
                      fontSize: 14,
                      package: 'flutter_credit_card',
                    ),
                  ),
                ),
                onPressed: () {
                  FirebaseHandler().addBuyer(widget.member.uid,widget.post, AddressEditor.text);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Buy succesfully"))
                );
                  },
              ),

          ]
          ),
        ),


      ),

    );
  }
  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

}
