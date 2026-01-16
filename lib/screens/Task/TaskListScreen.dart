import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taskflow_app/screens/Task/sub_task.dart';
import 'package:taskflow_app/screens/Task/taskCard.dart';
import '../../providers/task_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/task_model.dart';
import 'AddTaskScreen.dart';
import 'edittaskdialog.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFirstLoad = true; // Flag to track first load

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  void _loadTasks() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.fetchTasks().then((_) {
      // Set flag to false after first load
      if (_isFirstLoad && mounted) {
        setState(() {
          _isFirstLoad = false;
        });
      }
    });
  }

  void _showAddTaskDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTaskScreen(),
      ),
    );
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    print('Edit task: ${task.title}');

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAdmin && !authProvider.isManager) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You do not have permission to edit tasks'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditTaskDialog(
        task: task,
      ),
    );

    if (result != null && result['success'] == true) {
      _loadTasks();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Task updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _deleteTask(BuildContext context, Task task) async {
    print('Delete task: ${task.title}');

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAdmin && !authProvider.isManager) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You do not have permission to delete tasks'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text(
            'Are you sure you want to delete "${task.title}"?\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ??
        false;

    if (confirmDelete) {
      final currentContext = context;

      try {
        final success = await taskProvider.deleteTask(task.id);

        if (currentContext.mounted) {
          if (success) {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              SnackBar(
                content: Text('Task "${task.title}" deleted successfully'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              SnackBar(
                content: Text('Failed to delete task: ${taskProvider.error}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        if (currentContext.mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _viewTaskDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubTaskListScreen(task: task),
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
      body: _isFirstLoad && taskProvider.isLoading
          ? _buildShimmerLoading() // Shimmer for first load
          : Column(
        children: [
          // Search and Filter Bar
          _buildSearchFilterBar(taskProvider, screenWidth),

          // Task List
          Expanded(
            child: _buildTaskList(taskProvider),
          ),
        ],
      ),
    );
  }

  // Shimmer Loading Screen for first load
  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Shimmer Search and Filter Bar
          _buildShimmerSearchFilterBar(),

          // Shimmer Task Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (int i = 0; i < 6; i++) ...[
                  _buildShimmerTaskCard(),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer Search and Filter Bar
  Widget _buildShimmerSearchFilterBar() {
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
        children: [
          // Shimmer Search Bar
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Shimmer Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < 4; i++) ...[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80,
                      height: 36,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer Task Card - FIXED VERSION
  Widget _buildShimmerTaskCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status
              Row(
                children: [
                  Container(
                    width: 120,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
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
              const SizedBox(height: 12),

              // Description
              Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              // Details row - FIXED: Properly closed the Row widget
              Row(
                children: [
                  // Priority
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 60,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),

                  // Assignee
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Dates
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildTaskList(TaskProvider taskProvider) {
    // Show circular progress indicator for subsequent loads
    if (taskProvider.isLoading && !_isFirstLoad) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Check for errors
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

    final listKey = ValueKey<int>(taskProvider.tasks.length);

    return RefreshIndicator(
      key: listKey,
      onRefresh: () async {
        await taskProvider.fetchTasks();
      },
      child: ListView.builder(
        key: PageStorageKey<String>('task-list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          if (index >= taskProvider.tasks.length) {
            return const SizedBox.shrink();
          }

          final task = taskProvider.tasks[index];

          return TaskCard(
            key: ValueKey(task.id),
            task: task,
            onEdit: () => _editTask(context, task),
            onDelete: () => _deleteTask(context, task),
            onViewDetails: () => _viewTaskDetails(task),
          );
        },
      ),
    );
  }
}