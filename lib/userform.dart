import 'package:flutter/material.dart';
import 'package:submissionform/userdetailsscreen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:submissionform/str.dart';

import 'dart:io';

class Userform extends StatefulWidget {
  const Userform({super.key});

  @override
  State<Userform> createState() => _UserformState();
}

class _UserformState extends State<Userform> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  var globalkey = GlobalKey<FormState>();
  var name = '';
  var sname = '';
  var email = '';
  var address = '';
  var password = '';
  final intl = DateFormat.yMd();
  DateTime? selecteddate;
  void setvalidate() async {
    if (globalkey.currentState!.validate()) {
      globalkey.currentState!.save();
      var url = Uri.https(
          'user-details-14898-default-rtdb.firebaseio.com', '/userdata.json');
      final res = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name,
            'sname': sname,
            'email': email,
            'address': address,
            'date': selecteddate.toString(),
            'password': password,
          }));
      print(res.body);
      globalkey.currentState!.reset();
      setState(() {
        selecteddate = null;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return Userdetailsscreen();
      }));
    }
  }

  void showdate() async {
    final now = DateTime.now();
    // final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickdate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    setState(() {
      selecteddate = pickdate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Registeration form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: globalkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(labelText: "Firstname"),
                      validator: (value) {
                        if (value == '') {
                          return 'required';
                        }

                        if (value!.trim().length > 20) {
                          return 'name should be less than 20 characters';
                        }
                        if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value!)) {
                          return 'any special character,number,whitespace are not allowed';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        name = value!;
                      },
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        label: Text('LastName'),
                      ),
                      validator: (value) {
                        if (value == '') {
                          return 'required';
                        }
                        if (value!.trim().length > 20) {
                          return 'name should be less than 20 characters';
                        }

                        if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value!)) {
                          return 'any special character and numbers are not allowed';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        sname = value!;
                      },
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        label: Text('Email'),
                      ),
                      validator: (value) {
                        //email validation logic
                        if (value == '') {
                          return 'required';
                        }

                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                          return 'email not valid';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        email = value!;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0, top: 8, right: 0, bottom: 0),
                      child: Text(
                        selecteddate == null
                            ? "select date"
                            : intl.format(selecteddate!),
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ),
                    IconButton(
                        onPressed: showdate, icon: Icon(Icons.calendar_month)),
                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          label: Text('Address'),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'required';
                          }

                          if (value!.trim().length > 20) {
                            return 'address should be less than 20 characters';
                          }
                          if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value!)) {
                            return 'any special character,numbers,whitespaces are not allowed';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          address = value!;
                        }),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      controller: _pass,
                      decoration: InputDecoration(
                        label: Text('Password'),
                      ),
                      validator: (value) {
                        // var pass = value;
                        var regv =
                            RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
                        if (value == '') {
                          return 'required';
                        }
                        if (value!.trim().length < 6) {
                          return 'password should be greater than 6 characters';
                        }
                        if (value!.trim().length > 12) {
                          return 'password should be less than 12 characters';
                        }
                        if (!regv.hasMatch(value)) {
                          return 'password must include special character,numbers,lower & uppercase characters';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        password = value!;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _confirmPass,
                      decoration: InputDecoration(
                        label: Text('Confirm password'),
                      ),
                      validator: (value) {
                        if (value == '') {
                          return 're-enter password';
                        }
                        if (value != _pass.text) {
                          return 'password should be match to previous ';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setvalidate();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.black54, // Background color
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Submit'),
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              globalkey.currentState!.reset();
                              setState(() {
                                selecteddate = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.black54, // Background color
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Reset'),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
