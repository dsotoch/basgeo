import 'package:dio/dio.dart';

class DioObjeto {
  static final DioObjeto _instancia = DioObjeto._internal();
  late final Dio dio;

  factory DioObjeto() {
    return _instancia;
  }

  DioObjeto._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }
}
