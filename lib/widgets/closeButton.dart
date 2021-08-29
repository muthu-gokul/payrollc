import 'package:cybertech/constants/constants.dart';
import 'package:flutter/material.dart';
class CancelButton extends StatelessWidget {
  VoidCallback? ontap;
  Color bgColor;
  Color iconColor;
  CancelButton({this.ontap,this.bgColor=Colors.white,this.iconColor=addNewTextFieldFocusBorder});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ontap,
      child: Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.only(left: 20,right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
        ),
        child: Center(
          child: Icon(Icons.clear,color: iconColor,size: 18,),
        ),
      ),
    );;
  }
}