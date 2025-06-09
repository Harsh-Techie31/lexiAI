import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/legal_research_provider.dart';
import '../../models/legal_research_models.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SimilarCasesTab extends ConsumerStatefulWidget {
  const SimilarCasesTab({super.key});

  @override
  ConsumerState<SimilarCasesTab> createState() => _SimilarCasesTabState();
}

class _SimilarCasesTabState extends ConsumerState<SimilarCasesTab> {
  final _factsController = TextEditingController();

  @override
  void dispose() {
    _factsController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final facts = _factsController.text.trim();
    if (facts.isNotEmpty) {
      await ref.read(legalResearchProvider.notifier).search(facts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(legalResearchProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _factsController,
            maxLines: 3,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              labelText: 'Case Facts',
              hintText: 'Enter case facts to find similar judgments',
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              alignLabelWithHint: true,
              labelStyle: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                onPressed: state.isLoading ? null : _performSearch,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (state.error != null)
            Center(
              child: Column(
                children: [
                  Text(
                    state.error!,
                    style: TextStyle(
                      color: isDark ? Colors.red[300] : Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _performSearch,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (state.searchResult?.cases.isNotEmpty ?? false)
            Expanded(
              child: ListView.builder(
                itemCount: state.searchResult!.cases.length,
                itemBuilder: (context, index) {
                  final legalCase = state.searchResult!.cases[index];
                  return Card(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        legalCase.title,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            legalCase.court,
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
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
                              'Relevance: ${(legalCase.relevanceScore * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${legalCase.date}',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Summary:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8, bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                  ),
                                ),
                                child: MarkdownBody(
                                  data: legalCase.summary,
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Full Text:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8, bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                  ),
                                ),
                                child: MarkdownBody(
                                  data: legalCase.fullText,
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.copy,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                        text: 'Case: ${legalCase.title}\nCourt: ${legalCase.court}\nSummary: ${legalCase.summary}',
                                      ));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Case details copied to clipboard'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    tooltip: 'Copy Case Details',
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      Share.share(
                                        'Case: ${legalCase.title}\nCourt: ${legalCase.court}\nSummary: ${legalCase.summary}',
                                      );
                                    },
                                    tooltip: 'Share Case',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            Center(
              child: Text(
                'No similar cases found. Try different case facts.',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getRelevanceColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.orange;
    return Colors.red;
  }
} 