import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("List View")),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.list),
              title: Text("Item ${index + 1}"),
              subtitle: Text("Item ${index + 1} description"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                
              },
            );
          },
        ),
      )
    );
  }
}