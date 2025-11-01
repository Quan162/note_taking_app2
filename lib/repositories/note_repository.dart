
import 'package:note_taking_app/models/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(String id);
  Future<void> saveNote(Note note); 
  Future<void> deleteNote(String id);
}