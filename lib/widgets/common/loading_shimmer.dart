import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallPhone = screenWidth < 360;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
        child: Column(
          children: List.generate(3, (index) => _buildShimmerCard(isSmallPhone)),
        ),
      ),
    );
  }

  Widget _buildShimmerCard(bool isSmallPhone) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallPhone ? 12 : 16),
      padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 12 : 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallPhone ? 40 : 50,
                height: isSmallPhone ? 40 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isSmallPhone ? 8 : 12),
                ),
              ),
              SizedBox(width: isSmallPhone ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: isSmallPhone ? 16 : 20,
                      color: Colors.white,
                    ),
                    SizedBox(height: isSmallPhone ? 6 : 8),
                    Container(
                      width: 100,
                      height: isSmallPhone ? 12 : 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallPhone ? 12 : 16),
          Container(
            width: double.infinity,
            height: isSmallPhone ? 12 : 16,
            color: Colors.white,
          ),
          SizedBox(height: isSmallPhone ? 6 : 8),
          Container(
            width: 150,
            height: isSmallPhone ? 12 : 16,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}