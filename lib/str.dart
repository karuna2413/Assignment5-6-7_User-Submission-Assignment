import 'package:intl/intl.dart';

final intl = DateFormat.yMd(); //intl date format methode

class Structure {
  Structure(
      {required this.id,
      required this.name,
      required this.sname,
      required this.address,
      required this.email,
      required this.password,
      required this.date,
      required this.img});
  String? id;
  String? name;
  String? sname;
  String? address;
  String? password;
  String? email;
  DateTime? date;
  String? img;
  String get formatdate {
    return intl.format(date!);
  }
}
