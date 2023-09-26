import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  var upd = {};
  String? err;
  List<Structure> initiallist = [];

  @override
  void initState() {
    // TODO: implement initState
    api();
    super.initState();
  }

  void api() async {
    // setState(() {
    //   isloader = true;
    // });
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
    // if(res.body=='null')
    // {
    //   setState(() {
    //     isloader=false;
    //     err ='no data found';
    //
    //   });
    //   return;
    // }
    final Map<String, dynamic> result = json.decode(res.body);

    final List<Structure> newlist = [];
    for (final user in result.entries) {
      // print('value${user.value['password']}');
      // if(user.value['email']!=widget.email)

      newlist.add(Structure(
          id: user.key,
          name: user.value['name'],
          sname: user.value['sname'],
          address: user.value['address'],
          email: user.value['email'],
          password: user.value['password'],
          date: user.value['date']));

      // else{
      //   //already exist
      // }
      // print('id${user.key}');
    }
print('list$newlist');
    setState(() {
      initiallist = newlist;
      isloader = false;
      print('newlist$initiallist');
    });
  }

  void delete(Structure dlist) {
    var url = Uri.https('user-details-14898-default-rtdb.firebaseio.com',
        '/userdata/${dlist.id}.json');
    http.delete(url);
    // setState(() {
    //   isloader = true;
    // });

    // api();
    setState(() {
      initiallist.remove(dlist);
    });
  }

  void edit(elist) async {
    var upd =
        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return Updatescreen(
          name: elist.name,
          sname: elist.sname,
          password: elist.password,
          address: elist.address,
          date: elist.date,
          email: elist.email);
    }));

    print('upd${upd['name']}');
    var url = Uri.https('user-details-14898-default-rtdb.firebaseio.com',
        '/userdata/${elist.id}.json');
    http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': upd['name'],
          'sname': upd['sname'],
          'email': upd['email'],
          'address': upd['address'],
          'date': upd['date'].toString(),
          'password': upd['password'],
        }));

    // final List<Structure> newlist2 = [];
    //
    // newlist2.add(Structure(
    //     id: elist.id,
    //     name: upd['name'],
    //     sname: upd['sname'],
    //     address: upd['address'],
    //     email: upd['email'],
    //     password: upd['password'],
    //     date: upd['date']));
    // // print('id${user.key}');
    //
    // setState(() {
    //   initiallist = newlist2;
    //   // print('newlist$initiallist');
    // });
    api();
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('user details')),
        body: isloader
            ? Center(child: CircularProgressIndicator())
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
                                    'Date: ${initiallist[index].date!.toString()}',
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
                                                      child: Text(
                                                        'Cancel',
                                                        style: GoogleFonts
                                                            .aBeeZee(),
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          delete(initiallist[
                                                              index]);
                                                          Navigator.pop(
                                                              context);
                                                          // Navigator.pop(context, true)
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: GoogleFonts
                                                              .aBeeZee(),
                                                        )),
                                                  ]),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.blue,
                                          )),
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
                                                      'This action will permanently edit this data',
                                                    style: GoogleFonts.aBeeZee(),

                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child:
                                                           Text('Cancel',
                                                             style: GoogleFonts.aBeeZee(),

                                                           ),
                                                    ),
                                                    SizedBox(width: 30),
                                                    TextButton(
                                                        onPressed: () {
                                                          edit(initiallist[
                                                              index]);

                                                          // Navigator.pop(context, true)
                                                        },
                                                        child:
                                                            Text('Edit',
                                                              style: GoogleFonts.aBeeZee(),

                                                            )),
                                                  ]),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue,
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
