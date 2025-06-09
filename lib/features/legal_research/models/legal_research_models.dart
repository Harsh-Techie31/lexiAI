import 'package:flutter/foundation.dart';

@immutable
class LegalCase {
  final String title;
  final String citation;
  final String summary;
  final String court;
  final String date;
  final String fullText;
  final List<String> relatedSections;
  final double relevanceScore;

  const LegalCase({
    required this.title,
    required this.citation,
    required this.summary,
    required this.court,
    required this.date,
    required this.fullText,
    required this.relatedSections,
    required this.relevanceScore,
  });
}

@immutable
class LegalSection {
  final String title;
  final String actName;
  final String sectionNumber;
  final String content;
  final String description;
  final List<String> relatedCases;

  const LegalSection({
    required this.title,
    required this.actName,
    required this.sectionNumber,
    required this.content,
    required this.description,
    required this.relatedCases,
  });
}

@immutable
class SearchResult {
  final List<LegalCase> cases;
  final List<LegalSection> sections;
  final String searchTerm;
  final int totalResults;

  const SearchResult({
    required this.cases,
    required this.sections,
    required this.searchTerm,
    required this.totalResults,
  });
} 