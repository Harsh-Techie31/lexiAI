import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/legal_research_provider.dart';
import '../../models/legal_research_models.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LegalSearchTab extends ConsumerStatefulWidget {
  const LegalSearchTab({super.key});

  @override
  ConsumerState<LegalSearchTab> createState() => _LegalSearchTabState();
}

class _LegalSearchTabState extends ConsumerState<LegalSearchTab> {
  final _queryController = TextEditingController();
  final _courtController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _queryController.dispose();
    _courtController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (_queryController.text.isNotEmpty) {
      await ref.read(legalResearchProvider.notifier).search(_queryController.text);
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
            controller: _queryController,
            decoration: InputDecoration(
              labelText: 'Search Query',
              hintText: 'Enter keywords, citation, or case details',
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
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _courtController,
            decoration: InputDecoration(
              labelText: 'Court',
              hintText: 'Enter court name (optional)',
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
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_fromDate?.toString().split(' ')[0] ?? 'From Date'),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _fromDate = date);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_toDate?.toString().split(' ')[0] ?? 'To Date'),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _toDate = date);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _performSearch,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Search'),
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
                          Text(
                            'Date: ${legalCase.date}',
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
                              'Relevance: ${(legalCase.relevanceScore * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
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
                              MarkdownBody(
                                data: legalCase.summary,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Full Text:',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              MarkdownBody(
                                data: legalCase.fullText,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.copy,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      // Copy citation to clipboard
                                    },
                                    tooltip: 'Copy Citation',
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