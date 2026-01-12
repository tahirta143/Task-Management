// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:taskflow_app/models/user_model.dart';
// import 'package:taskflow_app/providers/user_provider.dart';
//
// class AddUserDialog extends StatefulWidget {
//   final User? user;
//
//   const AddUserDialog({super.key, this.user});
//
//   @override
//   State<AddUserDialog> createState() => _AddUserDialogState();
// }
//
// class _AddUserDialogState extends State<AddUserDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _phoneController = TextEditingController();
//
//   String _selectedRole = 'staff';
//   String? _selectedCompanyId;
//   bool _isActive = true;
//   bool _isEditing = false;
//   bool _showPassword = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isEditing = widget.user != null;
//
//     if (_isEditing && widget.user != null) {
//       _nameController.text = widget.user!.name;
//       _emailController.text = widget.user!.email;
//       _phoneController.text = widget.user!.number?.toString() ?? '';
//       _selectedRole = widget.user!.role;
//       _selectedCompanyId = widget.user!.company?.id;
//       _isActive = widget.user!.isActive;
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final provider = Provider.of<UserProvider>(context, listen: false);
//
//       if (_isEditing && widget.user != null) {
//         final success = await provider.updateUser(
//           id: widget.user!.id,
//           name: _nameController.text.trim(),
//           email: _emailController.text.trim(),
//           role: _selectedRole,
//           companyId: _selectedRole == 'admin' ? null : _selectedCompanyId,
//           number: _phoneController.text.isNotEmpty ? int.tryParse(_phoneController.text) : null,
//           isActive: _isActive,
//         );
//
//         if (success) {
//           Navigator.pop(context);
//         }
//       } else {
//         final success = await provider.createUser(
//           name: _nameController.text.trim(),
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//           role: _selectedRole,
//           companyId: _selectedRole == 'admin' ? null : _selectedCompanyId,
//           number: _phoneController.text.isNotEmpty ? int.tryParse(_phoneController.text) : null,
//           isActive: _isActive,
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
//     final userProvider = Provider.of<UserProvider>(context);
//     final screenWidth = MediaQuery.of(context).size.width;
//     final bool isSmallPhone = screenWidth < 360;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(isSmallPhone ? 12 : 16),
//       ),
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallPhone ? 16 : 24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title
//               Text(
//                 _isEditing ? 'Edit User' : 'Add New User',
//                 style: TextStyle(
//                   fontSize: isSmallPhone ? 18 : 20,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: isSmallPhone ? 4 : 8),
//               Text(
//                 _isEditing ? 'Update user information' : 'Enter user details',
//                 style: TextStyle(
//                   fontSize: isSmallPhone ? 12 : 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               SizedBox(height: isSmallPhone ? 16 : 24),
//
//               // Name
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Full Name',
//                   prefixIcon: const Icon(Icons.person),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: isSmallPhone ? 12 : 16),
//
//               // Email
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   prefixIcon: const Icon(Icons.email),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                   ),
//                 ),
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
//               SizedBox(height: isSmallPhone ? 12 : 16),
//
//               // Password (only for new users)
//               if (!_isEditing)
//                 Column(
//                   children: [
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: !_showPassword,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         prefixIcon: const Icon(Icons.lock),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _showPassword ? Icons.visibility : Icons.visibility_off,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _showPassword = !_showPassword;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: isSmallPhone ? 12 : 16),
//                   ],
//                 ),
//
//               // Phone
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number (Optional)',
//                   prefixIcon: const Icon(Icons.phone),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                   ),
//                 ),
//               ),
//               SizedBox(height: isSmallPhone ? 12 : 16),
//
//               // Role Dropdown
//               DropdownButtonFormField2<String>(
//                 value: _selectedRole,
//                 decoration: InputDecoration(
//                   labelText: 'Role',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                 ),
//                 isExpanded: true,
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'admin',
//                     child: Text('Admin'),
//                   ),
//                   DropdownMenuItem(
//                     value: 'manager',
//                     child: Text('Manager'),
//                   ),
//                   DropdownMenuItem(
//                     value: 'staff',
//                     child: Text('Staff'),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedRole = value!;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select role';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: isSmallPhone ? 12 : 16),
//
//               // Company Dropdown (only for staff and manager)
//               if (_selectedRole != 'admin')
//                 DropdownButtonFormField2<String>(
//                   value: _selectedCompanyId,
//                   decoration: InputDecoration(
//                     labelText: 'Company',
//                     hintText: 'Select company',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                   ),
//                   isExpanded: true,
//                   items: userProvider.companies.map((company) {
//                     return DropdownMenuItem(
//                       value: company.id,
//                       child: Text(company.name),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCompanyId = value;
//                     });
//                   },
//                   validator: _selectedRole != 'admin'
//                       ? (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select company';
//                     }
//                     return null;
//                   }
//                       : null,
//                 ),
//
//               // Active Toggle
//               SizedBox(height: isSmallPhone ? 12 : 16),
//               Row(
//                 children: [
//                   const Text(
//                     'Status:',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(width: isSmallPhone ? 8 : 12),
//                   Switch(
//                     value: _isActive,
//                     onChanged: (value) {
//                       setState(() {
//                         _isActive = value;
//                       });
//                     },
//                     activeColor: Colors.green,
//                   ),
//                   Text(
//                     _isActive ? 'Active' : 'Inactive',
//                     style: TextStyle(
//                       color: _isActive ? Colors.green : Colors.grey,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//
//               // Buttons
//               SizedBox(height: isSmallPhone ? 20 : 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallPhone ? 12 : 14,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                         ),
//                       ),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   SizedBox(width: isSmallPhone ? 12 : 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: userProvider.isLoading ? null : _submitForm,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallPhone ? 12 : 14,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
//                         ),
//                       ),
//                       child: userProvider.isLoading
//                           ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                           : Text(_isEditing ? 'Update' : 'Create'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }