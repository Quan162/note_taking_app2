import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  )
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.white,
  )
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _changeTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkMode == true ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(title: Text("Demo")),
        body: Center(
          child: SwitchListTile(
            title: Text("Dark mode"),
            value: _isDarkMode, 
            onChanged: (value) {
              _changeTheme(value);
            }
          ),
        ),
      ),
    );
  }
}