import 'package:dio/dio.dart';

class DioService {
  // Create Dio instance
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com', // API base URL
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json', // Set default headers
      },
    ),
  );

  // GET Request
  Future<Response?> getRequest(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Handle DioError here
      print('GET request error: ${e.response?.data}');
      return e.response;
    }
  }

  // POST Request
  Future<Response?> postRequest(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      // Handle DioError here
      print('POST request error: ${e.response?.data}');
      return e.response;
    }
  }

  // PUT Request
  Future<Response?> putRequest(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      // Handle DioError here
      print('PUT request error: ${e.response?.data}');
      return e.response;
    }
  }

  // DELETE Request
  Future<Response?> deleteRequest(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.delete(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      // Handle DioError here
      print('DELETE request error: ${e.response?.data}');
      return e.response;
    }
  }
}
