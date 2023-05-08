import 'package:dio/dio.dart';

class ApiNewsService {
  final _baseUrl = 'https://newsapi.org/v2/';
  final Dio _dio;

  ApiNewsService(this._dio);

  Future<Map<String, dynamic>> get({required String endpoint}) async {
    var response = await _dio.get('$_baseUrl$endpoint');
    return response.data;
  }
}
