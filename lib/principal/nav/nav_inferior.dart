import 'package:basgeo/logica/navegacion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavInferior extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
      final _providerNavegacion = Provider.of<Navegacion>(context);
    return Container(
      color: const Color.fromRGBO(41, 40, 77, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: BottomNavigationBar(
              currentIndex: _providerNavegacion.Index,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.transparent, // Se usa el color del Container padre
              type: BottomNavigationBarType.fixed,
              onTap: (value) => _providerNavegacion.setIndex(value),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
                BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Ruta"),
                BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alertas"),
              ],
            ),
          ),
        ],
      ),
    );



  }

}