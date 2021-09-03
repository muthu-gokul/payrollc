import 'package:cybertech/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AddButton extends StatelessWidget {
  VoidCallback? ontap;
  String image;
  Color iconColor;
  AddButton({this.ontap,this.image="assets/svg/tick.svg",this.iconColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ontap,
      child: Container(

        height: 65,
        width: 65,
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 8), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(image,height: 30,width: 30,color: iconColor,),
        ),
      ),
    );
  }
}
//"assets/svg/plusIcon.svg"


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




//Add Button
/*
Align(
alignment: Alignment.bottomCenter,
child: AddButton(

),
),*/
