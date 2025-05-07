import 'package:basgeo/colores.dart';
import 'package:basgeo/logica/registro.dart';
import 'package:basgeo/login/login.dart';
import 'package:basgeo/notificaciones.dart';
import 'package:basgeo/principal/principal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'customTextField.dart';

class Registrarse extends StatelessWidget {
  final Notificaciones _notificaciones = Notificaciones();
  @override
  Widget build(BuildContext context) {
    final _providerRegistro = Provider.of<Registro>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colores.colorTarjetas,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Crear Cuenta",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Regístrate para continuar",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 20),

                        // Campo Nombre
                        CustomTextField(
                          label: "Nombre",
                          icon: Icons.person,
                          onChanged: (value) =>
                              _providerRegistro.setNombre(value),
                        ),
                        SizedBox(height: 15),

                        // Campo Apellidos
                        CustomTextField(
                          label: "Apellidos",
                          icon: Icons.person_outline,
                          onChanged: (value) =>
                              _providerRegistro.setApellidos(value),
                        ),
                        SizedBox(height: 15),

                        // Campo Zona
                        CustomTextField(
                          label: "Zona",
                          icon: Icons.location_on,
                          onChanged: (value) =>
                              _providerRegistro.setZona(value),
                        ),
                        SizedBox(height: 15),

                        // Campo Correo
                        CustomTextField(
                          label: "Correo Electrónico",
                          icon: Icons.email,
                          onChanged: (value) =>
                              _providerRegistro.setCorreo(value),
                        ),
                        SizedBox(height: 15),

                        // Campo Contraseña
                        CustomTextField(
                          label: "Contraseña",
                          icon: Icons.lock,
                          obscureText: true,
                          onChanged: (value) =>
                              _providerRegistro.setContrasena(value),
                        ),
                        SizedBox(height: 25),

                        // Botón de Registro
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final resultado =
                                  await _providerRegistro.registrarUsuario();
                              if (resultado['codigo'] == 200) {
                                if (context.mounted) {
                                  _notificaciones.mensajeExito(
                                      context,
                                      "Registro Exitoso",
                                      "El usuario se registró correctamente");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                }
                              } else {
                                if (context.mounted) {
                                  _notificaciones.mensajeError(context,
                                      "Hubo un error", resultado['mensaje']);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Registrarse",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Ya tienes cuenta? Iniciar sesión
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("¿Ya tienes una cuenta? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ));
                              },
                              child: Text(
                                "Inicia Sesión",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
            Consumer<Registro>(
              builder: (context, value, child) {
                if (value.ejecutando) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3, // Puedes ajustar esto si aún se ve muy grueso
                        ),
                      ),
                    ),
                  );

                } else {
                  return SizedBox.shrink();
                }
              },
            )
          ],
        ));
  }
}
