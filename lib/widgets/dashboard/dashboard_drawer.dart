import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/screens/auth/login_screen.dart';
import '../../providers/auth_provider.dart';
import '../../screens/profile/profile_screen.dart';

class DashboardDrawer extends StatelessWidget {
  final Function(int) onMenuItemSelected;

  const DashboardDrawer({
    super.key,
    required this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Define menu items for each role
    final List<Map<String, dynamic>> adminMenuItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard', 'route': 0},
      {'icon': Icons.task, 'label': 'Tasks', 'route': 1},
      {'icon': Icons.people, 'label': 'Users', 'route': 2},
      {'icon': Icons.business, 'label': 'Companies', 'route': 3},
      {'icon': Icons.analytics, 'label': 'Reports', 'route': 4},
      {'icon': Icons.settings, 'label': 'Settings', 'route': 5},
    ];

    final List<Map<String, dynamic>> managerMenuItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard', 'route': 0},
      {'icon': Icons.task, 'label': 'Tasks', 'route': 1},
      {'icon': Icons.people, 'label': 'Users', 'route': 2},
      {'icon': Icons.analytics, 'label': 'Reports', 'route': 3},
      {'icon': Icons.settings, 'label': 'Settings', 'route': 4},
    ];

    final List<Map<String, dynamic>> staffMenuItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard', 'route': 0},
      {'icon': Icons.task, 'label': 'Tasks', 'route': 1},
      // {'icon': Icons.analytics, 'label': 'Reports', 'route': 2},
      // {'icon': Icons.settings, 'label': 'Settings', 'route': 3},
    ];

    final menuItems = authProvider.isAdmin
        ? adminMenuItems
        : authProvider.isManager
        ? managerMenuItems
        : staffMenuItems;

    Future<void> _logout() async {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        // Close drawer
        Navigator.pop(context);

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Logout
        await authProvider.logout();

        // Navigate to login screen and clear all routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
    }

    return Drawer(
      child: Column(
        children: [
          // Header Section
          Container(
            height: 200,
            width: 305,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    authProvider.userName?.isNotEmpty == true
                        ? authProvider.userName!.substring(0, 1).toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  authProvider.userName ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    authProvider.role?.toUpperCase() ?? 'STAFF',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [
                ...menuItems.map((item) => _buildMenuItem(
                  context,
                  icon: item['icon'],
                  label: item['label'],
                  onTap: () {
                    Navigator.pop(context); // Close drawer

                    // Check if this is the Settings menu
                    if (item['label'] == 'Settings') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    } else {
                      onMenuItemSelected(item['route']); // default behavior
                    }
                  },
                ))

              ],
            ),
          ),

          // Logout Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              children: [
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 8),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  label: 'Logout',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: _logout,
                  showTrailing: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        Color? iconColor,
        Color? textColor,
        required VoidCallback onTap,
        bool showTrailing = true,
      }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.blue.shade700,
          size: 22,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.grey.shade800,
        ),
      ),
      trailing: showTrailing
          ? Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
      )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap,
    );
  }
}