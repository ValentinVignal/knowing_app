// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyRecord _$DailyRecordFromJson(Map<String, dynamic> json) {
  return _DailyRecord.fromJson(json);
}

/// @nodoc
mixin _$DailyRecord {
  String get date => throw _privateConstructorUsedError;
  Phase get phase => throw _privateConstructorUsedError;

  /// Serializes this DailyRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyRecordCopyWith<DailyRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRecordCopyWith<$Res> {
  factory $DailyRecordCopyWith(
          DailyRecord value, $Res Function(DailyRecord) then) =
      _$DailyRecordCopyWithImpl<$Res, DailyRecord>;
  @useResult
  $Res call({String date, Phase phase});
}

/// @nodoc
class _$DailyRecordCopyWithImpl<$Res, $Val extends DailyRecord>
    implements $DailyRecordCopyWith<$Res> {
  _$DailyRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? phase = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as Phase,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyRecordImplCopyWith<$Res>
    implements $DailyRecordCopyWith<$Res> {
  factory _$$DailyRecordImplCopyWith(
          _$DailyRecordImpl value, $Res Function(_$DailyRecordImpl) then) =
      __$$DailyRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, Phase phase});
}

/// @nodoc
class __$$DailyRecordImplCopyWithImpl<$Res>
    extends _$DailyRecordCopyWithImpl<$Res, _$DailyRecordImpl>
    implements _$$DailyRecordImplCopyWith<$Res> {
  __$$DailyRecordImplCopyWithImpl(
      _$DailyRecordImpl _value, $Res Function(_$DailyRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? phase = null,
  }) {
    return _then(_$DailyRecordImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as Phase,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRecordImpl with DiagnosticableTreeMixin implements _DailyRecord {
  const _$DailyRecordImpl({required this.date, required this.phase});

  factory _$DailyRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRecordImplFromJson(json);

  @override
  final String date;
  @override
  final Phase phase;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DailyRecord(date: $date, phase: $phase)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DailyRecord'))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('phase', phase));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRecordImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.phase, phase) || other.phase == phase));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, phase);

  /// Create a copy of DailyRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRecordImplCopyWith<_$DailyRecordImpl> get copyWith =>
      __$$DailyRecordImplCopyWithImpl<_$DailyRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRecordImplToJson(
      this,
    );
  }
}

abstract class _DailyRecord implements DailyRecord {
  const factory _DailyRecord(
      {required final String date,
      required final Phase phase}) = _$DailyRecordImpl;

  factory _DailyRecord.fromJson(Map<String, dynamic> json) =
      _$DailyRecordImpl.fromJson;

  @override
  String get date;
  @override
  Phase get phase;

  /// Create a copy of DailyRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyRecordImplCopyWith<_$DailyRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
