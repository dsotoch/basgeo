import 'package:basgeo/principal/principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basgeo/login/formulario_login.dart';
import 'package:basgeo/login/imagen.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: const Icon(
                        Icons.supervised_user_circle_rounded,
                        color: Colors.black,
                        weight: 20.0,
                        size: 150,
                      )
                  ),
                  Expanded(
                    flex: 2,
                    child: formulario_login(),
                  ),
                ],
              )
    );
  }
}
