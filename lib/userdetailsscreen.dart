import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:submissionform/landingscreen.dart';
import 'dart:convert';
import 'package:submissionform/str.dart';
import 'package:submissionform/updatescreen.dart';
import 'package:google_fonts/google_fonts.dart';

class Userdetailsscreen extends StatefulWidget {
  Userdetailsscreen({super.key});

  @override
  State<Userdetailsscreen> createState() => _UserdetailsscreenState();
}

class _UserdetailsscreenState extends State<Userdetailsscreen> {
  var isloader = true;

  String? err;
  List<Structure> initiallist = [];

  @override
  void initState() {
    // TODO: implement initState
    api();
    super.initState();
  }

  void api() async {
    var url = Uri.https(
        'user-details-14898-default-rtdb.firebaseio.com', '/userdata.json');
    final res = await http.get(url);
    if (res.body == 'null') {
      setState(() {
        isloader = false;
        err = 'no data found';
      });
      return;
    }
    final Map<String, dynamic> result = json.decode(res.body);

    final List<Structure> newlist = [];
    for (final user in result.entries) {
      print('value${user.value['name']}');

      newlist.add(Structure(
          id: user.key,
          name: user.value['name'],
          sname: user.value['sname'],
          address: user.value['address'],
          email: user.value['email'],
          password: user.value['password'],
          date: user.value['date'] != null
              ? DateTime.parse(user.value['date'])
              : user.value['date']));
    }

    setState(() {
      initiallist = newlist;
      print('list$newlist');
      isloader = false;
    });
  }

  void delete(Structure dlist) {
    var url = Uri.https('user-details-14898-default-rtdb.firebaseio.com',
        '/userdata/${dlist.id}.json');
    http.delete(url);

    setState(() {
      isloader = true;
      Timer(Duration(seconds: 2), () => api());
    });
  }

  void edit(elist) async {
    var istrue =
        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      var newDate = elist.date.toString();
      return Updatescreen(
          id: elist.id,
          name: elist.name,
          sname: elist.sname,
          password: elist.password,
          address: elist.address,
          date: newDate,
          email: elist.email);
    }));

    if (istrue == true) {
      setState(() {
        isloader = true;
      });
      Timer(Duration(seconds: 2), () => api());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('user details'),
          backgroundColor: Colors.black54,
        ),
        body: isloader
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.black54,
              ))
            : err != null
                ? Center(child: Text('$err!'))
                : ListView.builder(
                    itemCount: initiallist.length,
                    itemBuilder: (ctx, index) {
                      return SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${initiallist[index].name!}',
                                    style: GoogleFonts.aBeeZee(),
                                  ),
                                  Text(
                                    'Lastname: ${initiallist[index].sname!}',
                                    style: GoogleFonts.aBeeZee(),
                                  ),
                                  Text(
                                    'Address: ${initiallist[index].address!}',
                                    style: GoogleFonts.aBeeZee(),
                                  ),
                                  Text(
                                    'Date ${initiallist[index].date != null ? intl.format(initiallist[index].date!).toString() : ''}',
                                    style: GoogleFonts.aBeeZee(),
                                  ),
                                  Text(
                                    'Password: ${initiallist[index].password!}',
                                    style: GoogleFonts.aBeeZee(),
                                  ),
                                  Text(
                                    'Email: ${initiallist[index].email!}',
                                    style: GoogleFonts.aBeeZee(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                  title: Text(
                                                    'Are you sure?',
                                                    style:
                                                        GoogleFonts.aBeeZee(),
                                                  ),
                                                  content: Text(
                                                    'This action will permanently delete this data',
                                                    style:
                                                        GoogleFonts.aBeeZee(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          )),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          delete(initiallist[
                                                              index]);
                                                          Navigator.pop(
                                                              context);
                                                          // Navigator.pop(context, true)
                                                        },
                                                        child: Text('Delete',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                            ))),
                                                  ]),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.black54,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            edit(initiallist[index]);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black54,
                                          )),
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      ));
                    }));
  }
}
