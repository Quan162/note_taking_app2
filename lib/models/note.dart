import 'package:flutter/material.dart'; // Dùng cho Color

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isFavorite; 

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
    this.isFavorite = false,
  });


  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isFavorite,
    Color? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Chuyển đổi từ Map (dữ liệu đọc từ DB/JSON) sang object Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      isFavorite: (json['isFavorite'] as int? ?? 0) == 1,    
    );
  }

  // Chuyển đổi từ object Note sang Map (để ghi vào DB/JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}