import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/screens/Task/sub_task.dart';
// import 'package:taskflow_app/screens/Task/subtask_list_screen.dart';
import '../../models/task_model.dart';
import '../../providers/auth_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function()? onEdit;
  final Function()? onDelete;
  final Function()? onViewDetails;

  const TaskCard({
    Key? key,
    required this.task,
    this.onEdit,
    this.onDelete,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallPhone = screenWidth < 360;
    final authProvider = Provider.of<AuthProvider>(context);

    // Check if user can edit/delete (only admin and manager)
    final canEditDelete = authProvider.isAdmin || authProvider.isManager;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallPhone ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 8 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubTaskListScreen(task: task),
            ),
          );
        },
        borderRadius: BorderRadius.circular(isSmallPhone ? 8 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and priority
            Container(
              padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority).withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSmallPhone ? 8 : 12),
                  topRight: Radius.circular(isSmallPhone ? 8 : 12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallPhone ? 14 : 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isSmallPhone)
                          Text(
                            _formatDate(task.startDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isSmallPhone) _buildPriorityBadge(task.priority, isSmallPhone),
                ],
              ),
            ),

            // Task details
            Padding(
              padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (!isSmallPhone || task.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        task.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isSmallPhone ? 12 : 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  // Key Information Row - REMOVED COMPANY
                  if (isSmallPhone)
                    _buildCompactInfoRow()
                  else
                    _buildDetailedInfo(),

                  const SizedBox(height: 12),

                  // Dates Row
                  _buildDatesRow(isSmallPhone),

                  // Progress and Status Row
                  // _buildProgressStatusRow(isSmallPhone),

                  // Sub-tasks summary
                  if (task.subTasks.isNotEmpty)
                    _buildSubTasksSummary(context, isSmallPhone),

                  // Tags (show only if there's space)
                  if (task.tags.isNotEmpty && !isSmallPhone)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: task.tags.map((tag) {
                            return Chip(
                              label: Text(
                                tag,
                                style: TextStyle(fontSize: isSmallPhone ? 10 : 11),
                              ),
                              backgroundColor: Colors.grey[100],
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 0,
                              ),
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  // Action buttons
                  const SizedBox(height: 10),
                  _buildActionButtons(context, isSmallPhone, canEditDelete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoRow() {
    return Row(
      children: [
        Icon(Icons.person_outline, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            task.assignedTo.name,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // REMOVED COMPANY ICON AND TEXT
      ],
    );
  }

  Widget _buildDetailedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Assigned to only - REMOVED COMPANY
        Row(
          children: [
            Icon(Icons.person_outline, size: 16, color: Colors.grey[500]),
            const SizedBox(width: 8),
            Text(
              'Assigned to: ${task.assignedTo.name}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  Widget _buildDatesRow(bool isSmallPhone) {
    return Row(
      children: [
        Icon(Icons.calendar_today_outlined, size: isSmallPhone ? 14 : 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${_formatDate(task.startDate)} - ${_formatDate(task.endDate)}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isSmallPhone ? 12 : 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Widget _buildProgressStatusRow(bool isSmallPhone) {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 12),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Progress: ${task.progress}%',
  //                 style: TextStyle(
  //                   fontSize: isSmallPhone ? 12 : 13,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               LinearProgressIndicator(
  //                 value: task.progress / 100,
  //                 backgroundColor: Colors.grey[200],
  //                 color: _getStatusColor(task.status),
  //                 minHeight: 6,
  //                 borderRadius: BorderRadius.circular(3),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         _buildStatusBadge(task.status, isSmallPhone),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSubTasksSummary(BuildContext context, bool isSmallPhone) {
    final completedSubTasks = task.subTasks.where((st) => st.status == 'completed').length;
    final totalHours = task.subTasks.fold(0, (sum, st) => sum + st.hoursSpent);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubTaskListScreen(task: task),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[100]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.checklist,
              size: isSmallPhone ? 16 : 18,
              color: Colors.blue[600],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task.subTasks.length} Progress Items',
                    style: TextStyle(
                      fontSize: isSmallPhone ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[800],
                    ),
                  ),
                  if (!isSmallPhone)
                    Text(
                      '$completedSubTasks completed • ${totalHours}h total',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[600],
                      ),
                    ),
                ],
              ),
            ),
            if (isSmallPhone)
              Text(
                '$completedSubTasks/${task.subTasks.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            if (!isSmallPhone)
              Icon(
                Icons.chevron_right,
                color: Colors.blue[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isSmallPhone, bool canEditDelete) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hasSpaceForText = screenWidth > 400;

    return Row(
      children: [
        // View Details Button - Always visible for all users
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onViewDetails ?? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubTaskListScreen(task: task),
                ),
              );
            },
            icon: const Icon(Icons.visibility_outlined, size: 16),
            label: hasSpaceForText ? const Text('View Progress') : const SizedBox.shrink(),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue[600],
              backgroundColor: Colors.blue[50],
              padding: EdgeInsets.symmetric(
                horizontal: isSmallPhone ? 6 : 10,
                vertical: isSmallPhone ? 6 : 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),

        // Edit Button - Only for admin and manager
        if (canEditDelete) ...[
          const SizedBox(width: 8),
          Container(
            width: isSmallPhone ? 40 : null,
            child: ElevatedButton(
              onPressed: onEdit ?? () {
                // Show dialog or navigate to edit screen
                _showEditDialog(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.orange[600],
                backgroundColor: Colors.orange[50],
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallPhone ? 8 : 12,
                  vertical: isSmallPhone ? 8 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isSmallPhone
                  ? const Icon(Icons.edit, size: 16)
                  : const Text('Edit'),
            ),
          ),
        ],

        // Delete Button - Only for admin and manager
        if (canEditDelete) ...[
          const SizedBox(width: 8),
          Container(
            width: isSmallPhone ? 40 : null,
            child: ElevatedButton(
              onPressed: onDelete ?? () {
                // Show confirmation dialog
                _showDeleteDialog(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red[600],
                backgroundColor: Colors.red[50],
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallPhone ? 8 : 12,
                  vertical: isSmallPhone ? 8 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isSmallPhone
                  ? const Icon(Icons.delete_outline, size: 16)
                  : const Text('Delete'),
            ),
          ),
        ],
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    // Implement edit dialog or navigation to edit screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: const Text('Edit functionality to be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Call your edit API here
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Call your delete API here
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority, bool isSmallPhone) {
    final priorityColors = {
      'low': Colors.green,
      'medium': Colors.orange,
      'high': Colors.red,
    };

    final priorityText = {
      'low': 'Low',
      'medium': 'Med',
      'high': 'High',
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallPhone ? 6 : 10,
        vertical: isSmallPhone ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: priorityColors[priority]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isSmallPhone ? 6 : 12),
        border: Border.all(color: priorityColors[priority]!),
      ),
      child: Text(
        isSmallPhone ? priorityText[priority]![0] : priorityText[priority]!,
        style: TextStyle(
          color: priorityColors[priority],
          fontSize: isSmallPhone ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isSmallPhone) {
    final statusColors = {
      'pending': Colors.orange,
      'in-progress': Colors.blue,
      'completed': Colors.green,
    };

    final statusText = {
      'pending': isSmallPhone ? 'Pend' : 'Pending',
      'in-progress': isSmallPhone ? 'Progress' : 'In Progress',
      'completed': isSmallPhone ? 'Done' : 'Completed',
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallPhone ? 6 : 10,
        vertical: isSmallPhone ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: statusColors[status]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isSmallPhone ? 6 : 12),
        border: Border.all(color: statusColors[status]!),
      ),
      child: Text(
        statusText[status]!,
        style: TextStyle(
          color: statusColors[status],
          fontSize: isSmallPhone ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'pending':
  //       return Colors.orange;
  //     case 'in-progress':
  //       return Colors.blue;
  //     case 'completed':
  //       return Colors.green;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}