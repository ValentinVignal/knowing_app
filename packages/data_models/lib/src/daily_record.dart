import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data_models/src/phase.dart';

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
