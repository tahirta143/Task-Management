import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/screens/report/report_Screen.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/dashboard/admin_dashboard.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/dashboard_bottom_nav.dart';
import '../../widgets/dashboard/dashboard_drawer.dart'; // Make sure this import is correct
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
  bool _isInitialized = false;

  final List<Widget> _adminPages = [
    const AdminDashboard(),
    const TaskListScreen(), // Tasks page
    const UsersScreen(), // Users page
    const CompanyListScreen(), // Companies page
    const ReportScreen(), // Reports page
  ];

  final List<Widget> _managerPages = [
    const ManagerDashboard(),
    const TaskListScreen(), // Tasks page
    const UsersScreen(), // Users page
    const ReportScreen(), // Reports page
  ];

  final List<Widget> _staffPages = [
    const StaffDashboard(),
    const TaskListScreen(), // Tasks page
    // const ReportScreen(), // Reports page
  ];

  @override
  void initState() {
    super.initState();
    // Schedule the data loading for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
      _isInitialized = true;
    });
  }

  void _loadDashboardData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

    if (authProvider.token != null) {
      dashboardProvider.fetchDashboardData(authProvider.token!).then((_) {
        // Print dashboard stats after loading - UPDATED TO MATCH NEW MODEL
        if (dashboardProvider.dashboardStats != null) {
          print('\n=== Dashboard Screen - Stats Loaded ===');
          print('Dashboard Provider loaded successfully!');
          print('Total Tasks: ${dashboardProvider.dashboardStats!.tasks.total}');
          print('Completed Tasks: ${dashboardProvider.dashboardStats!.tasks.completed}');
          print('Pending Tasks: ${dashboardProvider.dashboardStats!.tasks.pending}');
          print('In Progress Tasks: ${dashboardProvider.dashboardStats!.tasks.inProgress}');
          print('Delayed Tasks: ${dashboardProvider.dashboardStats!.tasks.delayed}');
          print('Productivity: ${dashboardProvider.dashboardStats!.summary.productivity}%');
          print('Recent Tasks Count: ${dashboardProvider.dashboardStats!.recentTasks.length}');
          print('====================================\n');
        }
      }).catchError((error) {
        print('Error loading dashboard data: $error');
      });
    } else {
      print('No authentication token available');
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

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onRefresh() {
    print('Refreshing dashboard data...');
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      appBar: DashboardAppBar(
        userName: authProvider.userName ?? 'User',
        role: authProvider.role ?? 'staff',
        onRefresh: _onRefresh,
      ),
      drawer: DashboardDrawer(
        onMenuItemSelected: _onMenuItemSelected,
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          // Show loading state only for the dashboard page (index 0)
          if (_selectedIndex == 0 && provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error only for the dashboard page (index 0)
          if (_selectedIndex == 0 && provider.error != null && !provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 20),
                  Text(
                    'Error loading dashboard data',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      provider.error!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _getPages(),
          );
        },
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
      floatingActionButton: FloatingActionButton(
        onPressed: _onRefresh,
        tooltip: 'Refresh Dashboard',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}