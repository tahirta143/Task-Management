import 'package:flutter/material.dart';

class TeamOverview extends StatelessWidget {
  const TeamOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.group, color: Colors.purple),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildTeamMember('Ali Gates', 'Developer', 85),
              _buildTeamMember('Burz', 'Manager', 92),
              _buildTeamMember('Eky', 'Designer', 78),
              _buildTeamMember('Ali Sohail', 'Developer', 65),
              _buildTeamMember('John Doe', 'Tester', 88),
              _buildTeamMember('Jane Smith', 'Analyst', 71),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, int productivity) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: productivity / 100,
                backgroundColor: Colors.grey.shade200,
                color: _getProductivityColor(productivity),
                strokeWidth: 4,
              ),
            ),
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blue.shade50,
              child: Text(
                name.split(' ').map((e) => e[0]).join(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          role,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getProductivityColor(int productivity) {
    if (productivity >= 80) return Colors.green;
    if (productivity >= 60) return Colors.orange;
    return Colors.red;
  }
}