import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_care/database.dart';
import 'package:life_care/home.dart';
import 'package:life_care/screens/drugs.dart';


class AddTime extends StatefulWidget {

  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int dailyDoses;

  const AddTime({Key? key, required this.name, required this.startDate, required this.endDate, required this.dailyDoses}) : super(key: key);

  @override
  State<AddTime> createState() => _AddTimeState();
}

class _AddTimeState extends State<AddTime> {

  List<TimeOfDay> times = [];
  List<Widget> fields = [];

  void generateTimes () {
    for (int i=0; i<widget.dailyDoses; i++) {
      TimeOfDay t = const TimeOfDay(hour: 12, minute: 30);
      times.add(t);
    }
  }

  void clearAllTimes() {
    for (int i=0; i<widget.dailyDoses; i++) {
      TimeOfDay t = const TimeOfDay(hour: 12, minute: 30);
      times[i] = t;
    }
  }

  List<Widget> getFields() {
    if (times.isEmpty) {
      generateTimes();
    }
      List<Widget> fields = [];

      for (int f=0; f<widget.dailyDoses; f++) {
        fields.add(
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black))
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 15),
              child: GestureDetector(
                onTap: () async {
                  await showTimePicker(
                      context: context,
                      initialTime: times[f],
                      builder: (context, child) {
                    final Widget mediaQueryWrapper = MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat: false,
                      ),
                      child: child!,
                    );
                    // A hack to use the es_US dateTimeFormat value.
                    if (Localizations.localeOf(context).languageCode == 'es') {
                      return Localizations.override(
                        context: context,
                        locale: Locale('es', 'US'),
                        child: mediaQueryWrapper,
                      );
                    }
                    return mediaQueryWrapper;
                  },
                  ).then((value) {
                    setState(() {
                      times[f] = value!;
                    });
                  });
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${f+1}${f == 0 ? "st" : f == 1 ? "nd" : "th"} dose time",
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        const Icon(
                          Icons.alarm,
                          size: 32,
                        )
                      ],
                    ),
                    Text(
                        times[f].hour < 12 ? "${times[f].hour}:${times[f].minute == 0 ? '00' : times[f].minute<=9 ? '0' + times[f].minute.toString() : times[f].minute} AM"
                        : "${times[f].hour - 12}:${times[f].minute == 0 ? '00' : times[f].minute<=9 ? '0' + times[f].minute.toString() : times[f].minute} PM",
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700
                        )
                    )
                  ],
                ),
              ),
            ),
          )
        );
      }

      return fields;
    }

  @override
  Widget build(BuildContext context) {

    int used_size = 80 * this.widget.dailyDoses;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double appBar = height / 10;
    double bottom = 70;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      width: width,
      color: const Color.fromRGBO(246, 246, 246, 1),
      height: height - appBar - bottom - keyboard + used_size + 100,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height/7, bottom: height/7, left: width/8, right: width/8),
          child: Container(
            height: height / 7 + used_size,
            width: width / 1.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(232, 232, 232, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: width / 7),
                        child: Text(
                            "Time do administer",
                          style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                clearAllTimes();
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 32,
                            )
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: getFields()
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(240, 45, 58, 1)
                    ),
                    onPressed: () {
                      setState(() {
                        DateTime act = widget.startDate;
                        while (!(act.compareTo(widget.endDate.add(Duration(days: 1))) > 0)) {
                          bool added = false;
                          times.forEach((time) {
                            if (
                                act.hour == time.hour
                                && time.minute == act.minute
                                && !added) {
                              save(widget.name.toString(), "${act.hour}:${act.minute}",
                                  "${act.month}/${act.day}/${act.year}", context);
                              added = true;
                            }
                          });
                          act = act.add(const Duration(minutes: 1));
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home()
                          ), (route) => false
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 32.0,
                      color: Color.fromRGBO(239, 246, 238, 1),
                    ),
                    label: Text(
                      'Add',
                      style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          color: const Color.fromRGBO(239, 246, 238, 1)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
