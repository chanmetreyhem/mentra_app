import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: String.fromEnvironment('API_URL'),
      headers: {
        'Content-Type': 'Application/json',
        'Accept': 'Application/json',
      },
    ),
  );

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Example: attach token dynamically
          options.headers["Authorization"] = "Bearer ";
          print("➡️ Request: ${options.method} ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response: ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ Error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> getData(String endPoint) async {
    return await dio.get(endPoint);
  }

  Future<Response> postData(String endPoint, Map<String, dynamic> data) async {
    return await dio.post(endPoint, data: data);
  }
}
