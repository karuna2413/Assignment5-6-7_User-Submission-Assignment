import 'package:flutter/material.dart';
import 'package:submissionform/userdetailsscreen.dart';
import 'package:submissionform/userform.dart';

class Landingscreen extends StatefulWidget {
  const Landingscreen({super.key});

  @override
  State<Landingscreen> createState() => _LandingscreenState();
}

class _LandingscreenState extends State<Landingscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,

          // title: Text('App'),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => Userform()));
              },
              icon: Icon(Icons.app_registration_rounded,
                  color: Colors.white, size: 20),
              label: Text('Register', style: TextStyle(color: Colors.white)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => Userdetailsscreen()));
              },
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              label: Text('UserList', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("img/img2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
