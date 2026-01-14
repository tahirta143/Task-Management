// screens/tasks/subtask_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';

class SubTaskDialog extends StatefulWidget {
  final String taskId;
  final SubTask? existingSubTask;
  final bool isEditMode;

  const SubTaskDialog({
    Key? key,
    required this.taskId,
    this.existingSubTask,
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
    _selectedDate = widget.existingSubTask?.date ?? DateTime.now();
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

  SubTask _createSubTask() {
    return SubTask(
      id: widget.existingSubTask?.id ?? '',
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      status: _selectedStatus,
      hoursSpent: int.tryParse(_hoursSpentController.text) ?? 0,
      remarks: _remarksController.text.trim(),
    );
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
                    widget.isEditMode ? 'Edit Progress' : 'Add Progress',
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
                            Text(
                              DateFormat('dd-MMM-yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.blue[600],
                              size: 20,
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
                        hintText: 'Enter sub-task description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
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

                    // Status Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'pending',
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Pending'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'in-progress',
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('In Progress'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'completed',
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Completed'),
                              ],
                            ),
                          ),
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
                    ),
                    const SizedBox(height: 16),

                    // Hours Spent
                    TextFormField(
                      controller: _hoursSpentController,
                      decoration: InputDecoration(
                        labelText: 'Hours Spent *',
                        hintText: 'Enter hours spent',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        suffixText: 'hours',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Remarks
                    TextFormField(
                      controller: _remarksController,
                      decoration: InputDecoration(
                        labelText: 'Remarks (Optional)',
                        hintText: 'Additional notes or comments',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      maxLines: 2,
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
                                Navigator.pop(context, _createSubTask());
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
}