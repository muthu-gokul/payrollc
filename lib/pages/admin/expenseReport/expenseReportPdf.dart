
import 'dart:developer';

import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


checkpdf(context,String date,List<dynamic> data) async {
 // log("DATA $data");

/*  data.forEach((element) {
    print(element);
    element['ExpensesList'].forEach((key,v){
      v['Img']=[];
      v['Images'].forEach((e) async {
        var res= await http.get(Uri.parse(e));
        print("res.bodyBytes ${res.bodyBytes}");
        v['Img'].add(res.bodyBytes);
      });
    });
  });
  log("DATA $data");*/

 pw.TextStyle boldTS12=pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold);
 pw.TextStyle normalTS12=pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.normal);

  List<int> temp=List.generate(60, (index) => index);
 final List<pw.Widget> tempWidget = temp.map((image) {
   return pw.Padding(
       padding: pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
           child: pw.Column(
           crossAxisAlignment: pw.CrossAxisAlignment.center,
           mainAxisSize: pw.MainAxisSize.max,
           children: [
             pw.Text("${image}"),
           ]
           )
         );
 }).toList();
 //create a list of card
 final List<pw.Widget> images = data.map((image) {
   return pw.Padding(
       padding: pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
       child: pw.Column(
           crossAxisAlignment: pw.CrossAxisAlignment.center,
           mainAxisSize: pw.MainAxisSize.max,
           children: [

             pw.Row(
                 children: [
                   pw.Text("Name:  ",style: boldTS12),
                   pw.Text("${image['UserDetail']['Name']}",style:normalTS12),
                 ]
             ),
             pw.Row(
                 children: [
                   pw.Text("Employee Id: ",style: boldTS12),
                   pw.Text("${image['UserDetail']['EmployeeId']}",style:normalTS12),
                 ]
             ),
             pw.Row(
                 children: [
                   pw.Text("Phone Number:  ",style: boldTS12),
                   pw.Text("${image['UserDetail']['PhoneNumber']}",style:normalTS12),
                 ]
             ),
             pw.Row(
                 children: [
                   pw.Text("RegionName:  ",style: boldTS12),
                   pw.Text("${image['UserDetail']['RegionName']}",style:normalTS12),
                 ]
             ),
             pw.SizedBox(height: 20),





             /* pw.ListView.builder(
                 itemBuilder: (ctx,index){
                   var key=image['ExpensesList'].keys.elementAt(index);
                   return Container(
                     //   height: 220,
                     //  width: 100,
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
                           child: Text("${image['ExpensesList'][key]['SiteName']}",style: boldTS12,),
                         ),
                         RichText(
                           text: TextSpan(
                             text: ' Expense Name:  ',
                             style: boldTS12,
                             children: <TextSpan>[
                               TextSpan(text: '${image['ExpensesList'][key]['ExpenseName']}', style: normalTS12),
                             ],
                           ),
                         ),

                         SizedBox(height: 3,),
                         RichText(
                           text: TextSpan(
                             text: ' Expense Value:  ',
                             style: boldTS12,
                             children: <TextSpan>[
                               TextSpan(text: '${image['ExpensesList'][key]['ExpenseValue']}', style: normalTS12),
                             ],
                           ),
                         ),
                         SizedBox(height: 3,),
                         RichText(
                           text: TextSpan(
                             text: ' Accepted Expense Value:  ',
                             style: boldTS12,
                             children: <TextSpan>[
                               TextSpan(text: '${image['ExpensesList'][key]['AcceptedExpenseValue']??0}', style: normalTS12),
                             ],
                           ),
                         ),
                         SizedBox(height: 3,),
                         RichText(
                           text: TextSpan(
                             text: ' Rejected Expense Value:  ',
                             style: boldTS12,
                             children: <TextSpan>[
                               TextSpan(text: '${image['ExpensesList'][key]['RejectedExpenseValue']??0}', style: normalTS12),
                             ],
                           ),
                         ),
                         //      for(int imageIndex=0;imageIndex<data[i]['ExpensesList'][key]['Images'].length;imageIndex++)
                         //     Image(pw.MemoryImage( data[i]['ExpensesList'][key]['Img'][imageIndex]),height: 200)


                      */
             /*   ListView.builder(
                             itemBuilder: (c,imageIndex)  {
                               // return img(data[i]['ExpensesList'][key]['Images'][imageIndex]);

                               return Image(pw.MemoryImage(image['ExpensesList'][key]['Img'][imageIndex]),);
                             },
                             itemCount: image['ExpensesList'][key]['Img'].length
                         )*/
             /*
                         //    SizedBox(height: 20,),

                       ],
                     ),

                   );
                 },
                 itemCount: image['ExpensesList'].length
             )*/
           ]
       )
   );
 }).toList();


  final pw.Document pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 5),
        crossAxisAlignment: CrossAxisAlignment.start,
        maxPages: 1000,
        build: (Context context) => <Widget>[

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

          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.max,
              children: tempWidget
          ),

          /*for(int i=0;i<data.length;i++)
            Column(
              children: [
                pw.Row(
                    children: [
                      pw.Text("Name:  ",style: boldTS12),
                      pw.Text("${data[i]['UserDetail']['Name']}",style:normalTS12),
                    ]
                ),
                pw.Row(
                    children: [
                      pw.Text("Employee Id: ",style: boldTS12),
                      pw.Text("${data[i]['UserDetail']['EmployeeId']}",style:normalTS12),
                    ]
                ),
                pw.Row(
                    children: [
                      pw.Text("Phone Number:  ",style: boldTS12),
                      pw.Text("${data[i]['UserDetail']['PhoneNumber']}",style:normalTS12),
                    ]
                ),
                pw.Row(
                    children: [
                      pw.Text("RegionName:  ",style: boldTS12),
                      pw.Text("${data[i]['UserDetail']['RegionName']}",style:normalTS12),
                    ]
                ),
                pw.SizedBox(height: 20),
                pw.ListView.builder(
                    itemBuilder: (ctx,index){
                      var key=data[i]['ExpensesList'].keys.elementAt(index);
                      return Container(
                     //   height: 220,
                      //  width: 100,
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
                              child: Text("${data[i]['ExpensesList'][key]['SiteName']}",style: boldTS12,),
                            ),
                            RichText(
                              text: TextSpan(
                                text: ' Expense Name:  ',
                                style: boldTS12,
                                children: <TextSpan>[
                                  TextSpan(text: '${data[i]['ExpensesList'][key]['ExpenseName']}', style: normalTS12),
                                ],
                              ),
                            ),

                            SizedBox(height: 3,),
                            RichText(
                              text: TextSpan(
                                text: ' Expense Value:  ',
                                style: boldTS12,
                                children: <TextSpan>[
                                  TextSpan(text: '${data[i]['ExpensesList'][key]['ExpenseValue']}', style: normalTS12),
                                ],
                              ),
                            ),
                            SizedBox(height: 3,),
                            RichText(
                              text: TextSpan(
                                text: ' Accepted Expense Value:  ',
                                style: boldTS12,
                                children: <TextSpan>[
                                  TextSpan(text: '${data[i]['ExpensesList'][key]['AcceptedExpenseValue']??0}', style: normalTS12),
                                ],
                              ),
                            ),
                            SizedBox(height: 3,),
                            RichText(
                              text: TextSpan(
                                text: ' Rejected Expense Value:  ',
                                style: boldTS12,
                                children: <TextSpan>[
                                  TextSpan(text: '${data[i]['ExpensesList'][key]['RejectedExpenseValue']??0}', style: normalTS12),
                                ],
                              ),
                            ),
                      //      for(int imageIndex=0;imageIndex<data[i]['ExpensesList'][key]['Images'].length;imageIndex++)
                         //     Image(pw.MemoryImage( data[i]['ExpensesList'][key]['Img'][imageIndex]),height: 200)


              ListView.builder(
                                itemBuilder: (c,imageIndex)  {
                                 // return img(data[i]['ExpensesList'][key]['Images'][imageIndex]);

                                    return Image(pw.MemoryImage(data[i]['ExpensesList'][key]['Img'][imageIndex]),);
                                },
                                itemCount:  data[i]['ExpensesList'][key]['Img'].length
                            )
                            //    SizedBox(height: 20,),

                          ],
                        ),

                      );
                    },
                    itemCount: data[i]['ExpensesList'].length
                )
              ]
            ),*/

          /*Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.asMap().map((key, value) => MapEntry(key, Container(
                  child:  ListView.builder(
                      itemBuilder: (ctx,index){
                        var key=value['ExpensesList'].keys.elementAt(index);
                        return Container(
                          //   height: 220,
                          //  width: 100,
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
                                child: Text("${value['ExpensesList'][key]['SiteName']}",style: boldTS12,),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: ' Expense Name:  ',
                                  style: boldTS12,
                                  children: <TextSpan>[
                                    TextSpan(text: '${value['ExpensesList'][key]['ExpenseName']}', style: normalTS12),
                                  ],
                                ),
                              ),

                              SizedBox(height: 3,),
                              RichText(
                                text: TextSpan(
                                  text: ' Expense Value:  ',
                                  style: boldTS12,
                                  children: <TextSpan>[
                                    TextSpan(text: '${value['ExpensesList'][key]['ExpenseValue']}', style: normalTS12),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3,),
                              RichText(
                                text: TextSpan(
                                  text: ' Accepted Expense Value:  ',
                                  style: boldTS12,
                                  children: <TextSpan>[
                                    TextSpan(text: '${value['ExpensesList'][key]['AcceptedExpenseValue']??0}', style: normalTS12),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3,),
                              RichText(
                                text: TextSpan(
                                  text: ' Rejected Expense Value:  ',
                                  style: boldTS12,
                                  children: <TextSpan>[
                                    TextSpan(text: '${value['ExpensesList'][key]['RejectedExpenseValue']??0}', style: normalTS12),
                                  ],
                                ),
                              ),
                              //      for(int imageIndex=0;imageIndex<data[i]['ExpensesList'][key]['Images'].length;imageIndex++)
                              //     Image(pw.MemoryImage( data[i]['ExpensesList'][key]['Img'][imageIndex]),height: 200)


                              */
          /*    ListView.builder(
                                itemBuilder: (c,imageIndex)  {
                                 // return img(data[i]['ExpensesList'][key]['Images'][imageIndex]);

                                    return Image(pw.MemoryImage(data[i]['ExpensesList'][key]['Img'][imageIndex]),);
                                },
                                itemCount:  data[i]['ExpensesList'][key]['Img'].length
                            )*/
          /*
                              //    SizedBox(height: 20,),

                            ],
                          ),

                        );
                      },
                      itemCount: value['ExpensesList'].length
                  )
              )
            )).values.toList()
          )*/

          //header
          /*     pw.Container(
            decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColor.fromInt(0xFFCDCDCD))
            ),
            child:  pw.Row(
                children: header.asMap().
                map((i, value) => MapEntry(i,
                    value.isActive?Container(
                        margin: pw.EdgeInsets.only(right: 10),
                        //  alignment: value.alignment,
                        //  padding: value.edgeInsets,
                        width:count>7?  value.width:(480/count).toDouble(),
                        // width: value.width,
                        //height: 16,
                        constraints: BoxConstraints(
                            minWidth:count>7? 50:(480/count).toDouble(),
                            maxWidth: count>7? 70:(480/count).toDouble()
                        ),
                        child: Text(value.columnName,style: pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFFCDCDCD)))
                    ):Container()
                ))
                    .values.toList()
            ),
          ),*/
          //data rows
         /* Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:data.asMap().
              map((i, value) => MapEntry(
                i, Container(

                decoration: pw.BoxDecoration(
                    border: pw.Border(right: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                      left: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                      bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFe3e3e3)),
                    )
                ),

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: header.asMap().map((j, v) {

                      return MapEntry(j,
                        v.isActive?!v.isDate?Container(
                          //   width: v.width,
                          width:count>7?  v.width:(480/count).toDouble(),
                          constraints: BoxConstraints(
                              minWidth:count>7? 50:(480/count).toDouble(),
                              maxWidth: count>7? 70:(480/count).toDouble()
                          ),
                          decoration: BoxDecoration(

                          ),
                          margin: pw.EdgeInsets.only(right: 10),
                          child: Text("${value[v.columnName].toString().isNotEmpty?value[v.columnName]??" ":" "}",
                            style:pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFF3b3b3d)),
                          ),
                        ):Container(
                          //width: v.width,
                          width:count>7?  v.width:(480/count).toDouble(),
                          constraints: BoxConstraints(
                              minWidth:count>7? 50:(480/count).toDouble(),
                              maxWidth: count>7? 70:(480/count).toDouble()
                          ),
                          decoration: BoxDecoration(

                          ),
                          margin: pw.EdgeInsets.only(right: 10),
                          child: Text("${value[v.columnName]!=null?DateFormat('dd-MM-yyyy').format(DateTime.parse(value[v.columnName])):" "}",
                            style:pw.TextStyle(fontSize: 12,color: PdfColor.fromInt(0xFF3b3b3d)),
                          ),
                        )
                            :Container(),
                      );
                    }
                    ).values.toList()
                ),
              ),

              )
              ).values.toList()
          ),*/
        ]
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
    CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/Download/quarry/reports/$filename.pdf", "", "");
  });




}

