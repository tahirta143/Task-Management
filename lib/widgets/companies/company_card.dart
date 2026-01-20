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
    final Color primaryColor = const Color(0xFF8B5CF6);
    final Color secondaryColor = const Color(0xFF7E57C2);

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
            color: primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  company.isActive ? primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                  company.isActive ? primaryColor.withOpacity(0.05) : Colors.grey.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                    gradient: LinearGradient(
                      colors: company.isActive
                          ? [primaryColor, secondaryColor]
                          : [Colors.grey.shade500, Colors.grey.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
                    boxShadow: [
                      BoxShadow(
                        color: company.isActive
                            ? primaryColor.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                _buildPopupMenuButton(context, isSmallPhone, primaryColor),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Contact Details with colored icons
                    _buildDetailRow(
                      context,
                      Icons.location_on_outlined,
                      company.address,
                      isSmallPhone,
                      primaryColor,
                    ),
                    SizedBox(height: detailSpacing),

                    _buildDetailRow(
                      context,
                      Icons.phone_outlined,
                      company.phone,
                      isSmallPhone,
                      primaryColor,
                    ),
                    SizedBox(height: detailSpacing),

                    _buildDetailRow(
                      context,
                      Icons.email_outlined,
                      company.email,
                      isSmallPhone,
                      primaryColor,
                    ),

                    // SizedBox(height: isSmallPhone ? 12 : 16),
                    // Divider(
                    //   height: 1,
                    //   color: Colors.grey.shade200,
                    // ),
                    // SizedBox(height: isSmallPhone ? 12 : 16),

                    // Stats Row
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                        // Team Members with purple accent
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: isSmallPhone ? 12 : 16,
                        //     vertical: isSmallPhone ? 6 : 8,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: primaryColor.withOpacity(0.08),
                        //     borderRadius: BorderRadius.circular(12),
                        //     border: Border.all(
                        //       color: primaryColor.withOpacity(0.2),
                        //       width: 1,
                        //     ),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'TEAM',
                        //         style: TextStyle(
                        //           fontSize: smallFontSize,
                        //           color: primaryColor,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       SizedBox(height: isSmallPhone ? 2 : 4),
                        //       Text(
                        //         '${company.totalUser}',
                        //         style: TextStyle(
                        //           fontSize: isSmallPhone ? 18 : 22,
                        //           fontWeight: FontWeight.w800,
                        //           color: primaryColor,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // Created Date with subtle styling
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: isSmallPhone ? 12 : 16,
                        //     vertical: isSmallPhone ? 6 : 8,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey.shade50,
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'CREATED',
                        //         style: TextStyle(
                        //           fontSize: smallFontSize,
                        //           color: Colors.grey.shade600,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       SizedBox(height: isSmallPhone ? 2 : 4),
                        //       Text(
                        //         DateFormat('MMM dd, yyyy').format(company.createdAt),
                        //         style: TextStyle(
                        //           fontSize: bodyFontSize,
                        //           fontWeight: FontWeight.w600,
                        //           color: Colors.grey.shade800,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // Footer Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: isSmallPhone ? 20 : 22,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Badge with gradient
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallPhone ? 12 : 16,
                    vertical: isSmallPhone ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: company.isActive
                          ? [Colors.green.shade100, Colors.green.shade50]
                          : [Colors.grey.shade200, Colors.grey.shade100],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: company.isActive
                          ? Colors.green.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: isSmallPhone ? 6 : 8,
                        height: isSmallPhone ? 6 : 8,
                        decoration: BoxDecoration(
                          color: company.isActive ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: company.isActive
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isSmallPhone ? 6 : 8),
                      Text(
                        company.isActive ? 'ACTIVE' : 'INACTIVE',
                        style: TextStyle(
                          fontSize: isSmallPhone ? 10 : 11,
                          fontWeight: FontWeight.w600,
                          color: company.isActive ? Colors.green.shade700 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit button for quick access
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  // child: IconButton(
                  //   onPressed: () => _showEditDialog(context, company),
                  //   icon: Icon(
                  //     Icons.edit_outlined,
                  //     size: isSmallPhone ? 16 : 18,
                  //     color: primaryColor,
                  //   ),
                  //   padding: EdgeInsets.all(isSmallPhone ? 4 : 6),
                  //   constraints: const BoxConstraints(),
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text, bool isSmallPhone, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isSmallPhone ? 24 : 28,
          height: isSmallPhone ? 24 : 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isSmallPhone ? 14 : 16,
            color: color,
          ),
        ),
        SizedBox(width: isSmallPhone ? 8 : 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallPhone ? 12 : 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenuButton(BuildContext context, bool isSmallPhone, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert_rounded,
          color: primaryColor,
          size: isSmallPhone ? 20 : 22,
        ),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
                Icon(Icons.edit_outlined, size: isSmallPhone ? 18 : 20, color: primaryColor),
                SizedBox(width: 10),
                Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'toggle',
            child: Row(
              children: [
                Icon(
                  company.isActive ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
                  size: isSmallPhone ? 18 : 20,
                  color: company.isActive ? Colors.grey : Colors.green,
                ),
                SizedBox(width: 10),
                Text(
                  company.isActive ? 'Deactivate' : 'Activate',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(height: 8),
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: isSmallPhone ? 18 : 20, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 32,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Company',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${company.name}"?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await provider.deleteCompany(company.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}