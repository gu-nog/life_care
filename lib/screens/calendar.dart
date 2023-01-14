import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  Future<String> getData() async {
    DateTime n = DateTime.now();
    return (await getDrugsDay()).toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(snapshot.data!, style: GoogleFonts.ubuntu(fontSize: 16),),
            );
          }
          else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}

