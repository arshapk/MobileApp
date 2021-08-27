import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fluttercard1.dart';
import 'model/Api3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Filelist extends StatefulWidget {
  const Filelist({Key key}) : super(key: key);

  @override
  _FilelistState createState() => _FilelistState();
}
class _FilelistState extends State<Filelist> {
  String  apiToken="";
  int companyId;
  Future<Filecust> getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken=prefs.getString('apiToken');
    companyId= prefs.getInt('companyId');
    String url=("http://api.lcsbridge.xyz/jobs/upload/list/272?api_token=$apiToken&company_id=$companyId&domain=apex");
    var response=await http.get(Uri.parse(url));
    if(response.statusCode==200)
    {
      return Filecust.fromJson(jsonDecode(response.body));
    } else
    {throw Exception('Failed to load list');}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {Navigator.pop(context);},),
    title: Text("Files List", style: TextStyle(color: Colors.black),),backgroundColor: Colors.indigoAccent,),
      body:  ListView(
        children: [
          FutureBuilder(future: getdata(),
              builder: (context,snapshot)
              {
                if (snapshot.hasData) {
                  List<Secured> arr=snapshot.data.secured;
                  return ListView.builder(
                    itemCount: arr.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context,index)
                    {
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>Cardsss(
                            id: arr[index].id,jobId:arr[index].jobId , size: arr[index].size,
                            postingDate: arr[index].postingDate, title: arr[index].title,
                            user_Name: arr[index].userName.toString(), file: arr[index].file,
                              )));
                        },
                        child: ListTile(
                            leading: Text(arr[index].id.toString()),
                            title: Text(arr[index].jobId.toString()),
                            subtitle: Text(arr[index].postingDate.toString()),
                            trailing: Text(arr[index].size.toString())
                        ),);
                      },
                  );
                }
                else {return Container( height: 400, width: 450,);}
              }
              )
        ],
      ),
    );
  }
}