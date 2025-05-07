import 'package:basgeo/colores.dart';
import 'package:flutter/material.dart';

class Consejos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tamanio = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        color: Colores.colorFondo,
        height: tamanio.height,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                '"Ser puntual al sacar tus residuos sólidos ayuda a mejorar la recolección, reduce la contaminación '
                'y evita la acumulación en los puntos de recolección."',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: tamanio.width / 2 - 16,
                        height: tamanio.height / 6,
                        child:const Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Revisa el horario de recolección",
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                      ),
                      const Positioned(
                          right: 0
                          ,child: Icon(Icons.star_border, color: Colors.yellowAccent, size: 30)),
                    ],
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: tamanio.width / 2 - 16,
                        height: tamanio.height / 6,
                        child:const Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Configura tus notificaciones",
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                      ),
                      const Positioned(
                          right: 0
                          ,child: Icon(Icons.star_border, color: Colors.yellowAccent, size: 30)),
                    ],
                  )
                ],
              ),

              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: tamanio.width / 2 - 16,
                        height: tamanio.height / 6,
                        child:const Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Organiza tus residuos con anticipación",
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                      ),
                      const Positioned(
                          right: 0
                          ,child: Icon(Icons.star_border, color: Colors.yellowAccent, size: 30)),
                    ],
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: tamanio.width / 2 - 16,
                        height: tamanio.height / 6,
                        child:const Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Evita Sacar los residuos fuera del horario",
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                      ),
                      const Positioned(
                          right: 0
                          ,child: Icon(Icons.star_border, color: Colors.yellowAccent, size: 30)),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Image.asset(
                "images/consejos.jpg",
                height: tamanio.height / 4 - 10,
                width: tamanio.width,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
