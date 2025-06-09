import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/legal_research_provider.dart';
import '../widgets/case_card.dart';
import '../widgets/section_card.dart';
import '../widgets/search_bar.dart';

class LegalResearchPage extends ConsumerWidget {
  const LegalResearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(legalResearchProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
        appBar: AppBar(
          title: const Text('Legal Research'),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0,
          bottom: TabBar(
            onTap: (index) {
              ref.read(legalResearchProvider.notifier).setActiveTab(
                    ['Related Laws', 'Similar Cases', 'Search'][index],
                  );
            },
            tabs: const [
              Tab(text: 'Related Laws'),
              Tab(text: 'Similar Cases'),
              Tab(text: 'Search'),
            ],
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[700],
            indicatorColor: theme.colorScheme.primary,
          ),
        ),
        body: Column(
          children: [
            if (state.activeTab == 'Search')
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LegalSearchBar(
                  onSearch: (query) {
                    ref.read(legalResearchProvider.notifier).search(query);
                  },
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  // Related Laws Tab
                  _buildLawsTab(state, isDark),
                  
                  // Similar Cases Tab
                  _buildCasesTab(state, isDark),
                  
                  // Search Tab
                  _buildSearchTab(state, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLawsTab(LegalResearchState state, bool isDark) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.popularSections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SectionCard(section: state.popularSections[index]),
        );
      },
    );
  }

  Widget _buildCasesTab(LegalResearchState state, bool isDark) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.recentCases.length,
      itemBuilder: (context, index) {
        final legalCase = state.recentCases[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CaseCard(legalCase: legalCase),
        );
      },
    );
  }

  Widget _buildSearchTab(LegalResearchState state, bool isDark) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: TextStyle(
            color: isDark ? Colors.red[300] : Colors.red[700],
          ),
        ),
      );
    }

    if (state.searchResult == null) {
      return Center(
        child: Text(
          'Enter your search query above',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.searchResult!.cases.isNotEmpty) ...[
          Text(
            'Relevant Cases',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...state.searchResult!.cases.map((legalCase) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CaseCard(legalCase: legalCase),
              )),
        ],
        if (state.searchResult!.sections.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Related Laws',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...state.searchResult!.sections.map((section) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SectionCard(section: section),
              )),
        ],
      ],
    );
  }
} 