import 'package:dio/dio.dart';
import '../models/todo.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  final String _todosEndpoint = '/todos/1';

  Future<Todo> fetchTodo() async {
    try {
      Response response = await _dio.get(_todosEndpoint);
      
      return Todo.fromJson(response.data);
      
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      Response response = await _dio.get('/todos');
      
      List<dynamic> data = response.data;
      
      return data.map((json) => Todo.fromJson(json)).toList();
      
    } on DioException catch (e) {
      throw Exception('Failed to load todos: ${e.message}');
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    try {
      Response response = await _dio.post(
        '/todos',
        data: todo.toJson(), // Chuyển object → JSON
      );
      
      return Todo.fromJson(response.data);
      
    } on DioException catch (e) {
      throw Exception('Failed to create todo: ${e.message}');
    }
  }
}