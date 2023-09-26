import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart'as http;
class ApidataNotifier extends StateNotifier<Map<String,String>>{
  ApidataNotifier():super({});
  void postdata(Map value)async{
   var url=Uri.https('user-details-14898-default-rtdb.firebaseio.com','/userdata.json');
   final res= await http.post(url,
       headers:{'Content-Type':'application/json'} ,
       body: json.encode(
       {
       'Name': value['name'], 'Lastname': value['sname'], 'Email': value['email'],'Address':value['address'],'Date':value['date'],'Password':value['password']},

   ));
   // final result=json.decode(res.body);
   // state={res,...state};
   // print(res.body);
  }
}
final apidataprovider=StateNotifierProvider<ApidataNotifier,Map<String,String>>((ref){
  return ApidataNotifier();
});