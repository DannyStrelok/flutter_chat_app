import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      title: 'Material App',
      initialRoute: 'login',
      routes: appRoutes,
    );
  }
}
