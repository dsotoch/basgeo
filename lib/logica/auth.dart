import 'dart:developer';
import 'package:basgeo/logica/modelos/usuario.dart';
import 'package:basgeo/nucleo/dio.dart';
import 'package:basgeo/nucleo/env.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final BuildContext context;

  Auth({required this.context});

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //API REST BACKEEND LARAVEL

  Future<Map<String, dynamic>> restablecerPassword(String email) async {
    try {
      final path = "${Env().baseUrl}/api/buscarUsuario";
      final data = {
        "email": email,
      };

      final response = await DioObjeto().dio.post(path, data: data);
      final respuesta = response.data['mensaje'];
      return {'codigo': 200, 'mensaje': respuesta};
    } on DioException catch (e) {
      return {
        'codigo': 500,
        'mensaje': e.response?.data['mensaje'] ?? "Error Inesperado"
      };
    }
  }
  Future<Map<String, dynamic>> cambiarPassword(String id,String password) async {
    try {
      final path = "${Env().baseUrl}/api/reset";
      final data = {
        "id": id,
        "password":password
      };

      final response = await DioObjeto().dio.post(path, data: data);
      final respuesta = response.data['mensaje'];
      return {'codigo': 200, 'mensaje': respuesta};
    } on DioException catch (e) {
      return {
        'codigo': 500,
        'mensaje': e.response?.data['mensaje'] ?? "Error Inesperado"
      };
    }
  }

  Future<Map<String, dynamic>?> iniciarSesionApiRest() async {
    try {
      final path = "${Env().baseUrl}/api/login";
      final data = {
        "email": emailController.text,
        "password": passwordController.text
      };

      final response = await DioObjeto().dio.post(path, data: data);
      final respuesta = response.data;

      final token = respuesta['token'];
      final mensaje = respuesta['mensaje'] ?? 'Inicio de sesión exitoso';

      return {"token": token, "mensaje": mensaje, "codigo": 200};
    } on DioException catch (e) {
      return {
        "mensaje": e.response?.data['mensaje'],
        "codigo": e.response?.statusCode
      };
    }
  }

  Future<Map<String, dynamic>?> obtenerDatosUsuarioAutenticado(
      String token) async {
    try {
      final response = await DioObjeto().dio.get(
            '${Env().baseUrl}/api/usuario',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );

      final respuesta = response.data;
      print(respuesta);
      final usuarioModelo = UsuarioModelo.fromJson(respuesta['usuario']);
      return {'codigo': 200, 'mensaje': usuarioModelo};
    } on DioException catch (e) {
      print("ERROR" + e.message!);
      return {
        'codigo': e.response?.statusCode,
        'mensaje': e.response?.data['mensaje'] ?? 'ERROR DESCONOCIDO'
      };
    }
  }

  Future<Map<String, dynamic>> cerrarSesion(String token) async {
    try {
      final response = await DioObjeto().dio.post(
            '${Env().baseUrl}/api/logout',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );

      return {
        'codigo': response.statusCode,
        'mensaje': response.data['mensaje'] ?? 'Sesión cerrada',
      };
    } on DioException catch (e) {
      return {
        'codigo': e.response?.statusCode ?? 500,
        'mensaje': e.response?.data['mensaje'] ?? 'Error al cerrar sesión',
      };
    }
  }

  void mostrarMensaje(BuildContext context, String texto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.info),
        title: Text("Basgeo"),
        content: Text(
          texto,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
