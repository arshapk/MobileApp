import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:token/Service/CustomerService.dart';
import 'Api2.dart';
import 'Api3.dart';

int countGeneral = 0;
int countBlocked = 0;
int currentPage =0 ;
int blockPage =0 ;
String  apiToken="";
int companyId;
int limitss;
var customerGeneral;
var customerBlocked;
List<Blocked> block = [];
List<General> datageneral = [];
class Homecust extends StatefulWidget {
  @override
  _HomecustState createState() => _HomecustState();
}

class _HomecustState extends State<Homecust> {
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
                Tab(text: "General- ${datageneral.length} / ${datageneral.length} ",),
                Tab(text: "Blocked- ${block.length} /${blockPage} ",),
              ],),
          )
          , body: TabBarView(
          children: [
            HomePage1(),
          HomePage2(),
          ],
        ),
        )
    );
  }
}

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {

  final RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController _controller;
  Future<bool> getPassengerData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage=0
      ;
    }
    else
      {
      if (currentPage >= limitss)
      {
        refreshController.loadNoData();
        return false;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken=prefs.getString('apiToken');
    companyId= prefs.getInt('companyId');
    final Uri uri = Uri.parse(
        "http://api.lcsbridge.xyz/customers?api_token=${apiToken}&company_id=${companyId}&domain=apex&limit=$currentPage");
    final response = await http.get(uri);
    if (response.statusCode == 200)
    {
      final result = Toook.fromJson(jsonDecode(response.body));
      if (isRefresh)
      {
        datageneral = result.general;
      }
      else
        {
        datageneral.addAll(result.general.take(19));
      }
      currentPage=currentPage+19;
      limitss = result.limit;
      countGeneral=result.totalGeneral;
      print(limitss);
      setState(() {});
      return true;
    }
    else
      {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async
        {
          final result = await getPassengerData(isRefresh: true);
          if (result)
          {
            refreshController.refreshCompleted();
          } else
            {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async
        {
          final result = await getPassengerData();
          if (result)
          {
            refreshController.loadComplete();
          }
          else
            {
            refreshController.loadFailed();
          }
        },
        child: ListView.separated(
          controller: _controller,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final gen = datageneral[index];
            return ListTile(
              leading: Text(gen.id.toString()),
              title: Text(gen.name.toString()),
              subtitle: Text(gen.email.toString()),
              trailing: Text(gen.country.toString()),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: datageneral.length,
        ),
      ),
    );
  }
}

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}
class _HomePage2State extends State<HomePage2> {

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> blockedData({bool isRefresh = false}) async
  {
    if (isRefresh)
    {
      blockPage=1 ;
    }
    else
    {
      if (blockPage >= limitss)
      {
        refreshController.loadNoData();
        return false;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken=prefs.getString('apiToken');
    companyId= prefs.getInt('companyId');
    final Uri uri = Uri.parse("http://api.lcsbridge.xyz/customers?api_token=${apiToken}&company_id=${companyId}&domain=apex&status=1&limit=$blockPage");
    final response = await http.get(uri);
    if (response.statusCode == 200)
    {
      final result = Api3.fromJson(jsonDecode(response.body));
      if (isRefresh)
      {
        block = result.blocked;
      }
      else
      {
        block.addAll(result.blocked);
      }
      blockPage=blockPage+19;
      limitss = result.limit;
     // print(limitss);
      setState(() {});
      return true;
    } else
    {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,

        onRefresh: () async
        {
          final result = await blockedData(isRefresh: true);
          if (result)
          {
            refreshController.refreshCompleted();
          }
          else
            {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async
        {
          final result = await blockedData();
          if (result)
          {
            refreshController.loadComplete();
          }
          else
            {
            refreshController.loadFailed();
          }
        },
        child: ListView.separated(
          itemBuilder: (context, index)
          {
            final bloack = block[index];
            return ListTile(
              leading: Text(bloack.id.toString()),
              title: Text(bloack.name.toString()),
              subtitle: Text(bloack.email.toString()),
              trailing: Text(bloack.country.toString()),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: block.length,
        ),
      ),
    );
  }
}