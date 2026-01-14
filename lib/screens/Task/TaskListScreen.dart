// screens/tasks/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/screens/Task/taskCard.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/company_provider.dart';
import '../../providers/user_provider.dart';
import 'AddTaskScreen.dart';
import 'edittaskdialog.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  void _loadTasks() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.fetchTasks();
  }

  void _showAddTaskDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTaskScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Task Management',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          if (authProvider.isAdmin || authProvider.isManager)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                onPressed: _showAddTaskDialog,
                icon: const Icon(Icons.add_task, size: 18),
                label: const Text(
                  'Add Task',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
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
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchFilterBar(taskProvider, screenWidth),

          // Statistics Cards
          //_buildStatisticsCards(taskProvider),

          // Task List
          Expanded(
            child: _buildTaskList(taskProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterBar(TaskProvider taskProvider, double screenWidth) {
    final isSmall = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmall ? 12 : 16),
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
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) => taskProvider.setSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Search tasks by title, description, or assignee...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  taskProvider.setSearchQuery('');
                },
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmall ? 12 : 16,
                vertical: isSmall ? 12 : 14,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Status Filter
                _buildFilterChip(
                  'Status',
                  taskProvider.filterStatus,
                  taskProvider.statusOptions,
                  taskProvider.setFilterStatus,
                  isSmall,
                ),
                SizedBox(width: isSmall ? 8 : 12),

                // Priority Filter
                _buildFilterChip(
                  'Priority',
                  taskProvider.filterPriority,
                  taskProvider.priorityOptions,
                  taskProvider.setFilterPriority,
                  isSmall,
                ),
                SizedBox(width: isSmall ? 8 : 12),

                // Company Filter
                _buildFilterChip(
                  'Company',
                  taskProvider.filterCompany,
                  taskProvider.uniqueCompanies,
                  taskProvider.setFilterCompany,
                  isSmall,
                ),

                // Clear Filters Button
                if (taskProvider.filterStatus != 'All' ||
                    taskProvider.filterPriority != 'All' ||
                    taskProvider.filterCompany != 'All' ||
                    taskProvider.searchQuery.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: isSmall ? 8 : 12),
                    child: FilterChip(
                      label: Text(
                        'Clear All',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: isSmall ? 12 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: false,
                      onSelected: (_) => taskProvider.clearFilters(),
                      backgroundColor: Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.red[200]!),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 12 : 16,
                        vertical: isSmall ? 6 : 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label,
      String currentFilter,
      List<String> options,
      Function(String) onSelected,
      bool isSmall,
      ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentFilter,
        icon: Icon(Icons.arrow_drop_down, size: isSmall ? 18 : 20),
        elevation: 2,
        style: TextStyle(
          fontSize: isSmall ? 13 : 14,
          color: Colors.black87,
        ),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onSelected(newValue);
          }
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  // Widget _buildStatisticsCards(TaskProvider taskProvider) {
  //   final totalTasks = taskProvider.allTasks.length;
  //   final pendingTasks = taskProvider.allTasks.where((t) => t.status == 'pending').length;
  //   final inProgressTasks = taskProvider.allTasks.where((t) => t.status == 'in-progress').length;
  //   final completedTasks = taskProvider.allTasks.where((t) => t.status == 'completed').length;
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     child: Row(
  //       children: [
  //         _buildStatCard('Total', totalTasks, Icons.list, Colors.blue),
  //         const SizedBox(width: 12),
  //         _buildStatCard('Pending', pendingTasks, Icons.pending, Colors.orange),
  //         const SizedBox(width: 12),
  //         _buildStatCard('In Progress', inProgressTasks, Icons.autorenew, Colors.blue),
  //         const SizedBox(width: 12),
  //         _buildStatCard('Completed', completedTasks, Icons.check_circle, Colors.green),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskProvider taskProvider) {
    if (taskProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (taskProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${taskProvider.error}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => taskProvider.fetchTasks(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (taskProvider.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              taskProvider.searchQuery.isNotEmpty
                  ? 'No tasks found matching "${taskProvider.searchQuery}"'
                  : 'No tasks available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (taskProvider.searchQuery.isNotEmpty)
              TextButton(
                onPressed: () => taskProvider.clearFilters(),
                child: const Text('Clear filters'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await taskProvider.fetchTasks();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return TaskCard(
            task: task,
            onEdit: () => _editTask(context, task, taskProvider),
            onDelete: () => _deleteTask(context, task.id, taskProvider),
          );

        },
      ),
    );
  }Future<void> _editTask(BuildContext context, Task task, TaskProvider taskProvider) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditTaskDialog(
        task: task,
        taskProvider: taskProvider,
      ),
    );

    if (result != null && result['success'] == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _deleteTask(BuildContext context, String taskId, TaskProvider taskProvider) async {
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
            onPressed: () async {
              Navigator.pop(context);
              final success = await taskProvider.deleteTask(taskId);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}