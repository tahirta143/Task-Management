import 'package:flutter/material.dart';

class DashboardBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String role;

  const DashboardBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = role == 'admin';
    final bool isManager = role == 'manager';

    final List<BottomNavigationBarItem> adminItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Tasks',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Users',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.business),
        label: 'Companies',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.analytics),
        label: 'Reports',
      ),
    ];

    final List<BottomNavigationBarItem> managerItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Tasks',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Users',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.analytics),
        label: 'Reports',
      ),
    ];

    final List<BottomNavigationBarItem> staffItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Tasks',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.analytics),
        label: 'Reports',
      ),
    ];

    final items = isAdmin
        ? adminItems
        : isManager
        ? managerItems
        : staffItems;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      selectedItemColor: Colors.blue.shade700,
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: items,
    );
  }
}