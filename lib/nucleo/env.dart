class Env {
  static final Env _instancia = Env._internal();

  factory Env() {
    return _instancia;
  }

  Env._internal();

  String baseUrl = 'https://basgeo.com/apiRest/public';
}
