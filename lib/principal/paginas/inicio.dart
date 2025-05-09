import 'dart:async';

import 'package:basgeo/logica/anclaGps.dart';
import 'package:basgeo/logica/datos.dart';
import 'package:basgeo/logica/logicaNotificaciones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Inicio extends StatelessWidget {
  final String tipo;
  final LogicaNotificaciones logicaNotificaciones;
  const Inicio({required this.tipo, required this.logicaNotificaciones});
  @override
  Widget build(BuildContext context) {
    var tamanio = MediaQuery.of(context).size;
    var _providerDatos = Provider.of<Datos>(context);
    final _providerAncla = Provider.of<AnclaGps>(context);

    return
       FutureBuilder<dynamic>(future: logicaNotificaciones.iniciarAnclaGps(tipo), builder: (context, snapshot) {
         if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Obteniendo datos...",style: TextStyle(fontSize: 20),),
                  SizedBox(height: 10,),
                  CircularProgressIndicator(),
                ],
              ),
            );
         }else{
          return Container(
             child: Column(
               children: [
                 Container(
                   color: const Color.fromRGBO(41, 40, 77, 1),
                   child: Padding(
                     padding: const EdgeInsets.all(16),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text(
                           "Horarios de Recojo",
                           textAlign: TextAlign.left,
                           style: TextStyle(color: Colors.white, fontSize: 19),
                         ),
                         const SizedBox(height: 20),
                         SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                           child: FutureBuilder(
                             future: _providerDatos.obtenerHorario(),
                             builder: (context, snapshot) {
                               return snapshot.connectionState == ConnectionState.waiting
                                   ? SizedBox(
                                 width: tamanio.width,
                                 child: const LinearProgressIndicator(
                                   color: Colors.blue,
                                   minHeight: 10,
                                 ),
                               )
                                   : Row(
                                 children: List.generate(7, (index) {
                                   List<String> dias = [
                                     "Lun.", "Mar.", "Mie.", "Jue.", "Vie.", "Sab.", "Dom."
                                   ];

                                   List<String> diasFirestore = [
                                     "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
                                   ];

                                   return GestureDetector(
                                     onTap: () {
                                       _providerDatos.obtenerHorarioPorDia(diasFirestore[index], context);
                                     },
                                     child: Row(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         Container(
                                           alignment: Alignment.center,
                                           height: 100,
                                           width: (tamanio.width / 7),
                                           decoration: BoxDecoration(
                                             color: _providerDatos.posicionDia == index ? Colors.green : Colors.white,
                                             border: Border.all(color: Colors.black, width: 0.5),
                                             borderRadius: BorderRadius.circular(5),
                                           ),
                                           child: Text(
                                             dias[index],
                                             style: TextStyle(
                                               fontSize: 16,
                                               fontWeight: FontWeight.bold,
                                               color: _providerDatos.posicionDia == index ? Colors.white : Colors.black,
                                             ),
                                           ),
                                         ),
                                         const SizedBox(width: 5),
                                       ],
                                     ),
                                   );
                                 }),
                               );
                             },
                           ),
                         ),
                         const SizedBox(height: 10),
                       ],
                     ),
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.all(16),
                   child: _providerDatos.existeHorarioHoy
                       ? Column(
                     children: [
                       const Icon(Icons.error, size: 150, color: Colors.green),
                       const SizedBox(height: 10),
                       Text(
                         "Horario de recojo del día ${_providerDatos.diaactual}",
                         style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.blue, fontSize: 19),
                       ),
                       const SizedBox(height: 15),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           Column(
                             children: [
                               const Icon(Icons.access_time, color: Colors.blue),
                               Text(
                                 "Inicio: ${_providerDatos.horaInicio}",
                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                               ),
                             ],
                           ),
                           Column(
                             children: [
                               const Icon(Icons.timer_off, color: Colors.red),
                               Text(
                                 "Fin: ${_providerDatos.horaFin}",
                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ],
                   )
                       : Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Icon(Icons.error, size: 150, color: Colors.red),
                       const SizedBox(height: 10),
                       Center(
                         child: Text(
                           "El día ${_providerDatos.diaactual} no pasa el Carro recolector por tu zona.",
                           textAlign: TextAlign.center,
                           style: const TextStyle(color: Colors.red, fontSize: 19),
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           );
         }
       },
       );


  }
}
