import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate{
  late Member member;
  late VoidCallback callback;
  late bool scrolled;
  HeaderDelegate({
    required this.callback,
    required this.member ,
    required this.scrolled});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(10),
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          (scrolled)?Container(height: 0,width: 0,):InkWell(
            child: Text("${member.Username} ${member.name}"),
            onTap: callback,


          ),
          (member.Description!="")?Text("${member.Description}"):Text("Aucune Description"),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //TextButton(onPressed: (){}, child: Text("Followers :${member..length}")),
              TextButton(onPressed: (){}, child: Text("Following :${member.following.length}"))

            ],)


        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => (scrolled?150:200);

  @override
  // TODO: implement minExtent
  double get minExtent => (scrolled?150:200);

  @override
  bool shouldRebuild(HeaderDelegate oldDelegate)=>scrolled!=oldDelegate.scrolled||member!=oldDelegate.member;
}