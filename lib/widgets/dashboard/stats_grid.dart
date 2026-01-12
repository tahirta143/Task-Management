import 'package:flutter/material.dart';

import '../../models/dashboard_model.dart';


class StatsGrid extends StatelessWidget {
  final DashboardStats stats;
  final bool isAdmin;

  const StatsGrid({
    super.key,
    required this.stats,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          title: 'Total Tasks',
          value: stats.totalTasks.toString(),
          icon: Icons.task_alt,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Completed',
          value: stats.completedTasks.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'In Progress',
          value: stats.inProgressTasks.toString(),
          icon: Icons.autorenew,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: 'Pending',
          value: stats.pendingTasks.toString(),
          icon: Icons.pending_actions,
          color: Colors.yellow,
        ),
        _buildStatCard(
          title: 'Delayed',
          value: stats.delayedTasks.toString(),
          icon: Icons.warning,
          color: Colors.red,
        ),
        if (isAdmin) ...[
          _buildStatCard(
            title: 'Team Members',
            value: stats.teamMembers.toString(),
            icon: Icons.people,
            color: Colors.purple,
          ),
          _buildStatCard(
            title: 'Active Companies',
            value: stats.activeCompanies.toString(),
            icon: Icons.business,
            color: Colors.teal,
          ),
          _buildStatCard(
            title: 'Productivity',
            value: '${stats.productivity}%',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
        ] else ...[
          _buildStatCard(
            title: 'My Tasks',
            value: stats.summary.total.toString(),
            icon: Icons.assignment,
            color: Colors.blue,
          ),
          _buildStatCard(
            title: 'Completion Rate',
            value: '${stats.summary.completionRate}%',
            icon: Icons.bar_chart,
            color: Colors.green,
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}