  import 'package:flutter/material.dart';

  class AppDrawer extends StatelessWidget {

    const AppDrawer({super.key});

    @override
    Widget build(BuildContext context) {
      const drawerItems = [
        {'icon': Icons.list, 'title': 'Todo', 'route': '/todo'},
        {'icon': Icons.settings, 'title': 'Cài đặt', 'route': '/settings'},
        {'icon': Icons.info_outline, 'title': 'Giới thiệu', 'route': '/about'},
      ];

      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),

            ...drawerItems.map((item) => ListTile(
              leading: Icon(item['icon'] as IconData),
              title: Text(item['title'] as String),
              onTap: () {
                Navigator.pop(context);
                final route = item['route'] as String;
                if (route.isNotEmpty) {
                  Navigator.pushNamed(context, route);
                }
              },
            )),
          ],
        ),
      );
    }
  }