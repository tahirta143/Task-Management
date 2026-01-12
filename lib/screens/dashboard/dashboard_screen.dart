import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/dashboard/admin_dashboard.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/dashboard_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_drawer.dart';
import '../../widgets/dashboard/manager_dashboard.dart';
import '../../widgets/dashboard/staff_dashboard.dart';
import '../Task/TaskListScreen.dart';
import '../companies/company_list_screen.dart';
import '../users/user_list_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _adminPages = [
    const AdminDashboard(),
    const TaskListScreen(), // Tasks page
    const UsersScreen(), // Users page
    const CompanyListScreen(), // Companies page
    const Placeholder(), // Reports page
  ];

  final List<Widget> _managerPages = [
    const ManagerDashboard(),
    const TaskListScreen(), // Tasks page
    const UsersScreen(), // Users page
    const Placeholder(), // Reports page
  ];

  final List<Widget> _staffPages = [
    const StaffDashboard(),
    const Placeholder(), // Tasks page
    const Placeholder(), // Reports page
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

    if (authProvider.token != null) {
      dashboardProvider.fetchDashboardData(authProvider.token!);
    }
  }

  List<Widget> _getPages() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isAdmin) {
      return _adminPages;
    } else if (authProvider.isManager) {
      return _managerPages;
    } else {
      return _staffPages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: DashboardAppBar(
        userName: authProvider.userName ?? 'User',
        role: authProvider.role ?? 'staff',
      ),
      drawer: const DashboardDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _getPages(),
      ),
      bottomNavigationBar: DashboardBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        role: authProvider.role ?? 'staff',
      ),
    );
  }
}