import 'package:flutter/material.dart';

class DashboardBottomNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String role;

  const DashboardBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.role,
  });

  @override
  State<DashboardBottomNav> createState() => _DashboardBottomNavState();
}

class _DashboardBottomNavState extends State<DashboardBottomNav> {
  @override
  Widget build(BuildContext context) {
    final bool isAdmin = widget.role == 'admin';
    final bool isManager = widget.role == 'manager';

    final List<Map<String, dynamic>> adminItems = [
      {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'},
      {'icon': Icons.task_outlined, 'label': 'Tasks'},
      {'icon': Icons.people_outline, 'label': 'Users'},
      {'icon': Icons.business_outlined, 'label': 'Companies'},
      {'icon': Icons.analytics_outlined, 'label': 'Reports'},
    ];

    final List<Map<String, dynamic>> managerItems = [
      {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'},
      {'icon': Icons.task_outlined, 'label': 'Tasks'},
      {'icon': Icons.people_outline, 'label': 'Users'},
      {'icon': Icons.analytics_outlined, 'label': 'Reports'},
    ];

    final List<Map<String, dynamic>> staffItems = [
      {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'},
      {'icon': Icons.task_outlined, 'label': 'Tasks'},
    ];

    final items = isAdmin
        ? adminItems
        : isManager
        ? managerItems
        : staffItems;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Curved background
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 90),
            painter: _CurvedNavigationPainter(),
          ),

          // Navigation items
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length,
                    (index) {
                  final isSelected = widget.selectedIndex == index;
                  final item = items[index];

                  return GestureDetector(
                    onTap: () => widget.onItemSelected(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Floating icon effect when selected
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 3,
                                offset: const Offset(0, 5),
                              ),
                            ]
                                : null,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 24,
                            color: isSelected
                                ? Colors.blue.shade700
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Label with slide-up animation
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            0,
                            isSelected ? -5 : 0,
                            0,
                          ),
                          child: Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

    );
  }
}

class _CurvedNavigationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.5,
        0,
        size.width,
        size.height * 0.4,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Add subtle border
    final borderPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}