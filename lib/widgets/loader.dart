import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:flutter/material.dart';



class Loader extends StatelessWidget {
  bool isLoad;
  Loader({this.isLoad=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLoad? SizeConfig.screenHeight:0,
      width: isLoad? SizeConfig.screenWidth:0,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(yellowColor),),
      ),
    );
  }
}
