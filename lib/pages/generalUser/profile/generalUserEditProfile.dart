import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/closeButton.dart';
import 'package:cybertech/widgets/customTextField.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:cybertech/widgets/noData.dart';
import 'package:cybertech/widgets/sidePopUpParent.dart';
import 'package:cybertech/widgets/sidePopupWithoutModelList.dart';
import 'package:cybertech/widgets/validationErrorText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class GeneralUsesEditProfile extends StatefulWidget {
  VoidCallback drawerCallback;
  GeneralUsesEditProfile({required this.drawerCallback});
/*  bool isEdit;
  dynamic value;
  GeneralUsesEditProfile({required this.isEdit,required this.value});*/

  @override
  _GeneralUsesEditProfileState createState() => _GeneralUsesEditProfileState();
}

class _GeneralUsesEditProfileState extends State<GeneralUsesEditProfile> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;
  List<DateTime?> picked=[];
  int selIndex=-1;

  TextEditingController nameTextController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phNoController = new TextEditingController();
  TextEditingController empIdController = new TextEditingController();
  String editUid="";
  String? editUrl=null;

  bool name=false;
  bool password=false;
  bool email=false;
  bool emailValid=true;
  bool userGroup=false;
  bool phNo=false;
  bool empId=false;

  bool isEdit=false;


  bool isLoad=false;
  bool showShimmer=false;
  bool userGroupOpen=false;
  bool regionOpen=false;

  int? userGroupId=null;
  String? userGroupName=null;


  List<dynamic> userGroupList=[
    {"UserGroupId": 1, "UserGroupName": "Admin"},
    {"UserGroupId": 2, "UserGroupName": "GeneralUser"},
    {"UserGroupId": 3, "UserGroupName": "Sales Executive"}
  ];

  int? selectedRegionId=null;
  String? selectedRegion=null;
  List<dynamic> regionList=[
    {"RegionName": "Chennai","RegionId":1},
    {"RegionName": "Kerala","RegionId":2},
    {"RegionName": "Karnataka","RegionId":3},
    {"RegionName": "Andhra Pradesh","RegionId":4},
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
      setState(() {
        showShimmer=true;
      });
      usersRef.child(USERDETAIL['Uid']).onValue.listen((event) {
        print(event.snapshot.value);
        if(event.snapshot.value != null){
          setState(() {
            empIdController.text=event.snapshot.value['EmployeeId']??"";
            nameTextController.text=event.snapshot.value['Name']??"";
            phNoController.text=event.snapshot.value['PhoneNumber']??"";
            emailController.text=event.snapshot.value['Email']??"";
            passwordController.text=event.snapshot.value['Password']??"";
            userGroupId=event.snapshot.value['UserGroupId'];
            userGroupName=event.snapshot.value['UserGroupName'];
            selectedRegionId=event.snapshot.value['RegionId'];
            selectedRegion=event.snapshot.value['RegionName'];
            editUrl=event.snapshot.value['imgUrl'];
            showShimmer=false;
          });
        }
        else{
          setState(() {
            showShimmer=false;
          });
        }
      });

/*      if(widget.isEdit){
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
      }*/

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

                            NavBarIcon(
                              ontap: widget.drawerCallback,
                            ),
                            Text("  Profile",
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

                          width: SizeConfig.screenWidth,
                          // margin:EdgeInsets.only(top: 55),
                          decoration: BoxDecoration(
                              color:bgColor,
                              image: DecorationImage(
                                  image: AssetImage("assets/images/addEmployeeHeader.png")
                              )
                          ),
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
                    Align(
                      alignment:Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            isEdit=!isEdit;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: SizeConfig.width20!,top: 10,bottom: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigoAccent
                          ),
                          child: Center(
                            child:  isEdit?Icon(Icons.clear,color: Colors.white,):
                            SvgPicture.asset("assets/svg/edit.svg",width: 20,height: 20,color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(isEdit){
                          pickImage();
                        }

                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: uploadColor,width: 2)
                        ),
                        clipBehavior: Clip.antiAlias,
                     //   child:editUrl!=null?Image.network(editUrl!):
                        child:_imageFile==null&&editUrl!=null?CachedNetworkImage(
                          imageUrl: editUrl!,
                          placeholder: (context,url) => CupertinoActivityIndicator(
                            radius: 20,
                            animating: true,

                          ),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                        ):
                        _imageFile!=null? Image.file(_imageFile!,fit: BoxFit.contain,

                        ):
                        Center(child: SvgPicture.asset("assets/svg/upload.svg",height: 30,width: 30,)),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Upload Image",style: gridTextColor14,)
                    ),
                    SizedBox(height: 20,),
                    AddNewLabelTextField(
                      ontap: (){},
                      labelText: 'Employee Id',
                      regExp: '[A-Za-z0-9]',
                      textEditingController: empIdController,
                      maxlines: 1,
                      isEnabled: isEdit,
                      onChange: (v){},
                      onEditComplete: (){
                        node.unfocus();
                      },
                    ),
                    !empId?Container():ValidationErrorText(),
                    AddNewLabelTextField(
                      ontap: (){},
                      labelText: 'Name',
                      regExp: '[A-Za-z  ]',
                      textEditingController: nameTextController,
                      maxlines: 1,
                      isEnabled: isEdit,
                      onChange: (v){},
                      onEditComplete: (){
                        node.unfocus();
                      },
                    ),
                    !name?Container():ValidationErrorText(),
                    AddNewLabelTextField(
                      ontap: (){},
                      labelText: 'Contact Number',
                      regExp: '[0-9]',
                      textEditingController: phNoController,
                      maxlines: 1,
                      isEnabled: isEdit,
                      textLength: 10,
                      onChange: (v){},
                      onEditComplete: (){
                        node.unfocus();
                      },
                    ),
                    !phNo?Container():ValidationErrorText(title: '* Contact Number should be 10 digits',),
                    AddNewLabelTextField(
                      ontap: (){},
                      labelText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: emailController,
                      maxlines: 1,
                      isEnabled: isEdit,
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
                      isEnabled: isEdit,
                      onChange: (v){},
                      onEditComplete: (){
                        node.unfocus();
                      },
                    ),
                    !password?Container():ValidationErrorText(),


  /*                  GestureDetector(
                      onTap: (){
                        node.unfocus();
                        setState(() {
                          userGroupOpen=true;
                        });
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
                        node.unfocus();
                        setState(() {
                          regionOpen=true;
                        });
                      },
                      child: SidePopUpParent(
                        text:selectedRegion==null? "Select Region":selectedRegion,
                        textColor:selectedRegion==null? grey.withOpacity(0.5):grey,
                        iconColor:selectedRegion==null? grey:yellowColor,
                        //bgColor:userGroupName==null? disableColor:mun.isEdit?Colors.white:disableColor,
                        bgColor:selectedRegion==null? disableColor:Colors.white,

                      ),
                    ),
                    !userGroup?Container():ValidationErrorText(),
*/


                    !isEdit?Container():GestureDetector(
                      onTap: () async {
                        print(USERDETAIL);
                        if(emailController.text.isNotEmpty){
                          setState(() {
                            emailValid=EmailValidation().validateEmail(emailController.text);
                          });
                        }

                        if(phNoController.text.isEmpty){
                          setState(() {phNo=true;});
                        }
                        else if(phNoController.text.length<10){
                          setState(() {phNo=true;});
                        }
                        else{
                          setState(() {phNo=false;});
                        }


                        if(emailController.text.isEmpty){setState(() {email=true;});}
                        else{setState(() {email=false;});}

                        if(nameTextController.text.isEmpty){setState(() {name=true;});}
                        else{setState(() {name=false;});}

                        if(passwordController.text.isEmpty){setState(() {password=true;});}
                        else{setState(() {password=false;});}

                        if(empIdController.text.isEmpty){setState(() {empId=true;});}
                        else{setState(() {empId=false;});}

                /*        if(userGroupId==null){setState(() {userGroup=true;});}
                        else{setState(() {userGroup=false;});}*/

                        if(emailValid && !email && !name && !password && !userGroup && !phNo && !empId){

                          setState(() {
                            isLoad=true;
                          });

                          if(_imageFile!=null){
                            await firebase_storage.FirebaseStorage.instance.ref().child('propic/${ FirebaseAuth.instance.currentUser!.uid}')
                                .putFile(_imageFile!);

                            downloadUrl = await firebase_storage.FirebaseStorage.instance
                                .ref('propic/${ FirebaseAuth.instance.currentUser!.uid}')
                                .getDownloadURL();
                          }
                          else{
                            downloadUrl=null;
                          }

                          FirebaseAuth.instance.currentUser!.updateEmail(emailController.text);
                          FirebaseAuth.instance.currentUser!.updatePassword(passwordController.text);
                         await databaseReference.child("Users").child(FirebaseAuth.instance.currentUser!.uid).update({
                            'Email':emailController.text,
                            'PhoneNumber':phNoController.text,
                            'Password':passwordController.text,
                            'Name':nameTextController.text,
                            'EmployeeId':empIdController.text,
                           'imgUrl':downloadUrl,
                         //   'UserGroupId':userGroupId,
                         //   'UserGroupName':userGroupName,
                        //    'RegionId':selectedRegionId,
                         //   'RegionName':selectedRegion,
                          });
                          setState(() {
                            USERDETAIL={
                              'Email':emailController.text,
                              'PhoneNumber':phNoController.text,
                              'Password':passwordController.text,
                              'Name':nameTextController.text,
                              'EmployeeId':empIdController.text,
                              'UserGroupId':userGroupId,
                              'UserGroupName':userGroupName,
                              'RegionId':selectedRegionId,
                              'RegionName':selectedRegion,
                              'Uid': FirebaseAuth.instance.currentUser!.uid,
                              'imgUrl':downloadUrl,
                            };
                          });

                          setState(() {
                            isLoad=false;
                            isEdit=false;
                          });
                          /*if(widget.isEdit){
                            setState(() {
                              isLoad=true;
                            });
                            if(nameTextController.text!=widget.value['Name']){
                              databaseReference.child("Users").child(widget.value['Uid']).update({
                                'Name':nameTextController.text
                              });
                            }
                            if(userGroupId!=widget.value['UserGroupId']){
                              databaseReference.child("Users").child(widget.value['Uid']).update({
                                'UserGroupId':userGroupId,
                                'UserGroupName':userGroupName,
                              });
                            }

                            Navigator.pop(context);
                          }
                          else{
                            AuthenticationHelper()
                                .signUp(email: emailController.text, password: passwordController.text)
                                .then((result) async {
                              if (result == null) {
                                print(FirebaseAuth.instance.currentUser!.uid);
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


                                await databaseReference.child("Users").child("${FirebaseAuth.instance.currentUser!.uid}").set({
                                  'Name': nameTextController.text,
                                  'EmployeeId': empIdController.text,
                                  'PhoneNumber': phNoController.text,
                                  'Email':emailController.text,
                                  'Password':passwordController.text,
                                  'UserGroupId':userGroupId,
                                  'UserGroupName':userGroupName,
                                  'RegionId':selectedRegionId,
                                  'RegionName':selectedRegion,
                                  'imgUrl':downloadUrl,
                                  'Uid':FirebaseAuth.instance.currentUser!.uid

                                });
                                await AuthenticationHelper().auth2.signOut();
                                await AuthenticationHelper().signIn(email1: USERDETAIL['Email'],
                                    password1: USERDETAIL['Password']);
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
                          }*/

                        }

                      },
                      child:    Container(
                        height: 60,
                        margin: EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.green, spreadRadius: 3),
                          // ],
                          color: Colors.indigoAccent,
                        ),
                        child:Center(child: Text('Done',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xffffffff),fontFamily:'RR'), )) ,
                      ),
                    )
                  ],
                ),


              ),
            ),


            Loader(
              isLoad: isLoad,
            ),

            showShimmer?ShimmerWidget():Container(),

            Container(

              height: userGroupOpen || regionOpen? SizeConfig.screenHeight:0,
              width: userGroupOpen || regionOpen? SizeConfig.screenWidth:0,
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

            PopUpStatic2(
              title: "Select Region",
              isOpen: regionOpen,
              dataList: regionList,
              propertyKeyName:"RegionName",
              propertyKeyId: "RegionId",
              selectedId: selectedRegionId,
              itemOnTap: (index){
                setState(() {
                  selectedRegion=regionList[index]['RegionName'];
                  selectedRegionId=regionList[index]['RegionId'];
                  //  userGroupName=userGroupList[index]['UserGroupName'];
                  regionOpen=false;
                });
              },
              closeOnTap: (){
                setState(() {
                  regionOpen=false;
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