import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../database.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  List<String> dates = [];

  Future<String> getData() async {
    DateTime n = DateTime.now();
    dates = await getDrugsDay();
    await Future.delayed(const Duration(seconds: 2));
    return dates.toString();
  }

  DateTime focus = DateTime.now();

 List<String> _getDrugsfromDay(DateTime day) {
    bool has = false;
    dates.forEach((element) {
      if (element == "${day.month}/${day.day}/${day.year}") has = true;
    });
    if (has) {
      return ["event"];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  TableCalendar(
                    calendarBuilders: CalendarBuilders(
                      singleMarkerBuilder: (context, date, _) {
                        return Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(240, 45, 58, 1)
                          ), //Change color
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        );
                      },
                    ),
                    eventLoader: (day) {
                      return _getDrugsfromDay(day);
                    },
                    rowHeight: 50,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true
                    ),
                    locale: "en_US",
                    focusedDay: focus,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(DateTime.now().year + 70),
                    onDaySelected: (DateTime day, DateTime selected) {
                      setState(() {
                        focus = day;
                      });
                    },
                    selectedDayPredicate: (day) => isSameDay(day, focus),
                  ),
                ],
              ),
            );
            //   Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: Text(snapshot.data!, style: GoogleFonts.ubuntu(fontSize: 16),),
            // );
          }
          else {
            return Center(child: const CircularProgressIndicator());
          }
        }
    );
  }
}

