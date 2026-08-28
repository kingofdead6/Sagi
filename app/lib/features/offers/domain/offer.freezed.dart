// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Offer {

 String get id; String get title; String? get subtitle;@JsonKey(fromJson: _vendorName) String? get vendorName;@RefIdConverter() String? get vendor; ImageRef? get image; OfferType get type; num get value; List<String> get productIds;@NullableDateConverter() DateTime? get startsAt;@NullableDateConverter() DateTime? get endsAt; bool get isActive; bool get showOnHome; int get sortOrder;
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferCopyWith<Offer> get copyWith => _$OfferCopyWithImpl<Offer>(this as Offer, _$identity);

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.image, image) || other.image == image)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.productIds, productIds)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.showOnHome, showOnHome) || other.showOnHome == showOnHome)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,vendorName,vendor,image,type,value,const DeepCollectionEquality().hash(productIds),startsAt,endsAt,isActive,showOnHome,sortOrder);

@override
String toString() {
  return 'Offer(id: $id, title: $title, subtitle: $subtitle, vendorName: $vendorName, vendor: $vendor, image: $image, type: $type, value: $value, productIds: $productIds, startsAt: $startsAt, endsAt: $endsAt, isActive: $isActive, showOnHome: $showOnHome, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $OfferCopyWith<$Res>  {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) _then) = _$OfferCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? subtitle,@JsonKey(fromJson: _vendorName) String? vendorName,@RefIdConverter() String? vendor, ImageRef? image, OfferType type, num value, List<String> productIds,@NullableDateConverter() DateTime? startsAt,@NullableDateConverter() DateTime? endsAt, bool isActive, bool showOnHome, int sortOrder
});


$ImageRefCopyWith<$Res>? get image;

}
/// @nodoc
class _$OfferCopyWithImpl<$Res>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._self, this._then);

  final Offer _self;
  final $Res Function(Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? vendorName = freezed,Object? vendor = freezed,Object? image = freezed,Object? type = null,Object? value = null,Object? productIds = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? isActive = null,Object? showOnHome = null,Object? sortOrder = null,}) {
  return _then(Offer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ImageRef?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OfferType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,productIds: null == productIds ? _self.productIds : productIds // ignore: cast_nullable_to_non_nullable
as List<String>,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,showOnHome: null == showOnHome ? _self.showOnHome : showOnHome // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageRefCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ImageRefCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}


/// Adds pattern-matching-related methods to [Offer].
extension OfferPatterns on Offer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Offer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Offer value)  $default,){
final _that = this;
switch (_that) {
case _Offer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Offer value)?  $default,){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? subtitle, @JsonKey(fromJson: _vendorName)  String? vendorName, @RefIdConverter()  String? vendor,  ImageRef? image,  OfferType type,  num value,  List<String> productIds, @NullableDateConverter()  DateTime? startsAt, @NullableDateConverter()  DateTime? endsAt,  bool isActive,  bool showOnHome,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.vendorName,_that.vendor,_that.image,_that.type,_that.value,_that.productIds,_that.startsAt,_that.endsAt,_that.isActive,_that.showOnHome,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? subtitle, @JsonKey(fromJson: _vendorName)  String? vendorName, @RefIdConverter()  String? vendor,  ImageRef? image,  OfferType type,  num value,  List<String> productIds, @NullableDateConverter()  DateTime? startsAt, @NullableDateConverter()  DateTime? endsAt,  bool isActive,  bool showOnHome,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Offer():
return $default(_that.id,_that.title,_that.subtitle,_that.vendorName,_that.vendor,_that.image,_that.type,_that.value,_that.productIds,_that.startsAt,_that.endsAt,_that.isActive,_that.showOnHome,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? subtitle, @JsonKey(fromJson: _vendorName)  String? vendorName, @RefIdConverter()  String? vendor,  ImageRef? image,  OfferType type,  num value,  List<String> productIds, @NullableDateConverter()  DateTime? startsAt, @NullableDateConverter()  DateTime? endsAt,  bool isActive,  bool showOnHome,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.vendorName,_that.vendor,_that.image,_that.type,_that.value,_that.productIds,_that.startsAt,_that.endsAt,_that.isActive,_that.showOnHome,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Offer extends Offer {
  const _Offer({required this.id, required this.title, this.subtitle, @JsonKey(fromJson: _vendorName) this.vendorName, @RefIdConverter() this.vendor, this.image, this.type = OfferType.percentage, this.value = 0,  List<String> productIds = const <String>[], @NullableDateConverter() this.startsAt, @NullableDateConverter() this.endsAt, this.isActive = true, this.showOnHome = false, this.sortOrder = 0}): _productIds = productIds,super._();
  factory _Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? subtitle;
@override@JsonKey(fromJson: _vendorName) final  String? vendorName;
@override@RefIdConverter() final  String? vendor;
@override final  ImageRef? image;
@override@JsonKey() final  OfferType type;
@override@JsonKey() final  num value;
 final  List<String> _productIds;
@override@JsonKey() List<String> get productIds {
  if (_productIds is EqualUnmodifiableListView) return _productIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_productIds);
}

@override@NullableDateConverter() final  DateTime? startsAt;
@override@NullableDateConverter() final  DateTime? endsAt;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool showOnHome;
@override@JsonKey() final  int sortOrder;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferCopyWith<_Offer> get copyWith => __$OfferCopyWithImpl<_Offer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.image, image) || other.image == image)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other._productIds, _productIds)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.showOnHome, showOnHome) || other.showOnHome == showOnHome)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,vendorName,vendor,image,type,value,const DeepCollectionEquality().hash(_productIds),startsAt,endsAt,isActive,showOnHome,sortOrder);

@override
String toString() {
  return 'Offer(id: $id, title: $title, subtitle: $subtitle, vendorName: $vendorName, vendor: $vendor, image: $image, type: $type, value: $value, productIds: $productIds, startsAt: $startsAt, endsAt: $endsAt, isActive: $isActive, showOnHome: $showOnHome, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$OfferCopyWith(_Offer value, $Res Function(_Offer) _then) = __$OfferCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? subtitle,@JsonKey(fromJson: _vendorName) String? vendorName,@RefIdConverter() String? vendor, ImageRef? image, OfferType type, num value, List<String> productIds,@NullableDateConverter() DateTime? startsAt,@NullableDateConverter() DateTime? endsAt, bool isActive, bool showOnHome, int sortOrder
});


@override $ImageRefCopyWith<$Res>? get image;

}
/// @nodoc
class __$OfferCopyWithImpl<$Res>
    implements _$OfferCopyWith<$Res> {
  __$OfferCopyWithImpl(this._self, this._then);

  final _Offer _self;
  final $Res Function(_Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? vendorName = freezed,Object? vendor = freezed,Object? image = freezed,Object? type = null,Object? value = null,Object? productIds = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? isActive = null,Object? showOnHome = null,Object? sortOrder = null,}) {
  return _then(_Offer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ImageRef?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OfferType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,productIds: null == productIds ? _self._productIds : productIds // ignore: cast_nullable_to_non_nullable
as List<String>,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,showOnHome: null == showOnHome ? _self.showOnHome : showOnHome // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageRefCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ImageRefCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}

// dart format on
