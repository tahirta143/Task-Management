// import 'package:flutter/material.dart';
// import 'package:badge/badge.dart' as badge;
//
// class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String userName;
//   final String role;
//
//   const DashboardAppBar({
//     super.key,
//     required this.userName,
//     required this.role,
//   });
//
//   @override
//   Size get preferredSize => const Size.fromHeight(60);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       centerTitle: false,
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             userName,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           Text(
//             role.toUpperCase(),
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: badge.Badge(
//             showBadge: true,
//             badgeContent: const Text(
//               '3',
//               style: TextStyle(color: Colors.white, fontSize: 10),
//             ),
//             child: const Icon(Icons.notifications_none, color: Colors.black),
//           ),
//           onPressed: () {},
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 16.0),
//           child: CircleAvatar(
//             backgroundColor: Colors.blue.shade100,
//             child: Text(
//               userName.substring(0, 1),
//               style: const TextStyle(
//                 color: Colors.blue,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
 // Custom badge widget

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String role;

  const DashboardAppBar({
    super.key,
    required this.userName,
    required this.role,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

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
        IconButton(
          icon: CustomBadge(
            value: '3',
            color: Colors.red,
            child: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              userName.substring(0, 1),
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
}