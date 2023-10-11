import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:submissionform/userdetailsscreen.dart';

final firebase=FirebaseAuth.instance;//create obj of firebase sdk

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var email = '';
  var password = '';
  var isloader=false;

  var globalkey = GlobalKey<FormState>();
 void setvalidate()async{
   if (globalkey.currentState!.validate()) {
     globalkey.currentState!.save();
   try {
     final userlog = await firebase.signInWithEmailAndPassword(
         email: email, password: password);
     print('login$userlog');

     Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>Userdetailsscreen()));

   }
   on FirebaseAuthException catch (e) {
     if (e.code == 'user-not-found'||e.code == 'wrong-password') {

     }
     ScaffoldMessenger.of(context).clearSnackBars();
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('No user found for that email or wrong password.')),);

   //   else if (e.code == 'wrong-password') {
   //
   //   }
   // ScaffoldMessenger.of(context).clearSnackBars();
   // ScaffoldMessenger.of(context).showSnackBar(
   //   SnackBar(content: Text('Wrong password provided for that user.')),);
     // if (err.code == 'invalid-email') {}
     // ScaffoldMessenger.of(context).clearSnackBars();
     // ScaffoldMessenger.of(context).showSnackBar(
     //   SnackBar(content: Text('invalid email and password')),);
     // ScaffoldMessenger.of( context).clearSnackBars();
     // ScaffoldMessenger.of(context).showSnackBar(
     //   SnackBar(content:
     //
     //
     //       Text( 'Failed with error code: ${err.message}')),);
     // print('${err.message}');


   }
   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Login '),
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
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: true,
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
            child: Text('login'),
          )),
    ]),
    ),),),),);
  }
}
