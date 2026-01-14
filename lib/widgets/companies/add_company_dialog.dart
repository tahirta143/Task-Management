// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/company_model.dart';
// import '../../providers/company_provider.dart';
//
//
// class AddCompanyDialog extends StatefulWidget {
//   final Company? company;
//
//   const AddCompanyDialog({super.key, this.company});
//
//   @override
//   State<AddCompanyDialog> createState() => _AddCompanyDialogState();
// }
//
// class _AddCompanyDialogState extends State<AddCompanyDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   bool _isActive = true;
//   bool _isEditing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isEditing = widget.company != null;
//     if (_isEditing) {
//       _nameController.text = widget.company!.name;
//       _descriptionController.text = widget.company!.description;
//       _addressController.text = widget.company!.address;
//       _phoneController.text = widget.company!.phone;
//       _emailController.text = widget.company!.email;
//       _isActive = widget.company!.isActive;
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _addressController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final provider = Provider.of<CompanyProvider>(context, listen: false);
//
//       if (_isEditing && widget.company != null) {
//         final success = await provider.updateCompany(
//           id: widget.company!.id,
//           name: _nameController.text.trim(),
//           description: _descriptionController.text.trim(),
//           address: _addressController.text.trim(),
//           phone: _phoneController.text.trim(),
//           email: _emailController.text.trim(),
//           isActive: _isActive,
//         );
//
//         if (success) {
//           Navigator.pop(context);
//         }
//       } else {
//         final success = await provider.createCompany(
//           name: _nameController.text.trim(),
//           description: _descriptionController.text.trim(),
//           address: _addressController.text.trim(),
//           phone: _phoneController.text.trim(),
//           email: _emailController.text.trim(),
//         );
//
//         if (success) {
//           Navigator.pop(context);
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CompanyProvider>(context);
//
//     return AlertDialog(
//       title: Text(
//         _isEditing ? 'Edit Company' : 'Add New Company',
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Name
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Company Name',
//                   prefixIcon: Icon(Icons.business),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter company name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Description
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Address
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(
//                   labelText: 'Address',
//                   prefixIcon: Icon(Icons.location_on),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Phone
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone',
//                   prefixIcon: Icon(Icons.phone),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Email
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   if (!value.contains('@')) {
//                     return 'Please enter valid email';
//                   }
//                   return null;
//                 },
//               ),
//
//               // Active Toggle (only for edit)
//               if (_isEditing)
//                 Column(
//                   children: [
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         const Text(
//                           'Status:',
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(width: 12),
//                         Switch(
//                           value: _isActive,
//                           onChanged: (value) {
//                             setState(() {
//                               _isActive = value;
//                             });
//                           },
//                           activeColor: Colors.green,
//                         ),
//                         Text(
//                           _isActive ? 'Active' : 'Inactive',
//                           style: TextStyle(
//                             color: _isActive ? Colors.green : Colors.grey,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: provider.isLoading ? null : _submitForm,
//           child: provider.isLoading
//               ? const SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               color: Colors.white,
//             ),
//           )
//               : Text(_isEditing ? 'Update' : 'Create'),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/company_model.dart';
import '../../providers/company_provider.dart';

class AddCompanyDialog extends StatefulWidget {
  final Company? company;

  const AddCompanyDialog({super.key, this.company});

  @override
  State<AddCompanyDialog> createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends State<AddCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isActive = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.company != null;
    if (_isEditing) {
      _nameController.text = widget.company!.name;
      _descriptionController.text = widget.company!.description;
      _addressController.text = widget.company!.address;
      _phoneController.text = widget.company!.phone;
      _emailController.text = widget.company!.email;
      _isActive = widget.company!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CompanyProvider>(context, listen: false);

      if (_isEditing && widget.company != null) {
        final success = await provider.updateCompany(
          id: widget.company!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          isActive: _isActive,
        );

        if (success) {
          Navigator.pop(context);
        }
      } else {
        final success = await provider.createCompany(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
        );

        if (success) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isEditing ? Icons.edit_rounded : Icons.add_business_rounded,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing ? 'Edit Company' : 'Add New Company',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 18 : 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[900],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _isEditing ? 'Update company information' : 'Create a new company profile',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Company Name
                      _buildFormField(
                        label: 'Company Name',
                        controller: _nameController,
                        icon: Icons.business_rounded,
                        hint: 'Enter company name',
                        isSmallScreen: isSmallScreen,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Description
                      _buildFormField(
                        label: 'Description',
                        controller: _descriptionController,
                        icon: Icons.description_rounded,
                        hint: 'Enter company description',
                        isSmallScreen: isSmallScreen,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Address
                      _buildFormField(
                        label: 'Address',
                        controller: _addressController,
                        icon: Icons.location_on_rounded,
                        hint: 'Enter company address',
                        isSmallScreen: isSmallScreen,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Phone
                      _buildFormField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        icon: Icons.phone_rounded,
                        hint: 'Enter phone number',
                        isSmallScreen: isSmallScreen,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Email
                      _buildFormField(
                        label: 'Email Address',
                        controller: _emailController,
                        icon: Icons.email_rounded,
                        hint: 'Enter email address',
                        isSmallScreen: isSmallScreen,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      // Active Toggle (only for edit)
                      if (_isEditing)
                        Column(
                          children: [
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _isActive ? Icons.check_circle_rounded : Icons.remove_circle_rounded,
                                    color: _isActive ? Colors.green[600] : Colors.grey[500],
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Company Status',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 13 : 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          _isActive ? 'Active and visible to users' : 'Inactive and hidden from users',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 13,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _isActive,
                                    onChanged: (value) {
                                      setState(() {
                                        _isActive = value;
                                      });
                                    },
                                    activeColor: Colors.green[600],
                                    inactiveTrackColor: Colors.grey[400],
                                    inactiveThumbColor: Colors.grey[50],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      // Actions
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 14 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 15 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: provider.isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 14 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                shadowColor: Colors.blue.withOpacity(0.3),
                              ),
                              child: provider.isLoading
                                  ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isEditing ? Icons.check_rounded : Icons.add_rounded,
                                    size: isSmallScreen ? 18 : 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _isEditing ? 'Update' : 'Create',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 15 : 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required bool isSmallScreen,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
          decoration: InputDecoration(
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
              vertical: maxLines > 1 ? (isSmallScreen ? 12 : 14) : (isSmallScreen ? 0 : 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}