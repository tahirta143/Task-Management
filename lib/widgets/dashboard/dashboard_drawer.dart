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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFF4A1FB8), // Dark purple
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: const Color(0xFF7E57C2).withOpacity(0.8), // Appbar purple
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFEE2E2), // Light red
                    const Color(0xFFFECACA),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color(0xFFDC2626), // Red
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7E57C2).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Color(0xFF7E57C2)), // Appbar purple
              ),
            ),
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
      backgroundColor: const Color(0xFFFAF5FF), // Light purple background
      child: Column(
        children: [
          // Header Section
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF7E57C2), // Appbar purple
                  const Color(0xFF8B5CF6), // Light purple
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7E57C2).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.8),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      authProvider.userName?.isNotEmpty == true
                          ? authProvider.userName!.substring(0, 1).toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        color: Color(0xFF7E57C2), // Appbar purple
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  authProvider.userName ?? 'User',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    authProvider.role?.toUpperCase() ?? 'STAFF',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
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
              color: const Color(0xFFF5F3FF), // Slightly darker purple
              border: Border(
                top: BorderSide(color: const Color(0xFFEDE9FE), width: 1.5), // Light purple border
              ),
            ),
            child: Column(
              children: [
                Divider(color: const Color(0xFFEDE9FE)),
                const SizedBox(height: 8),
                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  iconColor: const Color(0xFFDC2626), // Red
                  textColor: const Color(0xFFDC2626), // Red
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEDE9FE), // Light purple border
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7E57C2).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF7E57C2).withOpacity(0.1), // Purple with opacity
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor ?? const Color(0xFF7E57C2), // Appbar purple
            size: 22,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor ?? const Color(0xFF4A1FB8), // Dark purple
          ),
        ),
        trailing: showTrailing
            ? Icon(
          Icons.chevron_right_rounded,
          color: const Color(0xFF8B5CF6).withOpacity(0.6), // Light purple
          size: 22,
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}