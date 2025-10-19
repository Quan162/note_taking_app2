import 'dart:async';
import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorBasic extends StatefulWidget {
  final Note? note;

  const NoteEditorBasic({super.key, this.note});

  @override
  State<NoteEditorBasic> createState() => _NoteEditorBasicState();
}

class _NoteEditorBasicState extends State<NoteEditorBasic> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();

  Timer? _debounce;
  String? _noteId;
  NoteProvider? _noteProvider;

  bool get _isEditing => _noteId != null;

  @override
  void initState() {
    super.initState();
    _noteId = widget.note?.id;

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _noteProvider = Provider.of<NoteProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _titleController.removeListener(_onTextChanged);
    _contentController.removeListener(_onTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      _autoSaveNote();
    });
  }

  void _autoSaveNote() {
    if (_noteProvider == null) return;

    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      if (_isEditing) {
        _noteProvider!.deleteNote(_noteId!);
        _noteId = null;
      }
      return;
    }

    if (!_isEditing) {
      final newId = _noteProvider!.addNote(title, content);
      _noteId = newId;
    } else {
      _noteProvider!.updateNote(_noteId!, title, content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        _debounce?.cancel();
        _autoSaveNote();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.note != null ? 'Chỉnh sửa Ghi chú' : 'Ghi chú mới'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          // --- CẤU TRÚC BODY THAY ĐỔI ---
          child: Column( // Giữ nguyên Column
            children: [
              TextField(
                controller: _titleController,
                autofocus: widget.note == null,
                decoration: const InputDecoration(
                  hintText: 'Tiêu đề',
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.headlineSmall,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_contentFocusNode);
                },
              ),
              const Divider(),
              Expanded( // Nội dung ghi chú vẫn chiếm phần lớn
                child: TextField(
                  controller: _contentController,
                  focusNode: _contentFocusNode,
                  decoration: const InputDecoration(
                    hintText: 'Nội dung...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              
            ],
          ),
          // --- KẾT THÚC THAY ĐỔI BODY ---
        ),
      ),
    );
  }
}