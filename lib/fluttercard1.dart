import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:isolate';
import 'dart:ui';
class Cardsss extends StatefulWidget {
  int id;
  int jobId;
  String title;
  String file;
  String size;
  String postingDate;
  String user_Name;
  Cardsss({Key key,this.user_Name,this.size,this.title,this.file,this.jobId,this.postingDate,this.id});
  @override
  _CardsssState createState() => _CardsssState();
}
class _CardsssState extends State<Cardsss> {
  int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress)
  {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
    sendPort.send([id, status, progress]);
  }
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");

      _receivePort.listen((message)
    {
    // if(mounted)
      setState(() {
        progress = message[2];
     });

      print(progress);
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading:IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: () {Navigator.pop(context);},),
        title: Text("File view", style: TextStyle(color: Colors.black),), backgroundColor: Colors.indigo,),
            backgroundColor: Colors.grey,
            body:SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(25.0),),
                elevation: 10, shadowColor: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                           Padding(
                           padding: const EdgeInsets.only(top: 20.0,left: 20),
                               child: Center(
                                 child: ListTile(

                                   title: Center(child: Text(widget.user_Name,style: TextStyle(fontSize: 13),)),
                                      subtitle: Center(child: Text(widget.size)),
                                   ),
                               ),
                              ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child:Image.network(widget.file,height: 300,width: 280),),
                        Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        // ignore: deprecated_member_use
                        child:   FlatButton(
                            child: Text("Download  $progress", style: TextStyle(),),
                            color: Colors.orange,
                            textColor: Colors.white,
                            onPressed: () async
                            {
                            final status = await Permission.storage.request();
                            if (status.isGranted) {
                                final externalDir = await getExternalStorageDirectory();
                                final id = await FlutterDownloader.enqueue(
                                  url: widget.file,
                                  savedDir: externalDir.path,
                                  fileName:"Download",
                                  showNotification: true,
                                  openFileFromNotification: true,);
                            }
                            else
                              {
                              print("Permission deined");
                            }
                            }
                        ),)
                    ],
                  ),
                ),
              ),
            )
    );
  }
}