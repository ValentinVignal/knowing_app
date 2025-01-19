import 'dart:convert';
import 'dart:io';

import 'package:data_models/data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:knowing_app/router/routes.dart';
import 'package:knowing_app/services/api_keys.dart';

extension on DateTime {
  String get yyyyMMdd =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
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

const daysInFuture = 3;

class AnalyzeScreen extends ConsumerStatefulWidget {
  const AnalyzeScreen({
    super.key,
  });

  @override
  ConsumerState<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends ConsumerState<AnalyzeScreen> {
  final _content = <({String title, String content})>[];

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
    final record = ref.watch(dailyRecordProvider).valueOrNull;
    final List<({String title, String content})> content;
    if (record != null) {
      content = [
        (title: 'Date', content: record.date),
        (title: 'Phase', content: record.phase.asString()),
      ];
    } else {
      content = const [];
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
            child: ListView.builder(
              itemCount: content.length,
              itemBuilder: (context, index) {
                final item = content[index];
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
