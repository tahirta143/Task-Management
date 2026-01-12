import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/widgets/dashboard/recent_activities.dart';
import 'package:taskflow_app/widgets/dashboard/recent_tasks.dart';
import 'package:taskflow_app/widgets/dashboard/stats_grid.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import 'chart_overview.dart';
import 'company_overview.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        dashboardProvider.refreshData(authProvider.token!);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            _buildWelcomeHeader(authProvider.userName ?? 'Admin'),

            const SizedBox(height: 24),

            // Stats Grid
            if (dashboardProvider.dashboardStats != null)
              StatsGrid(
                stats: dashboardProvider.dashboardStats!,
                isAdmin: true,
              ),

            const SizedBox(height: 24),

            // Chart Overview
            ChartOverview(
              chartData: dashboardProvider.dashboardStats?.chartData ?? [],
            ),

            const SizedBox(height: 24),

            // Company Overview
            const CompanyOverview(),

            const SizedBox(height: 24),

            // Recent Activities
            RecentActivities(
              activities: dashboardProvider.dashboardStats?.recentActivities ?? [],
            ),

            const SizedBox(height: 24),

            // Recent Tasks
            RecentTasks(
              tasks: dashboardProvider.dashboardStats?.recentTasks ?? [],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $userName 👋',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Here\'s what\'s happening with your tasks today.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}