 import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Color yellowColor=Color(0xFF158BCC);
Color bgColor=Color(0xFF4267F6);
Color gridBodyBgColor=Color(0xFFF6F7F9);
Color grey=Color(0xFF787878);
 Color addNewTextFieldBorder=Color(0xFFCDCDCD);
const Color addNewTextFieldFocusBorder=Color(0xFF6B6B6B);
 Color disableColor=Color(0xFFe8e8e8);
 Color uploadColor=Color(0xFFC7D0D8);
 Color indicatorColor=Color(0xFF1C1C1C);
 Color red=Color(0xFFE34343);

 Border gridBottomborder= Border(bottom: BorderSide(color: addNewTextFieldBorder.withOpacity(0.5)));
 TextStyle bgColorTS14=TextStyle(fontFamily: 'RR',color: bgColor,fontSize: 14);
 TextStyle gridHeaderTS=TextStyle(fontFamily: 'RR',color: bgColor,fontSize: 16);
 TextStyle gridTextColor14=TextStyle(fontFamily: 'RR',color: grey,fontSize: 14);
 TextStyle TSWhite166=TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white,letterSpacing: 0.1);
 TextStyle hintText=TextStyle(fontFamily: 'RR',fontSize: 16,color: grey.withOpacity(0.5));

 late String prefEmail;
 late String prefPassword;
 late Map USERDETAIL;


 //rawScrollBar Properties
  const Color srollBarColor=Colors.grey;
  const double scrollBarRadius=5.0;
  const double scrollBarThickness=4.0;

 double attWidth=10;

 Color attendanceMonthGridBodyBgColor=Color(0xFFF6F7F9);
 String dbDateFormat="yyyy-MM-dd";




 final databaseReference = FirebaseDatabase.instance.reference();

 final usersRef = FirebaseDatabase.instance.reference().child("Users");
 final attendanceRef = FirebaseDatabase.instance.reference().child("Attendance");

