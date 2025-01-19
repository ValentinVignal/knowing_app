import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowing_app/models/phase.dart';

part 'daily_record.freezed.dart';
part 'daily_record.g.dart';

@freezed
class DailyRecord with _$DailyRecord {
  const factory DailyRecord({
    required String date,
    required Phase phase,
  }) = _DailyRecord;

  factory DailyRecord.fromJson(Map<String, dynamic> json) =>
      _$DailyRecordFromJson(json);
}
