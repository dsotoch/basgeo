import 'dart:math';

import 'package:basgeo/logica/anclaGps.dart';
import 'package:basgeo/logica/modelos/notificacion.dart';
import 'package:basgeo/nucleo/dio.dart';
import 'package:basgeo/nucleo/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class LogicaNotificaciones {
  final String token;
  final BuildContext context;
  late final AnclaGps provider;

  // Constructor principal

  LogicaNotificaciones({required this.token, required this.context}) {
    _initializeProvider();
  }

  // Método privado para inicializar el provider
  void _initializeProvider() {
    provider = Provider.of<AnclaGps>(context);
  }

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

  static final FlutterLocalNotificationsPlugin _notificaciones =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificaciones.initialize(settings);
  }

  Future<void> mostrarNotificacion(
      String titulo, String mensaje, bool prioridad_maxima) async {
    int idAleatorio = Random().nextInt(1000000);
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'canal_id', 'Canal de Notificaciones',
      importance: prioridad_maxima ? Importance.max : Importance.high,
      priority: Priority.high,
      fullScreenIntent: prioridad_maxima ? true : false,
      playSound: true,
      enableVibration: true,
      autoCancel: prioridad_maxima ? false : true,

      styleInformation: BigTextStyleInformation(''), // Habilita texto largo
    );

    NotificationDetails detalles = NotificationDetails(android: androidDetails);

    await _notificaciones.show(idAleatorio, titulo, mensaje, detalles);
  }

  Future<void> iniciarAnclaGps(String tipo) async {
    // ✅ Ahora es un método válido
    await verificarPermisos();
    await inicializar();
    if (tipo == "cliente") {
      verificarTiempoLlegada();
      print("TIEMPO DE LLEGADAA CORRIENDO${tipo}");
    } else {
      print("TIEMPO DE LLEGADAA  NO CORRIENDO${tipo}");
    }
  }

  /// Calcula si el carro está a 5 minutos del usuario
  void verificarTiempoLlegada() async {
    try {
      const double velocidadPromedio = 30.0; // km/h
      const double minutosObjetivo = 5.0;

      // Obtener ubicación del usuario
      LatLng userLocation;
      try {
        userLocation = await provider.getUserLocation();
        print(
            "📍 Ubicación del usuario: ${userLocation.latitude}, ${userLocation.longitude}");
      } catch (e) {
        print("❌ Error al obtener la ubicación del usuario: $e");
        return;
      }

      // Escuchar cambios en la ubicación del carro recolector
      try {
        provider.getCarroLocation().listen((LatLng? carroLocation) async {
          if (carroLocation == null) {
            print("⚠️ Ubicación del carro recolector no disponible.");
            return;
          }

          // Calcular la distancia en km
          double distanciaKm;
          try {
            distanciaKm = Geolocator.distanceBetween(
                    userLocation.latitude,
                    userLocation.longitude,
                    carroLocation.latitude,
                    carroLocation.longitude) /
                1000;
          } catch (e) {
            print("❌ Error al calcular la distancia: $e");
            return;
          }

          // Calcular tiempo estimado en minutos
          double tiempoEstimadoMinutos = (distanciaKm / velocidadPromedio) * 60;

          // Notificar cuando falten menos de 5 minutos
          if (tiempoEstimadoMinutos <= minutosObjetivo &&
              !provider.cincoMinutos) {
            try {
              String fecha = NotificacionModelo.diaActual();
              String hora = NotificacionModelo.obtenerHora();
              String dia = diaActual();
              // Crear el objeto de notificación
              NotificacionModelo notificacionModelo = NotificacionModelo(
                usuarioId: token,
                dia: dia,
                fecha: fecha,
                horaPredecible: hora,
                horaLlegada: hora,
              );

              Map<String, dynamic> json = notificacionModelo.toJson();

              provider.cincoMinutos = true; // Marcamos que ya se notificó
              mostrarNotificacion("Atención 🚛",
                  "El carro recolector llegará en menos de 5 minutos.", false);

              await registrarNotificacion(json);
            } catch (e) {
              if (kDebugMode) {
                print("❌ Error al mostrar notificación de 5 minutos: $e");
              }
            }
          } else if (tiempoEstimadoMinutos > minutosObjetivo) {
            provider.cincoMinutos = false; // Reset si el carro se aleja
          }

          // Notificar cuando falten menos de 2 minutos
          if (tiempoEstimadoMinutos <= 2 && !provider.sacaBasura) {
            try {
              provider.sacaBasura = true; // Marcamos que ya se notificó
              mostrarNotificacion(
                  "Atención 🚛",
                  "Saca tu basura, el carro recolector está pasando por tu zona.",
                  true);
              await actualizarNotificacion(NotificacionModelo.obtenerHora());
              await reproducirSonido();
            } catch (e) {
              print("❌ Error al mostrar notificación de 2 minutos: $e");
            }
          } else if (tiempoEstimadoMinutos > 2) {
            provider.sacaBasura = false; // Reset si el carro se aleja
          }
        });
      } catch (e) {
        print("❌ Error al escuchar la ubicación del carro: $e");
      }
    } catch (e) {
      print("❌ Error general en verificarTiempoLlegada: $e");
    }
  }

  Future<Map<String, dynamic>> actualizarNotificacion(
      String hora_llegada) async {
    try {
      final path = "${Env().baseUrl}/api/update-noti";
      final response = await DioObjeto().dio.post(path,
          data: {'hora_llegada': hora_llegada},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      final data = response.data;
      return {"mensaje": data['mensaje'] ?? "Error Desconocido", "codigo": 200};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
            "OCURRIO UN ERROR: ${e.response?.statusCode} - ${e.response?.statusMessage}");
        print("Cuerpo de la respuestaa: ${e.response?.data}");
      }
      return {
        "mensaje": e.response?.data['mensaje'] ?? "Error Desconocido",
        "codigo": e.response?.statusCode.toString()
      };
    }
  }

  Future<Map<String, dynamic>> registrarNotificacion(
      dynamic notificacionmodelo) async {
    try {
      final path = "${Env().baseUrl}/api/guardar-noti";
      final response = await DioObjeto().dio.post(path,
          data: notificacionmodelo,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      final data = response.data;
      return {"mensaje": data['mensaje'] ?? "Error Desconocido", "codigo": 200};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
            "OCURRIO UN ERROR: ${e.response?.statusCode} - ${e.response?.statusMessage}");
        print("Cuerpo de la respuestaa: ${e.response?.data}");
      }
      return {
        "mensaje": e.response?.data['mensaje'] ?? "Error Desconocido",
        "codigo": e.response?.statusCode.toString()
      };
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

  Future<void> reproducirSonido() async {
    AudioPlayer audioPlayer = AudioPlayer();
    try {
      await audioPlayer.play(AssetSource("sonidos/sonido.mp3"));

      await audioPlayer.onPlayerComplete.first;

      if (kDebugMode) {
        print("Sonido reproducido completamente.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al reproducir el sonido: $e");
      }
    } finally {
      await audioPlayer.dispose();
      if (kDebugMode) {
        print("Recursos liberados.");
      }
    }
  }

}
