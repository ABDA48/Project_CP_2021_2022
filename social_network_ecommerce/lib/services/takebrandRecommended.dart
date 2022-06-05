import 'package:http/http.dart' as http;

import '../Controller/firebasecontroller.dart';
import '../utilities/Member.dart';
class Recommended{
  static void  PostRequest(Map<String,String> body) async{
    var url = Uri.parse('http://10.0.2.2:8000/');
    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');

  }
  static void TakeRecommended(String uid){
    FirebaseHandler.firestoreCollection.doc(uid).snapshots().listen((event) {
      Member member=Member(event);
      var fate=member.following;
      String data=fate.join("_");
      Map<String,String> body={"uid":uid,"name":data};

      Recommended.PostRequest(body);
    });
  }
  static void  PostRequestSentiment(Map<String,dynamic> body) async{
    var url = Uri.parse('http://10.0.2.2:8000/sentiment/');
    print(body);
    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');

  }
  static void  PostRecomendationSystem(Map<String,dynamic> body) async{
    var url = Uri.parse('http://10.0.2.2:8000/recomendationSystem/');
    print(body);
    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');

  }


}