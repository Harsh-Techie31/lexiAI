import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/case_prediction_provider.dart';
import '../widgets/case_prediction_form.dart';
import '../widgets/prediction_result_card.dart';

class CasePredictionPage extends StatelessWidget {
  const CasePredictionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Case Prediction'),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
      ),
      body: Consumer<CasePredictionProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.balance,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'AI-Powered Case Prediction',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your case details below and our AI will analyze the potential outcome.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const CasePredictionForm(),
                const SizedBox(height: 24),
                if (provider.isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  )
                else if (provider.error != null)
                  Card(
                    color: isDark 
                        ? Color.alphaBlend(Colors.red.withOpacity(0.1), const Color(0xFF1E1E1E))
                        : Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.error,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: provider.reset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (provider.result != null)
                  PredictionResultCard(result: provider.result!),
              ],
            ),
          );
        },
      ),
    );
  }
} 