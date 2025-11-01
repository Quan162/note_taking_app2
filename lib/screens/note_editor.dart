import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  bool _isEditing = false;
  String? _noteId;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_initialized) {
      final note = ModalRoute.of(context)?.settings.arguments as Note?;
      
      if (note != null) {
        _isEditing = true;
        _noteId = note.id;
        _titleController.text = note.title;
        _contentController.text = note.content;
      } else {
        _isEditing = false;
      }
      
      _initialized = true;
    }
  }

  Future<void> _saveNote() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Không lưu note rỗng
    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ghi chú không thể để trống')),
      );
      return;
    }

    try {
      if (_isEditing) {
        // Update note hiện tại
        await noteProvider.updateNote(_noteId!, title, content);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật ghi chú')),
          );
        }
      } else {
        // Thêm note mới
        final noteId = await noteProvider.addNote(title, content);
        setState(() {
          _noteId = noteId;
          _isEditing = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu ghi chú mới')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu: $e')),
        );
      }
    }
  }

  Future<void> _deleteNote() async {
    if (!_isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa ghi chú này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      await noteProvider.deleteNote(_noteId!);
      
      if (mounted) {
        Navigator.pop(context); // Quay lại màn hình danh sách
      }
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Xóa ghi chú',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteNote();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Chia sẻ'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chức năng đang phát triển')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Chỉnh sửa ghi chú' : 'Ghi chú mới'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: 'Lưu',
          ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showOptionsMenu,
              tooltip: 'Tùy chọn',
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // TextField cho tiêu đề
              TextField(
                controller: _titleController,
                autofocus: !_isEditing, // Auto focus khi tạo mới
                decoration: const InputDecoration(
                  hintText: 'Tiêu đề',
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.headlineSmall,
                textCapitalization: TextCapitalization.sentences,
              ),
              
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
              
              const SizedBox(height: 16),
              
              // TextField cho nội dung
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Nội dung ghi chú...',
                    border: InputBorder.none,
                  ),
                  maxLines: null, // Cho phép nhiều dòng
                  expands: true, // Mở rộng để lấp đầy không gian
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}