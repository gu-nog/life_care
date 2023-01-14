import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({Key? key}) : super(key: key);

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dailyDosesController = TextEditingController();
  late DateTime _datetimeStart = DateTime.now();
  late DateTime _datetimeFinish = DateTime.now().add(
      const Duration(days: 1)
  );
  int error_size = 0;
  String errorName = "";
  String errorDoses = "";

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double appBar = height / 10;
    double bottom = 70;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      width: width,
      color: const Color.fromRGBO(246, 246, 246, 1),
      height: height-appBar-bottom-keyboard+error_size,
      child: Center(
        child: Container(
            height: height/ 2.3 + error_size,
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
                    children: [
                      SizedBox(
                        width: width/1.9,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 8),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            cursorColor: const Color.fromRGBO(240, 45, 58, 1),
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(240, 45, 58, 1)
                                  ),
                                ),
                                label: Text(
                                  "Name",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black
                                      )
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _nameController.clear();
                              _dailyDosesController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 32,
                          )
                      )
                    ],
                  ),
                ),
                ErrorMessage(txt: errorName, top: 8, bottom: 0),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: _datetimeStart,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 50)
                      ).then((value) {
                        setState(() {
                          _datetimeStart = value!;
                        });
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "First day of treatment:",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const Icon(
                                Icons.calendar_month,
                                size: 32
                            )
                          ],
                        ),
                        Text(
                            "${_datetimeStart.month}/${_datetimeStart.day}/${_datetimeStart.year}",
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
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: _datetimeFinish,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 50)
                      ).then((value) {
                        setState(() {
                          _datetimeFinish = value!;
                        });
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Last day of treatment:",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const Icon(
                                Icons.calendar_month,
                                size: 32,
                            )
                          ],
                        ),
                        Text(
                            "${_datetimeFinish.month}/${_datetimeFinish.day}/${_datetimeFinish.year}",
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
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    maxLength: 2,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.number,
                    controller: _dailyDosesController,
                    cursorColor: const Color.fromRGBO(240, 45, 58, 1),
                    decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(240, 45, 58, 1)
                          ),
                        ),
                        label: Text(
                          "Daily Doses",
                          style: GoogleFonts.ubuntu(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black
                              )
                          ),
                        )
                    ),
                  ),
                ),
                ErrorMessage(txt: errorDoses, top: 0, bottom: 8),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(240, 45, 58, 1)
                    ),
                    onPressed: () {
                      setState(() {
                        if (_nameController.text == "" || _dailyDosesController.text == "") {
                          error_size = 0;
                          if (_nameController.text == "") {
                            errorName = "Missing medicine name!";
                            error_size += 25;
                          }
                          else {
                            errorName = "";
                          }
                          if (_dailyDosesController.text == "") {
                            error_size += 25;
                            errorDoses = "Missing daily doses amount!";
                          }
                          else {
                            errorDoses = "";
                          }
                        }
                        else {
                          errorDoses = "";
                          errorName = "";
                          error_size = 0;

                          print(_nameController.text);
                          print(_datetimeStart);
                          print(_datetimeFinish);
                          print(_dailyDosesController.text);
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.next_plan_outlined,
                      size: 32.0,
                      color: Color.fromRGBO(239, 246, 238, 1),
                    ),
                    label: Text(
                        'Proceed',
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Color.fromRGBO(239, 246, 238, 1)
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}


class ErrorMessage extends StatelessWidget {

  final String txt;
  final int top;
  final int bottom;

  const ErrorMessage({Key? key, required this.txt, required this.top,
    required this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (txt != "") {
      return Padding(
        padding: EdgeInsets.only(top: top.toDouble(), bottom: bottom.toDouble()),
        child: Text(
          txt,
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: const Color.fromRGBO(240, 45, 58, 1)
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }
}


