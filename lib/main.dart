import 'package:basgeo/colores.dart';
import 'package:basgeo/logica/anclaGps.dart';
import 'package:basgeo/logica/auth.dart';
import 'package:basgeo/logica/datos.dart';
import 'package:basgeo/logica/horario.dart';
import 'package:basgeo/logica/navegacion.dart';
import 'package:basgeo/logica/preferencias.dart';
import 'package:basgeo/logica/registro.dart';
import 'package:basgeo/login/login.dart';
import 'package:basgeo/principal/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> iniciarFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

}

Future<void> fixSSLProvider() async {
  try {
    await GoogleApiAvailability.instance.makeGooglePlayServicesAvailable();
  } catch (e) {
    print("Error al actualizar Google Play Services: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura la inicialización de Flutter
  runApp(
    AppInicializador()
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colores.colorFondo,
          useMaterial3: true,
        ),
        home: Login());
  }
}

class AppInicializador extends StatelessWidget {
  Future<void> _inicializarServicios() async {
    await Future.delayed(const Duration(seconds: 3)); // Espera 3 segundos

    await iniciarFirebase();
    await fixSSLProvider();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _inicializarServicios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splash(), // Muestra la pantalla de carga mientras inicializa
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text("❌ Error al iniciar la app")),
            ),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => Auth(context: context)),
              ChangeNotifierProvider(create: (context) => Datos()),
              ChangeNotifierProvider(create: (context) => Navegacion()),
              ChangeNotifierProvider(create: (context) => AnclaGps()),
              ChangeNotifierProvider(create: (context) => Preferencias()),
              ChangeNotifierProvider(create: (context) => Registro()),
            ],
            child: const MyApp(),
          );
        }
      },
    );
  }
}