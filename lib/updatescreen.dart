import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:submissionform/str.dart';

class Updatescreen extends StatefulWidget {
  Updatescreen(
      {required this.id,
      required this.name,
      required this.sname,
      required this.email,
      required this.address,
      required this.password,
      required this.date});
  // List initiallist;
  String id;
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
  var name1, sname1, email1, address1, password1, date1, id1;
  @override
  void initState() {
    id1 = widget.id;
    name1 = widget.name;
    sname1 = widget.sname;
    email1 = widget.email;
    date1 = widget.date;

    address1 = widget.address;
    password1 = widget.password;
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _pass = TextEditingController();

  var globalkey = GlobalKey<FormState>();
  final intl = DateFormat.yMd();
  DateTime? selecteddate;
  void showdate() async {
    final now = DateTime.now();

    final pickdate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
      initialDatePickerMode: DatePickerMode.year,
    );
    setState(() {
      selecteddate = pickdate;
    });
  }

  void savechng() {
    Navigator.pop(context);
    if (globalkey.currentState!.validate()) {
      globalkey.currentState!.save();
      if (selecteddate != null) {
        date1 = selecteddate.toString();
      }
      var url = Uri.https('user-details-14898-default-rtdb.firebaseio.com',
          '/userdata/${id1}.json');
      http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name1,
            'sname': sname1,
            'email': email1,
            'address': address1,
            'date': DateTime.parse(date1).toString(),
            'password': password1,
          }));

      Navigator.of(context).pop(true);
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit user data'),
          backgroundColor: Colors.black54,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: name1,
                        decoration: InputDecoration(
                          label: Text('FirstName'),
                        ),
                        validator: (value) {
                          if (value!.trim().length > 20) {
                            return 'name should be less than 20 characters';
                          }
                          if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value!)) {
                            return 'any special character,number,whitespace are not allowed';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          name1 = value!;
                        },
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: sname1,
                        decoration: InputDecoration(
                          label: Text('LastName'),
                        ),
                        validator: (value) {
                          if (value!.trim().length > 20) {
                            return 'lastname should be less than 20 characters';
                          }
                          if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value!)) {
                            return 'any special character,number,whitespace are not allowed';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          sname1 = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: email1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          label: Text('Email'),
                        ),
                        validator: (value) {
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                            return 'not valid';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          email1 = value!;
                        },
                      ),
                      Text(selecteddate != null
                          ? (DateFormat.yMd()
                                  .format(DateTime.parse('$selecteddate')))
                              .toString()
                          : (DateFormat.yMd().format(DateTime.parse(date1)))
                              .toString()),
                      IconButton(
                          onPressed: showdate,
                          icon: Icon(Icons.calendar_month)),
                      TextFormField(
                          initialValue: address1,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            label: Text('Address'),
                          ),
                          validator: (value) {
                            if (value!.trim().length > 20) {
                              return 'address should be less than 20 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            address1 = value!;
                          }),
                      TextFormField(
                        initialValue: password1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        // controller: _pass,
                        decoration: InputDecoration(
                          label: Text('Password'),
                        ),
                        validator: (value) {
                          var regv =
                              RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

                          if (value == null || value.trim().length < 6) {
                            return 'password should be greater than 6';
                          }
                          if (value.trim().length > 30) {
                            return 'password should be less than 30 characters';
                          }
                          if (!regv.hasMatch(value)) {
                            return 'password must include special character,numbers,uppercase&lowercase                      ';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          password1 = value!;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    title: Text(
                                      'Are you sure?',
                                    ),
                                    content: Text(
                                      'This action will permanently edit this data',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('Cancel',
                                            style: TextStyle(
                                              color: Colors.black54,
                                            )),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            savechng();
                                            // Navigator.pop(context);
                                          },
                                          child: Text('ok',
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ))),
                                    ]),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.black54, // Background color
                            ),
                            child: Text('save changes')),
                      )
                    ]),
              ))),
        ));
  }
}
