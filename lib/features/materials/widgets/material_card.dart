import 'package:flutter/material.dart';

class MaterialCard extends StatelessWidget {
  final String title;
  final String type;
  final VoidCallback onTap;

  const MaterialCard({
    super.key,
    required this.title,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getIconForType(type),
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'PDFs and Documents':
        return Icons.picture_as_pdf;
      case 'Video Tutorials':
        return Icons.play_circle;
      case 'Practice Materials':
        return Icons.assignment;
      case 'Study Guides':
        return Icons.book;
      default:
        return Icons.article;
    }
  }
} 