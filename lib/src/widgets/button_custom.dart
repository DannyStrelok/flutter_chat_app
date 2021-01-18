import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {

  final Function onPress;
  final String label;

  ButtonCustom({this.onPress, this.label = ''});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPress,
      style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>((states) => 2),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if(states.contains(MaterialState.pressed)) return Colors.blue[200];
            return Colors.blue;
          } ),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) => StadiumBorder())
      ),
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(this.label, style: TextStyle(color: Colors.white, fontSize: 18),),
        ),
      ),
    );
  }
}
