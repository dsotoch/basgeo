import 'package:flutter/material.dart';
class Navegacion extends ChangeNotifier{
    int _indexActual=0;
    bool _estadoGps=false;

    set estadoGps(bool now){
      _estadoGps=now;
      notifyListeners();
    }
    bool get estadoGps =>_estadoGps;
    void setIndex(int now){
      _indexActual=now;
      notifyListeners();
    }

    int get Index =>_indexActual;
}