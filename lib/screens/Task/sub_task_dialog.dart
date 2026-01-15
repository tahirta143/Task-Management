// // // screens/tasks/subtask_dialog.dart
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import '../../models/task_model.dart';
// //
// // class SubTaskDialog extends StatefulWidget {
// //   final String taskId;
// //   final SubTask? existingSubTask;
// //   final bool isEditMode;
// //
// //   const SubTaskDialog({
// //     Key? key,
// //     required this.taskId,
// //     this.existingSubTask,
// //     this.isEditMode = false,
// //   }) : super(key: key);
// //
// //   @override
// //   _SubTaskDialogState createState() => _SubTaskDialogState();
// // }
// //
// // class _SubTaskDialogState extends State<SubTaskDialog> {
// //   late TextEditingController _descriptionController;
// //   late TextEditingController _remarksController;
// //   late TextEditingController _hoursSpentController;
// //   late DateTime _selectedDate;
// //   late String _selectedStatus;
// //   final _formKey = GlobalKey<FormState>();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _selectedDate = widget.existingSubTask?.date ?? DateTime.now();
// //     _selectedStatus = widget.existingSubTask?.status ?? 'pending';
// //
// //     _descriptionController = TextEditingController(
// //       text: widget.existingSubTask?.description ?? '',
// //     );
// //     _remarksController = TextEditingController(
// //       text: widget.existingSubTask?.remarks ?? '',
// //     );
// //     _hoursSpentController = TextEditingController(
// //       text: widget.existingSubTask?.hoursSpent.toString() ?? '0',
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _descriptionController.dispose();
// //     _remarksController.dispose();
// //     _hoursSpentController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2100),
// //     );
// //
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() {
// //         _selectedDate = picked;
// //       });
// //     }
// //   }
// //
// //   SubTask _createSubTask() {
// //     return SubTask(
// //       id: widget.existingSubTask?.id ?? '',
// //       date: _selectedDate,
// //       description: _descriptionController.text.trim(),
// //       status: _selectedStatus,
// //       hoursSpent: int.tryParse(_hoursSpentController.text) ?? 0,
// //       remarks: _remarksController.text.trim(),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final isSmallPhone = screenWidth < 360;
// //
// //     return Dialog(
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       elevation: 0,
// //       backgroundColor: Colors.transparent,
// //       child: SingleChildScrollView(
// //         child: Container(
// //           padding: EdgeInsets.all(isSmallPhone ? 16 : 20),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Header
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     widget.isEditMode ? 'Edit Progress' : 'Add Progress',
// //                     style: TextStyle(
// //                       fontSize: isSmallPhone ? 18 : 20,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   IconButton(
// //                     icon: const Icon(Icons.close, size: 20),
// //                     onPressed: () => Navigator.pop(context),
// //                     padding: EdgeInsets.zero,
// //                     constraints: const BoxConstraints(),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //
// //               Form(
// //                 key: _formKey,
// //                 child: Column(
// //                   children: [
// //                     // Date Picker
// //                     GestureDetector(
// //                       onTap: () => _selectDate(context),
// //                       child: Container(
// //                         padding: const EdgeInsets.all(12),
// //                         decoration: BoxDecoration(
// //                           color: Colors.grey[50],
// //                           borderRadius: BorderRadius.circular(8),
// //                           border: Border.all(color: Colors.grey[300]!),
// //                         ),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Text(
// //                               DateFormat('dd-MMM-yyyy').format(_selectedDate),
// //                               style: const TextStyle(fontSize: 16),
// //                             ),
// //                             Icon(
// //                               Icons.calendar_today,
// //                               color: Colors.blue[600],
// //                               size: 20,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //
// //                     // Description Field
// //                     TextFormField(
// //                       controller: _descriptionController,
// //                       decoration: InputDecoration(
// //                         labelText: 'Description *',
// //                         hintText: 'Enter sub-task description',
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                           borderSide: BorderSide(color: Colors.grey[400]!),
// //                         ),
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         contentPadding: const EdgeInsets.all(12),
// //                       ),
// //                       maxLines: 3,
// //                       validator: (value) {
// //                         if (value == null || value.trim().isEmpty) {
// //                           return 'Please enter a description';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     const SizedBox(height: 16),
// //
// //                     // Status Dropdown
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(color: Colors.grey[400]!),
// //                       ),
// //                       child: DropdownButtonFormField<String>(
// //                         value: _selectedStatus,
// //                         icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
// //                         iconSize: 24,
// //                         elevation: 0,
// //                         decoration: const InputDecoration(
// //                           border: InputBorder.none,
// //                           labelText: 'Status *',
// //                         ),
// //                         items: [
// //                           DropdownMenuItem(
// //                             value: 'pending',
// //                             child: Row(
// //                               children: [
// //                                 Container(
// //                                   width: 10,
// //                                   height: 10,
// //                                   decoration: const BoxDecoration(
// //                                     color: Colors.orange,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 8),
// //                                 const Text('Pending'),
// //                               ],
// //                             ),
// //                           ),
// //                           DropdownMenuItem(
// //                             value: 'in-progress',
// //                             child: Row(
// //                               children: [
// //                                 Container(
// //                                   width: 10,
// //                                   height: 10,
// //                                   decoration: const BoxDecoration(
// //                                     color: Colors.blue,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 8),
// //                                 const Text('In Progress'),
// //                               ],
// //                             ),
// //                           ),
// //                           DropdownMenuItem(
// //                             value: 'completed',
// //                             child: Row(
// //                               children: [
// //                                 Container(
// //                                   width: 10,
// //                                   height: 10,
// //                                   decoration: const BoxDecoration(
// //                                     color: Colors.green,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 8),
// //                                 const Text('Completed'),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                         onChanged: (value) {
// //                           if (value != null) {
// //                             setState(() {
// //                               _selectedStatus = value;
// //                             });
// //                           }
// //                         },
// //                         validator: (value) {
// //                           if (value == null || value.isEmpty) {
// //                             return 'Please select a status';
// //                           }
// //                           return null;
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //
// //                     // Hours Spent
// //                     TextFormField(
// //                       controller: _hoursSpentController,
// //                       decoration: InputDecoration(
// //                         labelText: 'Hours Spent *',
// //                         hintText: 'Enter hours spent',
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                           borderSide: BorderSide(color: Colors.grey[400]!),
// //                         ),
// //                         suffixText: 'hours',
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         contentPadding: const EdgeInsets.all(12),
// //                       ),
// //                       keyboardType: TextInputType.number,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter hours spent';
// //                         }
// //                         final hours = int.tryParse(value);
// //                         if (hours == null || hours < 0) {
// //                           return 'Please enter a valid number';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     const SizedBox(height: 16),
// //
// //                     // Remarks
// //                     TextFormField(
// //                       controller: _remarksController,
// //                       decoration: InputDecoration(
// //                         labelText: 'Remarks (Optional)',
// //                         hintText: 'Additional notes or comments',
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                           borderSide: BorderSide(color: Colors.grey[400]!),
// //                         ),
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         contentPadding: const EdgeInsets.all(12),
// //                       ),
// //                       maxLines: 2,
// //                     ),
// //                     const SizedBox(height: 24),
// //
// //                     // Action Buttons
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: OutlinedButton(
// //                             onPressed: () => Navigator.pop(context),
// //                             style: OutlinedButton.styleFrom(
// //                               foregroundColor: Colors.grey[700],
// //                               side: BorderSide(color: Colors.grey[400]!),
// //                               padding: const EdgeInsets.symmetric(vertical: 14),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                               ),
// //                             ),
// //                             child: const Text('Cancel'),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 12),
// //                         Expanded(
// //                           child: ElevatedButton(
// //                             onPressed: () {
// //                               if (_formKey.currentState!.validate()) {
// //                                 Navigator.pop(context, _createSubTask());
// //                               }
// //                             },
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.blue[600],
// //                               foregroundColor: Colors.white,
// //                               padding: const EdgeInsets.symmetric(vertical: 14),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(8),
// //                               ),
// //                               elevation: 2,
// //                             ),
// //                             child: Text(widget.isEditMode ? 'Update' : 'Add'),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // screens/tasks/subtask_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taskflow_app/screens/Task/sub_task_dialog.dart';
// import '../../models/task_model.dart';
// import '../../providers/task_provider.dart';
//
// class SubTaskListScreen extends StatefulWidget {
//   final Task task;
//
//   const SubTaskListScreen({Key? key, required this.task}) : super(key: key);
//
//   @override
//   State<SubTaskListScreen> createState() => _SubTaskListScreenState();
// }
//
// class _SubTaskListScreenState extends State<SubTaskListScreen> {
//   // Group sub-tasks by date
//   Map<String, List<SubTask>> _groupSubTasksByDate() {
//     final Map<String, List<SubTask>> grouped = {};
//
//     for (final day in widget.task.days) {
//       final dateKey = _formatDateKey(day.date);
//       grouped[dateKey] = day.subTasks;
//     }
//
//     return grouped;
//   }
//
//   // Get all sub-tasks from all days
//   List<SubTask> get _allSubTasks {
//     return widget.task.days.expand((day) => day.subTasks).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);
//     final groupedSubTasks = _groupSubTasksByDate();
//     final allSubTasks = _allSubTasks;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Sub-Tasks: ${widget.task.title}',
//           style: const TextStyle(fontSize: 18),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showAddSubTaskDialog(taskProvider),
//           ),
//         ],
//       ),
//       body: widget.task.days.isEmpty
//           ? _buildEmptyState()
//           : _buildSubTaskList(groupedSubTasks, taskProvider),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddSubTaskDialog(taskProvider),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.checklist_outlined,
//             size: 64,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No sub-tasks yet',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Add your first sub-task to get started',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSubTaskList(Map<String, List<SubTask>> groupedSubTasks,
//       TaskProvider taskProvider) {
//     final dates = groupedSubTasks.keys.toList()
//       ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: dates.length,
//       itemBuilder: (context, dateIndex) {
//         final date = dates[dateIndex];
//         final subTasksForDate = groupedSubTasks[date] ?? [];
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Date header
//             Padding(
//               padding: EdgeInsets.only(bottom: 8, top: dateIndex == 0 ? 0 : 16),
//               child: Text(
//                 _formatDateDisplay(DateTime.parse(date)),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//
//             // Sub-tasks for this date
//             ...subTasksForDate.map((subTask) {
//               return _buildSubTaskCard(subTask, taskProvider, date);
//             }),
//
//             const SizedBox(height: 8),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildSubTaskCard(SubTask subTask,
//       TaskProvider taskProvider,
//       String dateKey) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 2,
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: _getStatusColor(subTask.status),
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: Center(
//             child: Text(
//               '${subTask.hoursSpent}h',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           subTask.description,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text(
//                   '${_formatDate(DateTime.parse(dateKey))}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 2),
//             Text(
//               'Remarks: ${subTask.remarks.isNotEmpty
//                   ? subTask.remarks
//                   : 'None'}',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(subTask.status).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: _getStatusColor(subTask.status),
//                     ),
//                   ),
//                   child: Text(
//                     subTask.status.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: _getStatusColor(subTask.status),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Updated: ${_formatTime(subTask.updatedAt)}',
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: PopupMenuButton(
//           itemBuilder: (context) =>
//           [
//             const PopupMenuItem(
//               value: 'edit',
//               child: Row(
//                 children: [
//                   Icon(Icons.edit, size: 18),
//                   SizedBox(width: 8),
//                   Text('Edit'),
//                 ],
//               ),
//             ),
//             const PopupMenuItem(
//               value: 'delete',
//               child: Row(
//                 children: [
//                   Icon(Icons.delete, color: Colors.red, size: 18),
//                   SizedBox(width: 8),
//                   Text('Delete', style: TextStyle(color: Colors.red)),
//                 ],
//               ),
//             ),
//           ],
//           onSelected: (value) {
//             if (value == 'edit') {
//               _showEditSubTaskDialog(taskProvider, subTask, dateKey);
//             } else if (value == 'delete') {
//               _showDeleteDialog(taskProvider, subTask);
//             }
//           },
//         ),
//         onTap: () => _showEditSubTaskDialog(taskProvider, subTask, dateKey),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'completed':
//         return Colors.green;
//       case 'in-progress':
//         return Colors.blue;
//       case 'pending':
//       default:
//         return Colors.orange;
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day
//         .toString().padLeft(2, '0')}';
//   }
//
//   String _formatDateKey(DateTime date) {
//     return date.toIso8601String().split('T')[0]; // YYYY-MM-DD
//   }
//
//   String _formatDateDisplay(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final taskDate = DateTime(date.year, date.month, date.day);
//
//     if (taskDate == today) {
//       return 'Today';
//     } else if (taskDate == today.subtract(const Duration(days: 1))) {
//       return 'Yesterday';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
//
//   String _formatTime(DateTime dateTime) {
//     return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute
//         .toString().padLeft(2, '0')}';
//   }
//
//   Future<void> _showAddSubTaskDialog(TaskProvider taskProvider) async {
//     final result = await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (context) =>
//           SubTaskDialog(
//             taskId: widget.task.id,
//             isEditMode: false,
//           ),
//     );
//
//     if (result != null && mounted) {
//       final success = await taskProvider.addSubTask(
//         taskId: widget.task.id,
//         date: result['date'],
//         description: result['description'],
//         status: result['status'],
//         hoursSpent: result['hoursSpent'],
//         remarks: result['remarks'],
//       );
//
//       if (success && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Sub-task added successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         // Refresh the task data
//         await taskProvider.fetchTasks();
//         setState(() {});
//       }
//     }
//   }
//
//   Future<void> _showEditSubTaskDialog(TaskProvider taskProvider,
//       SubTask subTask,
//       String dateKey) async {
//     final result = await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (context) =>
//           SubTaskDialog(
//             taskId: widget.task.id,
//             existingSubTask: subTask,
//             existingDate: dateKey,
//             isEditMode: true,
//           ),
//     );
//
//     if (result != null && mounted) {
//       final success = await taskProvider.updateSubTask(
//         taskId: widget.task.id,
//         subTaskId: subTask.id,
//         date: result['date'],
//         description: result['description'],
//         status: result['status'],
//         hoursSpent: result['hoursSpent'],
//         remarks: result['remarks'],
//       );
//
//       if (success && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Sub-task updated successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         // Refresh the task data
//         await taskProvider.fetchTasks();
//         setState(() {});
//       }
//     }
//   }
//
//   Future<void> _showDeleteDialog(TaskProvider taskProvider,
//       SubTask subTask) async {
//     showDialog(
//       context: context,
//       builder: (context) =>
//           AlertDialog(
//             title: const Text('Delete Sub-Task'),
//             content: const Text(
//                 'Are you sure you want to delete this sub-task?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   final success = await taskProvider.deleteSubTask(
//                     taskId: widget.task.id,
//                     subTaskId: subTask.id,
//                   );
//
//                   if (success && mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Sub-task deleted successfully'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//
//                     // Refresh the task data
//                     await taskProvider.fetchTasks();
//                     setState(() {});
//                   }
//                 },
//                 child: const Text(
//                   'Delete',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }
//
//   // Statistics Card
//   Widget _buildStatisticsCard() {
//     final allSubTasks = _allSubTasks;
//     final completed = allSubTasks
//         .where((st) => st.status == 'completed')
//         .length;
//     final inProgress = allSubTasks
//         .where((st) => st.status == 'in-progress')
//         .length;
//     final pending = allSubTasks
//         .where((st) => st.status == 'pending')
//         .length;
//     final totalHours = allSubTasks.fold(0, (sum, st) => sum + st.hoursSpent);
//
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Sub-Task Statistics',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStatItem('Total', '${allSubTasks.length}', Colors.blue),
//                 _buildStatItem('Completed', '$completed', Colors.green),
//                 _buildStatItem('In Progress', '$inProgress', Colors.orange),
//                 _buildStatItem('Pending', '$pending', Colors.grey),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Divider(color: Colors.grey[300]),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.timer, size: 16, color: Colors.blue),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Total Hours: $totalHours hours',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem(String label, String value, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: color),
//           ),
//           child: Center(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: color,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
// }


// screens/tasks/subtask_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';

class SubTaskDialog extends StatefulWidget {
  final String taskId;
  final SubTask? existingSubTask;
  final String? existingDate; // Add this for date from days array
  final bool isEditMode;

  const SubTaskDialog({
    Key? key,
    required this.taskId,
    this.existingSubTask,
    this.existingDate,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  _SubTaskDialogState createState() => _SubTaskDialogState();
}

class _SubTaskDialogState extends State<SubTaskDialog> {
  late TextEditingController _descriptionController;
  late TextEditingController _remarksController;
  late TextEditingController _hoursSpentController;
  late DateTime _selectedDate;
  late String _selectedStatus;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize date - use existingDate if provided, otherwise use existingSubTask date, otherwise use today
    if (widget.existingDate != null) {
      _selectedDate = DateTime.parse(widget.existingDate!);
    } else if (widget.existingSubTask != null) {
      _selectedDate = widget.existingSubTask!.createdAt;
    } else {
      _selectedDate = DateTime.now();
    }

    _selectedStatus = widget.existingSubTask?.status ?? 'pending';

    _descriptionController = TextEditingController(
      text: widget.existingSubTask?.description ?? '',
    );
    _remarksController = TextEditingController(
      text: widget.existingSubTask?.remarks ?? '',
    );
    _hoursSpentController = TextEditingController(
      text: widget.existingSubTask?.hoursSpent.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _remarksController.dispose();
    _hoursSpentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Changed from returning SubTask to returning Map
  Map<String, dynamic> _createSubTaskData() {
    return {
      'date': _formatDateForAPI(_selectedDate), // Format as YYYY-MM-DD
      'description': _descriptionController.text.trim(),
      'status': _selectedStatus,
      'hoursSpent': int.tryParse(_hoursSpentController.text) ?? 0,
      'remarks': _remarksController.text.trim(),
    };
  }

  String _formatDateForAPI(DateTime date) {
    // Format as YYYY-MM-DD for API
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatDateForDisplay(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallPhone = screenWidth < 360;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(isSmallPhone ? 16 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEditMode ? 'Edit Sub-Task' : 'Add Sub-Task',
                    style: TextStyle(
                      fontSize: isSmallPhone ? 18 : 20,
                      fontWeight: FontWeight.w600,
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
              const SizedBox(height: 16),

              // Task ID Info (for debugging)
              if (!isSmallPhone)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Task: ${widget.taskId.substring(0, 8)}...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Date Picker
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDateForDisplay(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.blue[600],
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        hintText: 'What did you work on?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                        prefixIcon: const Icon(Icons.description, size: 20),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status and Hours in Row for larger screens
                    // if (!isSmallPhone)
                    //   Row(
                    //     children: [
                    //       Expanded(
                    //         child: _buildStatusDropdown(),
                    //       ),
                    //       const SizedBox(width: 16),
                    //       Expanded(
                    //         child: _buildHoursSpentField(),
                    //       ),
                    //     ],
                    //   )
                    // else
                    //   Column(
                    //     children: [
                    //       _buildStatusDropdown(),
                    //       const SizedBox(height: 16),
                    //       _buildHoursSpentField(),
                    //     ],
                    //   ),
                    Column(
                      children: [
                        _buildStatusDropdown(),
                        const SizedBox(height: 16),
                        _buildHoursSpentField(),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Remarks
                    TextFormField(
                      controller: _remarksController,
                      decoration: InputDecoration(
                        labelText: 'Remarks (Optional)',
                        hintText: 'Additional notes or comments...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                        prefixIcon: const Icon(Icons.comment, size: 20),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),

                    // Info about date format
                    if (widget.isEditMode)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: Colors.blue[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Date changes may create a new day entry',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

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
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context, _createSubTaskData());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: Text(widget.isEditMode ? 'Update' : 'Add'),
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

  Widget _buildStatusDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        iconSize: 24,
        elevation: 0,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Status *',
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          prefixIcon: Icon(Icons.circle, size: 20),
        ),
        items: [
          _buildDropdownItem('pending', 'Pending', Colors.orange),
          _buildDropdownItem('in-progress', 'In Progress', Colors.blue),
          _buildDropdownItem('completed', 'Completed', Colors.green),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedStatus = value;
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a status';
          }
          return null;
        },
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String label, Color color) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildHoursSpentField() {
    return TextFormField(
      controller: _hoursSpentController,
      decoration: InputDecoration(
        labelText: 'Hours Spent *',
        hintText: '0',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        suffixText: 'hours',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        prefixIcon: const Icon(Icons.timer, size: 20),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter hours spent';
        }
        final hours = int.tryParse(value);
        if (hours == null || hours < 0) {
          return 'Please enter a valid number';
        }
        if (hours > 24) {
          return 'Hours cannot exceed 24';
        }
        return null;
      },
    );
  }
}