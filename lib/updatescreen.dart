import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:submissionform/str.dart';
class Updatescreen extends StatefulWidget {
  Updatescreen({required this.name,required this.sname,required this.email,required this.address,required this.password,required this.date});
  // List initiallist;
  String name;
  String sname;
  String email;
  String address;
  String password;
  String date;

  @override
  State<Updatescreen> createState() => _UpdatescreenState();
}

class _UpdatescreenState extends State<Updatescreen> {
  var name1,sname1,email1,address1,password1,date1;
@override
  void initState() {
   name1=widget.name;
   sname1=widget.sname;
   email1=widget.email;
   date1=widget.date;

   address1=widget.address;
   password1=widget.password;
  // TODO: implement initState
    super.initState();
  }
  final TextEditingController _pass = TextEditingController();

  var globalkey=GlobalKey<FormState>();
  // var name1=widget.name;
  // var sname='';
  // var email='';
  // var address='';
  // var password='';
  final intl=DateFormat.yMd();
  DateTime?selecteddate;
  void showdate()async
  {
    final now=DateTime.now();
    // final firstDate=DateTime(now.year-1,now.month,now.day);
    // final pickdate=await showDatePicker(context: context, initialDate: now, firstDate: firstDate, lastDate: now);
    final pickdate=await showDatePicker(context: context,
      initialDate: now,
      firstDate: DateTime(1800),
      lastDate: DateTime(2050),
      initialDatePickerMode: DatePickerMode.year,

    );
    setState(() {
      selecteddate=pickdate;
    });
  }
  void savechng(){
    if(globalkey.currentState!.validate()) {
      globalkey.currentState!.save();

      Navigator.of(context).pop(
          {'name':name1, 'sname':sname1, 'email':email1, 'address':address1, 'date':selecteddate.toString(), 'password':password1});
    }
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Edit user data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: globalkey,
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: name1,
                            decoration: InputDecoration(
                              label: Text('FirstName'),

                            ),
                            validator: (value){
                              if(value==null||value.length<3)
                              {
                                return 'name should be gretter than 3 characters';
                              }
                              return null;
                            },
                            onSaved: (value)
                            {
                              name1=value!;
                            },

                          ),
                          TextFormField(
                            initialValue: sname1,

                            decoration: InputDecoration(
                              label: Text('LastName'),

                            ),
                            validator: (value){
                              if(value==null||value.length<3)
                              {
                                return 'lastname should be gretter than 3 characters';
                              }
                              return null;
                            },
                            onSaved: (value)
                            {
                              sname1=value!;
                            },

                          ),
                          TextFormField(
                            initialValue: email1,

                            decoration: InputDecoration(
                              label: Text('Email'),

                            ),
                            validator: (value){
                              if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value!))
                              {
                                return 'not valid';
                              }
                              // if(value.characters!='@gmail.com')
                              //   {
                              //     return 'invalid email address';
                              //   }
                              return null;
                            },
                            onSaved: (value)
                            {
                              email1=value!;

                            },
                          ),
                          Text(selecteddate == null ? '$date1': intl.format(
                              selecteddate!))
                          ,
                          IconButton(onPressed: showdate, icon: Icon(Icons.calendar_month)),
                          TextFormField(
                              initialValue: address1,

                              decoration: InputDecoration(

                                label: Text('Address'),

                              ),
                              validator: (value){
                                if(value==null||value.length<3)
                                {
                                  return 'address must be include minimum 3 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                address1 = value!;
                              }
                          )
                          ,
                          TextFormField(
                            initialValue: password1,

                            // controller: _pass,
                            decoration: InputDecoration(
                              label: Text('Password'),

                            ),
                            validator: (value){
                              var regv=RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
                              if(value==null||value.trim().length<=6)
                              {
                                return 'password should be gretter than 6';
                              }
                              if(!regv.hasMatch(value))
                              {
                                return 'password must include special character or numbers';
                              }

                              return null;
                            },
                            onSaved: (value)
                            {

                              password1=value!;

                            },

                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(onPressed: (){
                              savechng();
                            }, child: Text('save changes')),
                          )
                        ]
                    ),
                  ))),
        )

      );

  }
}
