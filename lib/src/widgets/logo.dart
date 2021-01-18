import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String label;


  Logo({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/tag-logo.png'),
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              this.label,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}