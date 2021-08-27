// ignore_for_file: must_be_immutable
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:token/feedback.dart';
import 'package:token/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:token/suppilers.dart';
import 'package:token/uploadss.dart';
import 'cust.dart';
import 'customers.dart';
import 'ex.dart';
import 'files list.dart';
import 'model/CustomerService.dart';

class Apifetch extends StatefulWidget {

    String email,name;
    int companyId;
    Apifetch({Key key,this.name,this.companyId,this.email});
    @override
    _ApifetchState createState() => _ApifetchState();
    }
class _ApifetchState extends State<Apifetch> {

  File imageFile;
      _getFromGallery()async{
           // ignore: deprecated_member_use
           PickedFile pf=await ImagePicker().getImage(source: ImageSource.gallery, maxHeight: 100,maxWidth: 100);
          if(pf!=null)
                 {setState(() {imageFile = File(pf.path);});}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Dashboard"),backgroundColor: Colors.indigo,),
      drawer: Drawer(
        child:  Container(
          height: 300,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 200,
                child:UserAccountsDrawerHeader(
                  decoration:BoxDecoration(color: Colors.blueGrey),
                  accountName:Text(widget.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black87),),
                  accountEmail:Text(widget.email,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black87),),
                  currentAccountPicture: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 100.0,
                        child: ClipRRect(
                          child: (imageFile != null) ? Image.file(imageFile,fit: BoxFit.cover,) : Image.asset('images/jh.png'), borderRadius: BorderRadius.circular(100.0,),
                        ),),
                      Positioned(
                          top: 38,
                          left: 44,
                          child:CircleAvatar(
                              radius: 15,
                              child:InkWell(onTap: (){_getFromGallery();},
                                  child: Icon(Icons.camera_alt_rounded))) )
                    ],
                  ),
                ),),
              ListTile(
                leading:Icon( Icons.person, ),
                title: Text('Customers',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Homecust()));},),
              ListTile(
                leading:Icon( Icons.people_sharp, ),
                title: Text('Suppliers',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Suppilers()));},),
              ListTile(
                leading:Icon( Icons.feedback, ),
                title: Text('Feedback',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Feedbacks()));},),
              ListTile(
                leading:Icon( Icons.upload, ),
                title: Text('Files Upload',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Uploadjobdetails()));},),
              ListTile(
                leading:Icon( Icons.list, ),
                title: Text('File List',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Filelist()));},),
              ListTile(
                leading:Icon( Icons.logout, ),
                title: Text('Logout',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));},
              ),
              ListTile(
                leading:Icon( Icons.logout, ),
                title: Text('index',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
              //  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerPage()));},
              ),
              // ListTile(
              //   leading:Icon( Icons.logout, ),
              //   title: Text('hoome',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
              //
              // ),
            ],
          ),),
      ),
      body: Center(child: Text(widget.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
    );
  }
}