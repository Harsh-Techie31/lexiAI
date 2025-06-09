import 'package:flutter/material.dart';
import 'package:lexiai/features/case_prediction/presentation/pages/case_prediction_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/contract_analyzer/presentation/pages/contract_analyzer_page.dart';
import '../../features/legal_assistant/presentation/pages/legal_assistant_page.dart';

class AppRouter {
  static const String home = '/';
  static const String casePrediction = '/case-prediction';
  static const String contractAnalyzer = '/contract-analyzer';
  static const String legalAssistant = '/legal-assistant';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case casePrediction:
        return MaterialPageRoute(
          builder: (_) => const CasePredictionPage(),
        );
      case contractAnalyzer:
        return MaterialPageRoute(
          builder: (_) => const ContractAnalyzerPage(),
        );
      case legalAssistant:
        return MaterialPageRoute(
          builder: (_) => const LegalAssistantPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
    }
  }
} 