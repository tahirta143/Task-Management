import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentActivities extends StatelessWidget {
  final List<dynamic> activities; // Changed from List<RecentActivity>
  final VoidCallback? onViewAll;
  final int maxItemsToShow;

  const RecentActivities({
    super.key,
    this.activities = const [], // Default to empty list
    this.onViewAll,
    this.maxItemsToShow = 5,
  });

  @override
  Widget build(BuildContext context) {
    // Always show empty state since API doesn't provide this data
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none),
                color: Theme.of(context).hintColor,
                onPressed: () {},
                tooltip: 'Notifications',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: Colors.grey.shade400,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No recent activities',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Activity tracking will be available soon',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Remove the ActivityInfo class since it's not needed anymore