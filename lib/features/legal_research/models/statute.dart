class Amendment {
  final String description;
  final DateTime date;
  final String reference;

  Amendment({
    required this.description,
    required this.date,
    required this.reference,
  });

  factory Amendment.fromJson(Map<String, dynamic> json) {
    return Amendment(
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      reference: json['reference'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'date': date.toIso8601String(),
      'reference': reference,
    };
  }
}

class Statute {
  final String title;
  final String docId;
  final String text;
  final String section;
  final String actName;
  final double score;

  Statute({
    required this.title,
    required this.docId,
    required this.text,
    required this.section,
    required this.actName,
    required this.score,
  });

  factory Statute.fromJson(Map<String, dynamic> json) {
    return Statute(
      title: json['title'] ?? '',
      docId: json['doc_id'] ?? '',
      text: json['text'] ?? '',
      section: json['section'] ?? '',
      actName: json['act_name'] ?? '',
      score: (json['score'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'doc_id': docId,
      'text': text,
      'section': section,
      'act_name': actName,
      'score': score,
    };
  }
} 