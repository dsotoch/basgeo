import 'package:intl/intl.dart';

class NotificacionModelo {
  final String usuarioId;
  final String dia;
  final String fecha;
  final String horaPredecible;
  final String horaLlegada;

  // Constructor
  NotificacionModelo({
    required this.usuarioId,
    required this.dia,
    required this.fecha,
    required this.horaPredecible,
    required this.horaLlegada,
  });

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'dia': dia,
      'fecha': fecha,
      'hora_predecible': horaPredecible,
      'hora_llegada': horaLlegada,
    };
  }

  // Método para obtener la fecha actual
  static String diaActual() {
    final DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now); // Por ejemplo, "2025-05-08"
  }

  // Método para obtener la hora actual en formato HH:mm
  static String obtenerHora() {
    final DateTime now = DateTime.now();
    return DateFormat('HH:mm').format(now); // Por ejemplo, "14:30"
  }
}
