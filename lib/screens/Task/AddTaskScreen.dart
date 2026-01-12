// screens/tasks/add_task_screen.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../providers/company_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/task_provider.dart';
import '../../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  String _selectedPriority = 'medium';
  String? _selectedCompanyId;
  String? _selectedUserId;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  final List<SubTask> _subTasks = [];
  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final companyProvider = context.read<CompanyProvider>();
    final userProvider = context.read<UserProvider>();

    // Load companies and users
    await companyProvider.fetchCompanies();
    await userProvider.fetchUsers();

    // Auto-select company for managers
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isManager) {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');
      if (userData != null) {
        final user = jsonDecode(userData);
        _selectedCompanyId = user['companyId'];
      }
    }

    setState(() {});
  }

  // Future<void> _createTask() async {
  //   if (_formKey.currentState?.validate() != true) return;
  //   if (_selectedCompanyId == null) {
  //     setState(() {
  //       _error = 'Please select a company';
  //     });
  //     return;
  //   }
  //   if (_selectedUserId == null) {
  //     setState(() {
  //       _error = 'Please select an assignee';
  //     });
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //     _error = null;
  //     _successMessage = null;
  //   });
  //
  //   try {
  //     final taskProvider = context.read<TaskProvider>();
  //     final authProvider = context.read<AuthProvider>();
  //     final prefs = await SharedPreferences.getInstance();
  //     final currentUser = prefs.getString('user');
  //
  //     if (currentUser == null) {
  //       throw Exception('User not found');
  //     }
  //
  //     final currentUserData = jsonDecode(currentUser);
  //     final assignedById = currentUserData['_id'];
  //
  //     // Generate sub-tasks for each day between start and end date
  //     final subTasks = _generateSubTasks();
  //
  //     final success = await taskProvider.createTask(
  //       title: _titleController.text.trim(),
  //       description: _descriptionController.text.trim(),
  //       companyId: _selectedCompanyId!,
  //       assignedToId: _selectedUserId!,
  //       startDate: _startDate,
  //       endDate: _endDate,
  //       priority: _selectedPriority,
  //       tags: _tags,
  //       subTasks: subTasks,
  //     );
  //
  //     if (success) {
  //       setState(() {
  //         _successMessage = 'Task created successfully';
  //       });
  //       // Clear form after 2 seconds
  //       Future.delayed(const Duration(seconds: 2), () {
  //         if (mounted) {
  //           Navigator.pop(context);
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _error = e.toString();
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  Future<void> _createTask() async {
    print('=== CREATE TASK FUNCTION STARTED ===');

    if (_formKey.currentState?.validate() != true) {
      print('Form validation failed');
      return;
    }

    if (_selectedCompanyId == null) {
      print('No company selected');
      setState(() {
        _error = 'Please select a company';
      });
      return;
    }

    if (_selectedUserId == null) {
      print('No user selected');
      setState(() {
        _error = 'Please select an assignee';
      });
      return;
    }

    print('All validations passed');
    print('Setting loading state...');

    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final taskProvider = context.read<TaskProvider>();
      final authProvider = context.read<AuthProvider>();

      // Debug: Print AuthProvider state
      print('=== AUTH PROVIDER STATE ===');
      print('Is Authenticated: ${authProvider.isAuthenticated}');
      print('User ID: ${authProvider.userId}');
      print('User Name: ${authProvider.userName}');
      print('Role: ${authProvider.role}');
      print('Company ID: ${authProvider.companyId}');

      // Try to reload data if not available
      // if (authProvider.userId == null) {
      //   print('User ID is null, trying to reload from storage...');
      //   await authProvider.printStoredData();
      //
      //   // You might need to manually reload the data
      //   final prefs = await SharedPreferences.getInstance();
      //   final storedUserId = prefs.getString('userId');
      //   print('Stored User ID from SharedPreferences: $storedUserId');
      //
      //   if (storedUserId == null) {
      //     throw Exception('Please login to create tasks');
      //   }
      // }

      final String? userId = authProvider.userId;
      final String? userName = authProvider.userName;

      // if (userId == null) {
      //   throw Exception('User not found. Please login again.');
      // }

      print('Current User Details:');
      print('  ID: $userId');
      print('  Name: $userName');

      // Get token from AuthProvider
      final token = authProvider.token;
      print('=== TOKEN INFORMATION ===');
      if (token == null) {
        print('ERROR: No token found');
        throw Exception('Authentication token not found. Please login again.');
      } else {
        print('Token found (first 50 chars): ${token.substring(0, min(50, token.length))}...');
        print('Token length: ${token.length}');
      }

      print('=== FORM DATA ===');
      print('Title: ${_titleController.text.trim()}');
      print('Description: ${_descriptionController.text.trim()}');
      print('Company ID: $_selectedCompanyId');
      print('User ID: $_selectedUserId');
      print('Start Date: $_startDate');
      print('End Date: $_endDate');
      print('Priority: $_selectedPriority');
      print('Tags: $_tags');

      // Generate sub-tasks for each day between start and end date
      print('=== GENERATING SUBTASKS ===');
      final subTasks = _generateSubTasks();
      print('Generated ${subTasks.length} sub-tasks');

      print('=== CALLING TASK PROVIDER ===');
      final success = await taskProvider.createTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        companyId: _selectedCompanyId!,
        assignedToId: _selectedUserId!,
        startDate: _startDate,
        endDate: _endDate,
        priority: _selectedPriority,
        tags: _tags,
        subTasks: subTasks,
      );

      if (success) {
        print('SUCCESS: Task created successfully');
        setState(() {
          _successMessage = 'Task created successfully';
        });

        // Debug: Print the created task details
        print('Task Details:');
        print('  Title: ${_titleController.text.trim()}');
        print('  Assigned By: $userName');
        print('  Company: $_selectedCompanyId');
        print('  Priority: $_selectedPriority');
        print('  Duration: ${_endDate.difference(_startDate).inDays + 1} days');

        // Clear form after 2 seconds
        print('Will navigate back in 2 seconds...');
        Future.delayed(const Duration(seconds: 2), () {
          print('Navigating back to task list...');
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        print('FAILURE: Task provider returned false');
        // Error is already set by the provider
      }
    } catch (e, stackTrace) {
      print('=== EXCEPTION CAUGHT ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace: $stackTrace');

      setState(() {
        _error = e.toString();
      });
    } finally {
      print('Setting loading state to false...');
      setState(() {
        _isLoading = false;
      });
      print('=== CREATE TASK FUNCTION COMPLETED ===');
    }
  }
  List<SubTask> _generateSubTasks() {
    final List<SubTask> subTasks = [];
    final days = _endDate.difference(_startDate).inDays + 1;

    for (int i = 0; i < days; i++) {
      final date = _startDate.add(Duration(days: i));
      subTasks.add(SubTask(
        id: '',
        date: date,
        description: '${_titleController.text} - Day ${i + 1}',
        status: 'pending',
        hoursSpent: 0,
        remarks: '',
      ));
    }

    return subTasks;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success Message
              if (_successMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),

              // Error Message
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          setState(() {
                            _error = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  prefixIcon: const Icon(Icons.title_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Company Selection
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Company',
                  prefixIcon: const Icon(Icons.business_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCompanyId,
                    isExpanded: true,
                    hint: const Text('Select Company'),
                    items: companyProvider.companies.map((company) {
                      return DropdownMenuItem<String>(
                        value: company.id,
                        child: Text(company.name),
                      );
                    }).toList(),
                    onChanged: authProvider.isAdmin
                        ? (value) {
                      setState(() {
                        _selectedCompanyId = value;
                      });
                    }
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Assignee Selection
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Assign To',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedUserId,
                    isExpanded: true,
                    hint: const Text('Select User'),
                    items: userProvider.allUsers.map((user) {
                      return DropdownMenuItem<String>(
                        value: user.id,
                        child: Text('${user.name} (${user.role})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserId = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date Selection Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Date',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectStartDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Date',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectEndDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Priority Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Low'),
                          value: 'low',
                          groupValue: _selectedPriority,
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Medium'),
                          value: 'medium',
                          groupValue: _selectedPriority,
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('High'),
                          value: 'high',
                          groupValue: _selectedPriority,
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tags Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tags',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagsController,
                          decoration: InputDecoration(
                            hintText: 'Add tag...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onSubmitted: (_) => _addTag(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _addTag,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removeTag(tag),
                        );
                      }).toList(),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Task Duration Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Duration: ${_endDate.difference(_startDate).inDays + 1} days',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_endDate.difference(_startDate).inDays + 1} sub-tasks will be created automatically',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : const Text(
                    'Create Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}