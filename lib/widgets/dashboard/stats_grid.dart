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
          value: stats.tasks.total.toString(),
          icon: Icons.task_alt,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Completed',
          value: stats.tasks.completed.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'In Progress',
          value: stats.tasks.inProgress.toString(),
          icon: Icons.autorenew,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: 'Pending',
          value: stats.tasks.pending.toString(),
          icon: Icons.pending_actions,
          color: Colors.yellow,
        ),
        _buildStatCard(
          title: 'Delayed',
          value: stats.tasks.delayed.toString(),
          icon: Icons.warning,
          color: Colors.red,
        ),
        _buildStatCard(
          title: 'Total Subtasks',
          value: stats.subtasks.total.toString(),
          icon: Icons.list,
          color: Colors.purple,
        ),
        if (isAdmin) ...[
          _buildStatCard(
            title: 'Completed Subtasks',
            value: stats.subtasks.completed.toString(),
            icon: Icons.check_box,
            color: Colors.teal,
          ),
          _buildStatCard(
            title: 'Productivity',
            value: '${stats.summary.productivity}%',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
        ] else ...[
          _buildStatCard(
            title: 'My Work',
            value: stats.summary.totalWork.toString(),
            icon: Icons.assignment,
            color: Colors.blue,
          ),
          _buildStatCard(
            title: 'Completed Work',
            value: stats.summary.completedWork.toString(),
            icon: Icons.assignment_turned_in,
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