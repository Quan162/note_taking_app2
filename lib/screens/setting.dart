import 'package:flutter/material.dart';
import 'package:note_taking_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

// TODO: Thêm các tùy chọn cài đặt khác (ví dụ: cỡ chữ, ngôn ngữ)
// TODO: Lưu các cài đặt (màu theme, chế độ sáng/tối) vào SharedPreferences

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static const List<Color> _themeColors = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
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
            
            _buildColorPicker(context, themeProvider),

            const Divider(height: 32),

            ListTile(
              title: const Text('Chế độ tối'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: Gọi hàm đổi theme
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng đang phát triển!')),
                  );
                  // themeProvider.changeThemeMode(
                  //   value ? ThemeMode.dark : ThemeMode.light,
                  // );
                },
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    
      bottomNavigationBar: _buildVersionBanner(context),
    );
  }

  Widget _buildColorPicker(BuildContext context, ThemeProvider themeProvider) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _themeColors.map((color) {
        final bool isSelected = themeProvider.currentColor == color;

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
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                width: isSelected ? 3 : 2,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVersionBanner(BuildContext context) {
    const String appVersion = "0.0.1";

    return SafeArea(
      bottom: true,
      child: Container(
        height: 40,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Text(
            'Version $appVersion',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}