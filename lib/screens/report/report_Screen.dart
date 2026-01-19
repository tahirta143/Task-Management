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
  final Color primaryColor = const Color(0xFF8B5CF6);
  final Color secondaryColor = const Color(0xFF7E57C2);

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
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(

        title: const Text('Task Reports'),
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Debug button
          IconButton(
            icon: const Icon(Icons.bug_report,color: Colors.deepPurple,),
            onPressed: () => _debugReport(reportProvider),
            tooltip: 'Debug Report',
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt,color: Colors.deepPurple,),
            onPressed: () => _showFilterDialog(context, reportProvider, authProvider),
          ),
          IconButton(
            icon: const Icon(Icons.refresh,color: Colors.deepPurple,),
            onPressed: () => reportProvider.fetchReport(),
          ),
        ],
      ),
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 50, // Height of the bottom nav bar
            ),

          child: _buildBody(reportProvider, authProvider, mediaQuery)),
    ));
  }

  Widget _buildBody(ReportProvider reportProvider, AuthProvider authProvider, MediaQueryData mediaQuery) {
    final isSmallScreen = mediaQuery.size.width < 600;
    final padding = isSmallScreen ? 12.0 : 24.0;

    if (reportProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    if (reportProvider.error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${reportProvider.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: mediaQuery.size.width < 350 ? 14 : 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => reportProvider.fetchReport(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.1,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: mediaQuery.size.width < 350 ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (reportProvider.report == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assessment,
                size: 80,
                color: primaryColor.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              Text(
                'No report data available',
                style: TextStyle(
                  fontSize: mediaQuery.size.width < 350 ? 16 : 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => reportProvider.fetchReport(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.1,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  'Load Report',
                  style: TextStyle(
                    fontSize: mediaQuery.size.width < 350 ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => reportProvider.fetchReport(),
      color: primaryColor,
      child: CustomScrollView(
        slivers: [
          // Filter description
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor.withOpacity(0.1), secondaryColor.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reportProvider.filterDescription,
                      style: TextStyle(
                        fontSize: mediaQuery.size.width < 350 ? 11 : 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  if (reportProvider.selectedUserId != null ||
                      reportProvider.selectedCompanyId != null ||
                      reportProvider.selectedStatus != null ||
                      reportProvider.selectedPriority != null ||
                      reportProvider.searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () => reportProvider.clearFilters(),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                      child: Text(
                        'Clear Filters',
                        style: TextStyle(
                          fontSize: mediaQuery.size.width < 350 ? 11 : 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Summary Cards
          SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isSmallScreen ? 2 : 4,
                crossAxisSpacing: padding,
                mainAxisSpacing: padding,
                childAspectRatio: isSmallScreen ? 1.2 : 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildSummaryCard(index, reportProvider, mediaQuery);
                },
                childCount: 6,
              ),
            ),
          ),

          // Chart section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _buildChartSection(reportProvider, mediaQuery),
            ),
          ),

          // Tasks section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _buildTasksSection(reportProvider, mediaQuery),
            ),
          ),

          // Users section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _buildUsersSection(reportProvider, mediaQuery),
            ),
          ),

          // Add some bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: padding * 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int index, ReportProvider reportProvider, MediaQueryData mediaQuery) {
    final summary = reportProvider.filteredSummary;
    final List<Map<String, dynamic>> cards = [
      {
        'title': 'Total Tasks',
        'value': summary.totalTasks.toString(),
        'icon': Icons.task,
        'color': primaryColor,
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
        'color': secondaryColor,
      },
      {
        'title': 'Completion Rate',
        'value': '${summary.completionRate.toStringAsFixed(1)}%',
        'icon': Icons.percent,
        'color': Colors.teal,
      },
    ];

    final card = cards[index];
    final isSmallScreen = mediaQuery.size.width < 350;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 100, // Ensure minimum height
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              (card['color'] as Color).withOpacity(0.1),
              (card['color'] as Color).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 4 : 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Add this
            children: [
              Container(
                width: isSmallScreen ? 36 : 48,
                height: isSmallScreen ? 36 : 48,
                decoration: BoxDecoration(
                  color: (card['color'] as Color).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  card['icon'] as IconData,
                  color: card['color'] as Color,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 8), // Reduced spacing
              FittedBox( // Added FittedBox for value
                fit: BoxFit.scaleDown,
                child: Text(
                  card['value'] as String,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    color: card['color'] as Color,
                  ),
                ),
              ),
              SizedBox(height: 2), // Reduced spacing
              Text(
                card['title'] as String,
                textAlign: TextAlign.center,
                maxLines: 2, // Limit to 2 lines
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection(ReportProvider reportProvider, MediaQueryData mediaQuery) {
    final chartData = reportProvider.filteredChartData;
    final totalTasks = reportProvider.filteredSummary.totalTasks;
    final isSmallScreen = mediaQuery.size.width < 350;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Task Distribution',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: isSmallScreen ? 200 : 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: chartData.map((data) {
                  final percentage = totalTasks > 0
                      ? (data.value / totalTasks * 100)
                      : 0;

                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: percentage * (isSmallScreen ? 1.0 : 1.2),
                            margin: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  data.colorValue.withOpacity(0.8),
                                  data.colorValue.withOpacity(0.5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${data.value}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 10 : 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 2 : 4,
                            ),
                            child: Text(
                              data.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: $totalTasks tasks',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Filtered View',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: primaryColor,
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

  Widget _buildTasksSection(ReportProvider reportProvider, MediaQueryData mediaQuery) {
    final tasks = reportProvider.filteredDetailedTasks;
    final isSmallScreen = mediaQuery.size.width < 350;

    if (tasks.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
          child: Column(
            children: [
              Icon(
                Icons.task,
                size: isSmallScreen ? 48 : 64,
                color: primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No tasks found',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try changing your filters',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Detailed Tasks',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${tasks.length} tasks',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tasks.take(5).map((task) => _buildTaskItem(task, mediaQuery)),
            if (tasks.length > 5)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAllTasksDialog(context, tasks);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.visibility, size: isSmallScreen ? 16 : 18),
                    label: Text(
                      'View All Tasks',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(TaskDetail task, MediaQueryData mediaQuery) {
    final isSmallScreen = mediaQuery.size.width < 350;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 4 : 8,
          horizontal: 0,
        ),
        leading: Container(
          width: isSmallScreen ? 36 : 44,
          height: isSmallScreen ? 36 : 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                task.statusColor.withOpacity(0.2),
                task.statusColor.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(task.status),
            color: task.statusColor,
            size: isSmallScreen ? 18 : 20,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 15,
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
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? 80 : 100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6 : 8,
                  vertical: isSmallScreen ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  color: task.priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: task.priorityColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  task.priorityText,
                  style: TextStyle(
                    color: task.priorityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 9 : 10,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isSmallScreen ? 40 : 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: task.progress / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: task.progress == 100
                                ? [Colors.green, Colors.greenAccent]
                                : [primaryColor, secondaryColor],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${task.progress}%',
                    style: TextStyle(
                      color: task.progress == 100 ? Colors.green : primaryColor,
                      fontSize: isSmallScreen ? 10 : 11,
                      fontWeight: FontWeight.w500,
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

  Widget _buildUsersSection(ReportProvider reportProvider, MediaQueryData mediaQuery) {
    final users = reportProvider.filteredUserReports;
    final isSmallScreen = mediaQuery.size.width < 350;

    if (users.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
          child: Column(
            children: [
              Icon(
                Icons.people,
                size: isSmallScreen ? 48 : 64,
                color: primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No user data available',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people_alt, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'User Performance',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${users.length} users',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...users.take(5).map((user) => _buildUserItem(user, mediaQuery)),
            if (users.length > 5)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAllUsersDialog(context, users);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.people_outline, size: isSmallScreen ? 16 : 18),
                    label: Text(
                      'View All Users',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(UserReport user, MediaQueryData mediaQuery) {
    final isSmallScreen = mediaQuery.size.width < 350;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 4 : 8,
          horizontal: 0,
        ),
        leading: Container(
          width: isSmallScreen ? 36 : 44,
          height: isSmallScreen ? 36 : 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.2),
                secondaryColor.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
              style: TextStyle(
                color: primaryColor,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          user.name.isNotEmpty ? user.name : 'Unknown User',
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 15,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          user.email.isNotEmpty ? user.email : 'No email',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? 80 : 100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.task,
                    size: isSmallScreen ? 12 : 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${user.totalTasks}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: isSmallScreen ? 60 : 80,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  widthFactor: user.completionRate / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          user.completionRate >= 80
                              ? Colors.green
                              : user.completionRate >= 50
                              ? Colors.orange
                              : Colors.red,
                          user.completionRate >= 80
                              ? Colors.greenAccent
                              : user.completionRate >= 50
                              ? Colors.orangeAccent
                              : Colors.redAccent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${user.completionRate.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 11,
                  fontWeight: FontWeight.w500,
                  color: user.completionRate >= 80
                      ? Colors.green
                      : user.completionRate >= 50
                      ? Colors.orange
                      : Colors.red,
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
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 350;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: mediaQuery.size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Filter Report',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Month and Year
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Month',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        value: reportProvider.selectedMonth,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        items: reportProvider.availableMonths.map((month) {
                                          return DropdownMenuItem<int>(
                                            value: month['value'],
                                            child: Text(
                                              month['name'],
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 13 : 14,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          reportProvider.setMonth(value!);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 12 : 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Year',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        isExpanded: true,
                                        value: reportProvider.selectedYear,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        items: reportProvider.availableYears.map((year) {
                                          return DropdownMenuItem<int>(
                                            value: year,
                                            child: Text(
                                              year.toString(),
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 13 : 14,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          reportProvider.setYear(value!);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),

                        // User filter (only for admin)
                        if (authProvider.isAdmin)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filter by User',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: reportProvider.selectedUserId,
                                    hint: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'Select user',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 13 : 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: null,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            'All Users',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 13 : 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...reportProvider.uniqueUsers.map((user) {
                                        return DropdownMenuItem<String>(
                                          value: user,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              user,
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 13 : 14,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (value) {
                                      reportProvider.setUserId(value);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                            ],
                          ),

                        // Company filter (for admin, auto-set for manager)
                        if (authProvider.isAdmin)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filter by Company',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: reportProvider.selectedCompanyId,
                                    hint: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'Select company',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 13 : 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: null,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            'All Companies',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 13 : 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...reportProvider.uniqueCompanies.map((company) {
                                        return DropdownMenuItem<String>(
                                          value: company,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              company,
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 13 : 14,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (value) {
                                      reportProvider.setCompanyId(value);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                            ],
                          ),

                        // Status filter
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filter by Status',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: reportProvider.selectedStatus,
                                  items: reportProvider.uniqueStatuses.map((status) {
                                    return DropdownMenuItem<String>(
                                      value: status == 'All' ? null : status,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 13 : 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    reportProvider.setStatus(value);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),

                        // Priority filter
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filter by Priority',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: reportProvider.selectedPriority,
                                  items: reportProvider.uniquePriorities.map((priority) {
                                    return DropdownMenuItem<String>(
                                      value: priority == 'All' ? null : priority,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          priority,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 13 : 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    reportProvider.setPriority(value);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),

                        // Search
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search Tasks',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Search tasks...',
                                prefixIcon: Icon(Icons.search, color: primaryColor),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isSmallScreen ? 12 : 14,
                                ),
                              ),
                              onChanged: (value) {
                                reportProvider.setSearchQuery(value);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          reportProvider.clearFilters();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 24,
                            vertical: isSmallScreen ? 8 : 12,
                          ),
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[400]!),
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 16 : 24,
                                vertical: isSmallScreen ? 8 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          ElevatedButton(
                            onPressed: () {
                              reportProvider.fetchReport();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 16 : 24,
                                vertical: isSmallScreen ? 8 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
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
        );
      },
    );
  }

  // Debug methods
  void _debugReport(ReportProvider reportProvider) {
    if (reportProvider.report != null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bug_report, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Debug Report Info',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDebugInfo('Period', reportProvider.report!.period.formattedPeriod),
                        _buildDebugInfo('Total Tasks', reportProvider.report!.detailed.length.toString()),
                        _buildDebugInfo('User Reports', reportProvider.report!.userReports.length.toString()),

                        SizedBox(height: 16),
                        Text(
                          'Sample Tasks:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        ...reportProvider.report!.detailed.take(3).map((task) =>
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '• ${task.title}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Assigned: ${task.assignedTo}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Company: ${task.company}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Close'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildDebugInfo(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllTasksDialog(BuildContext context, List<TaskDetail> tasks) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 350;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: mediaQuery.size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.list_alt, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'All Tasks (${tasks.length})',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No tasks available',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[100]!,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
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
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                        subtitle: Text(
                          '${task.assignedTo} • ${task.company}',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 12,
                          ),
                        ),
                        trailing: Chip(
                          label: Text(
                            task.statusText,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 11,
                            ),
                          ),
                          backgroundColor: task.statusColor.withOpacity(0.1),
                          labelStyle: TextStyle(color: task.statusColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 32 : 48,
                        vertical: isSmallScreen ? 10 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllUsersDialog(BuildContext context, List<UserReport> users) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 350;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: mediaQuery.size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'All Users (${users.length})',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: users.isEmpty
                    ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No users available',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[100]!,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.2),
                                secondaryColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              user.name.isNotEmpty
                                  ? user.name.substring(0, 1).toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          user.name.isNotEmpty ? user.name : 'Unknown User',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                        subtitle: Text(
                          user.email.isNotEmpty ? user.email : 'No email',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 12,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${user.completionRate.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: user.completionRate >= 80
                                    ? Colors.green
                                    : user.completionRate >= 50
                                    ? Colors.orange
                                    : Colors.red,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${user.totalTasks} tasks',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 32 : 48,
                        vertical: isSmallScreen ? 10 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}