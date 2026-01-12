import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';


class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final List<Map<String, dynamic>> adminMenuItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.task, 'label': 'Tasks'},
      {'icon': Icons.people, 'label': 'Users'},
      {'icon': Icons.business, 'label': 'Companies'},
      {'icon': Icons.analytics, 'label': 'Reports'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    final List<Map<String, dynamic>> managerMenuItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.task, 'label': 'Tasks'},
      {'icon': Icons.people, 'label': 'Users'},
      {'icon': Icons.analytics, 'label': 'Reports'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    final List<Map<String, dynamic>> staffMenuItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.task, 'label': 'Tasks'},
      {'icon': Icons.analytics, 'label': 'Reports'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    final menuItems = authProvider.isAdmin
        ? adminMenuItems
        : authProvider.isManager
        ? managerMenuItems
        : staffMenuItems;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700,
                  Colors.blue.shade400,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    authProvider.userName?.substring(0, 1) ?? 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  authProvider.userName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  authProvider.role?.toUpperCase() ?? 'STAFF',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ...menuItems.map((item) => ListTile(
            leading: Icon(item['icon'], color: Colors.grey.shade700),
            title: Text(item['label']),
            onTap: () {
              Navigator.pop(context);
            },
          )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              authProvider.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}