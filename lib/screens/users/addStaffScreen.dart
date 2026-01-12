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

    // Initialize available roles based on current user role
    if (authProvider.isAdmin) {
      _availableRoles = ['manager', 'staff'];
      // Admin can see all companies
      await companyProvider.fetchCompanies();
      _companyOptions.clear();
      for (var company in companyProvider.companies) {
        _companyOptions.add({
          'id': company.id,
          'name': company.name,
        });
      }

      // Auto-select first company
      if (_companyOptions.isNotEmpty) {
        _selectedCompanyId = _companyOptions.first['id'];
        _selectedCompanyName = _companyOptions.first['name'];
      }
    } else if (authProvider.isManager) {
      _availableRoles = ['staff'];
      // Manager can only add staff to their own company
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');
      if (userData != null) {
        final user = jsonDecode(userData);
        _selectedCompanyId = user['companyId'];
        // Get company name from provider
        await companyProvider.fetchCompanies();
        final company = companyProvider.companies.firstWhere(
              (c) => c.id == _selectedCompanyId,
          orElse: () => Company(
            id: '',
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
      }
    }

    // Set default role
    _selectedRole = _availableRoles.isNotEmpty ? _availableRoles.first : null;

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

    if (context.read<AuthProvider>().isAdmin && _selectedCompanyId == null) {
      setState(() {
        _error = 'Please select a company';
      });
      return;
    }

    // DEBUG
    print('Creating user with:');
    print('Role: $_selectedRole');
    print('Company ID: $_selectedCompanyId');
    print('Company Name: $_selectedCompanyName');

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

      // Add password only for manager role when created by admin
      if (_selectedRole == 'manager' && context.read<AuthProvider>().isAdmin) {
        if (_passwordController.text.isEmpty) {
          throw Exception('Password is required for manager role');
        }
        requestBody['password'] = _passwordController.text;
      }

      // Add companyID for admin (for both manager and staff)
      if (context.read<AuthProvider>().isAdmin) {
        if (_selectedCompanyId == null || _selectedCompanyId!.isEmpty) {
          throw Exception('Please select a company');
        }
        requestBody['company'] = _selectedCompanyId;
      }
      // Manager doesn't need to send companyID - backend will use their company

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
        setState(() {
          _successMessage = 'User created successfully';
        });
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _numberController.clear();
        if (context.read<AuthProvider>().isAdmin) {
          _selectedCompanyId = null;
          _selectedCompanyName = null;
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      print('Error creating user: $e');
      setState(() {
        _error = e.toString();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New User',
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
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
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

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
              const SizedBox(height: 16),

              // Password Field (only for manager role when admin is creating)
              if (authProvider.isAdmin && _selectedRole == 'manager')
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required for manager';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              if (authProvider.isAdmin && _selectedRole == 'manager')
                const SizedBox(height: 16),

              // Phone Number Field
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Role Selection
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Role',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    hint: const Text('Select Role'),
                    items: _availableRoles.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(
                          role == 'admin' ? 'Admin' :
                          role == 'manager' ? 'Manager' : 'Staff',
                          style: const TextStyle(fontSize: 16),
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
              const SizedBox(height: 16),

              // Company Selection (only for admin)
              if (authProvider.isAdmin)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          items: _companyOptions.map((company) {
                            return DropdownMenuItem<String>(
                              value: company['id'],
                              child: Text(
                                company['name']!,
                                style: const TextStyle(fontSize: 16),
                              ),
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
                    if (_selectedCompanyName != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Selected: $_selectedCompanyName',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              if (authProvider.isAdmin) const SizedBox(height: 16),

              // Manager's Company Info (read-only)
              if (authProvider.isManager)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.business, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Company',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            if (_selectedCompanyName != null)
                              Text(
                                _selectedCompanyName!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            else
                              const Text(
                                'Loading company...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (authProvider.isManager) const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createUser,
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
                    'Create User',
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _numberController.dispose();
    super.dispose();
  }
}