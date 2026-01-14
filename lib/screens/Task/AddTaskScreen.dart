// // // screens/tasks/add_task_screen.dart
// // import 'dart:convert';
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../providers/auth_provider.dart';
// // import '../../providers/company_provider.dart';
// // import '../../providers/user_provider.dart';
// // import '../../providers/task_provider.dart';
// // import '../../models/task_model.dart';
// //
// // class AddTaskScreen extends StatefulWidget {
// //   const AddTaskScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<AddTaskScreen> createState() => _AddTaskScreenState();
// // }
// //
// // class _AddTaskScreenState extends State<AddTaskScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _descriptionController = TextEditingController();
// //   final TextEditingController _tagsController = TextEditingController();
// //
// //   DateTime _startDate = DateTime.now();
// //   DateTime _endDate = DateTime.now().add(const Duration(days: 7));
// //   String _selectedPriority = 'medium';
// //   String? _selectedCompanyId;
// //   String? _selectedUserId;
// //   bool _isLoading = false;
// //   String? _error;
// //   String? _successMessage;
// //
// //   final List<SubTask> _subTasks = [];
// //   final List<String> _tags = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _initializeData();
// //     });
// //   }
// //
// //   Future<void> _initializeData() async {
// //     final companyProvider = context.read<CompanyProvider>();
// //     final userProvider = context.read<UserProvider>();
// //
// //     // Load companies and users
// //     await companyProvider.fetchCompanies();
// //     await userProvider.fetchUsers();
// //
// //     // Auto-select company for managers
// //     final authProvider = context.read<AuthProvider>();
// //     if (authProvider.isManager) {
// //       final prefs = await SharedPreferences.getInstance();
// //       final userData = prefs.getString('user');
// //       if (userData != null) {
// //         final user = jsonDecode(userData);
// //         _selectedCompanyId = user['companyId'];
// //       }
// //     }
// //
// //     setState(() {});
// //   }
// //
// //   // Future<void> _createTask() async {
// //   //   if (_formKey.currentState?.validate() != true) return;
// //   //   if (_selectedCompanyId == null) {
// //   //     setState(() {
// //   //       _error = 'Please select a company';
// //   //     });
// //   //     return;
// //   //   }
// //   //   if (_selectedUserId == null) {
// //   //     setState(() {
// //   //       _error = 'Please select an assignee';
// //   //     });
// //   //     return;
// //   //   }
// //   //
// //   //   setState(() {
// //   //     _isLoading = true;
// //   //     _error = null;
// //   //     _successMessage = null;
// //   //   });
// //   //
// //   //   try {
// //   //     final taskProvider = context.read<TaskProvider>();
// //   //     final authProvider = context.read<AuthProvider>();
// //   //     final prefs = await SharedPreferences.getInstance();
// //   //     final currentUser = prefs.getString('user');
// //   //
// //   //     if (currentUser == null) {
// //   //       throw Exception('User not found');
// //   //     }
// //   //
// //   //     final currentUserData = jsonDecode(currentUser);
// //   //     final assignedById = currentUserData['_id'];
// //   //
// //   //     // Generate sub-tasks for each day between start and end date
// //   //     final subTasks = _generateSubTasks();
// //   //
// //   //     final success = await taskProvider.createTask(
// //   //       title: _titleController.text.trim(),
// //   //       description: _descriptionController.text.trim(),
// //   //       companyId: _selectedCompanyId!,
// //   //       assignedToId: _selectedUserId!,
// //   //       startDate: _startDate,
// //   //       endDate: _endDate,
// //   //       priority: _selectedPriority,
// //   //       tags: _tags,
// //   //       subTasks: subTasks,
// //   //     );
// //   //
// //   //     if (success) {
// //   //       setState(() {
// //   //         _successMessage = 'Task created successfully';
// //   //       });
// //   //       // Clear form after 2 seconds
// //   //       Future.delayed(const Duration(seconds: 2), () {
// //   //         if (mounted) {
// //   //           Navigator.pop(context);
// //   //         }
// //   //       });
// //   //     }
// //   //   } catch (e) {
// //   //     setState(() {
// //   //       _error = e.toString();
// //   //     });
// //   //   } finally {
// //   //     setState(() {
// //   //       _isLoading = false;
// //   //     });
// //   //   }
// //   // }
// //   Future<void> _createTask() async {
// //     print('=== CREATE TASK FUNCTION STARTED ===');
// //
// //     if (_formKey.currentState?.validate() != true) {
// //       print('Form validation failed');
// //       return;
// //     }
// //
// //     if (_selectedCompanyId == null) {
// //       print('No company selected');
// //       setState(() {
// //         _error = 'Please select a company';
// //       });
// //       return;
// //     }
// //
// //     if (_selectedUserId == null) {
// //       print('No user selected');
// //       setState(() {
// //         _error = 'Please select an assignee';
// //       });
// //       return;
// //     }
// //
// //     print('All validations passed');
// //     print('Setting loading state...');
// //
// //     setState(() {
// //       _isLoading = true;
// //       _error = null;
// //       _successMessage = null;
// //     });
// //
// //     try {
// //       final taskProvider = context.read<TaskProvider>();
// //       final authProvider = context.read<AuthProvider>();
// //
// //       // Debug: Print AuthProvider state
// //       print('=== AUTH PROVIDER STATE ===');
// //       print('Is Authenticated: ${authProvider.isAuthenticated}');
// //       print('User ID: ${authProvider.userId}');
// //       print('User Name: ${authProvider.userName}');
// //       print('Role: ${authProvider.role}');
// //       print('Company ID: ${authProvider.companyId}');
// //
// //       // Try to reload data if not available
// //       // if (authProvider.userId == null) {
// //       //   print('User ID is null, trying to reload from storage...');
// //       //   await authProvider.printStoredData();
// //       //
// //       //   // You might need to manually reload the data
// //       //   final prefs = await SharedPreferences.getInstance();
// //       //   final storedUserId = prefs.getString('userId');
// //       //   print('Stored User ID from SharedPreferences: $storedUserId');
// //       //
// //       //   if (storedUserId == null) {
// //       //     throw Exception('Please login to create tasks');
// //       //   }
// //       // }
// //
// //       final String? userId = authProvider.userId;
// //       final String? userName = authProvider.userName;
// //
// //       // if (userId == null) {
// //       //   throw Exception('User not found. Please login again.');
// //       // }
// //
// //       print('Current User Details:');
// //       print('  ID: $userId');
// //       print('  Name: $userName');
// //
// //       // Get token from AuthProvider
// //       final token = authProvider.token;
// //       print('=== TOKEN INFORMATION ===');
// //       if (token == null) {
// //         print('ERROR: No token found');
// //         throw Exception('Authentication token not found. Please login again.');
// //       } else {
// //         print('Token found (first 50 chars): ${token.substring(0, min(50, token.length))}...');
// //         print('Token length: ${token.length}');
// //       }
// //
// //       print('=== FORM DATA ===');
// //       print('Title: ${_titleController.text.trim()}');
// //       print('Description: ${_descriptionController.text.trim()}');
// //       print('Company ID: $_selectedCompanyId');
// //       print('User ID: $_selectedUserId');
// //       print('Start Date: $_startDate');
// //       print('End Date: $_endDate');
// //       print('Priority: $_selectedPriority');
// //       print('Tags: $_tags');
// //
// //       // Generate sub-tasks for each day between start and end date
// //       print('=== GENERATING SUBTASKS ===');
// //       final subTasks = _generateSubTasks();
// //       print('Generated ${subTasks.length} sub-tasks');
// //
// //       print('=== CALLING TASK PROVIDER ===');
// //       final success = await taskProvider.createTask(
// //         title: _titleController.text.trim(),
// //         description: _descriptionController.text.trim(),
// //         companyId: _selectedCompanyId!,
// //         assignedToId: _selectedUserId!,
// //         startDate: _startDate,
// //         endDate: _endDate,
// //         priority: _selectedPriority,
// //         tags: _tags,
// //         subTasks: subTasks,
// //       );
// //
// //       if (success) {
// //         print('SUCCESS: Task created successfully');
// //         setState(() {
// //           _successMessage = 'Task created successfully';
// //         });
// //
// //         // Debug: Print the created task details
// //         print('Task Details:');
// //         print('  Title: ${_titleController.text.trim()}');
// //         print('  Assigned By: $userName');
// //         print('  Company: $_selectedCompanyId');
// //         print('  Priority: $_selectedPriority');
// //         print('  Duration: ${_endDate.difference(_startDate).inDays + 1} days');
// //
// //         // Clear form after 2 seconds
// //         print('Will navigate back in 2 seconds...');
// //         Future.delayed(const Duration(seconds: 2), () {
// //           print('Navigating back to task list...');
// //           if (mounted) {
// //             Navigator.pop(context);
// //           }
// //         });
// //       } else {
// //         print('FAILURE: Task provider returned false');
// //         // Error is already set by the provider
// //       }
// //     } catch (e, stackTrace) {
// //       print('=== EXCEPTION CAUGHT ===');
// //       print('Error Type: ${e.runtimeType}');
// //       print('Error Message: $e');
// //       print('Stack Trace: $stackTrace');
// //
// //       setState(() {
// //         _error = e.toString();
// //       });
// //     } finally {
// //       print('Setting loading state to false...');
// //       setState(() {
// //         _isLoading = false;
// //       });
// //       print('=== CREATE TASK FUNCTION COMPLETED ===');
// //     }
// //   }
// //   List<SubTask> _generateSubTasks() {
// //     final List<SubTask> subTasks = [];
// //     final days = _endDate.difference(_startDate).inDays + 1;
// //
// //     for (int i = 0; i < days; i++) {
// //       final date = _startDate.add(Duration(days: i));
// //       subTasks.add(SubTask(
// //         id: '',
// //         date: date,
// //         description: '${_titleController.text} - Day ${i + 1}',
// //         status: 'pending',
// //         hoursSpent: 0,
// //         remarks: '',
// //       ));
// //     }
// //
// //     return subTasks;
// //   }
// //
// //   Future<void> _selectStartDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _startDate,
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(2100),
// //     );
// //     if (picked != null && picked != _startDate) {
// //       setState(() {
// //         _startDate = picked;
// //         if (_endDate.isBefore(_startDate)) {
// //           _endDate = _startDate.add(const Duration(days: 1));
// //         }
// //       });
// //     }
// //   }
// //
// //   Future<void> _selectEndDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _endDate,
// //       firstDate: _startDate,
// //       lastDate: DateTime(2100),
// //     );
// //     if (picked != null && picked != _endDate) {
// //       setState(() {
// //         _endDate = picked;
// //       });
// //     }
// //   }
// //
// //   void _addTag() {
// //     final tag = _tagsController.text.trim();
// //     if (tag.isNotEmpty && !_tags.contains(tag)) {
// //       setState(() {
// //         _tags.add(tag);
// //         _tagsController.clear();
// //       });
// //     }
// //   }
// //
// //   void _removeTag(String tag) {
// //     setState(() {
// //       _tags.remove(tag);
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final authProvider = context.watch<AuthProvider>();
// //     final companyProvider = context.watch<CompanyProvider>();
// //     final userProvider = context.watch<UserProvider>();
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Create New Task',
// //           style: TextStyle(fontWeight: FontWeight.w600),
// //         ),
// //         elevation: 1,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Success Message
// //               if (_successMessage != null)
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   margin: const EdgeInsets.only(bottom: 16),
// //                   decoration: BoxDecoration(
// //                     color: Colors.green[50],
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(color: Colors.green),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.check_circle, color: Colors.green),
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Text(
// //                           _successMessage!,
// //                           style: const TextStyle(color: Colors.green),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //               // Error Message
// //               if (_error != null)
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   margin: const EdgeInsets.only(bottom: 16),
// //                   decoration: BoxDecoration(
// //                     color: Colors.red[50],
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(color: Colors.red),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.error_outline, color: Colors.red),
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Text(
// //                           _error!,
// //                           style: const TextStyle(color: Colors.red),
// //                         ),
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.close, size: 16),
// //                         onPressed: () {
// //                           setState(() {
// //                             _error = null;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //               // Title Field
// //               TextFormField(
// //                 controller: _titleController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Task Title',
// //                   prefixIcon: const Icon(Icons.title_outlined),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter task title';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Description Field
// //               TextFormField(
// //                 controller: _descriptionController,
// //                 maxLines: 4,
// //                 decoration: InputDecoration(
// //                   labelText: 'Task Description',
// //                   alignLabelWithHint: true,
// //                   prefixIcon: const Icon(Icons.description_outlined),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter task description';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Company Selection
// //               InputDecorator(
// //                 decoration: InputDecoration(
// //                   labelText: 'Company',
// //                   prefixIcon: const Icon(Icons.business_outlined),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 child: DropdownButtonHideUnderline(
// //                   child: DropdownButton<String>(
// //                     value: _selectedCompanyId,
// //                     isExpanded: true,
// //                     hint: const Text('Select Company'),
// //                     items: companyProvider.companies.map((company) {
// //                       return DropdownMenuItem<String>(
// //                         value: company.id,
// //                         child: Text(company.name),
// //                       );
// //                     }).toList(),
// //                     onChanged: authProvider.isAdmin
// //                         ? (value) {
// //                       setState(() {
// //                         _selectedCompanyId = value;
// //                       });
// //                     }
// //                         : null,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Assignee Selection
// //               InputDecorator(
// //                 decoration: InputDecoration(
// //                   labelText: 'Assign To',
// //                   prefixIcon: const Icon(Icons.person_outline),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 child: DropdownButtonHideUnderline(
// //                   child: DropdownButton<String>(
// //                     value: _selectedUserId,
// //                     isExpanded: true,
// //                     hint: const Text('Select User'),
// //                     items: userProvider.allUsers.map((user) {
// //                       return DropdownMenuItem<String>(
// //                         value: user.id,
// //                         child: Text('${user.name} (${user.role})'),
// //                       );
// //                     }).toList(),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _selectedUserId = value;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Date Selection Row
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'Start Date',
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: Colors.grey,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         InkWell(
// //                           onTap: () => _selectStartDate(context),
// //                           child: Container(
// //                             padding: const EdgeInsets.all(16),
// //                             decoration: BoxDecoration(
// //                               border: Border.all(color: Colors.grey[300]!),
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             child: Row(
// //                               children: [
// //                                 const Icon(Icons.calendar_today, size: 20),
// //                                 const SizedBox(width: 12),
// //                                 Text(
// //                                   '${_startDate.day}/${_startDate.month}/${_startDate.year}',
// //                                   style: const TextStyle(fontSize: 16),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(width: 16),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'End Date',
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: Colors.grey,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         InkWell(
// //                           onTap: () => _selectEndDate(context),
// //                           child: Container(
// //                             padding: const EdgeInsets.all(16),
// //                             decoration: BoxDecoration(
// //                               border: Border.all(color: Colors.grey[300]!),
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             child: Row(
// //                               children: [
// //                                 const Icon(Icons.calendar_today, size: 20),
// //                                 const SizedBox(width: 12),
// //                                 Text(
// //                                   '${_endDate.day}/${_endDate.month}/${_endDate.year}',
// //                                   style: const TextStyle(fontSize: 16),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Priority Selection
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     'Priority',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       color: Colors.grey,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: RadioListTile<String>(
// //                           title: const Text('Low'),
// //                           value: 'low',
// //                           groupValue: _selectedPriority,
// //                           onChanged: (value) {
// //                             setState(() {
// //                               _selectedPriority = value!;
// //                             });
// //                           },
// //                           contentPadding: EdgeInsets.zero,
// //                         ),
// //                       ),
// //                       Expanded(
// //                         child: RadioListTile<String>(
// //                           title: const Text('Medium'),
// //                           value: 'medium',
// //                           groupValue: _selectedPriority,
// //                           onChanged: (value) {
// //                             setState(() {
// //                               _selectedPriority = value!;
// //                             });
// //                           },
// //                           contentPadding: EdgeInsets.zero,
// //                         ),
// //                       ),
// //                       Expanded(
// //                         child: RadioListTile<String>(
// //                           title: const Text('High'),
// //                           value: 'high',
// //                           groupValue: _selectedPriority,
// //                           onChanged: (value) {
// //                             setState(() {
// //                               _selectedPriority = value!;
// //                             });
// //                           },
// //                           contentPadding: EdgeInsets.zero,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Tags Input
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     'Tags',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       color: Colors.grey,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextField(
// //                           controller: _tagsController,
// //                           decoration: InputDecoration(
// //                             hintText: 'Add tag...',
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                           onSubmitted: (_) => _addTag(),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       ElevatedButton(
// //                         onPressed: _addTag,
// //                         style: ElevatedButton.styleFrom(
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 24,
// //                             vertical: 16,
// //                           ),
// //                         ),
// //                         child: const Text('Add'),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 8),
// //                   if (_tags.isNotEmpty)
// //                     Wrap(
// //                       spacing: 8,
// //                       runSpacing: 8,
// //                       children: _tags.map((tag) {
// //                         return Chip(
// //                           label: Text(tag),
// //                           deleteIcon: const Icon(Icons.close, size: 16),
// //                           onDeleted: () => _removeTag(tag),
// //                         );
// //                       }).toList(),
// //                     ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Task Duration Info
// //               Container(
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue[50],
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Icons.info_outline, color: Colors.blue),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'Task Duration: ${_endDate.difference(_startDate).inDays + 1} days',
// //                             style: const TextStyle(
// //                               fontWeight: FontWeight.w500,
// //                               color: Colors.blue,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Text(
// //                             '${_endDate.difference(_startDate).inDays + 1} sub-tasks will be created automatically',
// //                             style: const TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.blue,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 24),
// //
// //               // Submit Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: _isLoading ? null : _createTask,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.blue[600],
// //                     foregroundColor: Colors.white,
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     elevation: 2,
// //                   ),
// //                   child: _isLoading
// //                       ? const SizedBox(
// //                     height: 20,
// //                     width: 20,
// //                     child: CircularProgressIndicator(
// //                       strokeWidth: 2,
// //                       valueColor: AlwaysStoppedAnimation(Colors.white),
// //                     ),
// //                   )
// //                       : const Text(
// //                     'Create Task',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _titleController.dispose();
// //     _descriptionController.dispose();
// //     _tagsController.dispose();
// //     super.dispose();
// //   }
// // }
//
//
//
// // screens/tasks/add_task_screen.dart
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/company_provider.dart';
// import '../../providers/user_provider.dart';
// import '../../providers/task_provider.dart';
// import '../../models/task_model.dart' hide Company;
// import '../../models/company_model.dart'; // Make sure to import company model
//
// class AddTaskScreen extends StatefulWidget {
//   const AddTaskScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AddTaskScreen> createState() => _AddTaskScreenState();
// }
//
// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _tagsController = TextEditingController();
//
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(const Duration(days: 7));
//   String _selectedPriority = 'medium';
//   String? _selectedCompanyId;
//   String? _selectedCompanyName; // Added to display company name for manager
//   String? _selectedUserId;
//   bool _isLoading = false;
//   String? _error;
//   String? _successMessage;
//
//   final List<SubTask> _subTasks = [];
//   final List<String> _tags = [];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeData();
//     });
//   }
//
//   Future<void> _initializeData() async {
//     final authProvider = context.read<AuthProvider>();
//     final companyProvider = context.read<CompanyProvider>();
//     final userProvider = context.read<UserProvider>();
//
//     print('=== INITIALIZE DATA ===');
//     print('User Role: ${authProvider.role}');
//     print('Company ID from AuthProvider: ${authProvider.companyId}');
//
//     // Load companies for admin
//     if (authProvider.isAdmin) {
//       await companyProvider.fetchCompanies();
//       print('Loaded ${companyProvider.companies.length} companies for admin');
//     }
//
//     // Load users - IMPORTANT: Make sure users are loaded
//     try {
//       await userProvider.fetchUsers();
//       print('Loaded ${userProvider.allUsers.length} users');
//
//       // Debug: Print all users
//       for (var i = 0; i < userProvider.allUsers.length; i++) {
//         final user = userProvider.allUsers[i];
//         final userMap = _userToMap(user);
//         print('User $i: ${userMap['name']} - ${userMap['role']} - Company: ${userMap['companyId']}');
//       }
//     } catch (e) {
//       print('Error loading users: $e');
//     }
//
//     // Auto-set company for manager from AuthProvider
//     if (authProvider.isManager) {
//       _selectedCompanyId = authProvider.companyId;
//       print('Manager company ID set to: $_selectedCompanyId');
//
//       if (_selectedCompanyId != null) {
//         try {
//           await companyProvider.fetchCompanies();
//
//           Company? foundCompany;
//           for (var company in companyProvider.companies) {
//             if (company.id == _selectedCompanyId) {
//               foundCompany = company;
//               break;
//             }
//           }
//
//           if (foundCompany != null) {
//             _selectedCompanyName = foundCompany.name;
//             print('Found company name: $_selectedCompanyName');
//           } else {
//             _selectedCompanyName = 'My Company';
//             print('Company not found in list, using default name');
//           }
//         } catch (e) {
//           print('Error getting company name: $e');
//           _selectedCompanyName = 'My Company';
//         }
//       }
//     }
//
//     setState(() {});
//   }
//
//   Future<void> _createTask() async {
//     print('=== CREATE TASK FUNCTION STARTED ===');
//
//     if (_formKey.currentState?.validate() != true) {
//       print('Form validation failed');
//       return;
//     }
//
//     final authProvider = context.read<AuthProvider>();
//
//     // Check company ID based on user role
//     if (authProvider.isManager) {
//       // For manager, use company ID from AuthProvider
//       if (_selectedCompanyId == null) {
//         // Try to get it again from auth provider
//         _selectedCompanyId = authProvider.companyId;
//
//         if (_selectedCompanyId == null) {
//           print('ERROR: Manager has no company ID');
//           setState(() {
//             _error = 'Unable to determine your company. Please login again.';
//           });
//           return;
//         }
//       }
//       print('Manager will use company ID: $_selectedCompanyId');
//     } else if (authProvider.isAdmin) {
//       // For admin, check if company is selected
//       if (_selectedCompanyId == null) {
//         print('Admin company not selected');
//         setState(() {
//           _error = 'Please select a company';
//         });
//         return;
//       }
//       print('Admin selected company ID: $_selectedCompanyId');
//     }
//
//     if (_selectedUserId == null) {
//       print('No user selected');
//       setState(() {
//         _error = 'Please select an assignee';
//       });
//       return;
//     }
//
//     print('All validations passed');
//
//     setState(() {
//       _isLoading = true;
//       _error = null;
//       _successMessage = null;
//     });
//
//     try {
//       final taskProvider = context.read<TaskProvider>();
//
//       print('=== FORM DATA ===');
//       print('Title: ${_titleController.text.trim()}');
//       print('Description: ${_descriptionController.text.trim()}');
//       print('Company ID: $_selectedCompanyId');
//       print('User ID: $_selectedUserId');
//       print('Start Date: $_startDate');
//       print('End Date: $_endDate');
//       print('Priority: $_selectedPriority');
//       print('Tags: $_tags');
//       print('User Role: ${authProvider.role}');
//
//       // Generate sub-tasks
//       print('=== GENERATING SUBTASKS ===');
//       final subTasks = _generateSubTasks();
//       print('Generated ${subTasks.length} sub-tasks');
//
//       print('=== CALLING TASK PROVIDER ===');
//       final success = await taskProvider.createTask(
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         companyId: _selectedCompanyId!, // This will be sent to API
//         assignedToId: _selectedUserId!,
//         startDate: _startDate,
//         endDate: _endDate,
//         priority: _selectedPriority,
//         tags: _tags,
//         subTasks: subTasks,
//       );
//
//       if (success) {
//         print('SUCCESS: Task created successfully');
//         setState(() {
//           _successMessage = 'Task created successfully';
//         });
//
//         // Navigate back after 2 seconds
//         Future.delayed(const Duration(seconds: 2), () {
//           if (mounted) {
//             Navigator.pop(context);
//           }
//         });
//       } else {
//         print('FAILURE: Task provider returned false');
//       }
//     } catch (e, stackTrace) {
//       print('=== EXCEPTION CAUGHT ===');
//       print('Error: $e');
//       print('Stack Trace: $stackTrace');
//
//       setState(() {
//         _error = e.toString();
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   List<SubTask> _generateSubTasks() {
//     final List<SubTask> subTasks = [];
//     final days = _endDate.difference(_startDate).inDays + 1;
//
//     for (int i = 0; i < days; i++) {
//       final date = _startDate.add(Duration(days: i));
//       subTasks.add(SubTask(
//         id: '',
//         date: date,
//         description: '${_titleController.text} - Day ${i + 1}',
//         status: 'pending',
//         hoursSpent: 0,
//         remarks: '',
//       ));
//     }
//
//     return subTasks;
//   }
//
//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _startDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _startDate) {
//       setState(() {
//         _startDate = picked;
//         if (_endDate.isBefore(_startDate)) {
//           _endDate = _startDate.add(const Duration(days: 1));
//         }
//       });
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _endDate,
//       firstDate: _startDate,
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _endDate) {
//       setState(() {
//         _endDate = picked;
//       });
//     }
//   }
//
//   void _addTag() {
//     final tag = _tagsController.text.trim();
//     if (tag.isNotEmpty && !_tags.contains(tag)) {
//       setState(() {
//         _tags.add(tag);
//         _tagsController.clear();
//       });
//     }
//   }
//
//   void _removeTag(String tag) {
//     setState(() {
//       _tags.remove(tag);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();
//     final companyProvider = context.watch<CompanyProvider>();
//     final userProvider = context.watch<UserProvider>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Create New Task',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         elevation: 1,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Success Message
//               if (_successMessage != null)
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.green[50],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.check_circle, color: Colors.green),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _successMessage!,
//                           style: const TextStyle(color: Colors.green),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//               // Error Message
//               if (_error != null)
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.red[50],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.red),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_outline, color: Colors.red),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _error!,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, size: 16),
//                         onPressed: () {
//                           setState(() {
//                             _error = null;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//
//               // Title Field
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Task Title',
//                   prefixIcon: const Icon(Icons.title_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter task title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Description Field
//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   labelText: 'Task Description',
//                   alignLabelWithHint: true,
//                   prefixIcon: const Icon(Icons.description_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter task description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Company Field - Different for Admin vs Manager
//               _buildCompanyField(authProvider, companyProvider),
//               const SizedBox(height: 16),
//
//               // Assignee Selection
//               InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Assign To',
//                   prefixIcon: const Icon(Icons.person_outline),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: _selectedUserId,
//                     isExpanded: true,
//                     hint: const Text('Select User'),
//                     items: _getFilteredUsers(authProvider, userProvider).map((user) {
//                       // Use dynamic to handle different User types
//                       final userMap = _userToMap(user);
//                       final userName = userMap['name'] ?? 'Unknown';
//                       final userRole = userMap['role'] ?? 'user';
//
//                       return DropdownMenuItem<String>(
//                         value: userMap['id']?.toString() ?? '',
//                         child: Text('$userName ($userRole)'),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedUserId = value;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Date Selection Row
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Start Date',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         InkWell(
//                           onTap: () => _selectStartDate(context),
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey[300]!),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.calendar_today, size: 20),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   '${_startDate.day}/${_startDate.month}/${_startDate.year}',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'End Date',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         InkWell(
//                           onTap: () => _selectEndDate(context),
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey[300]!),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.calendar_today, size: 20),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   '${_endDate.day}/${_endDate.month}/${_endDate.year}',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Priority Selection
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Priority',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: RadioListTile<String>(
//                           title: const Text('Low'),
//                           value: 'low',
//                           groupValue: _selectedPriority,
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedPriority = value!;
//                             });
//                           },
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                       ),
//                       Expanded(
//                         child: RadioListTile<String>(
//                           title: const Text('Medium'),
//                           value: 'medium',
//                           groupValue: _selectedPriority,
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedPriority = value!;
//                             });
//                           },
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                       ),
//                       Expanded(
//                         child: RadioListTile<String>(
//                           title: const Text('High'),
//                           value: 'high',
//                           groupValue: _selectedPriority,
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedPriority = value!;
//                             });
//                           },
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Tags Input
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Tags',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _tagsController,
//                           decoration: InputDecoration(
//                             hintText: 'Add tag...',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onSubmitted: (_) => _addTag(),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       ElevatedButton(
//                         onPressed: _addTag,
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 16,
//                           ),
//                         ),
//                         child: const Text('Add'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   if (_tags.isNotEmpty)
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: _tags.map((tag) {
//                         return Chip(
//                           label: Text(tag),
//                           deleteIcon: const Icon(Icons.close, size: 16),
//                           onDeleted: () => _removeTag(tag),
//                         );
//                       }).toList(),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Task Duration Info
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.info_outline, color: Colors.blue),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Task Duration: ${_endDate.difference(_startDate).inDays + 1} days',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${_endDate.difference(_startDate).inDays + 1} sub-tasks will be created automatically',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _createTask,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue[600],
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation(Colors.white),
//                     ),
//                   )
//                       : const Text(
//                     'Create Task',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to convert different User types to Map
//   Map<String, dynamic> _userToMap(dynamic user) {
//     if (user is Map<String, dynamic>) {
//       return user;
//     } else {
//       // Try to convert object to map
//       try {
//         return {
//           'id': user.id?.toString() ?? '',
//           'name': user.name?.toString() ?? '',
//           'role': user.role?.toString() ?? '',
//           'companyId': user.companyId?.toString() ?? '',
//         };
//       } catch (e) {
//         return {'id': '', 'name': 'Unknown', 'role': 'user', 'companyId': ''};
//       }
//     }
//   }
//
//   Widget _buildCompanyField(AuthProvider authProvider, CompanyProvider companyProvider) {
//     if (authProvider.isAdmin) {
//       // Admin: Show dropdown to select company
//       return InputDecorator(
//         decoration: InputDecoration(
//           labelText: 'Company',
//           prefixIcon: const Icon(Icons.business_outlined),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: _selectedCompanyId,
//             isExpanded: true,
//             hint: const Text('Select Company'),
//             items: companyProvider.companies.map((company) {
//               return DropdownMenuItem<String>(
//                 value: company.id,
//                 child: Text(company.name),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedCompanyId = value;
//               });
//             },
//           ),
//         ),
//       );
//     } else if (authProvider.isManager) {
//       // Manager: Show read-only field with their company
//       return InputDecorator(
//         decoration: InputDecoration(
//           labelText: 'Company',
//           prefixIcon: const Icon(Icons.business_outlined),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//           child: Row(
//             children: [
//               Icon(Icons.business, color: Colors.grey[700]),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   _selectedCompanyName ?? 'Loading company...',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               if (_selectedCompanyId != null)
//                 Tooltip(
//                   message: 'Company ID: $_selectedCompanyId',
//                   child: Icon(Icons.info_outline, color: Colors.grey[500], size: 18),
//                 ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       // Staff or other roles
//       return InputDecorator(
//         decoration: InputDecoration(
//           labelText: 'Company',
//           prefixIcon: const Icon(Icons.business_outlined),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//           child: const Text(
//             'Not applicable',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ),
//       );
//     }
//   }
//
//   // screens/tasks/add_task_screen.dart
// // Update the _getFilteredUsers method:
//
//   List<dynamic> _getFilteredUsers(AuthProvider authProvider, UserProvider userProvider) {
//     final filteredUsers = <dynamic>[];
//
//     print('=== USER FILTERING DEBUG ===');
//     print('User Role: ${authProvider.role}');
//     print('Selected Company ID: $_selectedCompanyId');
//     print('Total users available: ${userProvider.allUsers.length}');
//
//     for (final user in userProvider.allUsers) {
//       final userMap = _userToMap(user);
//       final userCompanyId = userMap['companyId']?.toString();
//       final userName = userMap['name'] ?? 'Unknown';
//       final userRole = userMap['role'] ?? 'user';
//
//       print('User: $userName, Role: $userRole, Company: $userCompanyId');
//
//       // Special handling for staff users
//       if (authProvider.isManager) {
//         // Manager can only assign to users from their company
//         // But they should see ALL users from their company (including staff)
//         if (userCompanyId == _selectedCompanyId) {
//           filteredUsers.add(user);
//           print('  ✓ Added for manager');
//         } else {
//           print('  ✗ Skipped - different company');
//         }
//       } else if (authProvider.isAdmin) {
//         // Admin can assign to users from selected company or all if no company selected
//         if (_selectedCompanyId == null || userCompanyId == _selectedCompanyId) {
//           filteredUsers.add(user);
//           print('  ✓ Added for admin');
//         } else {
//           print('  ✗ Skipped - different company');
//         }
//       } else {
//         // For other roles, show all users
//         filteredUsers.add(user);
//         print('  ✓ Added (all users)');
//       }
//     }
//
//     print('Total filtered users: ${filteredUsers.length}');
//     return filteredUsers;
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _tagsController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/models/company_model.dart';
import 'package:taskflow_app/models/task_model.dart' hide Company;
import 'package:taskflow_app/providers/auth_provider.dart';
import 'package:taskflow_app/providers/company_provider.dart';
import 'package:taskflow_app/providers/task_provider.dart';
import 'package:taskflow_app/providers/user_provider.dart';

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
  String? _selectedCompanyName;
  String? _selectedUserId;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();
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

  Future<void> _createTask() async {
    if (_formKey.currentState?.validate() != true) return;

    final authProvider = context.read<AuthProvider>();

    // Validate company
    if (authProvider.isManager) {
      if (_selectedCompanyId == null) {
        _selectedCompanyId = authProvider.companyId;
        if (_selectedCompanyId == null) {
          setState(() {
            _error = 'Unable to determine your company';
          });
          return;
        }
      }
    } else if (authProvider.isAdmin && _selectedCompanyId == null) {
      setState(() {
        _error = 'Please select a company';
      });
      return;
    }

    if (_selectedUserId == null) {
      setState(() {
        _error = 'Please select an assignee';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final taskProvider = context.read<TaskProvider>();
      final subTasks = _generateSubTasks();

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
        setState(() {
          _successMessage = 'Task created successfully';
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Task',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isSmallScreen ? 18 : 20,
            color: Colors.grey[800],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                // Form Card
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field
                      _buildLabel('Task Title', isSmallScreen),
                      SizedBox(height: 6),
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
                      SizedBox(height: 16),

                      // Description Field
                      _buildLabel('Task Description', isSmallScreen),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
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
                      SizedBox(height: 16),

                      // Company Field
                      // _buildLabel('Company', isSmallScreen),
                      // SizedBox(height: 6),
                      // _buildCompanyField(authProvider, companyProvider, isSmallScreen),
                      // SizedBox(height: 16),

                      // Assignee Field
                      _buildLabel('Assign To', isSmallScreen),
                      SizedBox(height: 6),
                      _buildAssigneeField(userProvider, authProvider, isSmallScreen),
                      SizedBox(height: 16),

                      // Date Selection
                      _buildLabel('Timeline', isSmallScreen),
                      SizedBox(height: 6),
                      _buildDateFields(isSmallScreen),
                      SizedBox(height: 16),

                      // Priority Selection
                      _buildLabel('Priority', isSmallScreen),
                      SizedBox(height: 6),
                      _buildPrioritySelection(isSmallScreen),
                      SizedBox(height: 16),

                      // Tags Input
                      _buildLabel('Tags', isSmallScreen),
                      SizedBox(height: 6),
                      _buildTagsInput(isSmallScreen),
                      SizedBox(height: 20),

                      // Task Duration Info
                      _buildDurationInfo(isSmallScreen),
                      SizedBox(height: 24),

                      // Submit Button
                      _buildSubmitButton(isSmallScreen),
                    ],
                  ),
                ),
              ],
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
      margin: EdgeInsets.only(bottom: 16),
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
          SizedBox(width: 10),
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
              icon: Icon(Icons.close_rounded, size: 18),
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
  //
  // Widget _buildCompanyField(
  //     AuthProvider authProvider,
  //     CompanyProvider companyProvider,
  //     bool isSmallScreen,
  //     ) {
  //   if (authProvider.isAdmin) {
  //     return Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey[300]!),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton<String>(
  //           value: _selectedCompanyId,
  //           isExpanded: true,
  //           padding: EdgeInsets.symmetric(horizontal: 16),
  //           icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600]),
  //           style: TextStyle(
  //             fontSize: isSmallScreen ? 15 : 16,
  //             color: Colors.grey[800],
  //           ),
  //           hint: Text(
  //             'Select Company',
  //             style: TextStyle(color: Colors.grey[500]),
  //           ),
  //           items: companyProvider.companies.map((company) {
  //             return DropdownMenuItem<String>(
  //               value: company.id,
  //               child: Text(
  //                 company.name,
  //                 style: TextStyle(fontSize: isSmallScreen ? 14 : 15),
  //               ),
  //             );
  //           }).toList(),
  //           onChanged: (value) {
  //             setState(() {
  //               _selectedCompanyId = value;
  //             });
  //           },
  //         ),
  //       ),
  //     );
  //   } else if (authProvider.isManager) {
  //     return Container(
  //       padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[50],
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.grey[200]!),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(Icons.business_rounded, color: Colors.grey[600], size: 20),
  //           SizedBox(width: 12),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Your Company',
  //                   style: TextStyle(
  //                     fontSize: isSmallScreen ? 12 : 13,
  //                     color: Colors.grey[500],
  //                   ),
  //                 ),
  //                 SizedBox(height: 2),
  //                 Text(
  //                   _selectedCompanyName ?? 'Loading...',
  //                   style: TextStyle(
  //                     fontSize: isSmallScreen ? 15 : 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.grey[800],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[50],
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.grey[200]!),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(Icons.business_rounded, color: Colors.grey[400], size: 20),
  //           SizedBox(width: 12),
  //           Text(
  //             'Not applicable',
  //             style: TextStyle(
  //               fontSize: isSmallScreen ? 15 : 16,
  //               color: Colors.grey[600],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

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
          padding: EdgeInsets.symmetric(horizontal: 16),
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
                        SizedBox(width: 8),
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
                    SizedBox(height: 6),
                    Text(
                      _formatDate(_startDate),
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
          SizedBox(width: 12),
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
          SizedBox(width: 12),
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
                        SizedBox(width: 8),
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
                    SizedBox(height: 6),
                    Text(
                      _formatDate(_endDate),
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
            padding: EdgeInsets.only(right: 8),
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
                    SizedBox(height: 4),
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
            SizedBox(width: 12),
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
          SizedBox(height: 12),
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
                    SizedBox(width: 6),
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Duration: $days ${days == 1 ? 'day' : 'days'}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$days sub-tasks will be created automatically',
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

  Widget _buildSubmitButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _createTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: isSmallScreen ? 16 : 18,
          ),
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
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_task_rounded, size: isSmallScreen ? 20 : 22),
            SizedBox(width: 10),
            Text(
              'Create Task',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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

  String _formatDate(DateTime date) {
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