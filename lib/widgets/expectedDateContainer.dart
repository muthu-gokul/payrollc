import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:flutter/material.dart';


class ExpectedDateContainer extends StatelessWidget {
  String? text;
  Color? textColor;
  Color? iconColor;
  ExpectedDateContainer({this.text,this.textColor,this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:15,),
      padding: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!),
      height:50,
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: addNewTextFieldBorder),
        color: Colors.white
      ),
      child: Row(
        children: [
          Text(text!,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: textColor),),
          Spacer(),
          Container(
              height: SizeConfig.height25,
              width: SizeConfig.height25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor
              ),

              child: Center(child: Icon(Icons.calendar_today,color:Colors.grey ,size: 20,)))
        ],
      ),
    );
  }
}