import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/Api2.dart';
import 'model/Api3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/CustomerService.dart';
class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
 }
class _CustomersState extends State<Customers>with SingleTickerProviderStateMixin
{
  ScrollController _controller;
  String  apiToken="";
  int companyId;
  var customerGeneral;
  var customerBlocked;
  int countGeneral = 0;
  int countBlocked = 0;
  int blockedLimit = 0;
  int generallimit = 0;

  @override
  void initState() {
    super.initState();
    generallimit = 0;
    blockedLimit = 0;
    setState(() {});
  }
  // getdata()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   apiToken=prefs.getString('apiToken');
  //   companyId= prefs.getInt('companyId');
  //   String url=("http://api.lcsbridge.xyz/customers?api_token=$apiToken&company_id=$companyId&domain=apex&limit=60");
  //   var response=await http.get(Uri.parse(url));
  //   print(url);
  //   customerGeneral = response.body;
  //   print(customerGeneral);
  //   setState(()
  //   {
  //     generallimit = customerGeneral["limit"];
  //     print(generallimit);
  //   }
  //   );
  //   if(response.statusCode==200)
  //   {
  //     return Toook.fromJson(jsonDecode(response.body));
  //   } else
  //   {
  //     throw Exception('Failed to load list');
  //   }
  //   }
  getdata()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken=prefs.getString('apiToken');
    companyId= prefs.getInt('companyId');
    String url=("http://api.lcsbridge.xyz/customers?api_token=${apiToken}&company_id=${companyId}&domain=apex&limit=$generallimit");
    var response=await http.get(Uri.parse(url));
     customerGeneral = response.body;
       print(customerGeneral);
     //  customerGeneral["limit"];
    // generallimit = customerGeneral["limit"];
    // print(generallimit);
    if(response.statusCode==200)
    {
    final  result=  Toook.fromJson(jsonDecode(response.body));
     return result;
    }
    else
    {
      throw Exception('Failed to load list');
    }
  }
  blockeddata()async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     apiToken=prefs.getString('apiToken');
     companyId= prefs.getInt('companyId');
     String url=("http://api.lcsbridge.xyz/customers?api_token=${apiToken}&company_id=${companyId}&domain=apex&status=1");
     var response=await http.get(Uri.parse(url));
     if(response.statusCode==200)
     {
       return await Api3.fromJson(jsonDecode(response.body));
     }
     else
       {
       throw Exception('Failed to load list');
       }
   }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
      Scaffold(
        appBar: AppBar(title: Text("Customer List of Items"),backgroundColor: Colors.indigo,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.cyanAccent,
            indicatorWeight: 8,
            indicatorColor: Colors.yellow,
            tabs: [
              Tab(text: "General",),
              Tab(text: "Blocked",),
            ],),
        )
       , body: TabBarView(
          children: [
            ListView(
                      children: [
                  FutureBuilder(future: getdata(),
                       builder: (context, snapshot) {
                         if (snapshot.hasData) {
                           List<General> arr = snapshot.data.general;
                           return ListView.builder(
                             itemCount:  arr.length,
                             shrinkWrap: true,
                             controller: _controller,
                             scrollDirection: Axis.vertical,
                             physics: ScrollPhysics(),
                             primary: true,
                             itemBuilder: (context, index) {
                               return GestureDetector(
                                 onTap: () {},
                                 child: ListTile(
                                   leading: Text(arr[index].id.toString()),
                                   title: Text(arr[index].name.toString()),
                                   subtitle: Text(arr[index].email.toString()),
                                   trailing: Text(arr[index].country.toString()),),
                               );
                             },);
                         }
                         else {
                           return Container(height: 400, width: 450,);
                         }
                       }
                   ),
      ]
               ),

            ListView(
              children: [
                FutureBuilder(future: blockeddata(),
                    builder: (context,snapshot)
                    {
                      if (snapshot.hasData) {
                        List<Blocked> arr=snapshot.data.blocked;
                        return ListView.builder(
                          itemCount: arr.length,
                          shrinkWrap: true,
                          controller: _controller,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          itemBuilder: (context,index)
                          {
                            return GestureDetector(
                              onTap: (){
                              },
                              child: ListTile(
                                title: Text(arr[index].name.toString()),
                                subtitle: Text(arr[index].email.toString()),
                                trailing: Text(arr[index].postingDate.toString()),
                              ),
                            );
                            },
                        );
                      }
                      else {return Container( height: 400, width: 450, child: Center(child: CircularProgressIndicator(),),);}
                    })
              ],
            ),
          ],
        ),
      )
    );
  }
}