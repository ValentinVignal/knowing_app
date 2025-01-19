import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:data_models/data_models.dart';

void parseSampleData() {
  final dirtyData = File('apps/knowing_app/assets/sample_data.csv');
  final dirtyDataString = dirtyData.readAsStringSync();
  final dataCsv = const CsvToListConverter().convert(dirtyDataString);

  final data = <String, DailyRecord>{};

  for (final row in dataCsv.skip(1)) {
    final date = (row[0] as String).replaceAll('/', '-').trim();
    final phaseString = (row[4] as String).trim();

    if (date.isEmpty || phaseString.isEmpty) {
      continue;
    }
    final record = DailyRecord(
      date: date,
      phase: Phase.fromString(phaseString),
    );

    data[date] = record;
  }
  final json = jsonEncode(data);

  File('apps/knowing_app/assets/sample_data.json').writeAsStringSync(json);
}
