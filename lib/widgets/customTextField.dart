import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';


class AddNewLabelTextField extends StatelessWidget {
  bool isEnabled;
  String? labelText;
  TextEditingController? textEditingController;
  double scrollPadding;
  TextInputType textInputType;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Function(String)? onChange;
  VoidCallback? ontap;
  TextInputFormatter? textInputFormatter;
  VoidCallback? onEditComplete;
  bool isObscure;
  int? maxlines;
  int? textLength;
  String regExp;

  AddNewLabelTextField({this.textEditingController,this.labelText,this.scrollPadding=0.0,this.textInputType:TextInputType.text,
    this.prefixIcon,this.ontap,this.onChange,this.textInputFormatter,this.isEnabled=true,this.suffixIcon,this.onEditComplete,
    this.isObscure=false,this.maxlines=1,this.textLength=null,this.regExp='[A-Za-z0-9@.,]'});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  maxlines!=null? Container(

      margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:15,),
      height: 50,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.transparent
      ),
      child:  TextFormField(
         enabled: isEnabled,
         onTap: ontap,
         obscureText: isObscure,
         obscuringCharacter: '*',
         scrollPadding: EdgeInsets.only(bottom: scrollPadding),
        style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:grey,letterSpacing: 0.2),
        controller: textEditingController,
        decoration: InputDecoration(
          fillColor: Colors.white,
       //   fillColor:isEnabled?Colors.white:AppTheme.disableColor,
          filled: true,
          labelStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: grey.withOpacity(0.9)),
          border:  OutlineInputBorder(
              borderSide: BorderSide(color: addNewTextFieldBorder)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: addNewTextFieldBorder)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:addNewTextFieldFocusBorder)
          ),
          labelText: labelText,
           contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon



        ),
        maxLines: maxlines,
        keyboardType: textInputType,
        textInputAction: TextInputAction.done,
        // inputFormatters:  <TextInputFormatter>[
        //
        //   //textInputFormatter
        // ],

        inputFormatters: [
          LengthLimitingTextInputFormatter(textLength),
          FilteringTextInputFormatter.allow(RegExp(regExp)),
        ],
        onChanged: (v){
           onChange!(v);
        },
        onEditingComplete: (){
           onEditComplete!();
        },
      ),

    ):
    Container(

      margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:15,),
  //    height: 50,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.transparent
      ),
      child:  TextFormField(
        enabled: isEnabled,
        onTap: ontap,
        obscureText: isObscure,
        obscuringCharacter: '*',
        scrollPadding: EdgeInsets.only(bottom: scrollPadding),
        style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:grey,letterSpacing: 0.2),
        controller: textEditingController,
        decoration: InputDecoration(
            fillColor:isEnabled?Colors.white: Color(0xFFe8e8e8),
            filled: true,
            labelStyle: TextStyle(fontFamily: 'RL',fontSize: 15,color: grey.withOpacity(0.9)),
            border:  OutlineInputBorder(
                borderSide: BorderSide(color: addNewTextFieldBorder)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: addNewTextFieldBorder)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:addNewTextFieldFocusBorder)
            ),
            labelText: labelText,
            contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon



        ),
        maxLines: maxlines,
        keyboardType: textInputType,
        textInputAction: TextInputAction.done,

        onChanged: (v){
          onChange!(v);
        },
        onEditingComplete: (){
          onEditComplete!();
        },
      ),

    )
    ;

  }
}
