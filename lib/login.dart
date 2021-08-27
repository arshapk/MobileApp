import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:token/dashboard.dart';
import 'package:token/model/Api1.dart';
import 'model/Api1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override

  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home>
{

  GlobalKey<FormState> key=GlobalKey<FormState>();
   TextEditingController emailcn=new TextEditingController();
   TextEditingController passwordcn=new TextEditingController();
   TextEditingController apexcn=new TextEditingController();
   TextEditingController apiToken=new TextEditingController();
   TextEditingController companyId=new TextEditingController();
  void storedata()async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiToken', apiToken.text);
  }
  void display() async
  {
    String url="http://api.lcsbridge.xyz/login?email=${emailcn.text}&password=${passwordcn.text}&domain=${apexcn.text}";
       //"http://api.lcsbridge.xyz/login?email=aswajith@glaubetech.com&password=123456&domain=apex";
     print(url);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200)
    {
      var jsonResponse = Loginapi.fromJson(jsonDecode(response.body));

      String apiTokens = jsonResponse.data.apiToken.toString();
      if (jsonResponse.type == 0)
      {
        print("Login failed");
        throw Exception('Failed to load list');
      }
      else
        {
          print("Login success");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String apiToken = jsonResponse.data.apiToken.toString();
          int companyId = jsonResponse.data.companyId.toInt();
          prefs.setInt('companyId', companyId);
          prefs.setString('apiToken', apiToken);
          print(apiToken);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Apifetch(name:jsonResponse.data.name, email: jsonResponse.data.email,)));
      }}}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 120,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                ],),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width:280,
                    child: TextFormField(
                      controller: emailcn,
                       validator: (v){
                      if(v.isEmpty)
                        {return "Field is empty";}
                      else
                        {return null;}},
                      decoration: InputDecoration(hintText: "Email",),
                    ),)],),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 280,
                    child: TextFormField(
                      controller: passwordcn,
                      validator: (v){
                        if(v.isEmpty)
                        {return "Field is empty";}
                        else
                          {return null;}
                      },
                      decoration: InputDecoration(hintText: "Password"),
                    ),)],),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 280,
                    child: TextFormField(
                      controller: apexcn,
                      validator: (v){
                        if(v.isEmpty)
                        {
                          return "Field is empty";
                        }
                        else
                        {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Domain"
                      ),
                    ),
                  )],),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                     onTap: ()async {
                       if(key.currentState.validate())
                       {
                         display();
                         SharedPreferences prefs = await SharedPreferences.getInstance();
                         prefs.setString("Username",emailcn.text);
                         prefs.setString("Password", passwordcn.text);
                         prefs.setString("Apex", apexcn.text);
                       }
                     },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.blueAccent),
                      child: Center(child: Text("Submit")),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}