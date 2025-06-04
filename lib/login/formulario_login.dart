import 'dart:io';

import 'package:basgeo/logica/auth.dart';
import 'package:basgeo/login/registrarse.dart';
import 'package:basgeo/login/reset.dart';
import 'package:basgeo/principal/principal.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class formulario_login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _providerAuth = Provider.of<Auth>(context);

    return  Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 50),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
            children: [
              const Text(
                "BIENVENIDO",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Campo de Email
              TextFormField(
                controller: _providerAuth.emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese su correo electrónico";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Ingrese un correo válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo de Contraseña
              TextFormField(
                controller: _providerAuth.passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese su contraseña";
                  }
                  if (value.length < 6) {
                    return "La contraseña debe tener al menos 6 caracteres";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Botón de ingreso
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(41, 40, 77, 1),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await requestPermissions();

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      final loginSuccess =
                      await _providerAuth.iniciarSesionApiRest();
                      if (loginSuccess?['codigo'] != 200) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          _providerAuth.mostrarMensaje(
                              context, loginSuccess?['mensaje']);
                        }
                      } else {
                        final respuesta =
                        await _providerAuth.obtenerDatosUsuarioAutenticado(
                            loginSuccess?['token']);
                        if (respuesta?['codigo'] == 200) {
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Principal(
                                  usuario:
                                  "${respuesta?['mensaje'].nombre} ${respuesta?['mensaje'].apellidos}",
                                  zona: respuesta?['mensaje'].direccion,
                                  tipo: respuesta?['mensaje'].tipo,
                                  token: loginSuccess?['token'],
                                ),
                              ),
                            );
                          }
                        }
                      }
                    }
                  },
                  child: const Text(
                    "INGRESAR",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Opciones de recuperación y registro
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()),
                        );
                      },
                      child: const Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes una cuenta? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registrarse()),
                            );
                          },
                          child: const Text(
                            "Regístrate",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> requestPermissions() async {
    await Permission.location.request();
    await _requestLocationPermission(background: true);
  }
  Future<bool> _requestLocationPermission({bool background = false}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      // Location services is disabled.
      return false;
    }

    LocationPermission permission = await FlLocation.checkLocationPermission();
    if (permission == LocationPermission.denied) {
      // Android: ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION
      // iOS 12-: NSLocationWhenInUseUsageDescription or NSLocationAlwaysAndWhenInUseUsageDescription
      // iOS 13+: NSLocationWhenInUseUsageDescription
      permission = await FlLocation.requestLocationPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Location permission has been ${permission.name}.
      return false;
    }

    // Web: Only allow whileInUse permission.
    if (kIsWeb || kIsWasm) {
      return true;
    }

    // Android: You must request location permission one more time to access background location.
    // iOS 12-: You can request always permission through the above request.
    // iOS 13+: You can only request whileInUse permission. When the app enters the background,
    // a prompt will appear asking for always permission.
    if (Platform.isAndroid &&
        background &&
        permission == LocationPermission.whileInUse) {
      // You need a clear explanation of why your app's feature needs access to background location.
      // https://developer.android.com/develop/sensors-and-location/location/permissions#request-background-location

      // Android: ACCESS_BACKGROUND_LOCATION
      permission = await FlLocation.requestLocationPermission();

      if (permission != LocationPermission.always) {
        // Location permission must always be granted to collect location in the background.
        return false;
      }
    }

    return true;
  }

}
