import 'package:flutter/material.dart';
import 'package:cybertech/constants/size.dart';


class ValidationErrorText extends StatelessWidget {
 final String? title;
 ValidationErrorText({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!),
      child: Align(
        alignment: Alignment.centerLeft,
          child: Text(title==null?"* Required":"$title",style: TextStyle(fontSize: 14,color: Colors.red,fontFamily: 'RR'),textAlign: TextAlign.left,)),
    );
  }
}

class EmailValidation{
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    return (!regex.hasMatch(value)) ? false : true;
  }
}