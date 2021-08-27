import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class Feedbacks extends StatefulWidget {
  const Feedbacks({Key key}) : super(key: key);
  @override
  _FeedbacksState createState() => _FeedbacksState();
}
enum groupedvalue { bug, suggesstion }
class _FeedbacksState extends State<Feedbacks> {
  int radioout;
  int radiovalues=0;
  groupedvalue selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    radioout=0;
    selected=groupedvalue.bug;
  }
  String  apiToken="";
  int companyId;
  String sub="",feedbacks="";
 void getfeedback()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString('apiToken');
    companyId = prefs.getInt('companyId');
    sub = prefs.getString('subject');
    feedbacks = prefs.getString('feedback');
    String url = ("http://api.lcsbridge.xyz/feedback?api_token=${apiToken}&company_id=${companyId}&domain=apex&type=${radiovalues}&subject=${subject.text}&description=${feedback.text}");
    var response = await http.get(Uri.parse(url));
  }
    showToast(String msg, {int duration, int gravity})
    {Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM,backgroundRadius: 2,);}
    GlobalKey<FormState> key = GlobalKey<FormState>();
    TextEditingController feedback = TextEditingController();
    TextEditingController subject = TextEditingController();
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },),
          title: Text("Feedback", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,),
        body: SingleChildScrollView(
          child: Form(
            key: key,
            child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: groupedvalue.bug,
                          groupValue: selected,
                          onChanged: (value) {
                            setState(() {
                             radiovalues=0;
                             selected=value;
                            });
                          },
                        ),
                        Text("Bug", style: TextStyle(fontSize: 20),),
                        SizedBox(width: 40),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Radio(
                            value: groupedvalue.suggesstion,
                            groupValue: selected,
                            onChanged: (value) {
                                setState(() {
                                  radiovalues=1;
                                  selected=value;
                                });},),
                            Text("Suggestion", style: TextStyle(fontSize: 20),),
                          ],),
                      ],),
                    SizedBox(height: 20,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 280,
                          child: TextFormField(
                            controller: subject,
                            maxLines: 2,
                            validator: (v) {
                              if (v.isEmpty) {
                                return 'Invaild Subject';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: 'Subject',
                                border: OutlineInputBorder()),
                          ),),
                      ],),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 280,
                          child: TextFormField(
                            controller: feedback,
                            maxLines: 8,
                            validator: (v) {
                              if (v.isEmpty) {
                                return 'Invalid Feedback';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: 'Feedback',
                                border: OutlineInputBorder()),
                          ),
                        ),],
                    ),
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            getfeedback();
                            if (key.currentState.validate()) {
                              showToast("Sucessfully Sent Feedback",);
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("subject", subject.text);
                              prefs.setString("feedback", feedback.text);
                            }
                            radiovalues= 0;
                            selected = groupedvalue.bug;
                            subject.clear();
                            feedback.clear();
                          },
                          child: Container(
                            height: 50, width: 290,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(130)),
                            child: Center(
                              child: Text("Submit Feedback", style: TextStyle(
                                  color: Colors.white, fontSize: 17),),
                            ),
                          ),
                        ),
                      ],),
                  ],)
            ),
          ),
        ),
      );
    }
  }