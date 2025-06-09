import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/legal_research_provider.dart';
import '../../models/legal_research_models.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';

class RelatedLawsTab extends ConsumerStatefulWidget {
  const RelatedLawsTab({super.key});

  @override
  ConsumerState<RelatedLawsTab> createState() => _RelatedLawsTabState();
}

class _RelatedLawsTabState extends ConsumerState<RelatedLawsTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(legalResearchProvider.notifier).search(query);
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
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Case Type',
              hintText: 'Enter case type to find relevant laws',
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
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                onPressed: _performSearch,
              ),
            ),
            onSubmitted: (_) => _performSearch(),
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
          else if (state.searchResult?.sections.isNotEmpty ?? false)
            Expanded(
              child: ListView.builder(
                itemCount: state.searchResult!.sections.length,
                itemBuilder: (context, index) {
                  final section = state.searchResult!.sections[index];
                  return Card(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        '${section.actName} - Section ${section.sectionNumber}',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        section.description,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                  ),
                                ),
                                child: MarkdownBody(
                                  data: section.content,
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                                      height: 1.5,
                                    ),
                                    strong: TextStyle(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (section.relatedCases.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text(
                                  'Related Cases:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: section.relatedCases.map((caseTitle) {
                                    return Chip(
                                      label: Text(
                                        caseTitle,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? Colors.black87 : Colors.white,
                                        ),
                                      ),
                                      backgroundColor: theme.colorScheme.secondary.withOpacity(0.8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    );
                                  }).toList(),
                                ),
                              ],
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
                                      Clipboard.setData(ClipboardData(
                                        text: '${section.actName} - Section ${section.sectionNumber}\n\n${section.content}',
                                      ));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Section copied to clipboard'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    tooltip: 'Copy Section',
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      Share.share(
                                        '${section.actName} - Section ${section.sectionNumber}\n\n${section.content}',
                                      );
                                    },
                                    tooltip: 'Share Section',
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
                'No relevant laws found. Try a different search term.',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }
} 