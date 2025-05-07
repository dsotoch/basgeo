import 'package:basgeo/logica/modelos/usuario.dart';
import 'package:basgeo/nucleo/dio.dart';
import 'package:basgeo/nucleo/env.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registro extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _ejecutando = false;
  String _nombre = '';
  String _apellidos = '';
  String _zona = '';
  String _correo = '';
  String _contrasena = '';
  String _email = '';
  String _password = '';
  String _name = '';

  // Getter y Setter para email
  String get email => _email;
  set email(String value) {
    _email = value;
  }

  // Getter y Setter para password
  String get password => _password;
  set password(String value) {
    _password = value;
  }

  // Getter y Setter para name
  String get name => _name;
  set name(String value) {
    _name = value;
  }

  // Getters para acceder a los valores
  String get nombre => _nombre;
  String get apellidos => _apellidos;
  String get zona => _zona;
  String get correo => _correo;
  String get contrasena => _contrasena;
  bool get ejecutando => _ejecutando;

  // Métodos para actualizar los valores

  set ejecutando(bool now) {
    _ejecutando = now;
    notifyListeners();
  }

  void setNombre(String value) {
    _nombre = value;
    notifyListeners();
  }

  void setApellidos(String value) {
    _apellidos = value;
    notifyListeners();
  }

  void setZona(String value) {
    _zona = value;
    notifyListeners();
  }

  void setCorreo(String value) {
    _correo = value;
    notifyListeners();
  }

  void setContrasena(String value) {
    _contrasena = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> registrarUsuario() async {
    try {
      ejecutando=true;
      final url = "${Env().baseUrl}/api/crearUsuario";
      UsuarioModelo modelo = UsuarioModelo(
          nombre: _nombre,
          apellidos: _apellidos,
          tipo: 'cliente',
          direccion: _zona,
          token: '',
          password: contrasena,
          name: "$_nombre $_apellidos",
          email: correo);
      final response = await DioObjeto().dio.post(url, data: modelo.toJson());
      final respuesta = response.data;
      return {'codigo': response.statusCode, 'mensaje': respuesta['mensaje']};

    } on DioException catch (e) {
      print(e.response?.data);
      return {
        'codigo': e.response?.statusCode,
        'mensaje': e.response?.data['mensaje']
      };
    }finally{
      ejecutando = false;
    }
  }
}
