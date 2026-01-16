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
      color: theme.primaryColor,
      backgroundColor: theme.scaffoldBackgroundColor,
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
            theme.primaryColor.withOpacity(0.9),
            theme.primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.5),
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 28,
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
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.waving_hand,
                      color: Colors.yellow[300],
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Here\'s what\'s happening with your tasks today.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
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
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onBackground,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timeline,
                    color: theme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
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
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
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
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
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
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.red[600],
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to Load Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onBackground,
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
                  color: Colors.grey.shade600,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
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
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_outlined,
              color: theme.primaryColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Statistics Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete tasks to see your statistics',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor.withOpacity(0.9),
                      theme.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to all tasks
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: theme.primaryColor,
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
              color: Colors.grey.shade600,
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
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
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
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline_rounded,
            color: Colors.red[600],
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Failed to Load Tasks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
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
                color: Colors.grey.shade600,
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
            color: theme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.task_alt_outlined,
            color: theme.primaryColor,
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'No Recent Tasks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create new tasks to get started',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to create task
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Create First Task',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}