import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:knowing_app/models/daily_record.dart';
import 'package:knowing_app/models/phase.dart';

void main() {
  final dirtyData = File('assets/sample_data.csv');
  final dirtyDataString = dirtyData.readAsStringSync();
  final dataCsv = const CsvToListConverter().convert(dirtyDataString);

  final data = <String, DailyRecord>{};

  for (final row in dataCsv.skip(1)) {
    final date = (row[0] as String).replaceAll('/', '-');
    final record = DailyRecord(
      date: date,
      phase: Phase.fromJson(row[4] as String),
    );

    data[date] = record;
  }
  final json = jsonEncode(data);

  File('assets/sample_data.json').writeAsStringSync(json);
}
