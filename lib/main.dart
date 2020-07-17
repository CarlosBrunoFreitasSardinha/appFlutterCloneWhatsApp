import 'package:flutter/material.dart';
import 'package:flutterappwhatsappcb/login/login.dart';
import 'RouteGenerator.dart';

void main() {


  runApp(
      MaterialApp(
        title: "WhatsApp Clone",
        home: Login(),
        theme: ThemeData(
          primaryColor: Color(0xff075E54),
          accentColor: Color(0xff25D366)
        ),
        // ignore: missing_return
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
  ));
}