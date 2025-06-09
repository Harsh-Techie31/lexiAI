class LegalCase {
  final String title;
  final String docId;
  final String court;
  final String snippet;
  final String fullText;
  final double score;
  final DateTime date;

  LegalCase({
    required this.title,
    required this.docId,
    required this.court,
    required this.snippet,
    required this.fullText,
    required this.score,
    required this.date,
  });

  factory LegalCase.fromJson(Map<String, dynamic> json) {
    return LegalCase(
      title: json['title'] ?? '',
      docId: json['doc_id'] ?? '',
      court: json['court'] ?? '',
      snippet: json['snippet'] ?? '',
      fullText: json['full_text'] ?? '',
      score: (json['score'] ?? 0.0).toDouble(),
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'doc_id': docId,
      'court': court,
      'snippet': snippet,
      'full_text': fullText,
      'score': score,
      'date': date.toIso8601String(),
    };
  }
} 