// screens/users_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/screens/users/EditScreenUser.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import 'addStaffScreen.dart';


class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUsers();
    });
  }
  Future<void> _onRefresh() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          if (authProvider.isAdmin || authProvider.isManager)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: // Update the Add Staff button in UsersScreen
              // In UsersScreen, update the Add Staff button:
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddStaffScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text(
                  'Add Staff',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 1,
                ),
              ),
            ),
        ],
        elevation: 1,
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 50, // Height of the bottom nav bar
          ),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              // Search and Filter Bar
              _buildSearchFilterBar(userProvider),

              // Statistics Cards
            //  _buildStatisticsCards(userProvider),

              // User List
              Expanded(
                child: _buildUserList(userProvider),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSearchFilterBar(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) => userProvider.setSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Search users by name, email, or company...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  userProvider.setSearchQuery('');
                },
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Role Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: userProvider.roleOptions.map((role) {
                final isSelected = userProvider.filterRole == role;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      role,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => userProvider.setFilterRole(role),
                    backgroundColor: Colors.grey[100],
                    selectedColor: Colors.deepPurple.shade400,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildStatisticsCards(UserProvider userProvider) {
  //   final totalUsers = userProvider.allUsers.length;
  //   final admins = userProvider.allUsers.where((u) => u.role == 'admin').length;
  //   final managers = userProvider.allUsers.where((u) => u.role == 'manager').length;
  //   final staff = userProvider.allUsers.where((u) => u.role == 'staff').length;
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     child: Row(
  //       children: [
  //         _buildStatCard('Total Users', totalUsers, Icons.people, Colors.blue),
  //         const SizedBox(width: 12),
  //         _buildStatCard('Admins', admins, Icons.admin_panel_settings, Colors.green),
  //         const SizedBox(width: 12),
  //         _buildStatCard('Managers', managers, Icons.manage_accounts, Colors.orange),
  //         const SizedBox(width: 12),
  //         _buildStatCard('Staff', staff, Icons.badge, Colors.purple),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildStatCard(String title, int count, IconData icon, Color color) {
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 6,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: color.withOpacity(0.1),
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: Icon(icon, color: color, size: 20),
  //               ),
  //               const Spacer(),
  //               Text(
  //                 '$count',
  //                 style: const TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.w700,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: Colors.grey[600],
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildUserList(UserProvider userProvider) {
    if (userProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (userProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${userProvider.error}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => userProvider.fetchUsers(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (userProvider.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              userProvider.searchQuery.isNotEmpty
                  ? 'No users found matching "${userProvider.searchQuery}"'
                  : 'No users available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (userProvider.searchQuery.isNotEmpty)
              TextButton(
                onPressed: () => userProvider.clearFilters(),
                child: const Text('Clear filters'),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: userProvider.users.length,
      itemBuilder: (context, index) {
        final user = userProvider.users[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
          radius: 24,
          child: Icon(
            _getRoleIcon(user.role),
            color: _getRoleColor(user.role),
          ),
        ),
        title: Row(
          children: [
            Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),

          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRoleBadge(user.role),
                const Spacer(),
                if (user.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    user.email,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (user.number != null)
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    user.number!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            if (user.company != null)
              Row(
                children: [
                  Icon(Icons.business_outlined, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    user.company!.name,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          onPressed: () {
            _showUserActions(context, user);
          },
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final roleColors = {
      'admin': Colors.red,
      'manager': Colors.orange,
      'staff': Colors.blue,
    };

    final roleNames = {
      'admin': 'Admin',
      'manager': 'Manager',
      'staff': 'Staff',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: roleColors[role]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        roleNames[role]!,
        style: TextStyle(
          color: roleColors[role],
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'manager':
        return Colors.orange;
      case 'staff':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'manager':
        return Icons.manage_accounts;
      case 'staff':
        return Icons.badge;
      default:
        return Icons.person;
    }
  }

  void _showUserActions(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const Icon(Icons.edit, color: Colors.green),
                title: const Text('Edit User'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditUserScreen(user: user),
                    ),
                  );

                  // Navigate to edit user
                },
              ),
              // if (user.role != 'admin')
              //   ListTile(
              //     leading: Icon(
              //       user.isActive ? Icons.block : Icons.check_circle,
              //       color: user.isActive ? Colors.orange : Colors.green,
              //     ),
              //     title: Text(user.isActive ? 'Deactivate User' : 'Activate User'),
              //     onTap: () {
              //       Navigator.pop(context);
              //       // Toggle user active status
              //     },
              //   ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete User'),
                onTap: () {
                  // Navigator.pop(context);
                  _showDeleteDialog(context, user);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //
  void _showDeleteDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return AlertDialog(
              title: const Text('Delete User'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to delete ${user.name}?'),
                  const SizedBox(height: 8),
                  if (userProvider.error != null && userProvider.error!.contains('assigned tasks'))
                    Text(
                      'Note: This user has tasks assigned to them. You need to reassign or delete those tasks first.',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: userProvider.isLoading
                      ? null
                      : () async {
                    final success = await userProvider.deleteUser(user.id);

                    if (success && context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (context.mounted) {
                      // Don't close dialog on error, show error in dialog
                      if (userProvider.error != null && userProvider.error!.contains('assigned tasks')) {
                        // Show detailed error but keep dialog open
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Cannot delete user with assigned tasks'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  },
                  child: userProvider.isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

}