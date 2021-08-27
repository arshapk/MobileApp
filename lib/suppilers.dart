// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/Api2.dart';
import 'model/Api3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Suppilers extends StatefulWidget {

  int companyId;
  Suppilers({Key key,this.companyId});
  @override
  _SuppilersState createState() => _SuppilersState();
}
class _SuppilersState extends State<Suppilers> {
  String  apiToken="";
  int companyId;
  Future<Toook> getdatasup()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken=prefs.getString('apiToken');
    companyId= prefs.getInt('companyId');
    String url=("http://api.lcsbridge.xyz/suppliers?api_token=$apiToken&company_id=$companyId&domain=apex");
    var response=await http.get(Uri.parse(url));
    print(url);
    if(response.statusCode==200)
    {
      return Toook.fromJson(jsonDecode(response.body));
    } else
      {
      throw Exception('Failed to load list');
      }
  }
  Future<Api3> blockeddatasup()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken=prefs.getString('apiToken');
    companyId= prefs.getInt('companyId');
    String url=("http://api.lcsbridge.xyz/suppliers?api_token=$apiToken&company_id=$companyId&domain=apex&status=1");
    var response=await http.get(Uri.parse(url));
    print(url);
    if(response.statusCode==200)
    {
      return await Api3.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load list');}
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text("Suppliers List of Items"),backgroundColor: Colors.indigo,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.cyanAccent,
            indicatorWeight: 8,
            indicatorColor: Colors.yellow,
            tabs: [
              Tab(text: "General",),
              Tab(text: "Blocked",),
            ],),),
        body: TabBarView(
          children: [
            ListView(
              children: [
                FutureBuilder(future: getdatasup(),
                    builder: (context,snapshot)
                    {
                      if (snapshot.hasData) {
                        List<General> arr=snapshot.data.general;
                        return ListView.builder(
                          itemCount: arr.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context,index)
                          {
                            return ListTile(
                              title: Text(arr[index].name.toString()),
                              subtitle: Text(arr[index].email.toString()),
                              trailing: Text(arr[index].country.toString()),);},);
                      }
                      else {
                        return Container( height: 400, width: 450,);
                      }
                    })],),
            ListView(
              children: [
                FutureBuilder(future: blockeddatasup(),
                    builder: (context,snapshot)
                    {
                      if (snapshot.hasData) {
                        List<Blocked> arr=snapshot.data.blocked;
                        return ListView.builder(
                          itemCount: arr.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context,index)
                          {
                            return ListTile(
                              title: Text(arr[index].name.toString()),
                              subtitle: Text(arr[index].email.toString()),
                              trailing: Text(arr[index].postingDate.toString()),
                            );},
                        );
                      }
                      else {return Container( height: 400, width: 450, child: Center(child: CircularProgressIndicator(),),);}
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}