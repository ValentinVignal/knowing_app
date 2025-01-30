import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:data_models/data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:knowing_app/router/routes.dart';
import 'package:knowing_app/services/api_keys.dart';

const _phaseLength = {
  Phase.menstrual: 7,
  Phase.follicular: 7,
  Phase.ovulation: 2,
  Phase.luteal1: 7,
  Phase.luteal2: 7,
};

extension on DateTime {
  String get yyyyMMdd =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

class _TitleAndContent {
  const _TitleAndContent({
    required this.title,
    required this.content,
  });
  final String title;
  final String content;
}

final dateOverrideProvider = Provider<String?>((ref) {
  return null;
});

final dateProvider = Provider<String>((ref) {
  final override = ref.watch(dateOverrideProvider);
  if (override != null) {
    return override;
  }

  final now = DateTime.now();
  return now.yyyyMMdd;
}, dependencies: [dateOverrideProvider]);

final sampleDataProvider =
    FutureProvider<Map<String, DailyRecord>>((ref) async {
  final file = await rootBundle.loadString('assets/sample_data.json');
  final json = jsonDecode(file) as Map<String, dynamic>;
  return json.map((key, value) => MapEntry(key, DailyRecord.fromJson(value)));
});

final dailyRecordProvider = Provider<AsyncValue<DailyRecord?>>((ref) {
  final date = ref.watch(dateProvider);
  return ref.watch(sampleDataProvider).whenData(
        (data) => data[date],
      );
}, dependencies: [dateProvider, sampleDataProvider]);

final recommendationsProvider =
    FutureProvider<Map<Phase, List<_TitleAndContent>>>((ref) async {
  final file = await rootBundle.loadString('assets/recommendations.csv');
  final json = const CsvToListConverter().convert(file);
  final map = <Phase, List<_TitleAndContent>>{};
  final headers = (json.first).cast<String>();
  for (final (index, row) in json.skip(1).indexed) {
    final phase = Phase.values[index];
    map[phase] = row
        .mapIndexed((index, text) => _TitleAndContent(
              title: headers[index],
              content: text as String,
            ))
        .toList();
  }
  return map;
});

final expectedPhaseProvider = FutureProvider<Phase?>((ref) async {
  final sampleData = (await ref.watch(sampleDataProvider.future));
  if (sampleData.isEmpty) {
    return null;
  }
  final dates = sampleData.keys.sorted((a, b) => b.compareTo(a));
  final latestDateString = dates.first;
  var firstDateOfPhaseString = latestDateString;
  final phase = sampleData[firstDateOfPhaseString]!.phase;

  for (var i = 1; i < min(_phaseLength[phase]! + 1, sampleData.length); i++) {
    if (sampleData[dates[i]]!.phase != phase ||
        DateTime.parse(latestDateString)
                .difference(DateTime.parse(dates[i]))
                .inDays >
            _phaseLength[phase]!) {
      break;
    }
    firstDateOfPhaseString = dates[i];
  }

  final firstDateOfPhase = DateTime.parse(firstDateOfPhaseString);
  final date = DateTime.parse(ref.watch(dateProvider));
  var currentDate = firstDateOfPhase;
  var currentPhase = phase;
  while (date.difference(currentDate).inDays > 1) {
    currentDate = currentDate.add(Duration(
        days: min(
            _phaseLength[currentPhase]!, date.difference(currentDate).inDays)));
    currentPhase = Phase.values[(currentPhase.index + 1) % Phase.values.length];
  }

  return phase;
}, dependencies: [dateProvider, sampleDataProvider]);

final recommendationsForPhaseProvider =
    Provider<List<_TitleAndContent>?>((ref) {
  final phase = ref.watch(expectedPhaseProvider).valueOrNull;
  final recommendations =
      ref.watch(recommendationsProvider).valueOrNull ?? const {};
  if (phase == null || recommendations.isEmpty) {
    return const [];
  }
  return recommendations[phase] ?? const [];
}, dependencies: [expectedPhaseProvider, recommendationsProvider]);

const daysInFuture = 3;

class AnalyzeScreen extends ConsumerStatefulWidget {
  const AnalyzeScreen({
    super.key,
  });

  @override
  ConsumerState<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends ConsumerState<AnalyzeScreen> {
  void _onChatGPTPressed() async {
    final csv = await rootBundle.loadString('assets/sample_data.csv');
    const parameter1 = 2;
    const parameter2 = 4;
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'developer',
            'content':
                'You are a useful assistant that has access to the data of the user in the format of a CSV file:',
          },
          {
            'role': 'user',
            'content':
                'Analyze the data correlation between the input between those 2 columns $parameter1 and $parameter2 (starting from 0). And how does the column $parameter2 affect the column $parameter1?',
          },
        ]
      }),
    );
    final body = jsonDecode(response.body) as Map;
    print(body);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(dateProvider);
    final selectedDateTime = DateTime.parse(selectedDate);
    final now = DateTime.now();
    final List<_TitleAndContent> logged;
    if (selectedDateTime.isAfter(now)) {
      logged = const [];
    } else {
      final record = ref.watch(dailyRecordProvider).valueOrNull;
      if (record == null) {
        logged = const [];
      } else {
        logged = [
          _TitleAndContent(title: 'Date', content: record.date),
          _TitleAndContent(title: 'Phase', content: record.phase.asString()),
        ];
      }
    }

    final List<_TitleAndContent> recommendations;
    if (selectedDateTime.add(Duration(days: 1)).isBefore(now)) {
      recommendations = const [];
    } else {
      recommendations = ref.watch(recommendationsForPhaseProvider) ?? const [];
    }

    return Scaffold(
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _onChatGPTPressed,
              child: Text('Chat GPT'),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (context, index) {
                final date = DateTime.now()
                    .subtract(Duration(days: index - daysInFuture));

                final theme = Theme.of(context);

                final color = switch (index) {
                  < daysInFuture => theme.colorScheme.secondaryContainer,
                  daysInFuture => theme.colorScheme.primaryContainer,
                  _ => theme.colorScheme.tertiaryContainer,
                };
                final textColor = switch (index) {
                  < daysInFuture => theme.colorScheme.onSecondaryContainer,
                  daysInFuture => theme.colorScheme.onPrimaryContainer,
                  _ => theme.colorScheme.onTertiaryContainer,
                };

                final dateString = date.yyyyMMdd;
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: dateString == selectedDate
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            AnalyzeRoute(date: dateString).replace(context);
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                date.yyyyMMdd,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (recommendations.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recommendations',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  ...recommendations.map((item) {
                    return _TitleContentWidget(item: item);
                  })
                ],
                if (logged.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Logged',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  ...logged.map((item) {
                    return _TitleContentWidget(item: item);
                  })
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleContentWidget extends StatelessWidget {
  const _TitleContentWidget({
    required this.item,
    super.key,
  });

  final _TitleAndContent item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(item.content),
          ],
        ),
      )),
    );
  }
}
