import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/models/report_model.dart';
import '../../providers/report_provider.dart';
import '../../providers/auth_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReport();
    });
  }

  Future<void> _loadReport() async {
    final reportProvider = context.read<ReportProvider>();
    final authProvider = context.read<AuthProvider>();

    // Auto-set company for managers
    if (authProvider.isManager && authProvider.companyId != null) {
      reportProvider.setCompanyId(authProvider.companyId);
    }

    await reportProvider.fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Reports'),
        actions: [
          // Debug button
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => _debugReport(reportProvider),
            tooltip: 'Debug Report',
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context, reportProvider, authProvider),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => reportProvider.fetchReport(),
          ),
        ],
      ),
      body: _buildBody(reportProvider, authProvider),
    );
  }

  Widget _buildBody(ReportProvider reportProvider, AuthProvider authProvider) {
    if (reportProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reportProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${reportProvider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => reportProvider.fetchReport(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (reportProvider.report == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No report data available'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => reportProvider.fetchReport(),
              child: const Text('Load Report'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => reportProvider.fetchReport(),
      child: CustomScrollView(
        slivers: [
          // Filter description
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[100],
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reportProvider.filterDescription,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  if (reportProvider.selectedUserId != null ||
                      reportProvider.selectedCompanyId != null ||
                      reportProvider.selectedStatus != null ||
                      reportProvider.selectedPriority != null ||
                      reportProvider.searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () => reportProvider.clearFilters(),
                      child: const Text('Clear Filters'),
                    ),
                ],
              ),
            ),
          ),

          // Summary Cards
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildSummaryCard(index, reportProvider);
                },
                childCount: 6,
              ),
            ),
          ),

          // Chart section
          SliverToBoxAdapter(
            child: _buildChartSection(reportProvider),
          ),

          // Tasks section
          SliverToBoxAdapter(
            child: _buildTasksSection(reportProvider),
          ),

          // Users section
          SliverToBoxAdapter(
            child: _buildUsersSection(reportProvider),
          ),

          // Add some bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int index, ReportProvider reportProvider) {
    final summary = reportProvider.filteredSummary;
    final List<Map<String, dynamic>> cards = [
      {
        'title': 'Total Tasks',
        'value': summary.totalTasks.toString(),
        'icon': Icons.task,
        'color': Colors.blue,
      },
      {
        'title': 'Completed',
        'value': summary.completedTasks.toString(),
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'In Progress',
        'value': summary.inProgressTasks.toString(),
        'icon': Icons.timelapse,
        'color': Colors.orange,
      },
      {
        'title': 'Pending',
        'value': summary.pendingTasks.toString(),
        'icon': Icons.pending_actions,
        'color': Colors.red,
      },
      {
        'title': 'Total Hours',
        'value': '${summary.totalHours}h',
        'icon': Icons.access_time,
        'color': Colors.purple,
      },
      {
        'title': 'Completion Rate',
        'value': '${summary.completionRate.toStringAsFixed(1)}%',
        'icon': Icons.percent,
        'color': Colors.teal,
      },
    ];

    final card = cards[index];
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(card['icon'] as IconData, color: card['color'] as Color, size: 32),
            const SizedBox(height: 8),
            Text(
              card['value'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card['title'] as String,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(ReportProvider reportProvider) {
    final chartData = reportProvider.filteredChartData;
    final totalTasks = reportProvider.filteredSummary.totalTasks;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final isSmallScreen = availableWidth < 350;

                return SizedBox(
                  height: isSmallScreen ? 180 : 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: chartData.map((data) {
                      final percentage = totalTasks > 0
                          ? (data.value / totalTasks * 100)
                          : 0;

                      return Container(
                        width: isSmallScreen ? 50 : 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${data.value}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 11 : 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: isSmallScreen ? 30 : 40,
                              height: percentage * (isSmallScreen ? 1.0 : 1.2),
                              decoration: BoxDecoration(
                                color: data.colorValue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: isSmallScreen ? 50 : 60,
                              child: Text(
                                data.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 10 : 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksSection(ReportProvider reportProvider) {
    final tasks = reportProvider.filteredDetailedTasks;

    if (tasks.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.task, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'No tasks found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try changing your filters',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detailed Tasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('${tasks.length} tasks'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tasks.take(5).map((task) => _buildTaskItem(task)),
            if (tasks.length > 5)
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to detailed tasks screen
                    _showAllTasksDialog(context, tasks);
                  },
                  child: const Text('View All Tasks'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(TaskDetail task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: task.statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(task.status),
            color: task.statusColor,
            size: 20,
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          task.assignedTo.isNotEmpty
              ? '${task.assignedTo} • ${task.company}'
              : task.company,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: task.priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.priorityText,
                  style: TextStyle(
                    color: task.priorityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${task.progress}%',
                style: TextStyle(
                  color: task.progress == 100 ? Colors.green : Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersSection(ReportProvider reportProvider) {
    final users = reportProvider.filteredUserReports;

    if (users.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.people, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'No user data available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Performance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('${users.length} users'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...users.take(5).map((user) => _buildUserItem(user)),
            if (users.length > 5)
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to user performance screen
                    _showAllUsersDialog(context, users);
                  },
                  child: const Text('View All Users'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(UserReport user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blue[100],
          child: Text(
            user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          user.name.isNotEmpty ? user.name : 'Unknown User',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          user.email.isNotEmpty ? user.email : 'No email',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${user.totalTasks} tasks',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 4,
                child: LinearProgressIndicator(
                  value: user.completionRate / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    user.completionRate >= 80 ? Colors.green :
                    user.completionRate >= 50 ? Colors.orange : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${user.completionRate.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in-progress':
        return Icons.timelapse;
      default:
        return Icons.pending;
    }
  }

  Future<void> _showFilterDialog(
      BuildContext context,
      ReportProvider reportProvider,
      AuthProvider authProvider,
      ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Report'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Month and Year
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: reportProvider.selectedMonth,
                          decoration: const InputDecoration(
                            labelText: 'Month',
                            isDense: true,
                          ),
                          items: reportProvider.availableMonths.map((month) {
                            return DropdownMenuItem<int>(
                              value: month['value'],
                              child: Text(month['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            reportProvider.setMonth(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: reportProvider.selectedYear,
                          decoration: const InputDecoration(
                            labelText: 'Year',
                            isDense: true,
                          ),
                          items: reportProvider.availableYears.map((year) {
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            reportProvider.setYear(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // User filter (only for admin)
                  if (authProvider.isAdmin)
                    DropdownButtonFormField<String>(
                      value: reportProvider.selectedUserId,
                      decoration: const InputDecoration(
                        labelText: 'Filter by User',
                        hintText: 'Select user',
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Users'),
                        ),
                        ...reportProvider.uniqueUsers.map((user) {
                          return DropdownMenuItem<String>(
                            value: user,
                            child: Text(user),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        reportProvider.setUserId(value);
                      },
                    ),

                  // Company filter (for admin, auto-set for manager)
                  if (authProvider.isAdmin)
                    ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: reportProvider.selectedCompanyId,
                        decoration: const InputDecoration(
                          labelText: 'Filter by Company',
                          hintText: 'Select company',
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Companies'),
                          ),
                          ...reportProvider.uniqueCompanies.map((company) {
                            return DropdownMenuItem<String>(
                              value: company,
                              child: Text(company),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          reportProvider.setCompanyId(value);
                        },
                      ),
                    ],

                  // Status filter
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: reportProvider.selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Status',
                      isDense: true,
                    ),
                    items: reportProvider.uniqueStatuses.map((status) {
                      return DropdownMenuItem<String>(
                        value: status == 'All' ? null : status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      reportProvider.setStatus(value);
                    },
                  ),

                  // Priority filter
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: reportProvider.selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Priority',
                      isDense: true,
                    ),
                    items: reportProvider.uniquePriorities.map((priority) {
                      return DropdownMenuItem<String>(
                        value: priority == 'All' ? null : priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (value) {
                      reportProvider.setPriority(value);
                    },
                  ),

                  // Search
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      reportProvider.setSearchQuery(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                reportProvider.clearFilters();
                Navigator.pop(context);
              },
              child: const Text('Clear All'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                reportProvider.fetchReport();
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  // Debug methods
  void _debugReport(ReportProvider reportProvider) {
    if (reportProvider.report != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Debug Report Info'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDebugInfo('Period', reportProvider.report!.period.formattedPeriod),
                _buildDebugInfo('Total Tasks', reportProvider.report!.detailed.length.toString()),
                _buildDebugInfo('User Reports', reportProvider.report!.userReports.length.toString()),

                const SizedBox(height: 16),
                const Text('Sample Tasks:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...reportProvider.report!.detailed.take(3).map((task) =>
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ${task.title}', style: const TextStyle(fontSize: 12)),
                          Text('  Assigned: ${task.assignedTo}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('  Company: ${task.company}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDebugInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAllTasksDialog(BuildContext context, List<TaskDetail> tasks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Tasks'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text('${task.assignedTo} • ${task.company}'),
                trailing: Chip(
                  label: Text(task.statusText),
                  backgroundColor: task.statusColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: task.statusColor),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAllUsersDialog(BuildContext context, List<UserReport> users) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Users'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.name.isNotEmpty
                      ? user.name.substring(0, 1).toUpperCase()
                      : '?'),
                ),
                title: Text(user.name.isNotEmpty ? user.name : 'Unknown User'),
                subtitle: Text(user.email.isNotEmpty ? user.email : 'No email'),
                trailing: Text('${user.completionRate.toStringAsFixed(1)}%'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}