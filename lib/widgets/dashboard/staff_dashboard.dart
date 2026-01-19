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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B5CF6), // Appbar purple shade
                    const Color(0xFF7E57C2), // Main appbar color
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7E57C2).withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 5,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Tasks 📋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Track your assigned tasks and progress.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
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