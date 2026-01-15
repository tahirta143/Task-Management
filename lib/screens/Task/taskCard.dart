import 'package:flutter/material.dart';
import 'package:taskflow_app/screens/Task/sub_task.dart';
import '../../models/task_model.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
    final isMediumPhone = screenWidth < 400;

    // Get current user role for permission check
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
                      padding: const EdgeInsets.only(bottom: 12),
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

                  // Key Information Row (compressed on small screens)
                  if (isSmallPhone)
                    _buildCompactInfoRow() // FIXED: Removed context parameter as it's not needed
                  else
                    _buildDetailedInfo(context), // FIXED: Added context parameter

                  const SizedBox(height: 12),

                  // Progress Row with Edit/Delete buttons
                  _buildProgressRow(context, isSmallPhone, canEditDelete),

                  // Sub-tasks summary
                  if (task.allSubTasks.isNotEmpty)
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

                  // Action buttons (only View Details remains)
                  const SizedBox(height: 12),
                  _buildActionButtons(context, isSmallPhone),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoRow() { // FIXED: Removed parameters as they're not used
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
        Icon(Icons.business_outlined, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            task.company.name,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedInfo(BuildContext context) { // FIXED: Added context parameter
    final screenWidth = MediaQuery.of(context).size.width; // FIXED: Now has access to context
    final isMobile = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Assigned to row
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: isMobile ? 14 : 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Assigned to: ${task.assignedTo.name}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isMobile ? 12 : 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Company row
        // Row(
        //   children: [
        //     Icon(
        //       Icons.business_outlined,
        //       size: isMobile ? 14 : 16,
        //       color: Colors.grey[500],
        //     ),
        //     const SizedBox(width: 8),
        //     Expanded(
        //       child: Text(
        //         'Company: ${task.company.name}',
        //         style: TextStyle(
        //           color: Colors.grey[600],
        //           fontSize: isMobile ? 12 : 13,
        //         ),
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 6),

        // Dates row
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: isMobile ? 14 : 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_formatDate(task.startDate)} - ${_formatDate(task.endDate)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isMobile ? 12 : 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressRow(BuildContext context, bool isSmallPhone, bool canEditDelete) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumPhone = screenWidth < 400;

    // Calculate progress if needed
    final allSubTasks = task.allSubTasks;
    final totalSubTasks = allSubTasks.length;
    final completedSubTasks = allSubTasks.where((st) => st.status == 'completed').length;
    final progressPercentage = totalSubTasks > 0 ? (completedSubTasks / totalSubTasks * 100).toInt() : 0;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Progress indicator and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Progress: ',
                      style: TextStyle(
                        fontSize: isSmallPhone ? 12 : 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '$progressPercentage%',
                      style: TextStyle(
                        fontSize: isSmallPhone ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: _getProgressColor(progressPercentage),
                      ),
                    ),
                    if (totalSubTasks > 0) ...[
                      SizedBox(width: isSmallPhone ? 4 : 8),
                      Text(
                        '($completedSubTasks/$totalSubTasks)',
                        style: TextStyle(
                          fontSize: isSmallPhone ? 10 : 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progressPercentage / 100,
                  backgroundColor: Colors.grey[200],
                  color: _getProgressColor(progressPercentage),
                  minHeight: isSmallPhone ? 4 : 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),

          // Edit/Delete buttons (only for admin/manager)
          if (canEditDelete && (onEdit != null || onDelete != null)) ...[
            SizedBox(width: isSmallPhone ? 8 : 12),
            Wrap(
              spacing: isSmallPhone ? 6 : 8,
              children: [
                // Edit Button
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: EdgeInsets.all(isSmallPhone ? 6 : 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade100),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: isSmallPhone ? 16 : 18,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ),

                // Delete Button
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: EdgeInsets.all(isSmallPhone ? 6 : 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: isSmallPhone ? 16 : 18,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubTasksSummary(BuildContext context, bool isSmallPhone) {
    final allSubTasks = task.allSubTasks;
    final completedSubTasks = allSubTasks.where((st) => st.status == 'completed').length;
    final totalHours = allSubTasks.fold(0, (sum, st) => sum + st.hoursSpent);

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
                    '${allSubTasks.length} Progress Items',
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
                '$completedSubTasks/${allSubTasks.length}',
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

  Widget _buildActionButtons(BuildContext context, bool isSmallPhone) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hasSpaceForText = screenWidth > 400;

    return Row(
      children: [
        // Only View Details button remains
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
            label: hasSpaceForText ? const Text('View Details') : const SizedBox.shrink(),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue[600],
              backgroundColor: Colors.blue[50],
              padding: EdgeInsets.symmetric(
                horizontal: isSmallPhone ? 8 : 12,
                vertical: isSmallPhone ? 8 : 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
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

  Color _getProgressColor(int progress) {
    if (progress >= 100) return Colors.green;
    if (progress >= 50) return Colors.blue;
    if (progress > 0) return Colors.orange;
    return Colors.grey;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}