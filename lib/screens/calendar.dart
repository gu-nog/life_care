import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_care/screens/seeDay.dart';
import 'package:table_calendar/table_calendar.dart';

import '../database.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  List<String> dates = [];
  int page = 1;

  Future<String> getData() async {
    DateTime n = DateTime.now();
    dates = await getDrugsDay();
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
    if (page == 1) {
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
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(240, 45, 58, 1)
                        ),
                        onPressed: () {
                          setState(() {
                            page = 2;
                          });
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          size: 32.0,
                          color: Color.fromRGBO(239, 246, 238, 1),
                        ),
                        label: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'See drugs on ${focus.month}/${focus.day}/${focus.year}',
                            style: GoogleFonts.ubuntu(
                                fontSize: 16,
                                color: const Color.fromRGBO(239, 246, 238, 1)
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            else {
              return Center(child: const CircularProgressIndicator());
            }
          }
      );
    }
    else {
      return seeDay(show: focus);
    }
  }
}

