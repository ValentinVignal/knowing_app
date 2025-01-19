import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:knowing_app/services/api_keys.dart';

const _samplePhaseToRecommendationPhase = {
  'Menstrual': 'Menstrual (Day 1–5)',
  'Follicular': 'Follicular (Day 6–13)',
  'Ovulation': 'Ovulatory (Day 14±2)',
  'Luteal 1': 'Luteal phase 1',
  'Luteal 2': 'Luteal phase 2',
};

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  var _content = <({String title, String content})>[];

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

  void _onPressAnalyze() async {
    final sampleString = await rootBundle.loadString('assets/sample_data.csv');
    final recommendationsString =
        await rootBundle.loadString('assets/recommendations.csv');

    final sample = const CsvToListConverter().convert(sampleString);
    final current = sample[1]; // 0 is for the headers.
    final sampleCycle = (current[4] as String);
    final recommendations =
        const CsvToListConverter().convert(recommendationsString);
    final headers = recommendations.first;

    final recommendationCycle = _samplePhaseToRecommendationPhase[sampleCycle];

    final recommendation = recommendations.firstWhereOrNull(
      (element) => element.first == recommendationCycle,
    );
    if (recommendation == null) {
      return;
    }

    setState(() {
      _content = [
        for (final (index, header) in headers.indexed)
          (title: header, content: recommendation[index]),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _onChatGPTPressed,
              child: Text('Chat GPT'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _onPressAnalyze,
              child: Text('Analyze'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _content.length,
              itemBuilder: (context, index) {
                final item = _content[index];
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
