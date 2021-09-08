import 'package:cybertech/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GeneralUserExpenseNotifier extends ChangeNotifier{
  final dbRef = databaseReference.child("Expenses");
  List<dynamic> lists=[];


  getData(DateTime? date){
    dbRef.child(DateFormat(dbDateFormat).format(date!)).child(USERDETAIL['Uid']).once().then((event) {
      lists.clear();
      // DataSnapshot dataValues = event.snapshot;
      if(event.value!=null){
        Map<dynamic, dynamic> values = event.value;
        print("LIST  $values");
        values.forEach((key, values) {

            values['Key']=key;
            lists.add(values);

        });
      }
      else{
        lists=[];
      }
      notifyListeners();
    });
  }

}