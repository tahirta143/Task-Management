import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/models/company_model.dart';
import 'package:taskflow_app/models/task_model.dart' hide Company;
import 'package:taskflow_app/providers/auth_provider.dart';
import 'package:taskflow_app/providers/company_provider.dart';
import 'package:taskflow_app/providers/task_provider.dart';
import 'package:taskflow_app/providers/user_provider.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;

  late DateTime _startDate;
  late DateTime _endDate;
  late String _selectedPriority;
  late String _selectedStatus;
  String? _selectedCompanyId;
  String? _selectedCompanyName;
  String? _selectedUserId;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing task data
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _tagsController = TextEditingController();

    // Initialize dates
    _startDate = widget.task.startDate;
    _endDate = widget.task.endDate;

    // Initialize priority and status
    _selectedPriority = widget.task.priority;
    _selectedStatus = widget.task.status;

    // Initialize company
    _selectedCompanyId = widget.task.company.id;
    _selectedCompanyName = widget.task.company.name;

    // Initialize assigned user
    _selectedUserId = widget.task.assignedTo.id;

    // Initialize tags
    _tags.addAll(widget.task.tags);

    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final authProvider = context.read<AuthProvider>();
    final companyProvider = context.read<CompanyProvider>();
    final userProvider = context.read<UserProvider>();

    // Load companies for admin
    if (authProvider.isAdmin) {
      await companyProvider.fetchCompanies();
    }

    // Load users
    await userProvider.fetchUsers();

    // Auto-set company for manager
    if (authProvider.isManager) {
      _selectedCompanyId = authProvider.companyId;
      if (_selectedCompanyId != null) {
        try {
          await companyProvider.fetchCompanies();
          Company? foundCompany;
          for (var company in companyProvider.companies) {
            if (company.id == _selectedCompanyId) {
              foundCompany = company;
              break;
            }
          }
          _selectedCompanyName = foundCompany?.name ?? 'My Company';
        } catch (e) {
          _selectedCompanyName = 'My Company';
        }
      }
    }

    setState(() {});
  }

  Future<void> _updateTask() async {
    // Prevent multiple clicks
    if (_isLoading) return;

    print('=== UPDATE TASK FUNCTION STARTED ===');

    if (_formKey.currentState?.validate() != true) {
      print('Form validation failed');
      return;
    }

    final authProvider = context.read<AuthProvider>();

    // Validate company
    if (authProvider.isManager) {
      if (_selectedCompanyId == null) {
        _selectedCompanyId = authProvider.companyId;
        if (_selectedCompanyId == null) {
          if (mounted) {
            setState(() {
              _error = 'Unable to determine your company';
            });
          }
          return;
        }
      }
    } else if (authProvider.isAdmin && _selectedCompanyId == null) {
      if (mounted) {
        setState(() {
          _error = 'Please select a company';
        });
      }
      return;
    }

    if (_selectedUserId == null) {
      if (mounted) {
        setState(() {
          _error = 'Please select an assignee';
        });
      }
      return;
    }

    print('All validations passed');

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final taskProvider = context.read<TaskProvider>();

      print('=== FORM DATA ===');
      print('Task ID: ${widget.task.id}');
      print('Title: ${_titleController.text.trim()}');
      print('Description: ${_descriptionController.text.trim()}');
      print('Company ID: $_selectedCompanyId');
      print('User ID: $_selectedUserId');
      print('Start Date: ${_formatDateForAPI(_startDate)}');
      print('End Date: ${_formatDateForAPI(_endDate)}');
      print('Priority: $_selectedPriority');
      print('Status: $_selectedStatus');
      print('Tags: $_tags');
      print('User Role: ${authProvider.role}');
      print('Progress: ${widget.task.progress}');
      print('Days count: ${widget.task.days.length}');

      print('=== CALLING TASK PROVIDER ===');
      final success = await taskProvider.updateTask(
        id: widget.task.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        companyId: _selectedCompanyId!,
        assignedToId: _selectedUserId!,
        startDate: _startDate,
        endDate: _endDate,
        priority: _selectedPriority,
        status: _selectedStatus,
        progress: widget.task.progress,
        tags: _tags,
        days: widget.task.days,
      );

      if (!mounted) return;

      if (success) {
        print('SUCCESS: Task updated successfully');

        // Reset loading state
        setState(() {
          _isLoading = false;
          _successMessage = 'Task updated successfully!';
        });

        // Wait briefly to show success message
        await Future.delayed(const Duration(milliseconds: 1500));

        // Return a Map instead of a bool
        if (mounted) {
          Navigator.pop(context, {'success': true, 'taskId': widget.task.id});
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to update task: ${taskProvider.error}';
        });
      }
    } catch (e, stackTrace) {
      print('=== EXCEPTION CAUGHT ===');
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }
  String _formatDateForAPI(DateTime date) {
    // Format as YYYY-MM-DD
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final companyProvider = context.watch<CompanyProvider>();
    final userProvider = context.watch<UserProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Task',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isSmallScreen ? 18 : 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
              
                  // Task ID Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Task ID: ${widget.task.id.substring(0, 8)}...',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 13,
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Created: ${_formatDateForDisplay(widget.task.createdAt)}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11 : 12,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  // Success Message
                  if (_successMessage != null)
                    _buildMessage(
                      _successMessage!,
                      true,
                      isSmallScreen,
                    ),
              
                  // Error Message
                  if (_error != null)
                    _buildMessage(
                      _error!,
                      false,
                      isSmallScreen,
                      onClose: () => setState(() => _error = null),
                    ),
              
                  // Title Field
                  _buildLabel('Task Title', isSmallScreen),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleController,
                    style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                    decoration: _buildInputDecoration(
                      'Enter task title',
                      Icons.title_rounded,
                      isSmallScreen,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
              
                  // Description Field
                  _buildLabel('Task Description', isSmallScreen),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                    decoration: _buildInputDecoration(
                      'Enter task description',
                      Icons.description_rounded,
                      isSmallScreen,
                      multiline: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter task description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
              
                  // Company Field
                  // _buildLabel('Company', isSmallScreen),
                  // const SizedBox(height: 6),
                  // _buildCompanyField(authProvider, companyProvider, isSmallScreen),
                  // const SizedBox(height: 16),
              
                  // Assignee Field
                  _buildLabel('Assign To', isSmallScreen),
                  const SizedBox(height: 6),
                  _buildAssigneeField(userProvider, authProvider, isSmallScreen),
                  const SizedBox(height: 16),
              
                  // Date Selection
                  _buildLabel('Timeline', isSmallScreen),
                  const SizedBox(height: 6),
                  _buildDateFields(isSmallScreen),
                  const SizedBox(height: 16),
              
                  // Priority Selection
                  _buildLabel('Priority', isSmallScreen),
                  const SizedBox(height: 6),
                  _buildPrioritySelection(isSmallScreen),
                  const SizedBox(height: 16),
              
                  // Status Selection
                  _buildLabel('Status', isSmallScreen),
                  const SizedBox(height: 6),
                  _buildStatusSelection(isSmallScreen),
                  const SizedBox(height: 16),
              
                  // Tags Input
                  _buildLabel('Tags', isSmallScreen),
                  const SizedBox(height: 6),
                  _buildTagsInput(isSmallScreen),
                  const SizedBox(height: 20),
              
                  // Task Duration Info
                  _buildDurationInfo(isSmallScreen),
                  const SizedBox(height: 24),
              
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey[400]!),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            shadowColor: Colors.blue.withOpacity(0.3),
                          ),
                          child: _isLoading
                              ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                              : const Text('Update Task'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(String message, bool isSuccess, bool isSmallScreen, {VoidCallback? onClose}) {
    final color = isSuccess ? Colors.green : Colors.red;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color[200]!),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            color: color[600],
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color[800],
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              color: color[600],
              onPressed: onClose,
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool isSmallScreen) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
        fontSize: isSmallScreen ? 14 : 15,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      String hint,
      IconData icon,
      bool isSmallScreen, {
        bool multiline = false,
      }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: isSmallScreen ? 14 : 15,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.grey[500],
      ),
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
        borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: multiline ? (isSmallScreen ? 14 : 16) : (isSmallScreen ? 14 : 16),
      ),
    );
  }

  Widget _buildCompanyField(
      AuthProvider authProvider,
      CompanyProvider companyProvider,
      bool isSmallScreen,
      ) {
    if (authProvider.isAdmin) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCompanyId,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600]),
            style: TextStyle(
              fontSize: isSmallScreen ? 15 : 16,
              color: Colors.grey[800],
            ),
            hint: Text(
              'Select Company',
              style: TextStyle(color: Colors.grey[500]),
            ),
            items: companyProvider.companies.map((company) {
              return DropdownMenuItem<String>(
                value: company.id,
                child: Text(
                  company.name,
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 15),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCompanyId = value;
              });
            },
          ),
        ),
      );
    } else if (authProvider.isManager) {
      return Container(
        padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.business_rounded, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Company',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedCompanyName ?? widget.task.company.name,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 15 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.business_rounded, color: Colors.grey[400], size: 20),
            const SizedBox(width: 12),
            Text(
              widget.task.company.name,
              style: TextStyle(
                fontSize: isSmallScreen ? 15 : 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAssigneeField(
      UserProvider userProvider,
      AuthProvider authProvider,
      bool isSmallScreen,
      ) {
    final filteredUsers = _getFilteredUsers(authProvider, userProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedUserId,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600]),
          style: TextStyle(
            fontSize: isSmallScreen ? 15 : 16,
            color: Colors.grey[800],
          ),
          hint: Text(
            'Select Assignee',
            style: TextStyle(color: Colors.grey[500]),
          ),
          items: filteredUsers.map((user) {
            final userMap = _userToMap(user);
            final userName = userMap['name'] ?? 'Unknown';
            final userRole = userMap['role'] ?? 'user';
            final userId = userMap['id']?.toString() ?? '';

            return DropdownMenuItem<String>(
              value: userId,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    userRole.toUpperCase(),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedUserId = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDateFields(bool isSmallScreen) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectStartDate(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            color: Colors.grey[600], size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Start',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDateForDisplay(_startDate),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            child: Center(
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.grey[400],
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => _selectEndDate(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            color: Colors.grey[600], size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'End',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDateForDisplay(_endDate),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelection(bool isSmallScreen) {
    // Define priority options with proper typing
    final List<Map<String, dynamic>> priorityOptions = [
      {'value': 'low', 'label': 'Low', 'color': Colors.green},
      {'value': 'medium', 'label': 'Medium', 'color': Colors.orange},
      {'value': 'high', 'label': 'High', 'color': Colors.red},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: priorityOptions.map((priority) {
          final isSelected = _selectedPriority == priority['value'];
          final color = priority['color'] as Color;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedPriority = priority['value'] as String;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: isSmallScreen ? 80 : 90,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 12 : 14,
                  horizontal: isSmallScreen ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      priority['value'] == 'low'
                          ? Icons.arrow_downward_rounded
                          : priority['value'] == 'medium'
                          ? Icons.remove_rounded
                          : Icons.arrow_upward_rounded,
                      color: isSelected ? color : Colors.grey[500],
                      size: isSmallScreen ? 18 : 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priority['label'] as String,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? color : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusSelection(bool isSmallScreen) {
    // Define status options with proper typing
    final List<Map<String, dynamic>> statusOptions = [
      {'value': 'pending', 'label': 'Pending', 'color': Colors.orange},
      {'value': 'in-progress', 'label': 'In Progress', 'color': Colors.blue},
      {'value': 'completed', 'label': 'Completed', 'color': Colors.green},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statusOptions.map((status) {
          final isSelected = _selectedStatus == status['value'];
          final color = status['color'] as Color;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedStatus = status['value'] as String;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: isSmallScreen ? 100 : 110,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 12 : 14,
                  horizontal: isSmallScreen ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status['label'] as String,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? color : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTagsInput(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagsController,
                style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                decoration: InputDecoration(
                  hintText: 'Add tag...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
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
                    borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmallScreen ? 12 : 14,
                  ),
                ),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue[50],
              ),
              child: IconButton(
                onPressed: _addTag,
                icon: Icon(Icons.add_rounded, color: Colors.blue[600]),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 10 : 12,
                  vertical: isSmallScreen ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _removeTag(tag),
                      child: Icon(
                        Icons.close_rounded,
                        size: isSmallScreen ? 14 : 16,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildDurationInfo(bool isSmallScreen) {
    final days = _endDate.difference(_startDate).inDays + 1;
    final dayWord = days == 1 ? 'day' : 'days';

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Colors.blue[600],
              size: isSmallScreen ? 18 : 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Duration: $days $dayWord',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Remaining days can be updated in sub-tasks',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 13,
                    color: Colors.blue[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Map<String, dynamic> _userToMap(dynamic user) {
    if (user is Map<String, dynamic>) {
      return user;
    } else {
      try {
        return {
          'id': user.id?.toString() ?? '',
          'name': user.name?.toString() ?? '',
          'role': user.role?.toString() ?? '',
          'companyId': user.companyId?.toString() ?? '',
        };
      } catch (e) {
        return {'id': '', 'name': 'Unknown', 'role': 'user', 'companyId': ''};
      }
    }
  }

  List<dynamic> _getFilteredUsers(AuthProvider authProvider, UserProvider userProvider) {
    final filteredUsers = <dynamic>[];

    for (final user in userProvider.allUsers) {
      final userMap = _userToMap(user);
      final userCompanyId = userMap['companyId']?.toString();

      if (authProvider.isManager) {
        if (userCompanyId == _selectedCompanyId) {
          filteredUsers.add(user);
        }
      } else if (authProvider.isAdmin) {
        if (_selectedCompanyId == null || userCompanyId == _selectedCompanyId) {
          filteredUsers.add(user);
        }
      } else {
        filteredUsers.add(user);
      }
    }

    return filteredUsers;
  }

  String _formatDateForDisplay(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}