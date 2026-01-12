// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:taskflow_app/models/user_model.dart';
// import 'package:taskflow_app/providers/user_provider.dart';
// import 'package:taskflow_app/widgets/users/add_user_dialog.dart';
//
// import '../../providers/auth_provider.dart' show AuthProvider;
//
// class UserCard extends StatelessWidget {
//   final User user;
//
//   const UserCard({super.key, required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallPhone = screenWidth < 360;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: isSmallPhone ? 8 : 12),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(isSmallPhone ? 12 : 16),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Row
//               Row(
//                 children: [
//                   // Avatar
//                   Container(
//                     width: isSmallPhone ? 40 : 50,
//                     height: isSmallPhone ? 40 : 50,
//                     decoration: BoxDecoration(
//                       color: _getRoleColor(user.role),
//                       borderRadius: BorderRadius.circular(isSmallPhone ? 20 : 25),
//                     ),
//                     child: Center(
//                       child: Text(
//                         user.name.substring(0, 1).toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: isSmallPhone ? 16 : 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(width: isSmallPhone ? 12 : 16),
//
//                   // User Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           user.name,
//                           style: TextStyle(
//                             fontSize: isSmallPhone ? 15 : 16,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: isSmallPhone ? 2 : 4),
//                         Text(
//                           user.email,
//                           style: TextStyle(
//                             fontSize: isSmallPhone ? 12 : 13,
//                             color: Colors.grey.shade600,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: isSmallPhone ? 4 : 6),
//                         _buildRoleBadge(user.role, isSmallPhone),
//                       ],
//                     ),
//                   ),
//
//                   // Menu Button
//                   _buildPopupMenuButton(context, isSmallPhone),
//                 ],
//               ),
//
//               SizedBox(height: isSmallPhone ? 12 : 16),
//
//               // Details
//               Column(
//                 children: [
//                   // Company Row
//                   _buildDetailRow(
//                     Icons.business,
//                     'Company',
//                     user.company?.name ?? 'No Company',
//                     isSmallPhone,
//                   ),
//                   SizedBox(height: isSmallPhone ? 8 : 10),
//
//                   // Phone Row
//                   _buildDetailRow(
//                     Icons.phone,
//                     'Phone',
//                     user.number?.toString() ?? 'Not set',
//                     isSmallPhone,
//                   ),
//                   SizedBox(height: isSmallPhone ? 8 : 10),
//
//                   // Status & Joined Row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDetailRow(
//                           Icons.circle,
//                           'Status',
//                           user.isActive ? 'Active' : 'Inactive',
//                           isSmallPhone,
//                           statusColor: user.isActive ? Colors.green : Colors.grey,
//                         ),
//                       ),
//                       SizedBox(width: isSmallPhone ? 8 : 16),
//                       Expanded(
//                         child: _buildDetailRow(
//                           Icons.calendar_today,
//                           'Joined',
//                           DateFormat('MMM dd, yyyy').format(user.createdAt),
//                           isSmallPhone,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRoleBadge(String role, bool isSmallPhone) {
//     final roleColors = {
//       'admin': Colors.red,
//       'manager': Colors.orange,
//       'staff': Colors.blue,
//     };
//
//     final color = roleColors[role] ?? Colors.grey;
//
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: isSmallPhone ? 8 : 10,
//         vertical: isSmallPhone ? 2 : 4,
//       ),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         role.toUpperCase(),
//         style: TextStyle(
//           fontSize: isSmallPhone ? 9 : 10,
//           fontWeight: FontWeight.w600,
//           color: color,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String value, bool isSmallPhone, {Color? statusColor}) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: isSmallPhone ? 14 : 16,
//           color: statusColor ?? Colors.grey.shade600,
//         ),
//         SizedBox(width: isSmallPhone ? 8 : 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: isSmallPhone ? 10 : 11,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 2),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: isSmallPhone ? 12 : 14,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPopupMenuButton(BuildContext context, bool isSmallPhone) {
//     return PopupMenuButton<String>(
//       icon: Icon(
//         Icons.more_vert,
//         color: Colors.grey,
//         size: isSmallPhone ? 18 : 20,
//       ),
//       onSelected: (value) async {
//         final provider = Provider.of<UserProvider>(context, listen: false);
//         final authProvider = Provider.of<AuthProvider>(context, listen: false);
//
//         // Check permissions for manager
//         if (authProvider.isManager) {
//           // Manager can only edit/delete users from their company
//           // if (user.company?.id != authProvider.companyId) {
//           //   ScaffoldMessenger.of(context).showSnackBar(
//           //     const SnackBar(
//           //       content: Text('You can only manage users from your company'),
//           //       backgroundColor: Colors.red,
//           //     ),
//           //   );
//           //   return;
//           // }
//
//           // Manager cannot edit admins or other managers
//           if (user.role == 'admin' || (user.role == 'manager' && user.id != authProvider.userId)) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('You cannot manage this user'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//             return;
//           }
//         }
//
//         if (value == 'edit') {
//           _showEditDialog(context, user);
//         } else if (value == 'toggle') {
//           await provider.toggleUserStatus(user.id, user.isActive);
//         } else if (value == 'delete') {
//           await _showDeleteConfirmation(context, user, provider);
//         }
//       },
//       itemBuilder: (context) => [
//         PopupMenuItem<String>(
//           value: 'edit',
//           child: Row(
//             children: [
//               Icon(Icons.edit, size: isSmallPhone ? 16 : 18),
//               SizedBox(width: 8),
//               const Text('Edit'),
//             ],
//           ),
//         ),
//         PopupMenuItem<String>(
//           value: 'toggle',
//           child: Row(
//             children: [
//               Icon(
//                 user.isActive ? Icons.toggle_off : Icons.toggle_on,
//                 size: isSmallPhone ? 16 : 18,
//                 color: user.isActive ? Colors.grey : Colors.green,
//               ),
//               SizedBox(width: 8),
//               Text(user.isActive ? 'Deactivate' : 'Activate'),
//             ],
//           ),
//         ),
//         const PopupMenuDivider(),
//         PopupMenuItem<String>(
//           value: 'delete',
//           child: Row(
//             children: const [
//               Icon(Icons.delete, size: 18, color: Colors.red),
//               SizedBox(width: 8),
//               Text('Delete', style: TextStyle(color: Colors.red)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Color _getRoleColor(String role) {
//     switch (role) {
//       case 'admin':
//         return Colors.red;
//       case 'manager':
//         return Colors.orange;
//       case 'staff':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   void _showEditDialog(BuildContext context, User user) {
//     showDialog(
//       context: context,
//       builder: (context) => AddUserDialog(user: user),
//     );
//   }
//
//   Future<void> _showDeleteConfirmation(
//       BuildContext context,
//       User user,
//       UserProvider provider,
//       ) async {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete User'),
//         content: Text('Are you sure you want to delete ${user.name}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await provider.deleteUser(user.id);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }