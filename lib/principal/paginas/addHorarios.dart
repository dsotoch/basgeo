import 'package:basgeo/colores.dart';
import 'package:basgeo/logica/horario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddHorarios extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _zonaController = TextEditingController();

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final provider = Provider.of<Horario>(context, listen: false);
      isStart ? provider.setHoraInicio(picked) : provider.setHoraFin(picked);
    }
  }

  void _showAddHorarioModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Consumer<Horario>(
            builder: (context, provider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Agregar Horario",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _zonaController,
                      decoration: InputDecoration(labelText: "Zona"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese la zona";
                        }
                        return null;
                      },
                      onChanged: provider.setZona,
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text(provider.horaInicio == null
                          ? "Seleccionar Hora de Inicio"
                          : "Hora de Inicio: ${provider.horaInicio!.format(context)}"),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context, true),
                    ),
                    ListTile(
                      title: Text(provider.horaFin == null
                          ? "Seleccionar Hora de Fin"
                          : "Hora de Fin: ${provider.horaFin!.format(context)}"),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context, false),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            provider.horaInicio != null &&
                            provider.horaFin != null) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Horario agregado correctamente")),
                          );
                        }
                      },
                      child: Text("Guardar"),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Horarios"),backgroundColor: Colores.colorFondo,foregroundColor: Colors.white,),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showAddHorarioModal(context),
          child: Text("Agregar Horario"),
        ),
      ),
    );
  }
}
