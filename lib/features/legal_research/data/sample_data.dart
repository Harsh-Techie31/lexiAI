import '../models/legal_research_models.dart';

class SampleLegalData {
  static final List<LegalCase> sampleCases = [
    LegalCase(
      title: 'State of Maharashtra vs. Vijay Kumar',
      citation: '(2023) 5 SCC 123',
      summary: 'Landmark case discussing the interpretation of Section 302 IPC in cases of circumstantial evidence.',
      court: 'Supreme Court of India',
      date: '2023-03-15',
      fullText: '''
The Supreme Court held that in cases of circumstantial evidence, the prosecution must establish a complete chain of events leading to the crime. The court emphasized that each circumstance must be proved beyond reasonable doubt and must conclusively point towards the guilt of the accused.

Key Points:
1. Circumstantial evidence must form a complete chain
2. Each link must be proved beyond reasonable doubt
3. Evidence must point conclusively to the guilt
4. Alternative hypotheses must be ruled out

The court also laid down guidelines for evaluating circumstantial evidence in criminal cases...
      ''',
      relatedSections: ['Section 302 IPC', 'Section 114 Evidence Act'],
      relevanceScore: 0.95,
    ),
    LegalCase(
      title: 'ABC Technologies vs. XYZ Solutions',
      citation: '(2023) 2 CompLJ 456',
      summary: 'Important case on intellectual property rights and software patent infringement.',
      court: 'Delhi High Court',
      date: '2023-01-20',
      fullText: '''
The Delhi High Court granted an injunction against the defendant for patent infringement in a software-related dispute. The court discussed the scope of software patents in India and the criteria for determining infringement.

The court held that:
1. Software innovations can be patented if they demonstrate technical effect
2. Business methods per se are not patentable
3. Implementation must show technical contribution

This judgment significantly impacts the software industry...
      ''',
      relatedSections: ['Section 3(k) Patents Act', 'Section 48 Patents Act'],
      relevanceScore: 0.88,
    ),
  ];

  static final List<LegalSection> sampleSections = [
    LegalSection(
      title: 'Murder',
      actName: 'Indian Penal Code',
      sectionNumber: '302',
      content: '''
Whoever commits murder shall be punished with death, or imprisonment for life, and shall also be liable to fine.

Explanation: The following acts constitute murder:
1. Act done with the intention of causing death
2. Act done with the intention of causing such bodily injury as the offender knows to be likely to cause death
3. Act done with the intention of causing bodily injury sufficient in ordinary course of nature to cause death
      ''',
      description: 'Defines murder and prescribes punishment for the offense',
      relatedCases: ['State of Maharashtra vs. Vijay Kumar', 'State vs. John Doe'],
    ),
    LegalSection(
      title: 'Software Patents',
      actName: 'Patents Act',
      sectionNumber: '3(k)',
      content: '''
The following are not inventions within the meaning of this Act:
(k) a mathematical or business method or a computer programme per se or algorithms
      ''',
      description: 'Exclusion of certain subject matter from patentability',
      relatedCases: ['ABC Technologies vs. XYZ Solutions', 'Tech Corp vs. Innovation Ltd'],
    ),
  ];

  static SearchResult getSearchResults(String query) {
    // Simulate search functionality
    final lowercaseQuery = query.toLowerCase();
    
    final filteredCases = sampleCases.where((c) =>
      c.title.toLowerCase().contains(lowercaseQuery) ||
      c.summary.toLowerCase().contains(lowercaseQuery) ||
      c.fullText.toLowerCase().contains(lowercaseQuery)
    ).toList();

    final filteredSections = sampleSections.where((s) =>
      s.title.toLowerCase().contains(lowercaseQuery) ||
      s.content.toLowerCase().contains(lowercaseQuery) ||
      s.description.toLowerCase().contains(lowercaseQuery)
    ).toList();

    return SearchResult(
      cases: filteredCases,
      sections: filteredSections,
      searchTerm: query,
      totalResults: filteredCases.length + filteredSections.length,
    );
  }
} 