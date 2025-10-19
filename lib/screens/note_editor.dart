import 'dart:async';
import 'dart:convert';
import 'dart:io' as io show Directory, File;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/utils/embeds.dart';
import 'package:note_taking_app/widgets/custom_toobar.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;

  const NoteEditor({super.key, this.note});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final TextEditingController _titleController = TextEditingController();
  late QuillController _controller;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  String? _noteId;
  NoteProvider? _noteProvider;
  Timer? _debounceTimer;

  bool get _isEditing => _noteId != null;

  @override
  void initState() {
    super.initState();
    _noteId = widget.note?.id;
    _titleController.text = widget.note?.title ?? '';

    Document initialDocument;
    if (widget.note != null && widget.note!.content.isNotEmpty) {
      try {
        final decodedContent = jsonDecode(widget.note!.content) as List;
        initialDocument = Document.fromJson(decodedContent);
      } catch (e) {
        print('Lỗi giải mã nội dung note: $e. Tạo document rỗng.');
        initialDocument = Document();
      }
    } else {
      initialDocument = Document();
    }

    final config = QuillControllerConfig(
      clipboardConfig: QuillClipboardConfig(
        enableExternalRichPaste: true,
        onImagePaste: (imageBytes) async {
          if (kIsWeb) {
            return null;
          }
          final newFileName =
              'image-file-${DateTime.now().toIso8601String()}.png';
          final newPath = path.join(
            io.Directory.systemTemp.path,
            newFileName,
          );
          final file = await io.File(
            newPath,
          ).writeAsBytes(imageBytes, flush: true);
          return file.path;
        },
      ),
    );

    _controller = QuillController(
      document: initialDocument,
      selection: const TextSelection.collapsed(offset: 0),
      config: config,
    );
    
    _titleController.addListener(_onTextChanged);
    _controller.document.changes.listen((_) => _onContentChanged());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _noteProvider = Provider.of<NoteProvider>(context, listen: false);
  }

  void _onTextChanged() {
    _startDebounce();
  }

  void _onContentChanged() {
    _startDebounce();
  }

  void _startDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), _saveNote);
  }

  Future<void> _saveNote() async {
    if (_noteProvider == null) {
      print("Provider chưa sẵn sàng, không thể lưu");
      _startDebounce();
      return;
    }

    final title = _titleController.text;
    final contentJson = _controller.document.toDelta().toJson();
    final content = jsonEncode(contentJson);

    final isContentEmpty = contentJson.isEmpty ||
        (contentJson.length == 1 &&
            contentJson[0].containsKey('insert') &&
            contentJson[0]['insert'] == '\n');

    if (!_isEditing && title.isEmpty && isContentEmpty) {
      print("Note mới rỗng, không lưu.");
      return;
    }

    try {
      if (_isEditing) {
        _noteProvider!.updateNote(_noteId!, title, content);
      } else {
        final noteId = await _noteProvider!.addNote(title, content);
        
        setState(() {
          _noteId = noteId;
        });
      }
    } catch (e) {
      print("Lỗi khi lưu note: $e");
    }
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap( 
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Xóa ghi chú',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context); 
                  _noteProvider?.deleteNote(_noteId!); 
                  Navigator.pop(context); 
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Chia sẻ'),
                onTap: () {
                  Navigator.pop(context);
                  // Gọi hàm xử lý chia sẻ... (chưa triển khai)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng đang phát triển!')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Hủy bỏ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
    
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        _debounceTimer?.cancel();
        _saveNote();
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child:  Scaffold(
        appBar: AppBar(
          title: Text(widget.note != null ? 'Chỉnh sửa Ghi chú' : 'Ghi chú mới'),
          actions: [
            if (_isEditing) 
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  _showOptionsBottomSheet(context);
                },
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Column(
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
                          FocusScope.of(context).requestFocus(_editorFocusNode);
                        },
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                      ),
                    ],
                  )),
              Expanded(
                child: QuillEditor(
                  focusNode: _editorFocusNode,
                  scrollController: _editorScrollController,
                  controller: _controller,
                  config: QuillEditorConfig(
                    padding: const EdgeInsets.all(16),
                    embedBuilders: [
                      ...FlutterQuillEmbeds.editorBuilders(
                        imageEmbedConfig: QuillEditorImageEmbedConfig(
                          imageProviderBuilder: (context, imageUrl) {
                            if (imageUrl.startsWith('assets/')) {
                              return AssetImage(imageUrl);
                            }
                            return null;
                          },
                        ),
                        videoEmbedConfig: QuillEditorVideoEmbedConfig(
                          customVideoBuilder: (videoUrl, readOnly) {
                            return null;
                          },
                        ),
                      ),
                      
                      TimeStampEmbedBuilder(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomToolbar(controller: _controller),
      )
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.removeListener(_onTextChanged);
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    _titleController.dispose();
    super.dispose();
  }
}