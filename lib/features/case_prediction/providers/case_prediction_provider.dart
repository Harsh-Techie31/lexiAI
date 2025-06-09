import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CasePredictionState {
  final bool isLoading;
  final String? error;
  final CasePredictionResult? result;

  const CasePredictionState({
    this.isLoading = false,
    this.error,
    this.result,
  });

  CasePredictionState copyWith({
    bool? isLoading,
    String? error,
    CasePredictionResult? result,
  }) {
    return CasePredictionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,  // Pass null to clear error
      result: result ?? this.result,
    );
  }
}

class CasePredictionResult {
  final String prediction;
  final String confidence;
  final String legalSuggestions;

  const CasePredictionResult({
    required this.prediction,
    required this.confidence,
    required this.legalSuggestions,
  });

  factory CasePredictionResult.fromJson(Map<String, dynamic> json) {
    return CasePredictionResult(
      prediction: json['prediction'] as String? ?? 'Unknown',
      confidence: json['confidence'] as String? ?? '0%',
      legalSuggestions: json['legal_suggestions'] as String? ?? 'No suggestions available',
    );
  }
}

final casePredictionProvider =
    StateNotifierProvider<CasePredictionNotifier, CasePredictionState>((ref) {
  return CasePredictionNotifier();
});

class CasePredictionNotifier extends StateNotifier<CasePredictionState> {
  final Dio _dio = Dio();

  CasePredictionNotifier() : super(const CasePredictionState());

  Future<void> predictCaseOutcome(String facts) async {
    if (facts.trim().isEmpty) {
      state = state.copyWith(
        error: 'Please enter case details',
        isLoading: false,
      );
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _dio.post(
        'http://16.171.67.61/predict/',
        data: {'facts': facts},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        state = state.copyWith(
          result: CasePredictionResult.fromJson(response.data),
          isLoading: false,
          error: null,
        );
      } else {
        final errorMessage = response.data?['error'] ?? 'Failed to get prediction. Please try again.';
        state = state.copyWith(
          error: errorMessage,
          isLoading: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in predictCaseOutcome: $e');
      }
      state = state.copyWith(
        error: 'An error occurred. Please check your connection and try again.',
        isLoading: false,
      );
      rethrow; // Allow the UI layer to handle the error
    }
  }

  void reset() {
    state = const CasePredictionState();
  }
} 