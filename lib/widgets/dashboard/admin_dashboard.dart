// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:taskflow_app/widgets/dashboard/recent_tasks.dart';
// // import 'package:taskflow_app/widgets/dashboard/stats_grid.dart';
// //
// // import '../../providers/auth_provider.dart';
// // import '../../providers/dashboard_provider.dart';
// // import 'company_overview.dart';
// //
// // class AdminDashboard extends StatelessWidget {
// //   const AdminDashboard({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dashboardProvider = Provider.of<DashboardProvider>(context);
// //     final authProvider = Provider.of<AuthProvider>(context);
// //
// //     return RefreshIndicator(
// //       onRefresh: () async {
// //         if (authProvider.token != null) {
// //           await dashboardProvider.refreshData(authProvider.token!);
// //         }
// //       },
// //       child: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Welcome Header
// //             _buildWelcomeHeader(authProvider.userName ?? 'Admin'),
// //
// //             const SizedBox(height: 24),
// //
// //             // Stats Grid - Only show if we have data
// //             if (dashboardProvider.dashboardStats != null)
// //               StatsGrid(
// //                 stats: dashboardProvider.dashboardStats!,
// //                 isAdmin: true,
// //               )
// //             else if (dashboardProvider.isLoading)
// //               _buildLoadingStatsGrid()
// //             else
// //               _buildErrorStatsGrid(dashboardProvider.error),
// //
// //             const SizedBox(height: 24),
// //
// //             // Company Overview
// //             const CompanyOverview(),
// //
// //             const SizedBox(height: 24),
// //
// //             // Recent Tasks
// //             if (dashboardProvider.dashboardStats != null)
// //               RecentTasks(
// //                 tasks: dashboardProvider.dashboardStats!.recentTasks,
// //               )
// //             else if (dashboardProvider.isLoading)
// //               _buildLoadingRecentTasks()
// //             else
// //               _buildErrorRecentTasks(),
// //
// //             const SizedBox(height: 32),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildWelcomeHeader(String userName) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'Welcome back, $userName 👋',
// //           style: const TextStyle(
// //             fontSize: 28,
// //             fontWeight: FontWeight.w700,
// //             color: Colors.black,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         const Text(
// //           'Here\'s what\'s happening with your tasks today.',
// //           style: TextStyle(
// //             fontSize: 16,
// //             color: Colors.grey,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildLoadingStatsGrid() {
// //     return GridView.count(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       crossAxisCount: 2,
// //       crossAxisSpacing: 16,
// //       mainAxisSpacing: 16,
// //       childAspectRatio: 1.2,
// //       children: List.generate(8, (index) => _buildStatCardSkeleton()),
// //     );
// //   }
// //
// //   Widget _buildStatCardSkeleton() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             spreadRadius: 2,
// //           ),
// //         ],
// //       ),
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Container(
// //                 width: 40,
// //                 height: 40,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade200,
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Container(
// //                 width: 60,
// //                 height: 24,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade200,
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Container(
// //                 width: 80,
// //                 height: 14,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade200,
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildErrorStatsGrid(String? error) {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             spreadRadius: 2,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           const Icon(Icons.error_outline, color: Colors.red, size: 50),
// //           const SizedBox(height: 16),
// //           Text(
// //             'Failed to load statistics',
// //             style: TextStyle(
// //               fontSize: 16,
// //               color: Colors.grey.shade700,
// //             ),
// //           ),
// //           if (error != null) ...[
// //             const SizedBox(height: 8),
// //             Text(
// //               error,
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: Colors.grey.shade600,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildLoadingRecentTasks() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             spreadRadius: 2,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             width: 150,
// //             height: 24,
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade200,
// //               borderRadius: BorderRadius.circular(4),
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           ...List.generate(3, (index) => _buildTaskItemSkeleton()),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTaskItemSkeleton() {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade100,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 40,
// //             height: 40,
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade200,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Container(
// //                   width: 200,
// //                   height: 16,
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey.shade200,
// //                     borderRadius: BorderRadius.circular(4),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Container(
// //                   width: 150,
// //                   height: 12,
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey.shade200,
// //                     borderRadius: BorderRadius.circular(4),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildErrorRecentTasks() {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             spreadRadius: 2,
// //           ),
// //         ],
// //       ),
// //       child: const Column(
// //         children: [
// //           Icon(Icons.task_alt_outlined, color: Colors.grey, size: 50),
// //           SizedBox(height: 16),
// //           Text(
// //             'No recent tasks available',
// //             style: TextStyle(
// //               fontSize: 16,
// //               color: Colors.grey,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taskflow_app/widgets/dashboard/recent_tasks.dart';
// import 'package:taskflow_app/widgets/dashboard/stats_grid.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../providers/auth_provider.dart';
// import '../../providers/dashboard_provider.dart';
// import 'company_overview.dart';
//
// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final dashboardProvider = Provider.of<DashboardProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context);
//
//     // Use the new shouldShowShimmer getter
//     final showShimmer = dashboardProvider.shouldShowShimmer;
//
//     return RefreshIndicator(
//       onRefresh: () async {
//         if (authProvider.token != null) {
//           await dashboardProvider.refreshData(authProvider.token!);
//         }
//       },
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Welcome Header - Show shimmer on initial load
//             _buildWelcomeHeader(authProvider.userName ?? 'Admin', showShimmer),
//
//             const SizedBox(height: 24),
//
//             // Stats Grid - Simplified logic using shouldShowShimmer
//             if (showShimmer)
//               _buildLoadingStatsGrid()
//             else if (dashboardProvider.dashboardStats != null)
//               StatsGrid(
//                 stats: dashboardProvider.dashboardStats!,
//                 isAdmin: true,
//               )
//             else if (dashboardProvider.error != null)
//                 _buildErrorStatsGrid(dashboardProvider.error)
//               else
//                 _buildEmptyStatsGrid(),
//
//             const SizedBox(height: 24),
//
//             // Company Overview - Show only when we have data
//             if (!showShimmer && dashboardProvider.dashboardStats != null)
//               const CompanyOverview(),
//
//             const SizedBox(height: 24),
//
//             // Recent Tasks
//             if (showShimmer)
//               RecentTasks(tasks: [], isLoading: true)
//             else if (dashboardProvider.dashboardStats != null)
//               RecentTasks(
//                 tasks: dashboardProvider.dashboardStats!.recentTasks,
//                 isLoading: false,
//               )
//             else if (dashboardProvider.error != null)
//                 _buildErrorRecentTasks(dashboardProvider.error)
//               else
//                 _buildEmptyRecentTasks(),
//
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWelcomeHeader(String userName, bool isLoading) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (isLoading)
//           Shimmer.fromColors(
//             baseColor: Colors.grey.shade300,
//             highlightColor: Colors.grey.shade100,
//             child: Container(
//               width: 250,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ),
//           )
//         else
//           Text(
//             'Welcome back, $userName 👋',
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//         const SizedBox(height: 8),
//         if (isLoading)
//           Shimmer.fromColors(
//             baseColor: Colors.grey.shade300,
//             highlightColor: Colors.grey.shade100,
//             child: Container(
//               width: 300,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ),
//           )
//         else
//           const Text(
//             'Here\'s what\'s happening with your tasks today.',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingStatsGrid() {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       childAspectRatio: 1.2,
//       children: List.generate(8, (index) => _buildStatCardSkeleton()),
//     );
//   }
//
//   Widget _buildStatCardSkeleton() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   width: 80,
//                   height: 14,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorStatsGrid(String? error) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 50),
//           const SizedBox(height: 16),
//           Text(
//             'Failed to load statistics',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           if (error != null) ...[
//             const SizedBox(height: 8),
//             Text(
//               error,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyStatsGrid() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: const Column(
//         children: [
//           Icon(Icons.bar_chart_outlined, color: Colors.grey, size: 50),
//           SizedBox(height: 16),
//           Text(
//             'No statistics available',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorRecentTasks(String? error) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 50),
//           const SizedBox(height: 16),
//           Text(
//             'Failed to load tasks',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           if (error != null) ...[
//             const SizedBox(height: 8),
//             Text(
//               error,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyRecentTasks() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: const Column(
//         children: [
//           Icon(Icons.task_alt_outlined, color: Colors.grey, size: 50),
//           SizedBox(height: 16),
//           Text(
//             'No tasks available',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/widgets/dashboard/recent_tasks.dart';
import 'package:taskflow_app/widgets/dashboard/stats_grid.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import 'company_overview.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final showShimmer = dashboardProvider.shouldShowShimmer;

    return RefreshIndicator(
      color: const Color(0xFF7E57C2), // Matching appbar purple
      backgroundColor: const Color(0xFFF5F3FF), // Light purple background
      onRefresh: () async {
        if (authProvider.token != null) {
          await dashboardProvider.refreshData(authProvider.token!);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Welcome Header
            _buildModernWelcomeHeader(
                authProvider.userName ?? 'Admin', showShimmer, theme),

            const SizedBox(height: 32),

            // Quick Stats Overview
            _buildQuickStatsSection(dashboardProvider, showShimmer, theme),

            const SizedBox(height: 24),

            // Company Overview Card
            if (!showShimmer && dashboardProvider.dashboardStats != null)
              _buildCompanyOverviewCard(theme),

            const SizedBox(height: 24),

            // Recent Tasks Section
            _buildRecentTasksSection(dashboardProvider, showShimmer, theme),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildModernWelcomeHeader(
      String userName, bool isLoading, ThemeData theme) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 300,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.waving_hand_rounded,
                      color: const Color(0xFFFFD700),
                      size: 36,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Here\'s what\'s happening with your tasks today.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection(
      DashboardProvider dashboardProvider, bool showShimmer, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4A1FB8), // Dark purple
                letterSpacing: -0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7E57C2).withOpacity(0.15),
                    const Color(0xFF7E57C2).withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF7E57C2).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timeline_rounded,
                    color: const Color(0xFF7E57C2),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF7E57C2),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Stats Grid
        if (showShimmer)
          _buildLoadingStatsGrid(theme)
        else if (dashboardProvider.dashboardStats != null)
          StatsGrid(
            stats: dashboardProvider.dashboardStats!,
            isAdmin: true,
          )
        else if (dashboardProvider.error != null)
            _buildErrorStatsGrid(dashboardProvider.error, theme)
          else
            _buildEmptyStatsGrid(theme),
      ],
    );
  }

  Widget _buildLoadingStatsGrid(ThemeData theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: List.generate(8, (index) => _buildStatCardSkeleton(theme)),
    );
  }

  Widget _buildStatCardSkeleton(ThemeData theme) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEDE9FE), // Light purple
      highlightColor: const Color(0xFFF5F3FF), // Lighter purple
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7E57C2).withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFEDE9FE),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorStatsGrid(String? error, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFDF2F8),
            const Color(0xFFFCE7F3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFBCFE8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFBCFE8).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEC4899).withOpacity(0.1),
                  const Color(0xFFDB2777).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFF472B6),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: const Color(0xFFDB2777),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to Load Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFBE185D),
            ),
          ),
          const SizedBox(height: 8),
          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                error,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFFBE185D).withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyStatsGrid(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFAF5FF),
            const Color(0xFFF3E8FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE9D5FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE9D5FF).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7E57C2).withOpacity(0.15),
                  const Color(0xFF6D28D9).withOpacity(0.15),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFC4B5FD),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: const Color(0xFF7E57C2),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Statistics Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5B21B6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete tasks to see your statistics',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF5B21B6).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyOverviewCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF),
            const Color(0xFFFAF5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEDE9FE),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7E57C2).withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Company Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF4A1FB8),
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7E57C2),
                      const Color(0xFF6D28D9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7E57C2).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const CompanyOverview(),
        ],
      ),
    );
  }

  Widget _buildRecentTasksSection(
      DashboardProvider dashboardProvider, bool showShimmer, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF),
            const Color(0xFFFAF5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEDE9FE),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7E57C2).withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Tasks',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF4A1FB8),
                  letterSpacing: -0.5,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to all tasks
                },
                icon: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7E57C2),
                        const Color(0xFF6D28D9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7E57C2).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                tooltip: 'View all tasks',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Latest updates from your team',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF7E57C2).withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Recent Tasks Content
          if (showShimmer)
            _buildRecentTasksSkeleton(theme)
          else if (dashboardProvider.dashboardStats != null)
            RecentTasks(
              tasks: dashboardProvider.dashboardStats!.recentTasks,
              isLoading: false,
            )
          else if (dashboardProvider.error != null)
              _buildErrorRecentTasks(dashboardProvider.error, theme)
            else
              _buildEmptyRecentTasks(theme),
        ],
      ),
    );
  }

  Widget _buildRecentTasksSkeleton(ThemeData theme) {
    return Column(
      children: [
        for (int i = 0; i < 3; i++) ...[
          Shimmer.fromColors(
            baseColor: const Color(0xFFEDE9FE),
            highlightColor: const Color(0xFFF5F3FF),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEDE9FE),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 180,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 120,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorRecentTasks(String? error, ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFDF2F8),
                const Color(0xFFFBCFE8),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFF472B6),
              width: 3,
            ),
          ),
          child: Icon(
            Icons.error_rounded,
            color: const Color(0xFFDB2777),
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Failed to Load Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFBE185D),
          ),
        ),
        const SizedBox(height: 8),
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFFBE185D).withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyRecentTasks(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF5F3FF),
                const Color(0xFFEDE9FE),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFC4B5FD),
              width: 3,
            ),
          ),
          child: Icon(
            Icons.task_alt_rounded,
            color: const Color(0xFF7E57C2),
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'No Recent Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF5B21B6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create new tasks to get started',
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF5B21B6).withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7E57C2),
                const Color(0xFF6D28D9),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7E57C2).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to create task
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create First Task',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}