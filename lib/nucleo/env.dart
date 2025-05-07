class Env {
  static final Env _instancia = Env._internal();

  factory Env() {
    return _instancia;
  }

  Env._internal();

  String baseUrl = 'http://192.168.0.109:8000';
}
