import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_care/database.dart';

class Drugs extends StatefulWidget {
  const Drugs({Key? key}) : super(key: key);

  @override
  State<Drugs> createState() => _DrugsState();
}

class _DrugsState extends State<Drugs> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDrugs(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, List<int>>> snapshot){
          if (snapshot.hasData) {
            List<Widget> drugs = [];
            snapshot.data?.forEach((key, value) {
              drugs.add(Container(
                height: 100,
                color: const Color.fromRGBO(239, 246, 238, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        key,
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                            color: Colors.black,
                            backgroundColor: const Color.fromRGBO(0,0,0,0)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                          onPressed: () async {
                            await deleteDrug(value);
                            setState(() {

                            });
                          },
                          icon: const Icon(Icons.delete)
                      ),
                    )
                  ],
                ),
              ));
            });
            return SingleChildScrollView(
              child: Column(
                children: drugs
              ),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
);
  }
  }
