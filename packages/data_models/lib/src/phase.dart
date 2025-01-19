import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phase.g.dart';

@JsonEnum(alwaysCreate: true)
enum Phase {
  @JsonValue('Menstrual')
  menstrual,
  @JsonValue('Follicular')
  follicular,
  @JsonValue('Ovulation')
  ovulation,
  @JsonValue('Luteal 1')
  luteal1,
  @JsonValue('Luteal 2')
  luteal2;

  factory Phase.fromString(String json) =>
      _$PhaseEnumMap.entries.firstWhere((entry) => entry.value == json).key;

  static Phase? fromStringOrNull(String json) => _$PhaseEnumMap.entries
      .firstWhereOrNull((entry) => entry.value == json)
      ?.key;
}
