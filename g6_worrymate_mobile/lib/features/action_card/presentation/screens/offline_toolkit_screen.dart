import 'package:flutter/material.dart';

class OfflineToolkitScreen extends StatelessWidget {
  const OfflineToolkitScreen({super.key});

  Widget _buildToolCard({
    required Color color,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: color.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Open',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offline Toolkit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Wellness tools that work without internet',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Works Offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToolCard(
              color: const Color(0xFF007AFF),
              icon: Icons.favorite_border,
              title: 'Box Breathing',
              description: '4-4-4-4 breathing pattern to calm your mind',
              onTap: () {
                // TODO: Navigate to Box Breathing screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Box Breathing - Coming Soon!')),
                );
              },
            ),
            _buildToolCard(
              color: const Color(0xFF34C759),
              icon: Icons.camera_alt_outlined,
              title: '5-4-3-2-1 Grounding',
              description: 'Focus on your senses to stay present',
              onTap: () {
                // TODO: Navigate to 5-4-3-2-1 Grounding screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('5-4-3-2-1 Grounding - Coming Soon!')),
                );
              },
            ),
            _buildToolCard(
              color: const Color(0xFFAF52DE),
              icon: Icons.book_outlined,
              title: 'Daily Journal',
              description: 'Reflect on your thoughts and feelings',
              onTap: () {
                // TODO: Navigate to Daily Journal screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Daily Journal - Coming Soon!')),
                );
              },
            ),
            _buildToolCard(
              color: const Color(0xFFFF9500),
              icon: Icons.trending_up,
              title: 'Win Tracker',
              description: 'Celebrate small victories and progress',
              onTap: () {
                // TODO: Navigate to Win Tracker screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Win Tracker - Coming Soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
