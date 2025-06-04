
import 'package:flutter/material.dart';
import 'package:basgeo/login/formulario_login.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: formulario_login(),
      ),
    );

  }
}
