import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterappwhatsappcb/login/login.dart';

import 'RouteGenerator.dart';

void main() {
  final ThemeData temaPadrao = ThemeData(
      primaryColor: Color(0xff075E54), accentColor: Color(0xff25D366));
  final ThemeData temaIOS =
      ThemeData(primaryColor: Colors.grey[200], accentColor: Color(0xff25D366));

  runApp(MaterialApp(
    title: "WhatsApp Clone",
    home: Login(),
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    // ignore: missing_return
    onGenerateRoute: RouteGenerator.generateRoute,
    initialRoute: "/",
    debugShowCheckedModeBanner: false,
  ));
}
