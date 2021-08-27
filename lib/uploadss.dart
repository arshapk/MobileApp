import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:image_downloader/image_downloader.dart';
import 'dart:isolate';
import 'dart:ui';
class Uploadjobdetails extends StatefulWidget {
  const Uploadjobdetails({Key key}) : super(key: key);

  @override
  _UploadjobdetailsState createState() => _UploadjobdetailsState();
}
enum groupedvalue { insecure, secure }
class _UploadjobdetailsState extends State<Uploadjobdetails> {



  List<PlatformFile> files ;
  DateTime birthDate;
  List<MultipartFile> newList;
  int radiovalues=0;
  groupedvalue selected;
  String fileName;
  var i;
  var formatter = new DateFormat('dd-MM-yyyy');
  var now = new DateTime.now();
  var expdateController;
  var postdateController;
  TextEditingController title = TextEditingController();
  String get field => null;
  String  apiToken="";
  int companyId;
  String   _chosenValue;
  DateTime selectedDate = DateTime.now();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    expdateController = formatter.format(now);
    postdateController = formatter.format(now);
    radiovalues=0;
    selected=groupedvalue.insecure;
      }
  Future postdata(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString('apiToken');
    companyId = prefs.getInt('companyId');
    final url=(Uri.parse("http://api.lcsbridge.xyz/jobs/upload/save/272?api_token=${apiToken}&company_id=${companyId}&domain=apex"));
    http.MultipartRequest request = new http.MultipartRequest('POST', url);
    request.fields['service_id'] = "1";
    request.fields['title'] = "${title.text}";
    request.fields['posting_date'] = "$postdateController";
    request.fields['expiry_date'] = "$expdateController";
    request.fields['privacy'] = "$radiovalues";
    // ignore: deprecated_member_use
    List<MultipartFile> newList = new List<MultipartFile>();
    for (int i = 0; i < files.length; i++) {
      File file = File(files[i].path);
      // ignore: deprecated_member_use
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFiles = new http.MultipartFile(
          "file[]",
           stream,
           length,
           filename: path.basename(file.path));
           newList.add(multipartFiles);
    }
    request.files.addAll(newList);
    var response = await request.send();
    if (response.statusCode == 200)
    {
      print(" Uploaded Successful");
    }
    else
      {
      print("Upload Failed.....!");
    }
    response.stream.transform(utf8.decoder).listen((value)
    {
      print(value);
    }
    );
  }
  showToast(String msg, {int duration, int gravity})
  {
    Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM,backgroundRadius: 2,);
  }

void fromPaths()async
  {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['jpg', 'pdf','png','jpeg'],);
    if (result != null) {
      files = result.files.cast<PlatformFile>();
      setState(() {});
      fileName =  result.files.first.name;
      print(fileName);

      for ( i=0;i<(files?.length); i++) {
      }
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black,),
        onPressed: () {
          Navigator.pop(context);
        },),
        title: Text("Files Upload", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Container(
            color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Document for Service*", style: TextStyle( fontSize: 12.0), textAlign: TextAlign.left,
                            )),
                      ),
                      Padding(
                               padding: const EdgeInsets.only(top: 8.0),
                            child:   Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white,
                                  border: Border.all(color: Colors.black26)),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      focusColor:Colors.white,
                                      value: _chosenValue,
                                      underline: Container(),
                                        elevation: 0,
                                        isExpanded: true,
                                        isDense: true,
                                      style: TextStyle(color: Colors.white),
                                      iconEnabledColor:Colors.black,
                                      items: <String>['Addhar ID','Driving Licence','PAN Card','Passport']
                                          .map<DropdownMenuItem<String>>((String data) {
                                        return DropdownMenuItem<String>(
                                          value: data,
                                          child: Text(data,style:TextStyle(color:Colors.black),),
                                        );
                                      }).toList(),
                                      hint:
                                      Text(" Select", style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w500),),
                                      onChanged: (String data) {
                                        setState(() {
                                          _chosenValue = data;
                                        });
                                      },
                                    ),
                                  )
                              ,)
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Document Title", style: TextStyle( fontSize: 12.0), textAlign: TextAlign.left,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child:    Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            //decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                             controller: title,

                              decoration: InputDecoration(border: OutlineInputBorder()),
                            ),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Posting Date", style: TextStyle( fontSize: 12.0), textAlign: TextAlign.left,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final datePick = await showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime(1900),
                                lastDate: new DateTime(2100));
                            if (datePick != null && datePick != birthDate) {
                              setState(() {
                                birthDate = datePick;
                                postdateController =
                                    new DateFormat("dd-MM-yyyy").format(birthDate);
                              });
                            }
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                border: new Border.all(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                borderRadius: BorderRadius.circular(6)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    postdateController,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Expiry Date", style: TextStyle( fontSize: 12.0), textAlign: TextAlign.left,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child:    GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final datePick = await showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime(1900),
                                lastDate: new DateTime(2100));
                            if (datePick != null && datePick != birthDate) {
                              setState(() {
                                birthDate = datePick;
                                expdateController =
                                    new DateFormat("dd-MM-yyyy").format(birthDate);
                              });
                            }
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                border: new Border.all(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                borderRadius: BorderRadius.circular(6)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    expdateController,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "File Privacy", style: TextStyle( fontSize: 12.0), textAlign: TextAlign.left,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child:    Row(
                          children: [
                            Radio(
                              value: groupedvalue.insecure,
                              groupValue: selected,
                              onChanged: (groupedvalue value) {
                                setState(() {
                                  radiovalues=0;
                                  selected=value;
                                });
                              },
                            ),
                            Text("InSecure", style: TextStyle(fontSize: 17),),
                            SizedBox(width: 40),
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: groupedvalue.secure,
                                  groupValue: selected,
                                  onChanged: (groupedvalue value) {
                                    setState(() {
                                      radiovalues=1;
                                      selected=value;
                                    });
                                  },),
                                Text("Secure", style: TextStyle(fontSize: 17),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                              child: DottedBorder(
                                color: Colors.grey,
                                dashPattern: [7.0, 7],
                                strokeWidth: 1,
                                child: Container(
                                    height: 320,
                                    width: 280.0,
                                    child:files == null?
                                    IconButton(icon: Icon(Icons.add, color: Colors.blueAccent, size: 100.0),
                                        onPressed: () async {
                                          fromPaths();
                                        }
                                    ): GestureDetector(
                                      onTap: ()async{
                                        fromPaths();
                                      },
                                      child: GridView.count(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 1,
                                        children: List.generate(files.length, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              height: 350.0,
                                              width: MediaQuery.of(context).size.width,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Center(child: Image.file(File(files[index].path), height: 100.0, width: 120.0,),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Center(child: Text(" ${path.basename(files[index].path)}", style: TextStyle(fontSize: 10.0),),),
                                                    ),

                                              ]
                                            ),
                                          ),
                                          )
                                          );
                                        }
                                        ),
                                      ),
                                    )
                                )
                                ,),
                            ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child:    GestureDetector(
                              onTap: ()async{
                                postdata(context);
                                 showToast("file Upload Sucessfully",);
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("title", title.text);
                                prefs.setString("postdate",postdateController);
                                radiovalues= 0;
                                selected = groupedvalue.insecure;
                                title.clear();
                              },
                              child: Container(
                                height: 60,  width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(130)),
                                child: Center(
                                  child: Text("Save", style: TextStyle(
                                      color: Colors.white, fontSize: 17),),
                                ),
                              ),
                            ),),
                      ),
                      SizedBox(height: 10,)
            ]
          ),
      ),
    ),
        )
      )
    );
  }
}