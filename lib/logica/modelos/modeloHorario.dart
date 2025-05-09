class ModeloHorario {
  final String zona;
  final String horaInicio;
  final String horaFin;
  final String estado;
  final String dia;

  ModeloHorario(
      {required this.dia,required this.zona, required this.horaInicio, required this.horaFin,required this.estado});


  Map<String, dynamic> toJson() {
    return {
      'dia':dia,
      'estado':estado,
      'zona': zona,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
    };
  }
}
