import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/providers/company_provider.dart';
import 'package:taskflow_app/widgets/companies/company_card.dart';
import 'package:taskflow_app/widgets/companies/add_company_dialog.dart';
import 'package:taskflow_app/widgets/common/loading_shimmer.dart';
import 'package:taskflow_app/widgets/common/empty_state.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCompanies();
    });
  }

  void _loadCompanies() {
    final provider = Provider.of<CompanyProvider>(context, listen: false);
    provider.fetchCompanies();
  }

  void _showAddCompanyDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCompanyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive calculations
    final bool isSmallPhone = screenWidth < 360;
    final bool isMediumPhone = screenWidth >= 360 && screenWidth < 400;
    final bool isLargePhone = screenWidth >= 400;
    final bool isTablet = screenWidth >= 600;

    // Calculate grid columns based on screen size
    int crossAxisCount = 1;
    if (isTablet) {
      crossAxisCount = screenWidth >= 900 ? 3 : 2;
    } else if (isLargePhone) {
      crossAxisCount = 1;
    } else {
      crossAxisCount = 1;
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await companyProvider.fetchCompanies();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              elevation: 2,
              backgroundColor: Colors.white,
              title: Text(
                'Companies',
                style: TextStyle(
                  fontSize: isSmallPhone ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.blue,
                    size: isSmallPhone ? 20 : 24,
                  ),
                  onPressed: _loadCompanies,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.blue,
                    size: isSmallPhone ? 20 : 24,
                  ),
                  onPressed: _showAddCompanyDialog,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(isSmallPhone ? 52 : 62), // Increased slightly
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: isSmallPhone ? 12 : 16,
                    right: isSmallPhone ? 12 : 16,
                    top: isSmallPhone ? 4 : 6,
                    bottom: isSmallPhone ? 4 : 6,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: isSmallPhone ? 44 : 48, // Added maxHeight constraint
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search companies...',
                              hintStyle: TextStyle(
                                fontSize: isSmallPhone ? 13 : 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: isSmallPhone ? 18 : 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallPhone ? 12 : 16,
                                vertical: isSmallPhone ? 10 : 12, // Reduced vertical padding
                              ),
                            ),
                            onChanged: (value) {
                              // Implement search
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallPhone ? 8 : 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallPhone ? 10 : 12,
                          vertical: isSmallPhone ? 6 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
                        ),
                        child: Text(
                          '${companyProvider.companyCount}',
                          style: TextStyle(
                            fontSize: isSmallPhone ? 13 : 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Error/Success Messages
            if (companyProvider.error != null || companyProvider.successMessage != null)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallPhone ? 12 : 16,
                    vertical: isSmallPhone ? 6 : 8,
                  ),
                  child: Column(
                    children: [
                      if (companyProvider.error != null)
                        Container(
                          padding: EdgeInsets.all(isSmallPhone ? 10 : 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: isSmallPhone ? 18 : 20,
                              ),
                              SizedBox(width: isSmallPhone ? 8 : 12),
                              Expanded(
                                child: Text(
                                  companyProvider.error!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: isSmallPhone ? 12 : 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: isSmallPhone ? 16 : 18,
                                ),
                                onPressed: () {
                                  companyProvider.clearMessages();
                                },
                              ),
                            ],
                          ),
                        ),
                      if (companyProvider.successMessage != null)
                        Container(
                          padding: EdgeInsets.all(isSmallPhone ? 10 : 12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: isSmallPhone ? 18 : 20,
                              ),
                              SizedBox(width: isSmallPhone ? 8 : 12),
                              Expanded(
                                child: Text(
                                  companyProvider.successMessage!,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: isSmallPhone ? 12 : 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: isSmallPhone ? 16 : 18,
                                ),
                                onPressed: () {
                                  companyProvider.clearMessages();
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            // Loading State
            if (companyProvider.isLoading && companyProvider.companies.isEmpty)
              const SliverToBoxAdapter(
                child: LoadingShimmer(),
              ),

            // Empty State
            if (!companyProvider.isLoading && companyProvider.companies.isEmpty)
              SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.business,
                  title: 'No Companies Found',
                  message: 'Add your first company to get started',
                  actionText: 'Add Company',
                  onAction: _showAddCompanyDialog,
                ),
              ),

            // Companies Grid/List
            if (!companyProvider.isLoading && companyProvider.companies.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.all(isSmallPhone ? 8 : isTablet ? 20 : 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: isSmallPhone ? 8 : isTablet ? 16 : 12,
                    mainAxisSpacing: isSmallPhone ? 8 : isTablet ? 16 : 12,
                    childAspectRatio: _calculateChildAspectRatio(screenWidth, screenHeight),
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final company = companyProvider.companies[index];
                      return CompanyCard(company: company);
                    },
                    childCount: companyProvider.companies.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCompanyDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallPhone ? 14 : 16),
        ),
        child: Icon(
          Icons.add_business,
          size: isSmallPhone ? 22 : 24,
        ),
      ),
    );
  }

  double _calculateChildAspectRatio(double width, double height) {
    if (width >= 600) {
      // Tablet
      return width >= 900 ? 1.5 : 1.6;
    } else if (width >= 400) {
      // Large phone
      return 1.3;
    } else if (width >= 360) {
      // Medium phone
      return 1.2;
    } else {
      // Small phone
      return 1.1;
    }
  }

  void showDeleteCompanyDialog(BuildContext context, String companyId, String companyName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Company'),
          content: Text('Are you sure you want to delete "$companyName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            Consumer<CompanyProvider>(
              builder: (context, provider, _) {
                return TextButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                    final success = await provider.deleteCompany(companyId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Company deleted successfully'
                              : provider.error ?? 'Delete failed',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  child: provider.isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}