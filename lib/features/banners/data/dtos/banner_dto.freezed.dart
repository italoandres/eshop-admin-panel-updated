// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BannerDto _$BannerDtoFromJson(Map<String, dynamic> json) {
  return _BannerDto.fromJson(json);
}

/// @nodoc
mixin _$BannerDto {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  String? get targetUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this BannerDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerDtoCopyWith<BannerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerDtoCopyWith<$Res> {
  factory $BannerDtoCopyWith(BannerDto value, $Res Function(BannerDto) then) =
      _$BannerDtoCopyWithImpl<$Res, BannerDto>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String title,
      String imageUrl,
      int order,
      bool active,
      String? targetUrl,
      String? description});
}

/// @nodoc
class _$BannerDtoCopyWithImpl<$Res, $Val extends BannerDto>
    implements $BannerDtoCopyWith<$Res> {
  _$BannerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? order = null,
    Object? active = null,
    Object? targetUrl = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      targetUrl: freezed == targetUrl
          ? _value.targetUrl
          : targetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BannerDtoImplCopyWith<$Res>
    implements $BannerDtoCopyWith<$Res> {
  factory _$$BannerDtoImplCopyWith(
          _$BannerDtoImpl value, $Res Function(_$BannerDtoImpl) then) =
      __$$BannerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String title,
      String imageUrl,
      int order,
      bool active,
      String? targetUrl,
      String? description});
}

/// @nodoc
class __$$BannerDtoImplCopyWithImpl<$Res>
    extends _$BannerDtoCopyWithImpl<$Res, _$BannerDtoImpl>
    implements _$$BannerDtoImplCopyWith<$Res> {
  __$$BannerDtoImplCopyWithImpl(
      _$BannerDtoImpl _value, $Res Function(_$BannerDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? order = null,
    Object? active = null,
    Object? targetUrl = freezed,
    Object? description = freezed,
  }) {
    return _then(_$BannerDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      targetUrl: freezed == targetUrl
          ? _value.targetUrl
          : targetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BannerDtoImpl extends _BannerDto {
  const _$BannerDtoImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.title,
      required this.imageUrl,
      required this.order,
      required this.active,
      this.targetUrl,
      this.description})
      : super._();

  factory _$BannerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerDtoImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final int order;
  @override
  final bool active;
  @override
  final String? targetUrl;
  @override
  final String? description;

  @override
  String toString() {
    return 'BannerDto(id: $id, title: $title, imageUrl: $imageUrl, order: $order, active: $active, targetUrl: $targetUrl, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.targetUrl, targetUrl) ||
                other.targetUrl == targetUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, imageUrl, order, active, targetUrl, description);

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerDtoImplCopyWith<_$BannerDtoImpl> get copyWith =>
      __$$BannerDtoImplCopyWithImpl<_$BannerDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BannerDtoImplToJson(
      this,
    );
  }
}

abstract class _BannerDto extends BannerDto {
  const factory _BannerDto(
      {@JsonKey(name: '_id') required final String id,
      required final String title,
      required final String imageUrl,
      required final int order,
      required final bool active,
      final String? targetUrl,
      final String? description}) = _$BannerDtoImpl;
  const _BannerDto._() : super._();

  factory _BannerDto.fromJson(Map<String, dynamic> json) =
      _$BannerDtoImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  String get imageUrl;
  @override
  int get order;
  @override
  bool get active;
  @override
  String? get targetUrl;
  @override
  String? get description;

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerDtoImplCopyWith<_$BannerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
