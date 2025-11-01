import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ApiService _apiService = ApiService();
  late Future<Todo> _todoFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Hàm riêng để gọi API và gán Future
  void _fetchData() {
    _todoFuture = _apiService.fetchTodo();
  }

  /// Hàm xử lý khi nhấn nút "Retry"
  void _retryFetch() {
    setState(() {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Detail'),
      ),
      body: FutureBuilder<Todo>(
        future: _todoFuture,
        builder: (context, snapshot) {
          // Trạng thái 1: Đang loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          }

          // Trạng thái 2: Có lỗi
          else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          }

          // Trạng thái 3: Có dữ liệu
          else if (snapshot.hasData) {
            return _buildSuccessWidget(snapshot.data!);
          }

          // Trạng thái 4: Không có dữ liệu (edge case)
          else {
            return _buildNoDataWidget();
          }
        },
      ),
    );
  }

  /// Widget hiển thị khi đang tải dữ liệu
  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Widget hiển thị khi có lỗi xảy ra
  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryFetch, // Gọi hàm retry
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị khi không có dữ liệu
  Widget _buildNoDataWidget() {
    return const Center(
      child: Text('No data available'),
    );
  }

  /// Widget hiển thị khi tải dữ liệu thành công
  Widget _buildSuccessWidget(Todo todo) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // User ID
              _buildInfoRow('User ID', todo.userId.toString()),
              const SizedBox(height: 8),

              // Todo ID
              _buildInfoRow('Todo ID', todo.id.toString()),
              const SizedBox(height: 8),

              // Title
              _buildInfoRow('Title', todo.title),
              const SizedBox(height: 8),

              // Status
              _buildStatusRow(todo.completed),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget để hiển thị thông tin (giữ nguyên)
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  /// Helper widget mới để hiển thị hàng Status
  Widget _buildStatusRow(bool isCompleted) {
    return Row(
      children: [
        const Text(
          'Status: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Chip(
          label: Text(
            isCompleted ? 'Completed' : 'Pending',
            style: TextStyle(
              color: isCompleted ? Colors.green : Colors.orange,
            ),
          ),
          backgroundColor: isCompleted
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
        ),
      ],
    );
  }
}
