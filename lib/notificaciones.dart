import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Notificaciones{

  void mensajeExito(BuildContext context,String titulo,String texto){
    toastification.show(
        title: Text(titulo ,style: TextStyle(fontWeight: FontWeight.bold),),
      description: Text(texto),
      context: context,
      type: ToastificationType.success,
      icon: Icon(Icons.check_circle),
      autoCloseDuration: Duration(seconds: 5)
    );
  }
  void mensajeError(BuildContext context,String titulo,String texto){
    toastification.show(
        title: Text(titulo ,style: TextStyle(fontWeight: FontWeight.bold),),
        description: Text(texto),
        context: context,
        type: ToastificationType.error,
        icon: Icon(Icons.error),
        autoCloseDuration: Duration(seconds: 5)
    );
  }
}