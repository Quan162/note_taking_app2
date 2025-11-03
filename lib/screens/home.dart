import 'package:flutter/material.dart';
import 'package:note_taking_app/providers/note_provider.dart';
import 'package:note_taking_app/widgets/drawer.dart';
import 'package:note_taking_app/widgets/home/note_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen>{
  late ColorScheme cs;
  late TextTheme tt;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    tt = Theme.of(context).textTheme;
    cs = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: _buildAppBar(),
      body: const NoteList(),
      floatingActionButton: _buildFAB()
    ); 
  }

  AppBar _buildAppBar() {
    return AppBar(
    
      title: Text(
        "Ghi chú",
      ),

      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
                context,
                '/search',
              );
          }, 
          icon: Icon(Icons.search, color: cs.onSurface)
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }

  FloatingActionButton _buildFAB() {
    return FloatingActionButton.extended(
      label: Text("Thêm ghi chú mới"),
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/editor',
        );
      }
    );
  }

}