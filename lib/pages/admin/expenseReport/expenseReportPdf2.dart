
import 'dart:developer';

import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


checkpdf2(context,String date,List<dynamic> data) async {



  pw.TextStyle boldTS12=pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold);
  pw.TextStyle normalTS12=pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.normal);


  List<Widget> list=[
    pw.Container(
        child: pw.Row(
            children: [
              pw.SizedBox(width: 20),
              pw.Text("Expense Report",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d))),
              pw.Spacer(),
              pw.Text("$date",style: pw.TextStyle(fontSize: 18,color: PdfColor.fromInt(0xFF3b3b3d))),
              pw.SizedBox(width: 20),
            ]
        )
    ),
    pw.SizedBox(height: 20),
  ];

data.forEach((element) {
  print("element ${element}");
  list.add(
      pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisSize: pw.MainAxisSize.max,
          children: [
            pw.Row(
                children: [
                  pw.Text("Name:  ",style: boldTS12),
                  pw.Text("${element['UserDetail']['Name']}",style:normalTS12),
                ]
            ),
            pw.Row(
                children: [
                  pw.Text("Employee Id: ",style: boldTS12),
                  pw.Text("${element['UserDetail']['EmployeeId']}",style:normalTS12),
                ]
            ),
            pw.Row(
                children: [
                  pw.Text("Phone Number:  ",style: boldTS12),
                  pw.Text("${element['UserDetail']['PhoneNumber']}",style:normalTS12),
                ]
            ),
            pw.Row(
                children: [
                  pw.Text("RegionName:  ",style: boldTS12),
                  pw.Text("${element['UserDetail']['RegionName']}",style:normalTS12),
                ]
            ),
            pw.SizedBox(height: 20),
          ]
      )
   )
  );
  var tempMap=element['ExpensesList'] as Map;
  tempMap.forEach((key, value) {
    list.add(
        Container(
          margin: EdgeInsets.fromLTRB(20,20,20,20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //  border: Border.all(color: Colors.grey),
            //  color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                alignment: Alignment.center,
                //   color: Colors.grey,
                child: Text("${value['SiteName']}",style: boldTS12,),
              ),
              RichText(
                text: TextSpan(
                  text: ' Expense Name:  ',
                  style: boldTS12,
                  children: <TextSpan>[
                    TextSpan(text: '${value['ExpenseName']}', style: normalTS12),
                  ],
                ),
              ),

              SizedBox(height: 3,),
              RichText(
                text: TextSpan(
                  text: ' Expense Value:  ',
                  style: boldTS12,
                  children: <TextSpan>[
                    TextSpan(text: '${value['ExpenseValue']}', style: normalTS12),
                  ],
                ),
              ),
              SizedBox(height: 3,),
              RichText(
                text: TextSpan(
                  text: ' Accepted Expense Value:  ',
                  style: boldTS12,
                  children: <TextSpan>[
                    TextSpan(text: '${value['AcceptedExpenseValue']??0}', style: normalTS12),
                  ],
                ),
              ),
              SizedBox(height: 3,),
              RichText(
                text: TextSpan(
                  text: ' Rejected Expense Value:  ',
                  style: boldTS12,
                  children: <TextSpan>[
                    TextSpan(text: '${value['RejectedExpenseValue']??0}', style: normalTS12),
                  ],
                ),
              ),
            ],
          ),

        )
    );
    value['Img'].forEach((e){
      list.add(
          Image(MemoryImage(e),height: 200)
     //   Text("${e}")
      );
    });
    print("value $value");
  });
 // print("tempMap $tempMap");
});



  final pw.Document pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 5),
        crossAxisAlignment: CrossAxisAlignment.start,
        maxPages: 1000,
        build: (Context context) => list
    ),
  );



  // final String dirr ='/storage/emulated/0/Download/quarry/reports';
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  String filename="Expense Report";
  // await Directory('/storage/emulated/0/Download/quarry/reports').create(recursive: true);
  final String path = '$dirr/$filename.pdf';


  final File file = File(path);
  await file.writeAsBytes(await pdf.save()).then((value) async {
    OpenFile.open(path);
    //   CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/Download/quarry/reports/$filename.pdf", "", "");
  });




}

