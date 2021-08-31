import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeNotifier extends ChangeNotifier{


  var timeInfo;

  batteryInfo()  {
    timeInfo =DateFormat.jm().format(DateTime.parse(DateTime.now().toString()));
    notifyListeners();
  }
  @override
  void notifyListeners() {
    Timer(Duration(seconds: 1), (){
      batteryInfo();
    });

    super.notifyListeners();
  }

  @override
  void addListener(void Function() listener) {
    Timer(Duration(seconds: 1), (){
      batteryInfo();
    });
    super.addListener(listener);
  }

}