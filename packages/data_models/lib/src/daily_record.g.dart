// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyRecordImpl _$$DailyRecordImplFromJson(Map<String, dynamic> json) =>
    _$DailyRecordImpl(
      date: json['date'] as String,
      phase: $enumDecode(_$PhaseEnumMap, json['phase']),
    );

Map<String, dynamic> _$$DailyRecordImplToJson(_$DailyRecordImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'phase': _$PhaseEnumMap[instance.phase]!,
    };

const _$PhaseEnumMap = {
  Phase.menstrual: 'Menstrual',
  Phase.follicular: 'Follicular',
  Phase.ovulation: 'Ovulation',
  Phase.luteal1: 'Luteal 1',
  Phase.luteal2: 'Luteal 2',
};
