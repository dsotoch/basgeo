import 'package:basgeo/colores.dart';
import 'package:basgeo/logica/auth.dart';
import 'package:basgeo/login/login.dart';
import 'package:basgeo/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> cambiarpass = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final _providerAuth = Provider.of<Auth>(context);
    Notificaciones _notification = Notificaciones();
    var _email;
    var _pass;
    var id_usuario;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Restablecer Contraseña",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colores.colorTarjetas,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ingresa tu correo electrónico para reestablecer tu contraseña",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ValueListenableBuilder(
                  valueListenable: cambiarpass,
                  builder: (context, value, child) => value
                      ? TextFormField(
                          enabled: false,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Correo Electrónico",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (newValue) => _email = newValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Por favor, ingresa tu correo";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Ingresa un correo válido";
                            }
                            return null;
                          },
                        )
                      : TextFormField(
                          autofocus: true,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Correo Electrónico",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (newValue) => _email = newValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Por favor, ingresa tu correo";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Ingresa un correo válido";
                            }
                            return null;
                          },
                        ))
              // Campo de correo electrónico
              ,
              SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: cambiarpass,
                builder: (context, value, child) {
                  if (value) {
                    return TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Nueva  Contraseña",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (newValue) => _pass = newValue,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              SizedBox(height: 20),

              // Botón de envío
              ValueListenableBuilder(
                valueListenable: cambiarpass,
                builder: (context, value, child) {
                  if (value) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colores.colorTarjetas),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            );

                            try {
                              if (_pass == null || _pass.isEmpty) {
                                throw "Ingrese tu nueva contraseña, minimo 6 caracteres.";
                              }
                              final respuesta = await _providerAuth
                                  .cambiarPassword(id_usuario.toString(), _pass);

                              if (respuesta['codigo'] == 200) {
                                cambiarpass.value=false;
                                _notification.mensajeExito(
                                    context,
                                    "Confirmación",
                                    respuesta['mensaje']);

                              } else {
                                _notification.mensajeError(context,
                                    "Algo salió mal", respuesta['mensaje']);
                              }
                            } catch (e) {
                              print("ERROR"+e.toString());
                              _notification.mensajeError(
                                  context, "Error inesperado", e.toString());
                            } finally {
                              // Asegura que el diálogo se cierre solo si sigue abierto
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        child: ValueListenableBuilder(
                            valueListenable: cambiarpass,
                            builder: (context, value, child) => value
                                ? Text("Cambiar Contraseña")
                                : Text("Validar Datos")),
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colores.colorTarjetas),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            );

                            try {
                              if (_email == null || _email.isEmpty) {
                                throw "Ingrese un correo válido.";
                              }
                              final respuesta = await _providerAuth
                                  .restablecerPassword(_email);

                              if (respuesta['codigo'] == 200) {
                                cambiarpass.value = true;
                                id_usuario = respuesta['mensaje'];
                                _notification.mensajeExito(
                                    context,
                                    "Confirmación",
                                    "Por Favor Ingresa tu Nueva Contraseña");
                              } else {
                                cambiarpass.value = false;

                                _notification.mensajeError(context,
                                    "Algo salió mal", respuesta['mensaje']);
                              }
                            } catch (e) {
                              cambiarpass.value = false;
                              _notification.mensajeError(
                                  context, "Error inesperado", e.toString());
                            } finally {
                              // Asegura que el diálogo se cierre solo si sigue abierto
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        child: ValueListenableBuilder(
                            valueListenable: cambiarpass,
                            builder: (context, value, child) => value
                                ? Text("Cambiar Contraseña")
                                : Text("Validar Datos")),
                      ),
                    );
                  }
                },
              ),

              SizedBox(height: 20),

              // Volver al login
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ));
                },
                child: Text("Volver al inicio de sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
