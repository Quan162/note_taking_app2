import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/providers/theme_provider.dart';
import 'package:note_taking_app/repositories/note_repository.dart';
import 'package:note_taking_app/repositories/sqlite_note_repository.dart';
import 'package:note_taking_app/repositories/web_note_repository.dart';
import 'package:note_taking_app/screens/home.dart';
import 'package:note_taking_app/screens/note_editor.dart';
import 'package:note_taking_app/screens/search.dart';
import 'package:note_taking_app/screens/setting.dart';
import 'package:note_taking_app/screens/todo.dart';
import 'package:note_taking_app/widgets/home/note_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          create: (context) => NoteProvider(noteRepository: noteRepository), 
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(), 
        ),
        // ChangeNotifierProvider(
        //   create: (context) => ThemeProvider(), 
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
      theme: themeProvider.currentTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: { 
        '/': (context) => HomeScreen(), 
        '/editor': (context) => NoteEditor(),
        '/todo': (context) => TodoScreen(),
        '/search': (context) => SearchScreen(),
        '/settings': (context) => SettingScreen(),
        },
      themeMode: themeProvider.themeMode,
    );
  }
}