import 'package:basgeo/logica/anclaGps.dart';
import 'package:basgeo/logica/datos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class Ubicacion extends StatelessWidget {
  Stream<LatLng> _getCarroLocation() async* {
    yield LatLng(-8.4144, -78.7528); // Viru, Perú
  }

  @override
  Widget build(BuildContext context) {
    final _providerGps = Provider.of<AnclaGps>(context);

    return FutureBuilder(
      future: _providerGps.getUserLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final userLocation = snapshot.data;
          return StreamBuilder<LatLng>(
            stream: _providerGps.getCarroLocation(),
            builder: (context, carroSnapshot) {
              if (!carroSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              LatLng carroLocation = carroSnapshot.data!;
              return FutureBuilder<List<LatLng>>(
                future: _providerGps.getRoute(userLocation!, carroLocation),
                builder: (context, routeSnapshot) {
                  List<LatLng> route = routeSnapshot.data ?? [];
                  return FlutterMap(
                    options: MapOptions(
                        initialCenter: carroLocation, initialZoom: 13),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
                        userAgentPackageName: 'com.techub.basgeo',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: userLocation,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              size: 30,
                            ),
                          ),
                          Marker(
                              point: carroLocation,
                              width: 40,
                              height: 40,
                            child: const Icon(
                              Icons.location_on,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                      if (route.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: route,
                              strokeWidth: 4,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                    ],
                  );
                },
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
