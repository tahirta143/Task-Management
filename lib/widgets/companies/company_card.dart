import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/models/company_model.dart';
import 'package:taskflow_app/providers/company_provider.dart';
import 'package:taskflow_app/widgets/companies/add_company_dialog.dart';

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizing
    final bool isSmallPhone = screenWidth < 360;
    final bool isMediumPhone = screenWidth >= 360 && screenWidth < 400;
    final bool isLargePhone = screenWidth >= 400;

    // Calculate responsive values
    final double cardPadding = isSmallPhone ? 12 : 16;
    final double iconSize = isSmallPhone ? 16 : 18;
    final double titleFontSize = isSmallPhone ? 15 : 16;
    final double bodyFontSize = isSmallPhone ? 12 : 13;
    final double smallFontSize = isSmallPhone ? 10 : 11;
    final double detailSpacing = isSmallPhone ? 6 : 8;

    return Container(
      margin: EdgeInsets.all(isSmallPhone ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: company.isActive ? Colors.blue.shade50 : Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Company Icon
                Container(
                  width: isSmallPhone ? 40 : 50,
                  height: isSmallPhone ? 40 : 50,
                  decoration: BoxDecoration(
                    color: company.isActive ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
                  ),
                  child: Icon(
                    Icons.business,
                    color: Colors.white,
                    size: isSmallPhone ? 18 : 22,
                  ),
                ),

                SizedBox(width: isSmallPhone ? 8 : 12),

                // Company Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        company.name,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallPhone ? 2 : 4),
                      Text(
                        company.description,
                        style: TextStyle(
                          fontSize: bodyFontSize - 1,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Menu Button
                _buildPopupMenuButton(context, isSmallPhone),
              ],
            ),
          ),

          // Content Section (Scrollable if needed)
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Contact Details
                    _buildDetailRow(
                      context,
                      Icons.location_on,
                      company.address,
                      isSmallPhone,
                    ),
                    SizedBox(height: detailSpacing),

                    _buildDetailRow(
                      context,
                      Icons.phone,
                      company.phone,
                      isSmallPhone,
                    ),
                    SizedBox(height: detailSpacing),

                    _buildDetailRow(
                      context,
                      Icons.email,
                      company.email,
                      isSmallPhone,
                    ),

                    SizedBox(height: isSmallPhone ? 12 : 16),
                    const Divider(height: 1),
                    SizedBox(height: isSmallPhone ? 12 : 16),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Team Members
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TEAM',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: isSmallPhone ? 2 : 4),
                            Text(
                              '${company.totalUser}',
                              style: TextStyle(
                                fontSize: isSmallPhone ? 16 : 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        // Created Date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'CREATED',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: isSmallPhone ? 2 : 4),
                            Text(
                              DateFormat('MMM dd').format(company.createdAt),
                              style: TextStyle(
                                fontSize: bodyFontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: isSmallPhone ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallPhone ? 10 : 12,
                    vertical: isSmallPhone ? 3 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: company.isActive ? Colors.green.shade50 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: isSmallPhone ? 6 : 8,
                        height: isSmallPhone ? 6 : 8,
                        decoration: BoxDecoration(
                          color: company.isActive ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: isSmallPhone ? 4 : 6),
                      Text(
                        company.isActive ? 'ACTIVE' : 'INACTIVE',
                        style: TextStyle(
                          fontSize: isSmallPhone ? 10 : 11,
                          fontWeight: FontWeight.w600,
                          color: company.isActive ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // View Details Button
                TextButton(
                  onPressed: () {
                    // Navigate to company details
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallPhone ? 12 : 16,
                      vertical: isSmallPhone ? 4 : 6,
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    'VIEW',
                    style: TextStyle(
                      fontSize: isSmallPhone ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text, bool isSmallPhone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: isSmallPhone ? 14 : 16,
          color: Colors.grey.shade500,
        ),
        SizedBox(width: isSmallPhone ? 6 : 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallPhone ? 12 : 13,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenuButton(BuildContext context, bool isSmallPhone) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
        size: isSmallPhone ? 18 : 20,
      ),
      onSelected: (value) async {
        final provider = Provider.of<CompanyProvider>(context, listen: false);

        if (value == 'edit') {
          _showEditDialog(context, company);
        } else if (value == 'toggle') {
          await provider.toggleCompanyStatus(company.id, company.isActive);
        } else if (value == 'delete') {
          await _showDeleteConfirmation(context, company, provider);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: isSmallPhone ? 16 : 18),
              SizedBox(width: 8),
              const Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                company.isActive ? Icons.toggle_off : Icons.toggle_on,
                size: isSmallPhone ? 16 : 18,
                color: company.isActive ? Colors.grey : Colors.green,
              ),
              SizedBox(width: 8),
              Text(company.isActive ? 'Deactivate' : 'Activate'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, Company company) {
    showDialog(
      context: context,
      builder: (context) => AddCompanyDialog(company: company),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context,
      Company company,
      CompanyProvider provider,
      ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Company'),
        content: Text('Are you sure you want to delete ${company.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.deleteCompany(company.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}