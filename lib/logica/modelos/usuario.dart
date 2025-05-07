class UsuarioModelo {
  final String nombre;
  final String apellidos;
  final String tipo;
  final String direccion;
  final String token;
  final String email;
  final String password;
  final String name;
  UsuarioModelo(
      {required this.password,
      required this.name,
      required this.nombre,
      required this.apellidos,
      required this.tipo,
      required this.direccion,
      required this.token,
      required this.email});

  // Método para convertir desde JSON a UsuarioModelo
  factory UsuarioModelo.fromJson(Map<String, dynamic> json) {
    return UsuarioModelo(
        nombre: json['nombre'] ?? '',
        apellidos: json['apellidos'] ?? '',
        tipo: json['tipo'] ?? '',
        direccion: json['direccion'] ?? '',
        token: json['token'] ?? '',
        email: '',
        password: '',
        name: '');
  }

  // Método para convertir UsuarioModelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'tipo': tipo,
      'direccion': direccion,
      'token': token,
      'name':name,
      'email':email,
      'password':password
    };
  }
}
