import 'package:flutter/material.dart';

class imagen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final tamanio_pantalla= MediaQuery.of(context).size;

    return  Container(
      height: tamanio_pantalla.height/2,
      width: tamanio_pantalla.width,
      child: Image.asset('images/carrito_basura.jpg',fit: BoxFit.fitWidth,),
    );
  }

}