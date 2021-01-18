import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final FocusNode _focusNode = new FocusNode();
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                'DH',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Daniel Hoyas Martín-Caro',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, i) => Text('$i'),
              reverse: true,
            )),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      height: 50,
      child: Row(
        children: [
          Flexible(
              fit: FlexFit.tight,
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  if (text.trim().length > 0) {
                    if (!_isTyping) {
                      setState(() {
                        _isTyping = true;
                      });
                    }
                  } else {
                    if (_isTyping) {
                      setState(() {
                        _isTyping = false;
                      });
                    }
                  }
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Escribe un mensaje',
                ),
                focusNode: _focusNode,
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _isTyping
                        ? () =>
                            _handleSubmit(_textEditingController.text.trim())
                        : null,
                  )
                : IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      onPressed: _isTyping
                          ? () =>
                              _handleSubmit(_textEditingController.text.trim())
                          : null,
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    print(text);
    _textEditingController.clear();
    _focusNode.requestFocus();
    setState(() {
      _isTyping = false;
    });
  }
}
