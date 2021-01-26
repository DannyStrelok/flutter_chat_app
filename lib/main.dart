import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/routes/routes.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // showPerformanceOverlay: true,
        title: 'Material App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
