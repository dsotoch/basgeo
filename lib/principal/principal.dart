import 'package:basgeo/logica/anclaGps.dart';
import 'package:basgeo/logica/datos.dart';
import 'package:basgeo/principal/nav/drawer.dart';
import 'package:basgeo/principal/nav/nav_inferior.dart';
import 'package:basgeo/principal/paginas/alertas.dart';
import 'package:basgeo/principal/paginas/consejos.dart';
import 'package:basgeo/principal/paginas/inicio.dart';
import 'package:basgeo/principal/paginas/ubicacion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logica/navegacion.dart';

class Principal extends StatelessWidget {
  final String usuario;
  final String zona;
  final String tipo;
  final String token;
  Principal(
      {required this.usuario,
      required this.zona,
      required this.tipo,
      required this.token});

  @override
  Widget build(BuildContext context) {
    final _providerNavegacion = Provider.of<Navegacion>(context);
    final _providerDatos = Provider.of<Datos>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Hola, $usuario",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Para centrar el título correctamente
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _providerNavegacion.Index,
              children: [
                Inicio(
                  tipo: tipo,
                ),
                Ubicacion(),
                Alertas(tipo: tipo),
                Consejos(),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerNav(
        usuario: usuario,
        zona: zona,
        tipo: tipo,
        token: token,
      ),
      bottomNavigationBar: NavInferior(),
    );
  }
}
