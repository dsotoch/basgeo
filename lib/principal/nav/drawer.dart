import 'package:basgeo/colores.dart';
import 'package:basgeo/logica/anclaGps.dart';
import 'package:basgeo/logica/auth.dart';
import 'package:basgeo/logica/navegacion.dart';
import 'package:basgeo/logica/preferencias.dart';
import 'package:basgeo/login/login.dart';
import 'package:basgeo/notificaciones.dart';
import 'package:basgeo/principal/paginas/addHorarios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logica/datos.dart';

class DrawerNav extends StatelessWidget {
  final String usuario;
  final String zona;
  final String tipo;
  final String token;
  DrawerNav(
      {required this.usuario,
      required this.zona,
      required this.tipo,
      required this.token});
  @override
  Widget build(BuildContext context) {
    final _providerAuth = Provider.of<Auth>(context);
    final _providerNavegacion = Provider.of<Navegacion>(context);
    final _providerGps = Provider.of<AnclaGps>(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colores.colorTarjetas),
            child: Row(
              children: [
                const Icon(
                  Icons.supervised_user_circle_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(width: 10), // Espacio entre el icono y el texto
                Expanded(
                  // Permite que el Column tome el espacio restante
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centrar contenido verticalmente
                    children: [
                      Text(
                        "Hola, $usuario",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                          height: 5), // Espacio entre el texto y la línea
                      Container(
                        width:
                            double.infinity, // Ocupar todo el ancho disponible
                        height: 2, // Grosor de la línea
                        color: Colors.white70, // Color de la línea
                      ),
                      const SizedBox(
                          height:
                              5), // Espacio entre la línea y el siguiente texto
                      Text(
                        "Zona, $zona",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (tipo == 'admin') ...[
                  Container(
                    height: 1,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.gps_fixed,
                      color: Colors.deepPurpleAccent,
                    ),
                    subtitle: const Text(
                        "Compartir tu ubicación en tiempo real con los usuarios"),
                    title: const Text(
                      "Activar GPS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Switch(
                      value: _providerNavegacion.estadoGps,
                      onChanged: (value) async {
                        if (value) {
                          // Intentar iniciar el rastreo si el GPS está apagado
                          if (!_providerNavegacion.estadoGps) {
                            bool iniciado = await _providerGps.iniciarRastreo();
                            if (iniciado) {
                              _providerNavegacion.estadoGps = true;
                              if (context.mounted) {
                                Notificaciones().mensajeExito(
                                  context,
                                  "Confirmación",
                                  "Se empezó a compartir tu ubicación",
                                );
                              }
                            }
                          }
                        } else {
                          // Detener el rastreo si el GPS está encendido
                          _providerGps.detenerRastreo();
                          _providerNavegacion.estadoGps = false;
                          if (context.mounted) {
                            Notificaciones().mensajeExito(
                              context,
                              "Confirmación",
                              "Se dejó de compartir tu ubicación",
                            );
                          }
                        }
                      },
                    ),

                  ),
                  Container(
                    height: 1,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                ]
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Colors.grey,
                      width: 1)), // Línea separadora superior
              color: Color.fromRGBO(
                  41, 40, 77, 1), // Mismo color que el DrawerHeader
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await _providerAuth.cerrarSesion(token);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  },
                  child: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.login_outlined,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
