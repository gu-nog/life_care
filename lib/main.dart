import 'package:flutter/material.dart';
import 'package:life_care/home.dart';
import 'package:life_care/notifications.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            Provider<NotificationService>(create: (context) => NotificationService())
          ],
          child: const MaterialApp(
              debugShowCheckedModeBanner: false,
            home: Home()
            )
          )
  );
}
