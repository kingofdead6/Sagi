// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageRef {

 String get url; String get publicId; int? get width; int? get height;
/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageRefCopyWith<ImageRef> get copyWith => _$ImageRefCopyWithImpl<ImageRef>(this as ImageRef, _$identity);

  /// Serializes this ImageRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageRef&&(identical(other.url, url) || other.url == url)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,publicId,width,height);

@override
String toString() {
  return 'ImageRef(url: $url, publicId: $publicId, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $ImageRefCopyWith<$Res>  {
  factory $ImageRefCopyWith(ImageRef value, $Res Function(ImageRef) _then) = _$ImageRefCopyWithImpl;
@useResult
$Res call({
 String url, String publicId, int? width, int? height
});




}
/// @nodoc
class _$ImageRefCopyWithImpl<$Res>
    implements $ImageRefCopyWith<$Res> {
  _$ImageRefCopyWithImpl(this._self, this._then);

  final ImageRef _self;
  final $Res Function(ImageRef) _then;

/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? publicId = null,Object? width = freezed,Object? height = freezed,}) {
  return _then(ImageRef(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageRef].
extension ImageRefPatterns on ImageRef {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageRef value)  $default,){
final _that = this;
switch (_that) {
case _ImageRef():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageRef value)?  $default,){
final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String publicId,  int? width,  int? height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
return $default(_that.url,_that.publicId,_that.width,_that.height);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String publicId,  int? width,  int? height)  $default,) {final _that = this;
switch (_that) {
case _ImageRef():
return $default(_that.url,_that.publicId,_that.width,_that.height);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String publicId,  int? width,  int? height)?  $default,) {final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
return $default(_that.url,_that.publicId,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageRef extends ImageRef {
  const _ImageRef({required this.url, required this.publicId, this.width, this.height}): super._();
  factory _ImageRef.fromJson(Map<String, dynamic> json) => _$ImageRefFromJson(json);

@override final  String url;
@override final  String publicId;
@override final  int? width;
@override final  int? height;

/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageRefCopyWith<_ImageRef> get copyWith => __$ImageRefCopyWithImpl<_ImageRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageRef&&(identical(other.url, url) || other.url == url)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,publicId,width,height);

@override
String toString() {
  return 'ImageRef(url: $url, publicId: $publicId, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ImageRefCopyWith<$Res> implements $ImageRefCopyWith<$Res> {
  factory _$ImageRefCopyWith(_ImageRef value, $Res Function(_ImageRef) _then) = __$ImageRefCopyWithImpl;
@override @useResult
$Res call({
 String url, String publicId, int? width, int? height
});




}
/// @nodoc
class __$ImageRefCopyWithImpl<$Res>
    implements _$ImageRefCopyWith<$Res> {
  __$ImageRefCopyWithImpl(this._self, this._then);

  final _ImageRef _self;
  final $Res Function(_ImageRef) _then;

/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? publicId = null,Object? width = freezed,Object? height = freezed,}) {
  return _then(_ImageRef(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
