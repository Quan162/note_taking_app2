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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              context,
              title: 'Giao diện',
              icon: Icons.palette_outlined,
              children: [
                _buildThemeModeSelector(context, themeProvider),
                const SizedBox(height: 24),
                Text(
                  'Màu chủ đạo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                _buildColorPicker(context, themeProvider),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildSectionCard(
              context,
              title: 'Thông tin',
              icon: Icons.info_outline,
              children: [
                _buildInfoRow(
                  context,
                  icon: Icons.verified_outlined,
                  label: 'Phiên bản',
                  value: '0.0.1',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  icon: Icons.flutter_dash_outlined,
                  label: 'Framework',
                  value: 'Flutter',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildThemeModeButton(
            context,
            themeProvider,
            mode: ThemeMode.light,
            icon: Icons.light_mode,
            label: 'Sáng',
          ),
          _buildThemeModeButton(
            context,
            themeProvider,
            mode: ThemeMode.system,
            icon: Icons.brightness_auto,
            label: 'Tự động',
          ),
          _buildThemeModeButton(
            context,
            themeProvider,
            mode: ThemeMode.dark,
            icon: Icons.dark_mode,
            label: 'Tối',
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeButton(
    BuildContext context,
    ThemeProvider themeProvider, {
    required ThemeMode mode,
    required IconData icon,
    required String label,
  }) {
    final isSelected = themeProvider.themeMode == mode;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => themeProvider.changeThemeMode(mode),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    color: _getContrastColor(color),
                    size: 30,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  Color _getContrastColor(Color background) {
    // Tính toán độ sáng để chọn màu tương phản
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}