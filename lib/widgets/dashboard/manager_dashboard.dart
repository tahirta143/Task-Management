import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/widgets/dashboard/recent_activities.dart';
import 'package:taskflow_app/widgets/dashboard/recent_tasks.dart';
import 'package:taskflow_app/widgets/dashboard/stats_grid.dart';
import 'package:taskflow_app/widgets/dashboard/team_overview.dart';

import '../../providers/dashboard_provider.dart';
import 'chart_overview.dart';


class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh logic
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Team Dashboard 👥',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage your team and track their progress.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Grid
            if (dashboardProvider.dashboardStats != null)
              StatsGrid(
                stats: dashboardProvider.dashboardStats!,
                isAdmin: false,
              ),

            const SizedBox(height: 24),

            // Chart Overview
            ChartOverview(
              chartData: dashboardProvider.dashboardStats?.chartData ?? [],
            ),

            const SizedBox(height: 24),

            // Team Overview
            const TeamOverview(),

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
}