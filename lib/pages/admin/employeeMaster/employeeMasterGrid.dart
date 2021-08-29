import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterAddNEw.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:flutter/material.dart';

class EmployeeMasterGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  EmployeeMasterGrid({required this.drawerCallback});

  @override
  _EmployeeMasterGridState createState() => _EmployeeMasterGridState();
}

class _EmployeeMasterGridState extends State<EmployeeMasterGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Stack(
          children: [
            NavBarIcon(
              ontap: widget.drawerCallback,
            )
          ],
        ),
      ),
      floatingActionButton: IconButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>EmployeeMasterAddNew()));
      }, icon: Icon(Icons.add,color: Colors.red,)),
    );
  }
}
