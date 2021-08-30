import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/closeButton.dart';
import 'package:cybertech/widgets/customTextField.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:cybertech/widgets/sidePopUpParent.dart';
import 'package:cybertech/widgets/sidePopupWithoutModelList.dart';
import 'package:cybertech/widgets/validationErrorText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class EmployeeMasterAddNew extends StatefulWidget {
  bool isEdit;
  dynamic value;
  EmployeeMasterAddNew({required this.isEdit,required this.value});

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
  String editUid="";
  String? editUrl=null;

  bool name=false;
  bool password=false;
  bool email=false;
  bool emailValid=true;
  bool userGroup=false;


  bool isLoad=false;
  bool userGroupOpen=false;

  int? userGroupId=null;
  String? userGroupName=null;

  final databaseReference = FirebaseDatabase.instance.reference();
  List<dynamic> userGroupList=[
    {"UserGroupId": 1, "UserGroupName": "Admin"},
    {"UserGroupId": 2, "UserGroupName": "GeneralUser"},
    {"UserGroupId": 3, "UserGroupName": "Sales Executive"}
    ];

  File? _imageFile;
  final picker = ImagePicker();
  String? downloadUrl=null;
  Future pickImage() async {
    final tempImage = (await ImagePicker.platform.pickImage(source: ImageSource.gallery));
    if (tempImage != null) {
      _cropImage(tempImage);
    }
  }

  _cropImage(PickedFile picked) async {
    File? cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
          statusBarColor: Colors.red,
          toolbarColor: Colors.red,
          toolbarTitle: "Crop Image",
          toolbarWidgetColor: Colors.white,
          showCropGrid: false,
          hideBottomControls: true
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [

        CropAspectRatioPreset.square
      ],
      maxWidth: 800,
      cropStyle: CropStyle.rectangle,

    );
    if (cropped != null) {
      setState(() {
        _imageFile = cropped;
        // imagestring=Utility.base64String(sampleImage.readAsBytesSync());
      });
    }

  }


  Future uploadImageToFirebase(BuildContext context,String fileName) async {
    // String fileName = basename(_imageFile.path);



      await firebase_storage.FirebaseStorage.instance.ref().child('propic/$fileName')
      .putFile(_imageFile!);

      downloadUrl = await firebase_storage.FirebaseStorage.instance
          .ref('propic/$fileName')
          .getDownloadURL();

    // StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    // taskSnapshot.ref.getDownloadURL().then(
    //       (value) => print("Done: $value"),
    // );
  }


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


      if(widget.isEdit){
        print(widget.value);
        setState(() {
          nameTextController.text=widget.value['Name'];
          emailController.text=widget.value['Email'];
          passwordController.text=widget.value['Password'];
          userGroupId=widget.value['UserGroupId'];
          userGroupName=widget.value['UserGroupName'];
          editUrl=widget.value['imgUrl'];
          editUid=widget.value['Uid'];
        });
      }

    });
    super.initState();
  }
  AuthenticationHelper authenticationHelper=new AuthenticationHelper();
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
                      backgroundColor: bgColor,
                      leading: Container(),
                      actions: [
                        Container(
                          height: 50,
                          width:SizeConfig.screenWidth,
                          child: Row(
                            children: [
                             /* CancelButton(
                                ontap: (){
                                  Navigator.pop(context);
                                },
                              ),*/
                              ArrowBack(

                                ontap: (){
                                  Navigator.pop(context);
                                },
                                iconColor: Colors.white,
                              ),
                             Text(widget.isEdit?"":"Employee Master / Add New",
                             style: TextStyle(fontFamily: 'RR',fontSize: 16),
                             ),


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
                            color:bgColor,
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


                      GestureDetector(
                        onTap: (){
                          node.unfocus();
                          setState(() {
                            userGroupOpen=true;
                          });
                         /* if(mun.isEdit){
                            setState(() {
                              userGroupOpen=true;
                              _keyboardVisible=false;
                            });
                          }*/

                        },
                        child: SidePopUpParent(
                          text:userGroupName==null? "Select User Group":userGroupName,
                          textColor:userGroupName==null? grey.withOpacity(0.5):grey,
                          iconColor:userGroupName==null? grey:yellowColor,
                          //bgColor:userGroupName==null? disableColor:mun.isEdit?Colors.white:disableColor,
                          bgColor:userGroupName==null? disableColor:Colors.white,

                        ),
                      ),
                      !userGroup?Container():ValidationErrorText(),

                      GestureDetector(
                        onTap: (){
                          pickImage();
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: uploadColor,width: 2)
                          ),
                          clipBehavior: Clip.antiAlias,
                          child:widget.isEdit && editUrl!=null?Image.network(editUrl!):
                          _imageFile!=null? Image.file(_imageFile!,fit: BoxFit.contain,

                          ):
                          Center(child: SvgPicture.asset("assets/svg/upload.svg",height: 30,width: 30,)),
                        ),
                      ),
                      SizedBox(height: 20,),

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

                          if(userGroupId==null){setState(() {userGroup=true;});}
                          else{setState(() {userGroup=false;});}

                          if(emailValid && !email && !name && !password && !userGroup){

                            setState(() {
                              isLoad=true;
                            });
                           // AuthenticationHelper().signOut();
                         //   print(AuthenticationHelper().auth2.currentUser!.uid);
                            if(widget.isEdit){
                              
                            }
                            else{
                              AuthenticationHelper()
                                  .signUp(email: emailController.text, password: passwordController.text)
                                  .then((result) async {
                                if (result == null) {

                                  if(_imageFile!=null){
                                    await firebase_storage.FirebaseStorage.instance.ref().child('propic/${AuthenticationHelper().auth2.currentUser!.uid}')
                                        .putFile(_imageFile!);

                                    downloadUrl = await firebase_storage.FirebaseStorage.instance
                                        .ref('propic/${AuthenticationHelper().auth2.currentUser!.uid}')
                                        .getDownloadURL();
                                  }
                                  else{
                                    downloadUrl=null;
                                  }


                                  databaseReference.child("Users").child("${AuthenticationHelper().auth2.currentUser!.uid}").set({
                                    'Name': nameTextController.text,
                                    // 'PhoneNumber': phNo,
                                    'Email':emailController.text,
                                    'Password':passwordController.text,
                                    'UserGroupId':userGroupId,
                                    'UserGroupName':userGroupName,
                                    'imgUrl':downloadUrl,
                                    'Uid':AuthenticationHelper().auth2.currentUser!.uid

                                  });
                                  await AuthenticationHelper().auth2.signOut();
                                  AuthenticationHelper().signIn(email1: prefEmail,
                                      password1: prefPassword);
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
              ),


              Container(

                height: userGroupOpen ? SizeConfig.screenHeight:0,
                width: userGroupOpen ? SizeConfig.screenWidth:0,
                color: Colors.black.withOpacity(0.5),

              ),

              PopUpStatic2(
                title: "Select User Group",
                isOpen: userGroupOpen,
                dataList: userGroupList,
                propertyKeyName:"UserGroupName",
                propertyKeyId: "UserGroupId",
                selectedId: userGroupId,
                itemOnTap: (index){
                  setState(() {
                    userGroupId=userGroupList[index]['UserGroupId'];
                    userGroupName=userGroupList[index]['UserGroupName'];
                    userGroupOpen=false;
                  });
                },
                closeOnTap: (){
                  setState(() {
                    userGroupOpen=false;
                  });
                },
              ),
            ],
          ),
      ),
    );
  }
}


class UserGroupModel{
  int userGroupId;
  String userGroup;
  UserGroupModel({required this.userGroup,required this.userGroupId});
}