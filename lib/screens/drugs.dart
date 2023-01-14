import 'package:flutter/material.dart';

class Drugs extends StatefulWidget {
  const Drugs({Key? key}) : super(key: key);

  @override
  State<Drugs> createState() => _DrugsState();
}

class _DrugsState extends State<Drugs> {
  @override
  Widget build(BuildContext context) {
    return Text("drugs");
  }
}
