import 'dart:async';

import 'package:basgeo/logica/preferencias.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AnclaGps extends ChangeNotifier {

  final ref = FirebaseFirestore.instance
      .collection("carro_recolector")
      .doc("ubicacion");
  StreamSubscription<Position>? _suscripcionUbicacion;
  final Preferencias _preferencias = Preferencias(); // Usar una instancia fija
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _rastreoActivo = false;

  bool _cincoMinutos = false;
  bool _sacaBasura = false;

  bool get sacaBasura => _sacaBasura;
  bool get cincoMinutos => _cincoMinutos;

  set sacaBasura(bool estado) {
    if (_sacaBasura != estado) {
      _sacaBasura = estado;
      notifyListeners(); // 🔥 Asegura que la UI se actualice incluso en funciones async
    }
  }

  set cincoMinutos(bool estado) {
    if (_cincoMinutos != estado) {
      _cincoMinutos = estado;
      notifyListeners(); // 🔥 Asegura que la UI se actualice incluso en funciones async
    }
  }







  Future<void> _cargarEstadoGps() async {
    bool estadoGuardado =
        await _preferencias.loadData(); // Garantiza `false` si es null
    _rastreoActivo = estadoGuardado;
    notifyListeners();
  }

  /// 🔍 Verifica si el rastreo está activo
  set esRastreoActivo(bool estado) {
    _rastreoActivo = estado;
    _preferencias.saveData(estado);
    notifyListeners();
  }

  bool get esRastreoActivo => _rastreoActivo;

  dynamic _routePoints = null;

  set routePoints(dynamic now) {
    _routePoints = now;
    notifyListeners();
  }

  dynamic get routePoints => _routePoints;

  /// 🔍 Verifica si los permisos están concedidos
  Future<bool> verificarPermisos() async {
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        print("❌ El usuario denegó los permisos de ubicación.");
        return false;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      print("⚠️ Los permisos de ubicación están denegados permanentemente.");
      return false;
    }

    return true;
  }

  /// 📍 Inicia el rastreo de ubicación en tiempo real
  Future<bool> iniciarRastreo() async {
    bool permisos = await verificarPermisos();
    if (!permisos) return false;

    if (_suscripcionUbicacion != null) {
      print("⚠️ El rastreo ya está activo.");
      return false;
    }

    _suscripcionUbicacion = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Se actualiza cada 10 metros
      ),
    ).listen((Position position) {
      try {
        ref.set({
          "latitud": position.latitude,
          "longitud": position.longitude,
          "marca_de_tiempo": DateTime.now().millisecondsSinceEpoch,
        });
      } catch (e) {
        print("❌ Error al guardar ubicación: $e");
      }
    });

    esRastreoActivo = true;
    return true;
  }

  /// ⛔ Detiene el rastreo de ubicación
  void detenerRastreo() {
    _suscripcionUbicacion?.cancel();
    _suscripcionUbicacion = null;
    esRastreoActivo = false;
  }

  Future<LatLng> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  Stream<LatLng> getCarroLocation() {
    return ref.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        if (data.containsKey("latitud") && data.containsKey("longitud")) {
          // 🔥 Cambia a "latitud" y "longitud"
          double lat = (data["latitud"] as num).toDouble();
          double lng = (data["longitud"] as num).toDouble();
          print("📌 Ubicación actualizada: $lat, $lng");
          return LatLng(lat, lng);
        }
      }
      print("⚠️ No hay datos válidos en Firestore, devolviendo (0,0).");
      return LatLng(0, 0);
    });
  }

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url =
        "https://valhalla1.openstreetmap.de/route?json={\"locations\":[{\"lat\":${start.latitude},\"lon\":${start.longitude}},{\"lat\":${end.latitude},\"lon\":${end.longitude}}],\"costing\":\"auto\",\"directions_options\":{\"units\":\"km\"}}";

    try {
      final response = await Dio().get(url);
      final data = response.data;
      if (data["trip"]["legs"].isNotEmpty) {
        final polyline = data["trip"]["legs"][0]["shape"];
        return _decodePolyline(polyline);
      }
    } catch (e) {
      print("Error al obtener la ruta: $e");
    }

    return [];
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int result = 0, shift = 0;
      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      result = 0;
      shift = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1E6, lng / 1E6)); // Valhalla usa 1E6, no 1E5
    }

    return points;
  }


}
