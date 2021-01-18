import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String text;
  final String uuid;
  final AnimationController animationController;

  ChatMessage({@required this.text, @required this.uuid, @required this.animationController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        child: Container(
          child: this.uuid == '123' ? _ownMessage() : _othersMessage(),
        ),
      ),
    );
  }

  Widget _ownMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff4d9ef6),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),
        child: Text(this.text, style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _othersMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffe4e5e8),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, right: 50, left: 5),
        child: Text(this.text, style: TextStyle(color: Colors.black87),),
      ),
    );
  }

}
