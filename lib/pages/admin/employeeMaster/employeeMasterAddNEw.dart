import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/closeButton.dart';
import 'package:cybertech/widgets/customTextField.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:cybertech/widgets/validationErrorText.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class EmployeeMasterAddNew extends StatefulWidget {
  const EmployeeMasterAddNew({Key? key}) : super(key: key);

  @override
  _EmployeeMasterAddNewState createState() => _EmployeeMasterAddNewState();
}

class _EmployeeMasterAddNewState extends State<EmployeeMasterAddNew> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;
  List<DateTime?> picked=[];
  int selIndex=-1;

  TextEditingController nameTextController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController vehNoController = new TextEditingController();

  bool name=false;
  bool password=false;
  bool email=false;
  bool emailValid=true;
  bool isLoad=false;

  final databaseReference = FirebaseDatabase.instance.reference();


  @override
  void initState() {

    WidgetsBinding.instance!.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });

      silverController!.addListener(() {
        if(silverController!.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
        /*if(silverController!.offset>250){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-300));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<270){
          setState(() {
            silverBodyTopMargin=0;
          });
        }*/
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
            children: [
              NestedScrollView(
                controller: silverController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      toolbarHeight: 50,
                      backgroundColor: Color(0XFF353535),
                      leading: Container(),
                      actions: [
                        Container(
                          height: 50,
                          width:SizeConfig.screenWidth,
                          child: Row(
                            children: [
                              CancelButton(
                                ontap: (){
                                  Navigator.pop(context);
                                },
                              ),
                             Text("Employee Master Add New",
                             style: TextStyle(fontFamily: 'RR',fontSize: 16),
                             ),
                             /* ArrowBack(
                                ontap: (){
                                  Navigator.pop(context);
                                },
                              ),*/

                              SizedBox(width: 20,)
                            ],
                          ),
                        ),
                      ],
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: Color(0XFF353535),
                            width: SizeConfig.screenWidth,
                            margin:EdgeInsets.only(top: 55),

                          )
                      ),
                    ),
                  ];
                },
                body: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight!-55,
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.only(top: silverBodyTopMargin),
                 // padding: EdgeInsets.only(top: 50,bottom: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                    color: Color(0xFFF6F7F9),
                  ),
                  child: ListView(
                    children: [
                      AddNewLabelTextField(
                        ontap: (){},
                        labelText: 'Name',
                        regExp: '[A-Za-z  ]',
                        textEditingController: nameTextController,
                        maxlines: 1,
                        onChange: (v){},
                        onEditComplete: (){
                          node.unfocus();
                        },
                      ),
                      !name?Container():ValidationErrorText(),
                      AddNewLabelTextField(
                        ontap: (){},
                        labelText: 'Email',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: emailController,
                        maxlines: 1,
                        onChange: (v){},
                        onEditComplete: (){
                          node.unfocus();
                        },
                      ),
                      !email?Container():ValidationErrorText(),
                      emailValid?Container():ValidationErrorText(title: "* Invalid Email Address",),
                      AddNewLabelTextField(
                        ontap: (){},
                        labelText: 'Password',
                        isObscure: true,
                        textInputType: TextInputType.emailAddress,
                        textEditingController: passwordController,
                        maxlines: 1,
                        onChange: (v){},
                        onEditComplete: (){
                          node.unfocus();
                        },
                      ),
                      !password?Container():ValidationErrorText(),
                      Text("${AuthenticationHelper().prefEmail} "),
                      GestureDetector(
                        onTap: (){
                          if(emailController.text.isNotEmpty){
                            setState(() {
                              emailValid=EmailValidation().validateEmail(emailController.text);
                            });
                          }


                          if(emailController.text.isEmpty){setState(() {email=true;});}
                          else{setState(() {email=false;});}

                          if(nameTextController.text.isEmpty){setState(() {name=true;});}
                          else{setState(() {name=false;});}

                          if(passwordController.text.isEmpty){setState(() {password=true;});}
                          else{setState(() {password=false;});}

                          if(emailValid && !email && !name && !password){
                            setState(() {
                              isLoad=true;
                            });
                           // AuthenticationHelper().signOut();
                         //   print(AuthenticationHelper().auth2.currentUser!.uid);
                            AuthenticationHelper()
                                .signUp(email: emailController.text, password: passwordController.text)
                                .then((result) async {
                              if (result == null) {

                                databaseReference.child("Users").child("${AuthenticationHelper().auth2.currentUser!.uid}").set({
                                  'Name': nameTextController.text,
                                 // 'PhoneNumber': phNo,
                                  'Email':emailController.text,
                                  'Password':passwordController.text,

                                });
                               await AuthenticationHelper().auth2.signOut();
                                AuthenticationHelper().signIn(email1: AuthenticationHelper().prefEmail,
                                    password1: AuthenticationHelper().prefPassword);
                                setState(() {
                                  isLoad=false;
                                });
                                Navigator.pop(context);
                              //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
                              } else {
                                setState(() {
                                  isLoad=false;
                                });
                                CustomAlert().showMessage(result,context);
                              }
                            });
                          }


                        },
                        child: Container(
                          height: 50,
                          width: 120,
                          child: Center(
                            child: Text("Save"),
                          ),
                        ),
                      )
                    ],
                  ),


                ),
              ),


              Loader(
                isLoad: isLoad,
              )
            ],
          ),
      ),
    );
  }
}
