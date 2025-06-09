import 'package:flutter/material.dart';
import '../../providers/case_prediction_provider.dart';

class PredictionResultCard extends StatelessWidget {
  final CasePredictionResult result;

  const PredictionResultCard({
    super.key,
    required this.result,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 32,
                  color: Colors.blue[400],
                ),
                const SizedBox(width: 8),
                Text(
                  'Prediction Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildResultSection(
              context,
              'Prediction',
              result.prediction,
              Icons.gavel,
              result.prediction.contains('LOSES') ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 16),
            _buildResultSection(
              context,
              'Confidence',
              result.confidence,
              Icons.analytics,
              Colors.blue[400]!,
            ),
            const SizedBox(height: 16),
            _buildResultSection(
              context,
              'Legal Suggestions',
              result.legalSuggestions,
              Icons.lightbulb_outline,
              Colors.orange[400]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(BuildContext context, String title, String content, IconData icon, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: accentColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
} 