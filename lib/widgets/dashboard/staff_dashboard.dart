import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/widgets/dashboard/stats_grid.dart';

import '../../providers/dashboard_provider.dart';


class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

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
                  'My Tasks 📋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track your assigned tasks and progress.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Grid (Simplified for Staff)
            if (dashboardProvider.dashboardStats != null)
              StatsGrid(
                stats: dashboardProvider.dashboardStats!,
                isAdmin: false,
              ),

            const SizedBox(height: 24),

            // Task Progress
            // TaskProgress(
            //   summary: dashboardProvider.dashboardStats?.summary,
            // ),

            const SizedBox(height: 24),

            // My Tasks
            //const MyTasks(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}