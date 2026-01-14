// // screens/add_staff_screen.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/company_provider.dart';
// import '../../models/company_model.dart';
//
// class AddStaffScreen extends StatefulWidget {
//   const AddStaffScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AddStaffScreen> createState() => _AddStaffScreenState();
// }
//
// class _AddStaffScreenState extends State<AddStaffScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _numberController = TextEditingController();
//
//   String? _selectedRole;
//   String? _selectedCompanyId;
//   String? _selectedCompanyName;
//   bool _isLoading = false;
//   String? _error;
//   String? _successMessage;
//
//   List<String> _availableRoles = [];
//   final List<Map<String, String>> _companyOptions = [];
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
//
//     // Initialize available roles based on current user role
//     if (authProvider.isAdmin) {
//       _availableRoles = ['manager', 'staff'];
//       // Admin can see all companies
//       await companyProvider.fetchCompanies();
//       _companyOptions.clear();
//       for (var company in companyProvider.companies) {
//         _companyOptions.add({
//           'id': company.id,
//           'name': company.name,
//         });
//       }
//
//       // Auto-select first company
//       if (_companyOptions.isNotEmpty) {
//         _selectedCompanyId = _companyOptions.first['id'];
//         _selectedCompanyName = _companyOptions.first['name'];
//       }
//     } else if (authProvider.isManager) {
//       _availableRoles = ['staff'];
//       // Manager can only add staff to their own company
//       final prefs = await SharedPreferences.getInstance();
//       final userData = prefs.getString('user');
//       if (userData != null) {
//         final user = jsonDecode(userData);
//         _selectedCompanyId = user['companyId'];
//         // Get company name from provider
//         await companyProvider.fetchCompanies();
//         final company = companyProvider.companies.firstWhere(
//               (c) => c.id == _selectedCompanyId,
//           orElse: () => Company(
//             id: '',
//             name: 'Loading...',
//             description: '',
//             address: '',
//             phone: '',
//             email: '',
//             createdBy: null,
//             isActive: true,
//             totalUser: 0,
//             createdAt: DateTime.now(),
//             updatedAt: DateTime.now(),
//             version: 0,
//           ),
//         );
//         _selectedCompanyName = company.name;
//       }
//     }
//
//     // Set default role
//     _selectedRole = _availableRoles.isNotEmpty ? _availableRoles.first : null;
//
//     setState(() {});
//   }
//
//   Future<void> _createUser() async {
//     if (_formKey.currentState?.validate() != true) return;
//     if (_selectedRole == null) {
//       setState(() {
//         _error = 'Please select a role';
//       });
//       return;
//     }
//
//     if (context.read<AuthProvider>().isAdmin && _selectedCompanyId == null) {
//       setState(() {
//         _error = 'Please select a company';
//       });
//       return;
//     }
//
//     // DEBUG
//     print('Creating user with:');
//     print('Role: $_selectedRole');
//     print('Company ID: $_selectedCompanyId');
//     print('Company Name: $_selectedCompanyName');
//
//     setState(() {
//       _isLoading = true;
//       _error = null;
//       _successMessage = null;
//     });
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//
//       if (token == null) {
//         throw Exception('Authentication token not found');
//       }
//
//       final Map<String, dynamic> requestBody = {
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'number': _numberController.text.trim(),
//         'role': _selectedRole!,
//         'isActive': true,
//       };
//
//       // Add password only for manager role when created by admin
//       if (_selectedRole == 'manager' && context.read<AuthProvider>().isAdmin) {
//         if (_passwordController.text.isEmpty) {
//           throw Exception('Password is required for manager role');
//         }
//         requestBody['password'] = _passwordController.text;
//       }
//
//       // Add companyID for admin (for both manager and staff)
//       if (context.read<AuthProvider>().isAdmin) {
//         if (_selectedCompanyId == null || _selectedCompanyId!.isEmpty) {
//           throw Exception('Please select a company');
//         }
//         requestBody['company'] = _selectedCompanyId;
//       }
//       // Manager doesn't need to send companyID - backend will use their company
//
//       print('Sending request body: $requestBody');
//
//       final response = await http.post(
//         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//
//       if (response.statusCode == 201) {
//         setState(() {
//           _successMessage = 'User created successfully';
//         });
//         // Clear form
//         _nameController.clear();
//         _emailController.clear();
//         _passwordController.clear();
//         _numberController.clear();
//         if (context.read<AuthProvider>().isAdmin) {
//           _selectedCompanyId = null;
//           _selectedCompanyName = null;
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'Failed to create user');
//       }
//     } catch (e) {
//       print('Error creating user: $e');
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
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add New User',
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
//                       IconButton(
//                         icon: const Icon(Icons.close, size: 16),
//                         onPressed: () {
//                           setState(() {
//                             _successMessage = null;
//                           });
//                         },
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
//               // Name Field
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Full Name',
//                   prefixIcon: const Icon(Icons.person_outline),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Email Field
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   prefixIcon: const Icon(Icons.email_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               // Password Field (only for manager role when admin is creating)
//               if (authProvider.isAdmin && _selectedRole == 'manager')
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Password is required for manager';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//               if (authProvider.isAdmin && _selectedRole == 'manager')
//                 const SizedBox(height: 16),
//
//               // Phone Number Field
//               TextFormField(
//                 controller: _numberController,
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   prefixIcon: const Icon(Icons.phone_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
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
//               // Role Selection
//               InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Role',
//                   prefixIcon: const Icon(Icons.badge_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: _selectedRole,
//                     isExpanded: true,
//                     hint: const Text('Select Role'),
//                     items: _availableRoles.map((role) {
//                       return DropdownMenuItem<String>(
//                         value: role,
//                         child: Text(
//                           role == 'admin' ? 'Admin' :
//                           role == 'manager' ? 'Manager' : 'Staff',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedRole = value;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Company Selection (only for admin)
//               if (authProvider.isAdmin)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     InputDecorator(
//                       decoration: InputDecoration(
//                         labelText: 'Company',
//                         prefixIcon: const Icon(Icons.business_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           value: _selectedCompanyId,
//                           isExpanded: true,
//                           hint: const Text('Select Company'),
//                           items: _companyOptions.map((company) {
//                             return DropdownMenuItem<String>(
//                               value: company['id'],
//                               child: Text(
//                                 company['name']!,
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             final selectedCompany = _companyOptions.firstWhere(
//                                   (c) => c['id'] == value,
//                               orElse: () => {'name': 'Unknown'},
//                             );
//                             setState(() {
//                               _selectedCompanyId = value;
//                               _selectedCompanyName = selectedCompany['name'];
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     if (_selectedCompanyName != null)
//                       Container(
//                         margin: const EdgeInsets.only(top: 8),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[50],
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           'Selected: $_selectedCompanyName',
//                           style: TextStyle(
//                             color: Colors.blue[700],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               if (authProvider.isAdmin) const SizedBox(height: 16),
//
//               // Manager's Company Info (read-only)
//               if (authProvider.isManager)
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.business, color: Colors.grey),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Company',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             if (_selectedCompanyName != null)
//                               Text(
//                                 _selectedCompanyName!,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               )
//                             else
//                               const Text(
//                                 'Loading company...',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.orange,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               if (authProvider.isManager) const SizedBox(height: 16),
//
//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _createUser,
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
//                     'Create User',
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
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _numberController.dispose();
//     super.dispose();
//   }
// }



// screens/add_staff_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../providers/company_provider.dart';
import '../../models/company_model.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({Key? key}) : super(key: key);

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  String? _selectedRole;
  String? _selectedCompanyId;
  String? _selectedCompanyName;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  List<String> _availableRoles = [];
  final List<Map<String, String>> _companyOptions = [];

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

    print('=== Initializing AddStaffScreen ===');
    print('Current user role: ${authProvider.role}');
    print('Is Admin: ${authProvider.isAdmin}');
    print('Is Manager: ${authProvider.isManager}');
    print('User ID: ${authProvider.userId}');
    print('Company ID: ${authProvider.companyId}');

    // Initialize available roles based on current user role
    if (authProvider.isAdmin) {
      _availableRoles = ['manager', 'staff'];
      print('Admin detected - loading all companies');

      // Admin can see all companies
      await companyProvider.fetchCompanies();
      _companyOptions.clear();
      for (var company in companyProvider.companies) {
        _companyOptions.add({
          'id': company.id,
          'name': company.name,
        });
      }
      print('Loaded ${_companyOptions.length} companies');

      // Auto-select first company if available
      if (_companyOptions.isNotEmpty) {
        _selectedCompanyId = _companyOptions.first['id'];
        _selectedCompanyName = _companyOptions.first['name'];
        print('Auto-selected company: $_selectedCompanyName');
      }
    } else if (authProvider.isManager) {
      _availableRoles = ['staff'];
      print('Manager detected - using their company ID: ${authProvider.companyId}');

      // Manager can only add staff to their own company
      _selectedCompanyId = authProvider.companyId;

      if (_selectedCompanyId != null) {
        // Get company name from provider
        await companyProvider.fetchCompanies();
        final company = companyProvider.companies.firstWhere(
              (c) => c.id == _selectedCompanyId,
          orElse: () => Company(
            id: _selectedCompanyId!,
            name: 'Loading...',
            description: '',
            address: '',
            phone: '',
            email: '',
            createdBy: null,
            isActive: true,
            totalUser: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            version: 0,
          ),
        );
        _selectedCompanyName = company.name;
        print('Manager company name: $_selectedCompanyName');
      } else {
        print('ERROR: Manager company ID is null!');
        _error = 'Unable to determine your company. Please contact administrator.';
      }
    } else {
      print('ERROR: User is neither admin nor manager! Role: ${authProvider.role}');
      _error = 'You do not have permission to add users.';
    }

    // Set default role
    if (_availableRoles.isNotEmpty) {
      _selectedRole = _availableRoles.first;
      print('Default role set to: $_selectedRole');
    }

    setState(() {});
  }

  Future<void> _createUser() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedRole == null) {
      setState(() {
        _error = 'Please select a role';
      });
      return;
    }

    final authProvider = context.read<AuthProvider>();

    // Validate company selection for admin
    if (authProvider.isAdmin && (_selectedCompanyId == null || _selectedCompanyId!.isEmpty)) {
      setState(() {
        _error = 'Please select a company';
      });
      return;
    }

    // Validate company for manager
    if (authProvider.isManager && (_selectedCompanyId == null || _selectedCompanyId!.isEmpty)) {
      setState(() {
        _error = 'Unable to determine your company. Please contact administrator.';
      });
      return;
    }

    print('=== Creating User ===');
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print('Role: $_selectedRole');
    print('Company ID: $_selectedCompanyId');
    print('Company Name: $_selectedCompanyName');
    print('User is Admin: ${authProvider.isAdmin}');
    print('User is Manager: ${authProvider.isManager}');

    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final Map<String, dynamic> requestBody = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'number': _numberController.text.trim(),
        'role': _selectedRole!,
        'isActive': true,
      };

      // For Admin: Add password for manager role, company ID for all roles
      if (authProvider.isAdmin) {
        // Add password only for manager role
        if (_selectedRole == 'manager') {
          if (_passwordController.text.isEmpty) {
            throw Exception('Password is required for manager role');
          }
          requestBody['password'] = _passwordController.text;
        }

        // Admin must specify company ID
        requestBody['company'] = _selectedCompanyId;
      }
      // For Manager: No password needed, company ID is automatically their own
      else if (authProvider.isManager) {
        // Manager doesn't need to send companyID - backend will use their company
        // Just ensure _selectedCompanyId is not null (it should be their company ID)
        if (_selectedCompanyId == null) {
          throw Exception('Unable to determine company for manager');
        }
        // Note: Backend should automatically use manager's company
        // requestBody['company'] = _selectedCompanyId; // Uncomment if backend requires it
      }

      print('Sending request body: $requestBody');

      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _successMessage = 'User created successfully!';
        });

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _numberController.clear();

        // Reset company selection for admin only
        if (authProvider.isAdmin) {
          if (_companyOptions.isNotEmpty) {
            _selectedCompanyId = _companyOptions.first['id'];
            _selectedCompanyName = _companyOptions.first['name'];
          }
        }

        // Reset role to default
        if (_availableRoles.isNotEmpty) {
          _selectedRole = _availableRoles.first;
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create user. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating user: $e');
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New User',
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.green[600], size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _successMessage!,
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.w500,
                              fontSize: isSmallScreen ? 13 : 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, size: 18),
                          color: Colors.green[600],
                          onPressed: () {
                            setState(() {
                              _successMessage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                // Error Message
                if (_error != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded, color: Colors.red[600], size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.w500,
                              fontSize: isSmallScreen ? 13 : 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, size: 18),
                          color: Colors.red[600],
                          onPressed: () {
                            setState(() {
                              _error = null;
                            });
                          },
                        ),
                      ],
                    ),
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
                      // Name Field
                      Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 14 : 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                        decoration: InputDecoration(
                          hintText: 'Enter full name',
                          prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isSmallScreen ? 12 : 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Email Field
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 14 : 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter email address',
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isSmallScreen ? 12 : 14,
                          ),
                        ),
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
                      SizedBox(height: 16),

                      // Password Field (only for admin creating manager)
                      if (authProvider.isAdmin && _selectedRole == 'manager')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontSize: isSmallScreen ? 14 : 15,
                              ),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter password for manager',
                                prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey[500]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isSmallScreen ? 12 : 14,
                                ),
                              ),
                              validator: (value) {
                                if (authProvider.isAdmin && _selectedRole == 'manager') {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required for manager';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                          ],
                        ),

                      // Phone Number Field
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 14 : 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        controller: _numberController,
                        style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isSmallScreen ? 12 : 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Role Selection
                      Text(
                        'Role',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 14 : 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRole,
                            isExpanded: true,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600]),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 15 : 16,
                              color: Colors.grey[800],
                            ),
                            items: _availableRoles.map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(
                                  role == 'admin' ? 'Admin' :
                                  role == 'manager' ? 'Manager' : 'Staff',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Company Selection (only for admin)
                      if (authProvider.isAdmin)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontSize: isSmallScreen ? 14 : 15,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCompanyId,
                                  isExpanded: true,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600]),
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 15 : 16,
                                    color: Colors.grey[800],
                                  ),
                                  hint: Text('Select Company'),
                                  items: _companyOptions.map((company) {
                                    return DropdownMenuItem<String>(
                                      value: company['id'],
                                      child: Text(company['name']!),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    final selectedCompany = _companyOptions.firstWhere(
                                          (c) => c['id'] == value,
                                      orElse: () => {'name': 'Unknown'},
                                    );
                                    setState(() {
                                      _selectedCompanyId = value;
                                      _selectedCompanyName = selectedCompany['name'];
                                    });
                                  },
                                ),
                              ),
                            ),
                            if (_selectedCompanyName != null) ...[
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[100]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.business_rounded, color: Colors.blue[600], size: 18),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Selected: $_selectedCompanyName',
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.w500,
                                          fontSize: isSmallScreen ? 13 : 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: 16),
                          ],
                        ),

                      // Manager's Company Info (read-only - hidden dropdown)
                      if (authProvider.isManager && _selectedCompanyName != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontSize: isSmallScreen ? 14 : 15,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.business_rounded, color: Colors.grey[600], size: 20),
                                  SizedBox(width: 12),
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
                                        SizedBox(height: 2),
                                        Text(
                                          _selectedCompanyName!,
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
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Note: Staff will be added to your company automatically.',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 13,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: isSmallScreen ? 14 : 16,
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
                              : Text(
                            'Create User',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _numberController.dispose();
    super.dispose();
  }
}