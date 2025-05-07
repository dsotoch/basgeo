import 'package:basgeo/notificaciones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Datos extends ChangeNotifier {
  String _nombres = "";
  String _apellidos = "";
  String _zona = "";
  String _tipo = "";
  late String _diaActual = diaActual();
  bool _existeHorarioHoy = false;
  late String _horaInicio = "00:00";
  late String _horaFin = "00:00";
  int _posicionDia = -1;
// Getters
  String get diaactual => _diaActual;
  String get nombres => _nombres;
  String get apellidos => _apellidos;


  set diaACtual(String dia) {
    _diaActual = dia;
    notifyListeners();
  }

  String get zona => _zona;
  String get tipo => _tipo;

  set tipo(String value) {
    if(_tipo!=value){
      _tipo = value;
      notifyListeners();
    }
  }

  // Setters
  set nombres(String value) {
    if(_nombres!=value){
      _nombres = value;
      notifyListeners();
    }
  }

  set apellidos(String value) {
    if (_apellidos != value) {
      _apellidos = value;
      notifyListeners();
    }
  }

  set zona(String value) {
    if (_zona != value) {
      _zona = value;
      notifyListeners();
    }
  }

  void setPosicionDia(int now) {
    _posicionDia = now;
    notifyListeners();
  }

  void setHoraInicio(String now) {
    _horaInicio = now;
    notifyListeners();
  }

  void setHoraFin(String now) {
    _horaFin = now;
    notifyListeners();
  }

  void setExisteHorarioHoy(bool estado) {
    _existeHorarioHoy = estado;
    notifyListeners();
  }

  bool get existeHorarioHoy => _existeHorarioHoy;
  String get horaInicio => _horaInicio;
  String get horaFin => _horaFin;
  int get posicionDia => _posicionDia;
  final Notificaciones _notificaciones = Notificaciones();
  Future<void> obtenerHorario() async {
    try {
      final db = FirebaseFirestore.instance;

      List<String> diasSemana = [
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo'
      ];

      // Obtener todas las colecciones en paralelo
      List<Future<QuerySnapshot>> consultas = diasSemana.map((dia) {
        return db
            .collection("horarios")
            .doc("doc_horario")
            .collection(dia)
            .get();
      }).toList();

      List<QuerySnapshot> resultados = await Future.wait(consultas);
      String dia_actual = diaActual();
      _diaActual = dia_actual;

      for (int i = 0; i < diasSemana.length; i++) {
        String dia = diasSemana[i];
        QuerySnapshot snapshot = resultados[i];

        if (snapshot.docs.isNotEmpty) {
          if (!_existeHorarioHoy) {
            bool horarioEncontrado = snapshot.docs.any((doc) {
              var data = doc.data() as Map<String, dynamic>?;
              return data != null &&
                  data.containsKey("estado") &&
                  data["estado"] == true &&
                  dia_actual == dia;
            });

            // Buscar la primera hora de inicio disponible
            String? horaInicio = snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>?)
                .where((data) =>
                    data != null &&
                    data.containsKey("horaInicio") &&
                    dia_actual == dia)
                .map((data) => data!["horaInicio"] as String)
                .firstOrNull; // Obtiene el primer valor válido
            String? horaFin = snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>?)
                .where((data) =>
                    data != null &&
                    data.containsKey("horaFin") &&
                    dia_actual == dia)
                .map((data) => data!["horaFin"] as String)
                .firstOrNull;
            if (horarioEncontrado) {
              setExisteHorarioHoy(true);
              if (horaInicio != null) {
                setHoraInicio(horaInicio);
              }
              if (horaFin != null) {
                setHoraFin(horaFin);
              }
              setPosicionDia(i);
            }
          }
        }
      }
    } catch (e) {
      print("❌ Error al obtener los horarios: $e");
    }
  }

  Future<void> obtenerHorarioPorDia(String dia, BuildContext context) async {
    try {
      final db = FirebaseFirestore.instance;

      QuerySnapshot snapshot = await db
          .collection("horarios")
          .doc("doc_horario")
          .collection(dia)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>?;

          if (data != null && data["estado"] == true) {
            setExisteHorarioHoy(true);
            _diaActual = dia;
            setHoraInicio(data["horaInicio"]);
            setHoraFin(data["horaFin"]);
            return; // Salimos del bucle ya que encontramos un horario válido
          }
        }
      } else {
        setExisteHorarioHoy(false);
        _diaActual = dia;
        _notificaciones.mensajeError(
            context, "Resultado", "⚠️ No hay horarios para $dia");
      }
    } catch (e) {
      setExisteHorarioHoy(false);
      _diaActual = dia;
      _notificaciones.mensajeError(
          context, "Resultado", "❌ Error al obtener los horarios de $dia: $e");
    }
  }

  String diaActual() {
    DateTime now = DateTime.now();
    List<String> diasSemana = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];

    return diasSemana[now.weekday - 1];
  }
}
