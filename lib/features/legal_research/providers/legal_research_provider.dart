import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/legal_research_models.dart';
import '../data/sample_data.dart';

class LegalResearchState {
  final bool isLoading;
  final String? error;
  final SearchResult? searchResult;
  final List<LegalCase> recentCases;
  final List<LegalSection> popularSections;
  final String activeTab;

  const LegalResearchState({
    this.isLoading = false,
    this.error,
    this.searchResult,
    this.recentCases = const [],
    this.popularSections = const [],
    this.activeTab = 'Related Laws',
  });

  LegalResearchState copyWith({
    bool? isLoading,
    String? error,
    SearchResult? searchResult,
    List<LegalCase>? recentCases,
    List<LegalSection>? popularSections,
    String? activeTab,
  }) {
    return LegalResearchState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchResult: searchResult ?? this.searchResult,
      recentCases: recentCases ?? this.recentCases,
      popularSections: popularSections ?? this.popularSections,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

final legalResearchProvider =
    StateNotifierProvider<LegalResearchNotifier, LegalResearchState>((ref) {
  return LegalResearchNotifier();
});

class LegalResearchNotifier extends StateNotifier<LegalResearchState> {
  LegalResearchNotifier()
      : super(LegalResearchState(
          recentCases: SampleLegalData.sampleCases,
          popularSections: SampleLegalData.sampleSections,
        ));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        error: 'Please enter a search term',
        isLoading: false,
      );
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Use sample data for now
      final results = SampleLegalData.getSearchResults(query);
      
      state = state.copyWith(
        searchResult: results,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'An error occurred while searching. Please try again.',
        isLoading: false,
      );
    }
  }

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void reset() {
    state = state.copyWith(
      searchResult: null,
      error: null,
      isLoading: false,
    );
  }
} 