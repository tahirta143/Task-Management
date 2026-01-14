import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/screens/Task/sub_task_dialog.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

class SubTaskListScreen extends StatefulWidget {
  final Task task;

  const SubTaskListScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<SubTaskListScreen> createState() => _SubTaskListScreenState();
}

class _SubTaskListScreenState extends State<SubTaskListScreen> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _loadUpdatedTask();
  }

  Future<void> _loadUpdatedTask() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    // Fetch the latest task data from provider
    final updatedTask = taskProvider.tasks.firstWhere(
          (t) => t.id == widget.task.id,
      orElse: () => widget.task,
    );

    if (mounted) {
      setState(() {
        _currentTask = updatedTask;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for changes in the task provider
    final taskProvider = Provider.of<TaskProvider>(context);
    final updatedTask = taskProvider.tasks.firstWhere(
          (t) => t.id == widget.task.id,
      orElse: () => widget.task,
    );

    if (_currentTask.id != updatedTask.id ||
        _currentTask.subTasks.length != updatedTask.subTasks.length) {
      setState(() {
        _currentTask = updatedTask;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final subTasks = _currentTask.subTasks;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress: ${_currentTask.title}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              '${_currentTask.completedSubtasks}/${_currentTask.totalSubtasks} subtasks',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshTaskData(taskProvider),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSubTaskDialog(taskProvider),
            tooltip: 'Add Progress',
          ),
        ],
      ),
      body: subTasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Progress yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first progress update',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddSubTaskDialog(taskProvider),
              icon: const Icon(Icons.add),
              label: const Text('Add Progress'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Progress Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Progress: ${_calculateTotalHours()} hours',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_countCompleted()} completed',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text('${subTasks.length} updates'),
                  backgroundColor: Colors.blue[100],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subTasks.length,
              itemBuilder: (context, index) {
                final subTask = subTasks[index];
                return _buildSubTaskCard(subTask, taskProvider);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSubTaskDialog(taskProvider),
        child: const Icon(Icons.add),
        tooltip: 'Add Progress',
      ),
    );
  }

  int _calculateTotalHours() {
    return _currentTask.subTasks.fold(
      0,
          (total, subTask) => total + subTask.hoursSpent,
    );
  }

  int _countCompleted() {
    return _currentTask.subTasks
        .where((subTask) => subTask.status == 'completed')
        .length;
  }

  Widget _buildSubTaskCard(SubTask subTask, TaskProvider taskProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getStatusColor(subTask.status),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${subTask.hoursSpent}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  'hrs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Text(
          subTask.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 12,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(subTask.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (subTask.remarks.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remarks:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    subTask.remarks,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(subTask.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(subTask.status),
                  width: 1,
                ),
              ),
              child: Text(
                subTask.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: _getStatusColor(subTask.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditSubTaskDialog(taskProvider, subTask);
            } else if (value == 'delete') {
              _showDeleteDialog(taskProvider, subTask);
            }
          },
        ),
        onTap: () => _showEditSubTaskDialog(taskProvider, subTask),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
        return Colors.blue;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _refreshTaskData(TaskProvider taskProvider) async {
    await taskProvider.fetchTasks();
    await _loadUpdatedTask();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress data refreshed'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _showAddSubTaskDialog(TaskProvider taskProvider) async {
    final result = await showDialog<SubTask>(
      context: context,
      builder: (context) => SubTaskDialog(
        taskId: _currentTask.id,
        isEditMode: false,
      ),
    );

    if (result != null && mounted) {
      final success = await taskProvider.addSubTask(
        taskId: _currentTask.id,
        subTask: result,
      );

      if (success) {
        // Refresh the task data
        await _loadUpdatedTask();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress added successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add progress'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _showEditSubTaskDialog(
      TaskProvider taskProvider,
      SubTask subTask,
      ) async {
    final result = await showDialog<SubTask>(
      context: context,
      builder: (context) => SubTaskDialog(
        taskId: _currentTask.id,
        existingSubTask: subTask,
        isEditMode: true,
      ),
    );

    if (result != null && mounted) {
      final success = await taskProvider.updateSubTask(
        taskId: _currentTask.id,
        subTaskId: subTask.id,
        subTask: result,
      );

      if (success) {
        // Refresh the task data
        await _loadUpdatedTask();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _showDeleteDialog(
      TaskProvider taskProvider,
      SubTask subTask,
      ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Progress'),
        content: const Text('Are you sure you want to delete this progress update?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await taskProvider.deleteSubTask(
                taskId: _currentTask.id,
                subTaskId: subTask.id,
              );

              if (success && mounted) {
                // Refresh the task data
                await _loadUpdatedTask();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress deleted successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}