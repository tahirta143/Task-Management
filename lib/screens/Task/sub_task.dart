import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taskflow_app/screens/Task/sub_task_dialog.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/auth_provider.dart';

class SubTaskListScreen extends StatefulWidget {
  final Task task;

  const SubTaskListScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<SubTaskListScreen> createState() => _SubTaskListScreenState();
}

class _SubTaskListScreenState extends State<SubTaskListScreen> {
  late Task _currentTask;
  bool _isRefreshing = false;
  bool _isDisposed = false;
  bool _isLoading = false; // Add for shimmer
  Map<String, List<SubTask>> _groupedSubTasks = {};
  String? _selectedDateKey;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _isDisposed = false;
    _isLoading = true; // Start with loading
    _groupedSubTasks = _groupSubTasksByDate();

    // Load data with shimmer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (!isMounted) return;

    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    if (isMounted) {
      setState(() {
        _isLoading = false;
      });
      await _refreshTaskData();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  bool get isMounted => !_isDisposed && mounted;

  void _updateTaskFromProvider() {
    if (!isMounted) return;

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    try {
      final updatedTask = taskProvider.tasks.firstWhere(
            (t) => t.id == widget.task.id,
        orElse: () => widget.task,
      );

      if (isMounted) {
        setState(() {
          _currentTask = updatedTask;
          _groupedSubTasks = _groupSubTasksByDate();
        });
      }
    } catch (e) {
      print('Error updating task from provider: $e');
    }
  }

  Map<String, List<SubTask>> _groupSubTasksByDate() {
    final Map<String, List<SubTask>> grouped = {};

    for (final day in _currentTask.days) {
      final dateKey = _formatDateKey(day.date);
      grouped[dateKey] = day.subTasks;
    }

    return grouped;
  }

  String? _getDateKeyForSubTask(SubTask subTask) {
    for (final entry in _groupedSubTasks.entries) {
      if (entry.value.contains(subTask)) {
        return entry.key;
      }
    }
    return null;
  }

  List<SubTask> get _allSubTasks {
    return _currentTask.days.expand((day) => day.subTasks).toList();
  }

  Future<void> _refreshTaskData() async {
    if (_isRefreshing || !isMounted) return;

    if (isMounted) {
      setState(() {
        _isRefreshing = true;
      });
    }

    try {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.fetchTasks(forceRefresh: true);

      await Future.delayed(const Duration(milliseconds: 300));
      _updateTaskFromProvider();
    } catch (e) {
      print('Error refreshing task data: $e');
      _showSnackBar('Error refreshing data: ${e.toString()}');
    } finally {
      if (isMounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _refreshWithShimmer() async {
    if (!isMounted) return;

    setState(() {
      _isLoading = true;
    });

    await _refreshTaskData();

    if (isMounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isTaskAssignedUser(AuthProvider authProvider) {
    return authProvider.userId == _currentTask.assignedTo.id;
  }

  bool _canEditSubTask(AuthProvider authProvider) {
    if (authProvider.isAdmin) return true;
    if (authProvider.isStaff) {
      return _isTaskAssignedUser(authProvider);
    }
    return false;
  }

  bool _canDeleteSubTask(AuthProvider authProvider) {
    if (authProvider.isAdmin) return true;
    if (authProvider.isStaff) {
      return _isTaskAssignedUser(authProvider);
    }
    return false;
  }

  bool _canChangeStatus(AuthProvider authProvider) {
    if (authProvider.isAdmin) return true;
    if (authProvider.isManager) {
      return authProvider.companyId == _currentTask.company.id;
    }
    return false;
  }

  bool _canAddSubTask(AuthProvider authProvider) {
    if (authProvider.isAdmin) return true;
    if (authProvider.isManager) {
      return authProvider.companyId == _currentTask.company.id;
    }
    if (authProvider.isStaff) {
      return _isTaskAssignedUser(authProvider);
    }
    return false;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!isMounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final canEdit = _canEditSubTask(authProvider);
    final canDelete = _canDeleteSubTask(authProvider);
    final canChangeStatus = _canChangeStatus(authProvider);
    final canAdd = _canAddSubTask(authProvider);
    final isAssignedUser = _isTaskAssignedUser(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress: ${_currentTask.title}',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshTaskData,
            tooltip: 'Refresh',
          ),
          if (canAdd)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddSubTaskDialog(authProvider),
              tooltip: 'Add Progress',
            ),
        ],
      ),
      body: _isLoading
          ? _buildShimmerLoading()
          : _currentTask.days.isEmpty || _allSubTasks.isEmpty
          ? _buildEmptyState(authProvider, canAdd)
          : _buildSubTaskList(authProvider, canEdit, canDelete, canChangeStatus, isAssignedUser),
      floatingActionButton: canAdd && !_isLoading
          ? FloatingActionButton(
        onPressed: () => _showAddSubTaskDialog(authProvider),
        child: const Icon(Icons.add),
        tooltip: 'Add Progress',
      )
          : null,
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Shimmer Statistics Card
            _buildShimmerStatisticsCard(),
            const SizedBox(height: 16),

            // Shimmer Task Info Card
            _buildShimmerTaskInfoCard(),
            const SizedBox(height: 16),

            // Shimmer Date Headers with Sub-tasks
            for (int i = 0; i < 3; i++) ...[
              _buildShimmerDateHeader(),
              const SizedBox(height: 8),
              for (int j = 0; j < 2; j++)
                _buildShimmerSubTaskCard(),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerStatisticsCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerStatCircle(),
                  _buildShimmerStatCircle(),
                  _buildShimmerStatCircle(),
                  _buildShimmerStatCircle(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 100,
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
        ),
      ),
    );
  }

  Widget _buildShimmerStatCircle() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerTaskInfoCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 80,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerDateHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 120,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildShimmerSubTaskCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Circle with hours
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 60,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AuthProvider authProvider, bool canAdd) {
    return Center(
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
            'No progress updates yet',
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
          if (canAdd)
            ElevatedButton.icon(
              onPressed: () => _showAddSubTaskDialog(authProvider),
              icon: const Icon(Icons.add),
              label: const Text('Add Progress'),
            )
          else
            Text(
              'Only assigned user can add progress updates',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubTaskList(AuthProvider authProvider, bool canEdit, bool canDelete, bool canChangeStatus, bool isAssignedUser) {
    final dates = _groupedSubTasks.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return RefreshIndicator(
      onRefresh: _refreshTaskData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Statistics Card
          _buildStatisticsCard(),
          const SizedBox(height: 16),

          // Task Info Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assigned to: ${_currentTask.assignedTo.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isAssignedUser)
                    Text(
                      'You are assigned to this task',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Sub-tasks list
          ...dates.map((date) {
            final subTasksForDate = _groupedSubTasks[date] ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Text(
                    _formatDateDisplay(DateTime.parse(date)),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),

                // Sub-tasks for this date
                ...subTasksForDate.map((subTask) {
                  return _buildSubTaskCard(subTask, date, authProvider, canEdit, canDelete, canChangeStatus, isAssignedUser);
                }),

                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSubTaskCard(SubTask subTask, String dateKey, AuthProvider authProvider,
      bool canEdit, bool canDelete, bool canChangeStatus, bool isAssignedUser) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getStatusColor(subTask.status),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              '${subTask.hoursSpent}h',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subTask.description,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            if (isAssignedUser)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Text(
                    'Your Task',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(DateTime.parse(dateKey))}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Remarks: ${subTask.remarks.isNotEmpty ? subTask.remarks : 'None'}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (canChangeStatus)
                  GestureDetector(
                    onTap: () {
                      _selectedDateKey = dateKey;
                      _showStatusChangeDialog(subTask, authProvider);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(subTask.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(subTask.status),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            subTask.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: _getStatusColor(subTask.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit,
                            size: 10,
                            color: _getStatusColor(subTask.status),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(subTask.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(subTask.status),
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
                const SizedBox(width: 8),
                Text(
                  'Updated: ${_formatTime(subTask.updatedAt)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: (canEdit || canDelete || canChangeStatus)
            ? PopupMenuButton(
          itemBuilder: (context) {
            final items = <PopupMenuEntry<String>>[];

            if (canEdit) {
              items.add(
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
              );
            }

            if (canDelete) {
              items.add(
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
              );
            }

            if (canChangeStatus) {
              items.add(
                const PopupMenuItem(
                  value: 'change_status',
                  child: Row(
                    children: [
                      Icon(Icons.swap_vert, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Change Status'),
                    ],
                  ),
                ),
              );
            }

            return items;
          },
          onSelected: (value) async {
            if (value == 'edit' && canEdit) {
              _selectedDateKey = dateKey;
              _showEditSubTaskDialog(subTask, authProvider);
            } else if (value == 'change_status' && canChangeStatus) {
              _selectedDateKey = dateKey;
              _showStatusChangeDialog(subTask, authProvider);
            } else if (value == 'delete' && canDelete) {
              _selectedDateKey = dateKey;
              _showDeleteDialog(subTask, authProvider);
            }
          },
        )
            : null,
        onTap: () {
          _selectedDateKey = dateKey;
          if (canEdit) {
            _showEditSubTaskDialog(subTask, authProvider);
          } else if (canChangeStatus) {
            _showStatusChangeDialog(subTask, authProvider);
          }
        },
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
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  String _formatDateDisplay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _showAddSubTaskDialog(AuthProvider authProvider) async {
    if (!_canAddSubTask(authProvider)) {
      _showSnackBar('Only assigned user can add progress updates', isError: true);
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SubTaskDialog(
        taskId: _currentTask.id,
        isEditMode: false,
      ),
    );

    if (result != null && isMounted) {
      // Show loading shimmer
      setState(() {
        _isLoading = true;
      });

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final success = await taskProvider.addSubTask(
        taskId: _currentTask.id,
        date: result['date'],
        description: result['description'],
        status: result['status'],
        hoursSpent: result['hoursSpent'],
        remarks: result['remarks'],
      );

      if (success) {
        _showSnackBar('Progress added successfully');

        // Force refresh with shimmer
        await _refreshWithShimmer();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to add progress: ${taskProvider.error}', isError: true);
      }
    }
  }

  Future<void> _showEditSubTaskDialog(SubTask subTask, AuthProvider authProvider) async {
    if (!_canEditSubTask(authProvider)) {
      _showSnackBar('You do not have permission to edit this progress', isError: true);
      return;
    }

    final dateKey = _selectedDateKey ?? _getDateKeyForSubTask(subTask) ?? _formatDateKey(subTask.createdAt);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SubTaskDialog(
        taskId: _currentTask.id,
        existingSubTask: subTask,
        existingDate: dateKey,
        isEditMode: true,
      ),
    );

    if (result != null && isMounted) {
      // Show loading shimmer
      setState(() {
        _isLoading = true;
      });

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final success = await taskProvider.updateSubTask(
        taskId: _currentTask.id,
        subTaskId: subTask.id,
        date: result['date'] ?? dateKey,
        description: result['description'] ?? '',
        status: result['status'] ?? 'pending',
        hoursSpent: result['hoursSpent'] ?? 0,
        remarks: result['remarks'] ?? '',
      );

      if (success) {
        _showSnackBar('Progress updated successfully');

        // Force refresh with shimmer
        await _refreshWithShimmer();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to update progress: ${taskProvider.error}', isError: true);
      }
    }
  }

  Future<void> _showStatusChangeDialog(SubTask subTask, AuthProvider authProvider) async {
    if (!_canChangeStatus(authProvider)) {
      _showSnackBar('You do not have permission to change status', isError: true);
      return;
    }

    final dateKey = _selectedDateKey ?? _getDateKeyForSubTask(subTask) ?? _formatDateKey(subTask.createdAt);
    String? selectedStatus;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusOptionInDialog('pending', 'Pending', subTask.status, (value) {
              selectedStatus = value;
              Navigator.pop(context);
            }),
            const SizedBox(height: 12),
            _buildStatusOptionInDialog('in-progress', 'In Progress', subTask.status, (value) {
              selectedStatus = value;
              Navigator.pop(context);
            }),
            const SizedBox(height: 12),
            _buildStatusOptionInDialog('completed', 'Completed', subTask.status, (value) {
              selectedStatus = value;
              Navigator.pop(context);
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedStatus != null && isMounted) {
      // Show loading shimmer
      setState(() {
        _isLoading = true;
      });

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final success = await taskProvider.updateSubTask(
        taskId: _currentTask.id,
        subTaskId: subTask.id,
        date: dateKey,
        description: subTask.description,
        status: selectedStatus!,
        hoursSpent: subTask.hoursSpent,
        remarks: subTask.remarks,
      );

      if (success) {
        _showSnackBar('Status updated to ${selectedStatus!.toUpperCase()}');

        // Force refresh with shimmer
        await _refreshWithShimmer();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to update status: ${taskProvider.error}', isError: true);
      }
    }
  }

  Widget _buildStatusOptionInDialog(String value, String label, String currentStatus, Function(String) onSelected) {
    final isCurrent = currentStatus == value;
    final color = _getStatusColor(value);

    return GestureDetector(
      onTap: () => onSelected(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent ? color.withOpacity(0.2) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent ? color : Colors.grey[300]!,
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isCurrent ? color : Colors.grey[700],
              ),
            ),
            const Spacer(),
            if (isCurrent)
              Icon(
                Icons.check_circle,
                color: color,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(SubTask subTask, AuthProvider authProvider) async {
    if (!_canDeleteSubTask(authProvider)) {
      _showSnackBar('You do not have permission to delete this progress', isError: true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Progress'),
        content: const Text('Are you sure you want to delete this progress update?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && isMounted) {
      // Show loading shimmer
      setState(() {
        _isLoading = true;
      });

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final success = await taskProvider.deleteSubTask(
        taskId: _currentTask.id,
        subTaskId: subTask.id,
      );

      if (success) {
        _showSnackBar('Progress deleted successfully');

        // Force refresh with shimmer
        await _refreshWithShimmer();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to delete progress: ${taskProvider.error}', isError: true);
      }
    }
  }

  Widget _buildStatisticsCard() {
    final allSubTasks = _allSubTasks;
    final completed = allSubTasks.where((st) => st.status == 'completed').length;
    final inProgress = allSubTasks.where((st) => st.status == 'in-progress').length;
    final pending = allSubTasks.where((st) => st.status == 'pending').length;
    final totalHours = allSubTasks.fold(0, (sum, st) => sum + st.hoursSpent);

    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Total', '${allSubTasks.length}', Colors.blue),
                _buildStatItem('Completed', '$completed', Colors.green),
                _buildStatItem('In Progress', '$inProgress', Colors.orange),
                _buildStatItem('Pending', '$pending', Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Total Hours: $totalHours hours',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}