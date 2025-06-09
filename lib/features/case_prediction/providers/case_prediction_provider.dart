import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class CasePredictionResult {
  final String prediction;
  final String confidence;
  final String legalSuggestions;

  CasePredictionResult({
    required this.prediction,
    required this.confidence,
    required this.legalSuggestions,
  });

  factory CasePredictionResult.fromJson(Map<String, dynamic> json) {
    return CasePredictionResult(
      prediction: json['prediction'] as String,
      confidence: json['confidence'] as String,
      legalSuggestions: json['legal_suggestions'] as String,
    );
  }
}

class CasePredictionProvider with ChangeNotifier {
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _error;
  CasePredictionResult? _result;

  bool get isLoading => _isLoading;
  String? get error => _error;
  CasePredictionResult? get result => _result;

  Future<void> predictCaseOutcome(String facts) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _dio.post(
        'http://16.171.67.61/predict/',
        data: {'facts': facts},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        _result = CasePredictionResult.fromJson(response.data);
      } else {
        _error = 'Failed to get prediction. Please try again.';
      }
    } catch (e) {
      _error = 'An error occurred. Please check your connection and try again.';
      if (kDebugMode) {
        print('Error in predictCaseOutcome: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _error = null;
    _result = null;
    notifyListeners();
  }
} 