import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../widgets/activity_chart.dart';
import '../widgets/subject_progress_chart.dart';

class AnalyticsDashboard extends ConsumerWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDateRangePicker(context, ref),
          ),
        ],
      ),
      body: analytics.when(
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(analyticsProvider.future),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCards(data),
                const SizedBox(height: 24),
                _buildWeeklyActivityChart(data),
                const SizedBox(height: 24),
                _buildSubjectProgressChart(data),
                const SizedBox(height: 24),
                _buildStrengthsAndWeaknesses(data),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildOverviewCards(AnalyticsSummary data) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Total Study Time',
          '${data.totalStudyTime.inHours}h ${data.totalStudyTime.inMinutes % 60}m',
          Icons.timer,
          Colors.blue,
        ),
        _buildStatCard(
          'Average Score',
          '${data.averageQuizScore.toStringAsFixed(1)}%',
          Icons.score,
          Colors.green,
        ),
        _buildStatCard(
          'Quizzes Taken',
          data.totalQuizzes.toString(),
          Icons.quiz,
          Colors.orange,
        ),
        _buildStatCard(
          'Active Subjects',
          data.subjectProgress.length.toString(),
          Icons.book,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyActivityChart(AnalyticsSummary data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ActivityChart(data: data.weeklyActivity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectProgressChart(AnalyticsSummary data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: SubjectProgressChart(progress: data.subjectProgress),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsAndWeaknesses(AnalyticsSummary data) {
    return Row(
      children: [
        Expanded(
          child: _buildStrengthsCard(data.strengthAreas),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildWeaknessesCard(data.improvementAreas),
        ),
      ],
    );
  }

  Widget _buildStrengthsCard(List<String> strengths) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Strong Subjects',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...strengths.map(
              (subject) => Chip(
                label: Text(subject),
                backgroundColor: Colors.green[100],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaknessesCard(List<String> weaknesses) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Needs Improvement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...weaknesses.map(
              (subject) => Chip(
                label: Text(subject),
                backgroundColor: Colors.orange[100],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context, WidgetRef ref) async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (range != null) {
      ref.read(analyticsProvider.notifier).updateDateRange(range);
    }
  }
} 