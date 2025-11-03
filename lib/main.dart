import 'package:flutter/material.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/providers/theme_provider.dart';
import 'package:note_taking_app/repositories/note_repository.dart';
import 'package:note_taking_app/repositories/sqlite_note_repository.dart';
import 'package:note_taking_app/screens/home.dart';
import 'package:note_taking_app/screens/note_editor.dart';
import 'package:note_taking_app/screens/search.dart';
import 'package:note_taking_app/screens/setting.dart';
import 'package:note_taking_app/screens/todo.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final NoteRepository noteRepository;

  // if (kIsWeb) {
  //   final prefs = await SharedPreferences.getInstance();
  //   noteRepository = WebNoteRepository(prefs: prefs);
  // } else {
  //   noteRepository = SqliteNoteRepository();
  // }
  noteRepository = SqliteNoteRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(), 
        ),
        ChangeNotifierProvider(
          create: (context) => NoteProvider(noteRepository: noteRepository), 
        ),

        // ChangeNotifierProvider(
        //   create: (context) => Provider(), 
        // ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: { 
        '/': (context) => HomeScreen(), 
        '/editor': (context) => NoteEditor(),
        '/todo': (context) => TodoScreen(),
        '/search': (context) => SearchScreen(),
        '/settings': (context) => SettingScreen(),
        },
    );
  }
}