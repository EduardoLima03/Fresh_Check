import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackbarCustom{
  show(BuildContext context, String mensagem, Color backgroundColor){
    ScaffoldMessenger.of(context)
        .showSnackBar( SnackBar(
      content: Text(mensagem),
      backgroundColor: backgroundColor,
    ));
  }
}