import 'package:basgeo/colores.dart';
import 'package:basgeo/logica/anclaGps.dart';
import 'package:basgeo/logica/datos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Alertas extends StatelessWidget {
  final String tipo;
  const Alertas({super.key,required this.tipo});

  String _obtenerHoraActual() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  String _obtenerHoraMenos5Minutos() {
    return DateFormat('hh:mm a').format(DateTime.now().subtract(const Duration(minutes: 5)));
  }

  @override
  Widget build(BuildContext context) {
    final tamanio = MediaQuery.of(context).size;
    final horaActual = _obtenerHoraActual();
    final horaMenos5 = _obtenerHoraMenos5Minutos();
     final _providerdatos = Provider.of<Datos>(context);
    return Container(
      child: Column(children: [
        Container(
          color: Colores.colorTarjetas,
          alignment: Alignment.center,
          height: tamanio.height / 6,
          child: const Text(
            "NOTIFICACIONES",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),

        // Notificaciones del GPS
        Consumer<AnclaGps>(
          builder: (context, providerGps, child) {
            return Column(
              children: [
                if ( tipo=='cliente' && providerGps.cincoMinutos==true)
                  _buildNotificacion(
                    icono: Icons.timer_rounded,
                    titulo: "Llegada del CAMIÓN RECOLECTOR",
                    mensaje: "En 5 minutos",
                    hora: horaMenos5,
                  ),
                if (tipo=='cliente' && providerGps.sacaBasura==true)
                  _buildNotificacion(
                    icono: Icons.taxi_alert,
                    titulo: "Saca tus RESIDUOS SÓLIDOS",
                    mensaje: "Ahora",
                    hora: horaActual,
                  ),
              ],
            );
          },
        ),

        // Mensaje para Administrador
        Consumer<Datos>(
          builder: (context, providerDatos, child) {
            return tipo == 'admin'
                ? _buildMensajeAdmin()
                : const SizedBox.shrink();
          },
        ),
      ]),
    );
  }

  /// 🔹 Widget Reutilizable para Notificaciones
  Widget _buildNotificacion({
    required IconData icono,
    required String titulo,
    required String mensaje,
    required String hora,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icono),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(mensaje),
                        Text(hora),
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

  /// 🔹 Widget Reutilizable para el Mensaje de Admin
  Widget _buildMensajeAdmin() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.blue,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "¡Atención! Maneja con cuidado y respeta las normas de tránsito 🚛💨",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
