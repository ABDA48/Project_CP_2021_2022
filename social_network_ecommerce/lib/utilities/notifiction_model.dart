
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network_ecommerce/utilities/date_Handler.dart';

import '../constant.dart';

class Notifications {
  late DocumentReference reference;
  late String text;
  late String date;
  late String userId;
  late String refProduct;
  late int seen;
  late String type;
  late String image;
  late String name;
  late String sentiment;
  Notifications(DocumentSnapshot snapshot) {
    reference = snapshot.reference;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    text = map[textKey];
    date = DateHandler().myDate(int.parse(map[dateKey]));
    userId = map[uidKey];
    refProduct=map["refProduct"];
    print(refProduct);
    seen = map[seenKey];
    type = map[typeKey];
    image=map[ImageKey];
    name=map[nameKey];
    sentiment=map["sentiment"];
  }

}