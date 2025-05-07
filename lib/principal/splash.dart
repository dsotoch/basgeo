import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    "images/logos.png",
                    height: 150,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Cargando datos...",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(
                    color: Colors.yellowAccent,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Basgeo, Rastreo Carro Recolector.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text("Versión 1.0.0",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              )
            ],
          ),
        ));
  }
}
