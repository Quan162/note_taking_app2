import 'package:flutter/material.dart';
import 'package:note_taking_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {

  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    const List<Color> themeColors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn màu chủ đạo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12.0, 
              runSpacing: 12.0, 
              children: themeColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    themeProvider.changeThemeColor(color);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        width: 2,
                      )
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}