class Env {
  static final Env _instancia = Env._internal();

  factory Env() {
    return _instancia;
  }

  Env._internal();

  String baseUrl = 'http://192.168.1.103:8000';
}
