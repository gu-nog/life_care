import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(width, height / 10),
            child: Container(
              color: Color.fromRGBO(240, 45, 58, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 20
                      ),
                      child: Image.asset(
                          'assets/logo.png',
                          width: height/10 - 20
                      ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        right: 12
                      ),
                      child: IconButton(
                          onPressed: () {
                            print("helo");
                          },
                          icon: const Icon(
                              Icons.settings,
                              size: 37,
                              color: Color.fromRGBO(239, 246, 238, 1)
                          )
                      ),
                  )
                ],
              ),
            )
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Color.fromRGBO(239, 246, 238, 1),
            selectedFontSize: 16,
            currentIndex: _currentIndex,
            backgroundColor: const Color.fromRGBO(240, 45, 58, 1),
            unselectedLabelStyle: GoogleFonts.ubuntu(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700
              )
            ),
            items: const [
              BottomNavigationBarItem(
                  label: 'schedule',
                  icon: Icon(
                      Icons.alarm,
                      color: Color.fromRGBO(239, 246, 238, 1),
                      size: 37
                  )
              ),
              BottomNavigationBarItem(
                  label: 'add',
                  icon: Icon(
                      Icons.add_circle_outline,
                      color: Color.fromRGBO(239, 246, 238, 1),
                      size: 37
                  )
              ),
              BottomNavigationBarItem(
                  label: 'calendar',
                  icon: Icon(
                      Icons.calendar_month,
                      color: Color.fromRGBO(239, 246, 238, 1),
                      size: 37
                  )
              )
            ],
          ),
        )
    );
  }
}

