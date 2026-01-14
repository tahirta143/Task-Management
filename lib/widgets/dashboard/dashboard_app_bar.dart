import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// Custom badge widget
class CustomBadge extends StatelessWidget {
  final String value;
  final Color color;
  final Widget child;

  const CustomBadge({
    super.key,
    required this.value,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -8,
          right: -8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String role;
  final VoidCallback? onRefresh;

  const DashboardAppBar({
    super.key,
    required this.userName,
    required this.role,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            role.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      actions: [
        if (onRefresh != null)
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: onRefresh,
            tooltip: 'Refresh Dashboard',
          ),
        IconButton(
          icon: CustomBadge(
            value: '3',
            color: Colors.red,
            child: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          onPressed: () {
            // Handle notification tap
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}