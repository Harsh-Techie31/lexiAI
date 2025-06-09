import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LexiAI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to LexiAI',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI-powered legal assistant',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _buildFeatureCard(
              context,
              title: 'Case Outcome Prediction',
              description: 'Get AI-powered predictions for your legal case outcome',
              icon: Icons.gavel,
              route: AppRouter.casePrediction,
              isHighlighted: true,
            ),
            _buildFeatureCard(
              context,
              title: 'Legal Research',
              description: 'Search laws and similar case judgments',
              icon: Icons.search,
              route: AppRouter.legalResearch,
            ),
            _buildFeatureCard(
              context,
              title: 'Contract Analyzer',
              description: 'Extract key terms and analyze legal contracts',
              icon: Icons.description,
              route: AppRouter.contractAnalyzer,
            ),
            _buildFeatureCard(
              context,
              title: 'Legal Assistant',
              description: 'Get answers to your legal questions',
              icon: Icons.chat,
              route: AppRouter.legalAssistant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String route,
    bool isHighlighted = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isHighlighted ? 4 : 1,
      color: isHighlighted
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isHighlighted
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 