// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taskflow_app/screens/profile/profile_screen.dart';
// import '../../providers/password_provider.dart';
//
// // Enhanced Custom badge widget with modern design
// class CustomBadge extends StatelessWidget {
//   final String value;
//   final Color color;
//   final Widget child;
//
//   const CustomBadge({
//     super.key,
//     required this.value,
//     required this.color,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         child,
//         Positioned(
//           top: -6,
//           right: -6,
//           child: Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.3),
//                   blurRadius: 4,
//                   spreadRadius: 1,
//                 ),
//               ],
//               border: Border.all(
//                 color: Colors.white,
//                 width: 2,
//               ),
//             ),
//             constraints: const BoxConstraints(
//               minWidth: 18,
//               minHeight: 18,
//             ),
//             child: Center(
//               child: Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w900,
//                   height: 1,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String userName;
//   final String role;
//   final VoidCallback? onRefresh;
//
//   const DashboardAppBar({
//     super.key,
//     required this.userName,
//     required this.role,
//     this.onRefresh,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return AppBar(
//       elevation: 2,
//       backgroundColor: Colors.deepPurple,
//       surfaceTintColor: Colors.white,
//       foregroundColor: Colors.white,
//       shadowColor: Colors.black.withOpacity(0.08),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//       ),
//       centerTitle: false,
//       title: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               userName,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//               decoration: BoxDecoration(
//                 color: _getRoleColor(role).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: _getRoleColor(role).withOpacity(0.2),
//                   width: 1.5,
//                 ),
//               ),
//               child: Text(
//                 role.toUpperCase(),
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: _getRoleColor(role),
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         if (onRefresh != null)
//           Container(
//             margin: const EdgeInsets.only(right: 4),
//             child: IconButton(
//               icon: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: Colors.blue.shade100,
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.shade100.withOpacity(0.2),
//                       blurRadius: 4,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.refresh,
//                   color: Colors.blue,
//                   size: 20,
//                 ),
//               ),
//               onPressed: onRefresh,
//               tooltip: 'Refresh Dashboard',
//             ),
//           ),
//
//         Container(
//           margin: const EdgeInsets.only(right: 4),
//           child: IconButton(
//             icon: CustomBadge(
//               value: '3',
//               color: Colors.red,
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: Colors.orange.shade100,
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.orange.shade100.withOpacity(0.2),
//                       blurRadius: 4,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.notifications_none,
//                   color: Colors.deepOrange,
//                   size: 20,
//                 ),
//               ),
//             ),
//             onPressed: () {
//               // Handle notification tap
//             },
//           ),
//         ),
//
//         Padding(
//           padding: const EdgeInsets.only(right: 12.0),
//           child: InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChangeNotifierProvider(
//                     create: (_) => PasswordProvider(),
//                     child: const ProfileScreen(),
//                   ),
//                 ),
//               );
//             },
//             borderRadius: BorderRadius.circular(30),
//             child: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.shade600,
//                     Colors.blue.shade800,
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.3),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   userName.isNotEmpty
//                       ? userName.substring(0, 1).toUpperCase()
//                       : 'U',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black26,
//                         blurRadius: 2,
//                         offset: Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Color _getRoleColor(String role) {
//     switch (role.toLowerCase()) {
//       case 'admin':
//         return const Color(0xFF8B5CF6); // Purple
//       case 'manager':
//         return const Color(0xFF10B981); // Green
//       case 'employee':
//         return const Color(0xFF3B82F6); // Blue
//       case 'super admin':
//         return const Color(0xFFEF4444); // Red
//       default:
//         return const Color(0xFF6B7280); // Gray
//     }
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(70);
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/screens/profile/profile_screen.dart';
import '../../providers/password_provider.dart';

// Enhanced Custom badge widget with modern design
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
          top: -6,
          right: -6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 2.5,
              ),
            ),
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
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
    final theme = Theme.of(context);

    return AppBar(
      elevation: 4,
      backgroundColor: _getAppBarColor(),
      surfaceTintColor: Colors.white,
      foregroundColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      centerTitle: false,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getRoleColor(role).withOpacity(0.3),
                    _getRoleColor(role).withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _getRoleColor(role).withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getRoleColor(role).withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getRoleIcon(role),
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    role.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.6,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (onRefresh != null)
          Container(
            margin: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan.shade400,
                      Colors.blue.shade600,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              onPressed: onRefresh,
              tooltip: 'Refresh Dashboard',
            ),
          ),

        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            icon: CustomBadge(
              value: '3',
              color: const Color(0xFFFF6B6B),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFA726),
                      const Color(0xFFEF5350),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => PasswordProvider(),
                    child: const ProfileScreen(),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF9575CD),
                    const Color(0xFF673AB7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 3,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty
                      ? userName.substring(0, 1).toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getAppBarColor() {
    return const Color(0xFF7E57C2); // A vibrant purple color
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color(0xFFAB47BC); // Vibrant Purple
      case 'manager':
        return const Color(0xFF26A69A); // Teal
      case 'employee':
        return const Color(0xFF42A5F5); // Bright Blue
      case 'super admin':
        return const Color(0xFFFF7043); // Coral Orange
      default:
        return const Color(0xFF78909C); // Blue Gray
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.security;
      case 'manager':
        return Icons.people;
      case 'employee':
        return Icons.person;
      case 'super admin':
        return Icons.star;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}