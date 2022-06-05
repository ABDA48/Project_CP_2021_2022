import 'package:flutter/material.dart';
class BarItem extends IconButton{
  BarItem({
    required Icon icon,
    required VoidCallback onPressed,
    required bool selected,
  }) : super(
      onPressed: onPressed,
      icon: icon,
      color: (selected)?Colors.green:Colors.grey
  );

}