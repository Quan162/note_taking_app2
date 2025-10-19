import 'package:flutter/material.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/providers/theme_provider.dart';
import 'package:note_taking_app/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteProvider(), 
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

      home: const HomeScreen(),
    );
  }
}
// final ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: Colors.blue,
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.blue,
//     foregroundColor: Colors.white,
//   )
// );

// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: Colors.blueGrey,
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.blueGrey,
//     foregroundColor: Colors.white,
//   )
// );

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<StatefulWidget> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _isDarkMode = false;

//   void _changeTheme(bool isDarkMode) {
//     setState(() {
//       _isDarkMode = isDarkMode;
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // theme: lightTheme,
//       // darkTheme: darkTheme,
//       // themeMode: _isDarkMode == true ? ThemeMode.dark : ThemeMode.light,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true
//       ),
//       home:  HomeScreen(),
//     );
//   }
// }