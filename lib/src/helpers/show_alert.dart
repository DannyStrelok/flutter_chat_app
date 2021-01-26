import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showAlert(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cerrar'),
                  elevation: 5,
                )
              ],
            ));
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(titulo),
            content: Text(subtitulo),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ));
}
