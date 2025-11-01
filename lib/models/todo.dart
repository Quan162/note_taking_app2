import 'package:json_annotation/json_annotation.dart';

// Phần này cần thiết - cho generator biết file output
part 'todo.g.dart';

// Annotation báo class này cần generate serialization code
@JsonSerializable()
class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  // Factory constructor để parse JSON → Object
  // _$TodoFromJson sẽ được generate trong todo.g.dart
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  // Method để chuyển Object → JSON
  // _$TodoToJson sẽ được generate trong todo.g.dart
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}