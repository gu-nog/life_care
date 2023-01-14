import 'package:flutter/material.dart';
import 'package:life_care/database.dart';

class Drugs extends StatefulWidget {
  const Drugs({Key? key}) : super(key: key);

  @override
  State<Drugs> createState() => _DrugsState();
}

class _DrugsState extends State<Drugs> {

  @override
  Widget build(BuildContext context) {
    return const Text("drugs");
  }
}
