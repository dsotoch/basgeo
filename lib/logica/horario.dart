import 'package:flutter/material.dart';

class Horario extends ChangeNotifier{
  String zona = "";
  TimeOfDay? horaInicio;
  TimeOfDay? horaFin;

  void setZona(String value) {
    zona = value;
    notifyListeners();
  }

  void setHoraInicio(TimeOfDay time) {
    horaInicio = time;
    notifyListeners();
  }

  void setHoraFin(TimeOfDay time) {
    horaFin = time;
    notifyListeners();
  }
}