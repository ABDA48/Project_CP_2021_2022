import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant.dart';

class Buy {
  late String Buyeruid;
  late String Description;
  late String Address;
  late String branduid;
  late String date;
  late int price;
  late String uid;
  late DocumentReference reference;
  late String id;

  Buy(DocumentSnapshot snapshot) {
    id = snapshot.id;
    reference = snapshot.reference;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Buyeruid = data[buyerUidKey];
    price = data[priceKey];
    Description = data[DescriptionKey];
    Address = data[AddressKey];
    uid = data[uidKey];
    date =data[dateKey];
  }

  Map<String, dynamic> toMap() {
    return {
      uidKey: uid,
      buyerUidKey: Buyeruid,
      priceKey: price,
      DescriptionKey: Description,
      AddressKey: Address,
      uidKey: uid,
      dateKey: date,

    };
  }
}