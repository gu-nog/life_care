import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_care/database.dart';

class seeDay extends StatefulWidget {

  final DateTime show;

  const seeDay({Key? key, required this.show}) : super(key: key);

  @override
  State<seeDay> createState() => _seeDayState();
}

class _seeDayState extends State<seeDay> {

  treat() async {
    List<Map<String, dynamic>> drugs = await getDrugsofDay("${widget.show.month}/${widget.show.day}/${widget.show.year}");
    Map<String, List<Map<String, dynamic>>> end = {};
    drugs.forEach((element) {
      if (!end.containsKey(element['time'])) {
        end[element['time']] = [{"name": element["drug"], "active": element["active"], "id": element["id"]}];
      }
      else {
        end[element['time']]!.add({"name": element["drug"], "active": element["active"], "id": element['id']});
      }
    });
    return end;
  }

  Future<Map<String, List<Map<String, dynamic>>>> getData() async {
    return await treat();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, List<Map<String, dynamic>>>> snapshot){
          if (snapshot.hasData) {

            final times = <Widget>[];
            snapshot.data?.forEach((key, value) {
              int hour = int.parse(key.split(':')[0]);
              int minute = int.parse(key.split(':')[1]);
              times.add(
                  Division(width: width,
                      txt: hour < 12 ? "${hour}:${minute == 0 ? '00' : minute<=9 ? '0' + minute.toString() : minute} AM"
                          : "${hour - 12}:${minute == 0 ? '00' : minute<=9 ? '0' + minute.toString() : minute} PM"
                  ));
              value.forEach((element) {
                times.add(Container(
                  width: width,
                  height: 100,
                  color: const Color.fromRGBO(239, 246, 238, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                              element["name"]!,
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                              color: Colors.black,
                              backgroundColor: Color.fromRGBO(0,0,0,0)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                              onPressed: () async {
                                await invertActivation(element['id'], context);
                                setState(() {

                                });
                              },
                              icon: element["active"] == 1 ? const Icon(
                                  Icons.alarm_sharp,
                                  size: 30
                              ) : const Icon(
                                  Icons.alarm_off,
                                size: 30,
                              )
                          ),
                        )
                      ],
                  ),
                ));
              });
            });


            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: Division(width: width, txt: "${widget.show.month}/${widget.show.day}/${widget.show.year}"),
                  ),
                  Column(
                    children: times,
                  )
                ],
              ),
            );
              // Text(snapshot.data.toString());
          }
          else {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
        }
    );
  }
}

class Division extends StatelessWidget {

  final double width;
  final String txt;

  const Division({Key? key, required this.width, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int size_text = 40 + (10 * txt.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            color: Colors.black,
            width: (width - size_text) / 2,
            height: 3,
            margin: const EdgeInsets.only(
                left: 10,
                right: 10
            )
        ),
        Text(
            txt,
            style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.w500
            )
        ),
        Container(
            color: Colors.black,
            width: (width - size_text) / 2,
            height: 3,
            margin: const EdgeInsets.only(
                left: 10,
                right: 10
            )
        ),
      ],
    );
  }
}

