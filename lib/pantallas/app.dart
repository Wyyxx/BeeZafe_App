import 'package:beezafe_mvl/pantallas/register.dart';
import 'package:beezafe_mvl/pantallas/login.dart';
import 'package:flutter/material.dart';

import 'landing.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bee Zafe',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
      },
    );
  }
}