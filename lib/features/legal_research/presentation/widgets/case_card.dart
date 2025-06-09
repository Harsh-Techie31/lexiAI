import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/legal_research_models.dart';

class CaseCard extends StatelessWidget {
  final LegalCase legalCase;

  const CaseCard({
    super.key,
    required this.legalCase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    legalCase.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: legalCase.citation));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Citation copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: 'Copy Citation',
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Implement sharing functionality
                  },
                  tooltip: 'Share Case',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              legalCase.citation,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${legalCase.court} • ${legalCase.date}',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              legalCase.summary,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[800],
                height: 1.5,
              ),
            ),
            if (legalCase.relatedSections.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: legalCase.relatedSections.map((section) {
                  return Chip(
                    label: Text(
                      section,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.black87 : Colors.white,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Relevance: ',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getRelevanceColor(legalCase.relevanceScore),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(legalCase.relevanceScore * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRelevanceColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.orange;
    return Colors.red;
  }
} 