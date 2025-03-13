import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import '../config/env.dart';

class APIService {
  late final Dio _dio;
  final _retryOptions = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  );

  APIService() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          final token = StorageService().getUserPreference('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle token expiration
            // Redirect to login
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool useCache = true,
  }) async {
    try {
      if (useCache) {
        final cachedData = await StorageService().getCachedData<T>(path);
        if (cachedData != null) {
          return cachedData;
        }
      }

      final response = await _retryOptions.retry(
        () => _dio.get(path, queryParameters: queryParameters),
        retryIf: (error) => error is DioError &&
            error.type != DioErrorType.cancel,
      );

      if (useCache) {
        await StorageService().cacheData(
          key: path,
          data: response.data,
        );
      }

      return response.data;
    } catch (e) {
      throw APIException('Failed to fetch data: $e');
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _retryOptions.retry(
        () => _dio.post(path, data: data, queryParameters: queryParameters),
        retryIf: (error) => error is DioError &&
            error.type != DioErrorType.cancel,
      );
      return response.data;
    } catch (e) {
      throw APIException('Failed to post data: $e');
    }
  }
}

class APIException implements Exception {
  final String message;
  APIException(this.message);

  @override
  String toString() => message;
} 