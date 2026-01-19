// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:taskflow_app/screens/Task/TaskListScreen.dart';
//
// import '../../models/dashboard_model.dart';
//
//
// class RecentTasks extends StatelessWidget {
//   final List<RecentTask> tasks;
//
//   const RecentTasks({super.key, required this.tasks});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
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
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Recent Tasks',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               Icon(Icons.assignment, color: Colors.blue),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...tasks.take(3).map((task) => _buildTaskItem(task)),
//           if (tasks.length > 3)
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskListScreen()));},
//                 child: const Text('View All Tasks'),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTaskItem(RecentTask task) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 4,
//             height: 40,
//             decoration: BoxDecoration(
//               color: _getStatusColor(task.status),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   task.title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.person, size: 12, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       task.assignedTo.name,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.calendar_today,
//                         size: 12, color: Colors.grey.shade600),
//                     const SizedBox(width: 4),
//                     Text(
//                       DateFormat('MMM dd').format(task.endDate),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Chip(
//             label: Text(
//               task.status.toUpperCase(),
//               style: const TextStyle(fontSize: 10, color: Colors.white),
//             ),
//             backgroundColor: _getStatusColor(task.status),
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'in progress':
//         return Colors.orange;
//       case 'pending':
//         return Colors.yellow.shade700;
//       case 'delayed':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskflow_app/screens/Task/TaskListScreen.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/dashboard_model.dart';

class RecentTasks extends StatelessWidget {
  final List<RecentTask> tasks;
  final bool isLoading;

  const RecentTasks({
    super.key,
    required this.tasks,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 600;
    final bool isMediumScreen = screenWidth >= 600 && screenWidth < 1024;

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
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: isSmallScreen ? 12 : 16),
          if (isLoading)
            _buildShimmerTasks(context)
          else
            _buildTasksContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isLoading)
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: isSmallScreen ? 100 : 120,
              height: isSmallScreen ? 20 : 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          )
        else
          Text(
            'Recent Tasks',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

        if (isLoading)
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: isSmallScreen ? 20 : 24,
              height: isSmallScreen ? 20 : 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        else
          Icon(
            Icons.assignment,
            color: Colors.deepPurple,
            size: isSmallScreen ? 20 : 24,
          ),
      ],
    );
  }

  Widget _buildTasksContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Column(
      children: [
        ...tasks.take(3).map((task) => _buildTaskItem(task, context)),
        if (tasks.length > 3)
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListScreen()),
                );
              },
              child: Text(
                'View All Tasks',
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerTasks(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Column(
      children: [
        for (int i = 0; i < 3; i++) _buildShimmerTaskItem(context),
      ],
    );
  }

  Widget _buildShimmerTaskItem(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 4,
              height: isSmallScreen ? 32 : 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: double.infinity,
                    height: isSmallScreen ? 14 : 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: isSmallScreen ? 60 : 80,
                        height: isSmallScreen ? 10 : 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: isSmallScreen ? 50 : 60,
                        height: isSmallScreen ? 10 : 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: isSmallScreen ? 50 : 60,
              height: isSmallScreen ? 20 : 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(RecentTask task, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    final double iconSize = isSmallScreen ? 10 : 12;
    final double fontSizeSmall = isSmallScreen ? 10 : 12;
    final double fontSizeNormal = isSmallScreen ? 12 : 14;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: isSmallScreen ? 32 : 40,
            decoration: BoxDecoration(
              color: _getStatusColor(task.status),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: fontSizeNormal,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Row(
                  children: [
                    Icon(Icons.person, size: iconSize, color: Colors.grey.shade600),
                    SizedBox(width: isSmallScreen ? 2 : 4),
                    Text(
                      task.assignedTo.name,
                      style: TextStyle(
                        fontSize: fontSizeSmall,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Icon(Icons.calendar_today,
                        size: iconSize, color: Colors.grey.shade600),
                    SizedBox(width: isSmallScreen ? 2 : 4),
                    Text(
                      DateFormat('MMM dd').format(task.endDate),
                      style: TextStyle(
                        fontSize: fontSizeSmall,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Chip(
            label: Text(
              task.status.toUpperCase(),
              style: TextStyle(
                fontSize: isSmallScreen ? 8 : 10,
                color: Colors.white,
              ),
            ),
            backgroundColor: _getStatusColor(task.status),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 6 : 8,
              vertical: isSmallScreen ? 1 : 2,
            ),
            visualDensity: isSmallScreen
                ? VisualDensity.compact
                : VisualDensity.standard,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.yellow.shade700;
      case 'delayed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}