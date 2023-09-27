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
      required this.date});
  String? id;
  String? name;
  String? sname;
  String? address;
  String? password;
  String? email;
  DateTime? date;
  String get formatdate {
    return intl.format(date!);
  }
}
