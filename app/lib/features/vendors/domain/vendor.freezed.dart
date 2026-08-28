// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Category {

 String get id; String get nameAr; String get nameFr; String get iconKey; int get sortOrder; bool get isActive;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameFr,iconKey,sortOrder,isActive);

@override
String toString() {
  return 'Category(id: $id, nameAr: $nameAr, nameFr: $nameFr, iconKey: $iconKey, sortOrder: $sortOrder, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String id, String nameAr, String nameFr, String iconKey, int sortOrder, bool isActive
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameAr = null,Object? nameFr = null,Object? iconKey = null,Object? sortOrder = null,Object? isActive = null,}) {
  return _then(Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameFr: null == nameFr ? _self.nameFr : nameFr // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameFr,  String iconKey,  int sortOrder,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameFr,_that.iconKey,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nameAr,  String nameFr,  String iconKey,  int sortOrder,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.nameAr,_that.nameFr,_that.iconKey,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nameAr,  String nameFr,  String iconKey,  int sortOrder,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.nameAr,_that.nameFr,_that.iconKey,_that.sortOrder,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({required this.id, required this.nameAr, required this.nameFr, required this.iconKey, this.sortOrder = 0, this.isActive = true});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

@override final  String id;
@override final  String nameAr;
@override final  String nameFr;
@override final  String iconKey;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool isActive;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameFr, nameFr) || other.nameFr == nameFr)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameAr,nameFr,iconKey,sortOrder,isActive);

@override
String toString() {
  return 'Category(id: $id, nameAr: $nameAr, nameFr: $nameFr, iconKey: $iconKey, sortOrder: $sortOrder, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String nameAr, String nameFr, String iconKey, int sortOrder, bool isActive
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameAr = null,Object? nameFr = null,Object? iconKey = null,Object? sortOrder = null,Object? isActive = null,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,nameFr: null == nameFr ? _self.nameFr : nameFr // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$OpeningHour {

 int get day; String get from; String get to;
/// Create a copy of OpeningHour
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpeningHourCopyWith<OpeningHour> get copyWith => _$OpeningHourCopyWithImpl<OpeningHour>(this as OpeningHour, _$identity);

  /// Serializes this OpeningHour to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpeningHour&&(identical(other.day, day) || other.day == day)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,from,to);

@override
String toString() {
  return 'OpeningHour(day: $day, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $OpeningHourCopyWith<$Res>  {
  factory $OpeningHourCopyWith(OpeningHour value, $Res Function(OpeningHour) _then) = _$OpeningHourCopyWithImpl;
@useResult
$Res call({
 int day, String from, String to
});




}
/// @nodoc
class _$OpeningHourCopyWithImpl<$Res>
    implements $OpeningHourCopyWith<$Res> {
  _$OpeningHourCopyWithImpl(this._self, this._then);

  final OpeningHour _self;
  final $Res Function(OpeningHour) _then;

/// Create a copy of OpeningHour
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? from = null,Object? to = null,}) {
  return _then(OpeningHour(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OpeningHour].
extension OpeningHourPatterns on OpeningHour {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpeningHour value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpeningHour() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpeningHour value)  $default,){
final _that = this;
switch (_that) {
case _OpeningHour():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpeningHour value)?  $default,){
final _that = this;
switch (_that) {
case _OpeningHour() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  String from,  String to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpeningHour() when $default != null:
return $default(_that.day,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  String from,  String to)  $default,) {final _that = this;
switch (_that) {
case _OpeningHour():
return $default(_that.day,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  String from,  String to)?  $default,) {final _that = this;
switch (_that) {
case _OpeningHour() when $default != null:
return $default(_that.day,_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpeningHour implements OpeningHour {
  const _OpeningHour({required this.day, required this.from, required this.to});
  factory _OpeningHour.fromJson(Map<String, dynamic> json) => _$OpeningHourFromJson(json);

@override final  int day;
@override final  String from;
@override final  String to;

/// Create a copy of OpeningHour
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpeningHourCopyWith<_OpeningHour> get copyWith => __$OpeningHourCopyWithImpl<_OpeningHour>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpeningHourToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpeningHour&&(identical(other.day, day) || other.day == day)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,from,to);

@override
String toString() {
  return 'OpeningHour(day: $day, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$OpeningHourCopyWith<$Res> implements $OpeningHourCopyWith<$Res> {
  factory _$OpeningHourCopyWith(_OpeningHour value, $Res Function(_OpeningHour) _then) = __$OpeningHourCopyWithImpl;
@override @useResult
$Res call({
 int day, String from, String to
});




}
/// @nodoc
class __$OpeningHourCopyWithImpl<$Res>
    implements _$OpeningHourCopyWith<$Res> {
  __$OpeningHourCopyWithImpl(this._self, this._then);

  final _OpeningHour _self;
  final $Res Function(_OpeningHour) _then;

/// Create a copy of OpeningHour
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? from = null,Object? to = null,}) {
  return _then(_OpeningHour(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Vendor {

 String get id; String get name; String get slug; String? get description;@RefIdConverter() String? get category; ImageRef? get logo; ImageRef? get cover; String get phone; String get addressText;@GeoPointConverter() LatLng? get location; double get rating; int get ratingCount; int get prepTimeMin; int get prepTimeMax;@MoneyConverter() Money get deliveryFeeCentimes;@MoneyConverter() Money get minOrderCentimes; bool get isOpen; List<OpeningHour> get openingHours; bool get isFeatured; bool get isActive; double? get distanceKm; int? get etaMinutes; bool? get isOpenNow;
/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorCopyWith<Vendor> get copyWith => _$VendorCopyWithImpl<Vendor>(this as Vendor, _$identity);

  /// Serializes this Vendor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vendor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.location, location) || other.location == location)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.prepTimeMin, prepTimeMin) || other.prepTimeMin == prepTimeMin)&&(identical(other.prepTimeMax, prepTimeMax) || other.prepTimeMax == prepTimeMax)&&(identical(other.deliveryFeeCentimes, deliveryFeeCentimes) || other.deliveryFeeCentimes == deliveryFeeCentimes)&&(identical(other.minOrderCentimes, minOrderCentimes) || other.minOrderCentimes == minOrderCentimes)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&const DeepCollectionEquality().equals(other.openingHours, openingHours)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.isOpenNow, isOpenNow) || other.isOpenNow == isOpenNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,description,category,logo,cover,phone,addressText,location,rating,ratingCount,prepTimeMin,prepTimeMax,deliveryFeeCentimes,minOrderCentimes,isOpen,const DeepCollectionEquality().hash(openingHours),isFeatured,isActive,distanceKm,etaMinutes,isOpenNow]);

@override
String toString() {
  return 'Vendor(id: $id, name: $name, slug: $slug, description: $description, category: $category, logo: $logo, cover: $cover, phone: $phone, addressText: $addressText, location: $location, rating: $rating, ratingCount: $ratingCount, prepTimeMin: $prepTimeMin, prepTimeMax: $prepTimeMax, deliveryFeeCentimes: $deliveryFeeCentimes, minOrderCentimes: $minOrderCentimes, isOpen: $isOpen, openingHours: $openingHours, isFeatured: $isFeatured, isActive: $isActive, distanceKm: $distanceKm, etaMinutes: $etaMinutes, isOpenNow: $isOpenNow)';
}


}

/// @nodoc
abstract mixin class $VendorCopyWith<$Res>  {
  factory $VendorCopyWith(Vendor value, $Res Function(Vendor) _then) = _$VendorCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String? description,@RefIdConverter() String? category, ImageRef? logo, ImageRef? cover, String phone, String addressText,@GeoPointConverter() LatLng? location, double rating, int ratingCount, int prepTimeMin, int prepTimeMax,@MoneyConverter() Money deliveryFeeCentimes,@MoneyConverter() Money minOrderCentimes, bool isOpen, List<OpeningHour> openingHours, bool isFeatured, bool isActive, double? distanceKm, int? etaMinutes, bool? isOpenNow
});


$ImageRefCopyWith<$Res>? get logo;$ImageRefCopyWith<$Res>? get cover;

}
/// @nodoc
class _$VendorCopyWithImpl<$Res>
    implements $VendorCopyWith<$Res> {
  _$VendorCopyWithImpl(this._self, this._then);

  final Vendor _self;
  final $Res Function(Vendor) _then;

/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? category = freezed,Object? logo = freezed,Object? cover = freezed,Object? phone = null,Object? addressText = null,Object? location = freezed,Object? rating = null,Object? ratingCount = null,Object? prepTimeMin = null,Object? prepTimeMax = null,Object? deliveryFeeCentimes = null,Object? minOrderCentimes = null,Object? isOpen = null,Object? openingHours = null,Object? isFeatured = null,Object? isActive = null,Object? distanceKm = freezed,Object? etaMinutes = freezed,Object? isOpenNow = freezed,}) {
  return _then(Vendor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as ImageRef?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as ImageRef?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,prepTimeMin: null == prepTimeMin ? _self.prepTimeMin : prepTimeMin // ignore: cast_nullable_to_non_nullable
as int,prepTimeMax: null == prepTimeMax ? _self.prepTimeMax : prepTimeMax // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeCentimes: null == deliveryFeeCentimes ? _self.deliveryFeeCentimes : deliveryFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,minOrderCentimes: null == minOrderCentimes ? _self.minOrderCentimes : minOrderCentimes // ignore: cast_nullable_to_non_nullable
as Money,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,openingHours: null == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<OpeningHour>,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,isOpenNow: freezed == isOpenNow ? _self.isOpenNow : isOpenNow // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageRefCopyWith<$Res>? get logo {
    if (_self.logo == null) {
    return null;
  }

  return $ImageRefCopyWith<$Res>(_self.logo!, (value) {
    return _then(_self.copyWith(logo: value));
  });
}/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageRefCopyWith<$Res>? get cover {
    if (_self.cover == null) {
    return null;
  }

  return $ImageRefCopyWith<$Res>(_self.cover!, (value) {
    return _then(_self.copyWith(cover: value));
  });
}
}


/// Adds pattern-matching-related methods to [Vendor].
extension VendorPatterns on Vendor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vendor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vendor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vendor value)  $default,){
final _that = this;
switch (_that) {
case _Vendor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vendor value)?  $default,){
final _that = this;
switch (_that) {
case _Vendor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description, @RefIdConverter()  String? category,  ImageRef? logo,  ImageRef? cover,  String phone,  String addressText, @GeoPointConverter()  LatLng? location,  double rating,  int ratingCount,  int prepTimeMin,  int prepTimeMax, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money minOrderCentimes,  bool isOpen,  List<OpeningHour> openingHours,  bool isFeatured,  bool isActive,  double? distanceKm,  int? etaMinutes,  bool? isOpenNow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vendor() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.category,_that.logo,_that.cover,_that.phone,_that.addressText,_that.location,_that.rating,_that.ratingCount,_that.prepTimeMin,_that.prepTimeMax,_that.deliveryFeeCentimes,_that.minOrderCentimes,_that.isOpen,_that.openingHours,_that.isFeatured,_that.isActive,_that.distanceKm,_that.etaMinutes,_that.isOpenNow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description, @RefIdConverter()  String? category,  ImageRef? logo,  ImageRef? cover,  String phone,  String addressText, @GeoPointConverter()  LatLng? location,  double rating,  int ratingCount,  int prepTimeMin,  int prepTimeMax, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money minOrderCentimes,  bool isOpen,  List<OpeningHour> openingHours,  bool isFeatured,  bool isActive,  double? distanceKm,  int? etaMinutes,  bool? isOpenNow)  $default,) {final _that = this;
switch (_that) {
case _Vendor():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.category,_that.logo,_that.cover,_that.phone,_that.addressText,_that.location,_that.rating,_that.ratingCount,_that.prepTimeMin,_that.prepTimeMax,_that.deliveryFeeCentimes,_that.minOrderCentimes,_that.isOpen,_that.openingHours,_that.isFeatured,_that.isActive,_that.distanceKm,_that.etaMinutes,_that.isOpenNow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String? description, @RefIdConverter()  String? category,  ImageRef? logo,  ImageRef? cover,  String phone,  String addressText, @GeoPointConverter()  LatLng? location,  double rating,  int ratingCount,  int prepTimeMin,  int prepTimeMax, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money minOrderCentimes,  bool isOpen,  List<OpeningHour> openingHours,  bool isFeatured,  bool isActive,  double? distanceKm,  int? etaMinutes,  bool? isOpenNow)?  $default,) {final _that = this;
switch (_that) {
case _Vendor() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.category,_that.logo,_that.cover,_that.phone,_that.addressText,_that.location,_that.rating,_that.ratingCount,_that.prepTimeMin,_that.prepTimeMax,_that.deliveryFeeCentimes,_that.minOrderCentimes,_that.isOpen,_that.openingHours,_that.isFeatured,_that.isActive,_that.distanceKm,_that.etaMinutes,_that.isOpenNow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vendor extends Vendor {
  const _Vendor({required this.id, required this.name, this.slug = '', this.description, @RefIdConverter() this.category, this.logo, this.cover, this.phone = '', this.addressText = '', @GeoPointConverter() this.location, this.rating = 0, this.ratingCount = 0, this.prepTimeMin = 15, this.prepTimeMax = 30, @MoneyConverter() this.deliveryFeeCentimes = const Money.zero(), @MoneyConverter() this.minOrderCentimes = const Money.zero(), this.isOpen = true,  List<OpeningHour> openingHours = const <OpeningHour>[], this.isFeatured = false, this.isActive = true, this.distanceKm, this.etaMinutes, this.isOpenNow}): _openingHours = openingHours,super._();
  factory _Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String slug;
@override final  String? description;
@override@RefIdConverter() final  String? category;
@override final  ImageRef? logo;
@override final  ImageRef? cover;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String addressText;
@override@GeoPointConverter() final  LatLng? location;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int prepTimeMin;
@override@JsonKey() final  int prepTimeMax;
@override@JsonKey()@MoneyConverter() final  Money deliveryFeeCentimes;
@override@JsonKey()@MoneyConverter() final  Money minOrderCentimes;
@override@JsonKey() final  bool isOpen;
 final  List<OpeningHour> _openingHours;
@override@JsonKey() List<OpeningHour> get openingHours {
  if (_openingHours is EqualUnmodifiableListView) return _openingHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openingHours);
}

@override@JsonKey() final  bool isFeatured;
@override@JsonKey() final  bool isActive;
@override final  double? distanceKm;
@override final  int? etaMinutes;
@override final  bool? isOpenNow;

/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorCopyWith<_Vendor> get copyWith => __$VendorCopyWithImpl<_Vendor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vendor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.location, location) || other.location == location)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.prepTimeMin, prepTimeMin) || other.prepTimeMin == prepTimeMin)&&(identical(other.prepTimeMax, prepTimeMax) || other.prepTimeMax == prepTimeMax)&&(identical(other.deliveryFeeCentimes, deliveryFeeCentimes) || other.deliveryFeeCentimes == deliveryFeeCentimes)&&(identical(other.minOrderCentimes, minOrderCentimes) || other.minOrderCentimes == minOrderCentimes)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&const DeepCollectionEquality().equals(other._openingHours, _openingHours)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.isOpenNow, isOpenNow) || other.isOpenNow == isOpenNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,description,category,logo,cover,phone,addressText,location,rating,ratingCount,prepTimeMin,prepTimeMax,deliveryFeeCentimes,minOrderCentimes,isOpen,const DeepCollectionEquality().hash(_openingHours),isFeatured,isActive,distanceKm,etaMinutes,isOpenNow]);

@override
String toString() {
  return 'Vendor(id: $id, name: $name, slug: $slug, description: $description, category: $category, logo: $logo, cover: $cover, phone: $phone, addressText: $addressText, location: $location, rating: $rating, ratingCount: $ratingCount, prepTimeMin: $prepTimeMin, prepTimeMax: $prepTimeMax, deliveryFeeCentimes: $deliveryFeeCentimes, minOrderCentimes: $minOrderCentimes, isOpen: $isOpen, openingHours: $openingHours, isFeatured: $isFeatured, isActive: $isActive, distanceKm: $distanceKm, etaMinutes: $etaMinutes, isOpenNow: $isOpenNow)';
}


}

/// @nodoc
abstract mixin class _$VendorCopyWith<$Res> implements $VendorCopyWith<$Res> {
  factory _$VendorCopyWith(_Vendor value, $Res Function(_Vendor) _then) = __$VendorCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String? description,@RefIdConverter() String? category, ImageRef? logo, ImageRef? cover, String phone, String addressText,@GeoPointConverter() LatLng? location, double rating, int ratingCount, int prepTimeMin, int prepTimeMax,@MoneyConverter() Money deliveryFeeCentimes,@MoneyConverter() Money minOrderCentimes, bool isOpen, List<OpeningHour> openingHours, bool isFeatured, bool isActive, double? distanceKm, int? etaMinutes, bool? isOpenNow
});


@override $ImageRefCopyWith<$Res>? get logo;@override $ImageRefCopyWith<$Res>? get cover;

}
/// @nodoc
class __$VendorCopyWithImpl<$Res>
    implements _$VendorCopyWith<$Res> {
  __$VendorCopyWithImpl(this._self, this._then);

  final _Vendor _self;
  final $Res Function(_Vendor) _then;

/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? category = freezed,Object? logo = freezed,Object? cover = freezed,Object? phone = null,Object? addressText = null,Object? location = freezed,Object? rating = null,Object? ratingCount = null,Object? prepTimeMin = null,Object? prepTimeMax = null,Object? deliveryFeeCentimes = null,Object? minOrderCentimes = null,Object? isOpen = null,Object? openingHours = null,Object? isFeatured = null,Object? isActive = null,Object? distanceKm = freezed,Object? etaMinutes = freezed,Object? isOpenNow = freezed,}) {
  return _then(_Vendor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as ImageRef?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as ImageRef?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,prepTimeMin: null == prepTimeMin ? _self.prepTimeMin : prepTimeMin // ignore: cast_nullable_to_non_nullable
as int,prepTimeMax: null == prepTimeMax ? _self.prepTimeMax : prepTimeMax // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeCentimes: null == deliveryFeeCentimes ? _self.deliveryFeeCentimes : deliveryFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,minOrderCentimes: null == minOrderCentimes ? _self.minOrderCentimes : minOrderCentimes // ignore: cast_nullable_to_non_nullable
as Money,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,openingHours: null == openingHours ? _self._openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as List<OpeningHour>,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,isOpenNow: freezed == isOpenNow ? _self.isOpenNow : isOpenNow // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageRefCopyWith<$Res>? get logo {
    if (_self.logo == null) {
    return null;
  }

  return $ImageRefCopyWith<$Res>(_self.logo!, (value) {
    return _then(_self.copyWith(logo: value));
  });
}/// Create a copy of Vendor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageRefCopyWith<$Res>? get cover {
    if (_self.cover == null) {
    return null;
  }

  return $ImageRefCopyWith<$Res>(_self.cover!, (value) {
    return _then(_self.copyWith(cover: value));
  });
}
}


/// @nodoc
mixin _$MenuSection {

 String get id; String get name; int get sortOrder;
/// Create a copy of MenuSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuSectionCopyWith<MenuSection> get copyWith => _$MenuSectionCopyWithImpl<MenuSection>(this as MenuSection, _$identity);

  /// Serializes this MenuSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuSection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sortOrder);

@override
String toString() {
  return 'MenuSection(id: $id, name: $name, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $MenuSectionCopyWith<$Res>  {
  factory $MenuSectionCopyWith(MenuSection value, $Res Function(MenuSection) _then) = _$MenuSectionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int sortOrder
});




}
/// @nodoc
class _$MenuSectionCopyWithImpl<$Res>
    implements $MenuSectionCopyWith<$Res> {
  _$MenuSectionCopyWithImpl(this._self, this._then);

  final MenuSection _self;
  final $Res Function(MenuSection) _then;

/// Create a copy of MenuSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? sortOrder = null,}) {
  return _then(MenuSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuSection].
extension MenuSectionPatterns on MenuSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuSection value)  $default,){
final _that = this;
switch (_that) {
case _MenuSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuSection value)?  $default,){
final _that = this;
switch (_that) {
case _MenuSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuSection() when $default != null:
return $default(_that.id,_that.name,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _MenuSection():
return $default(_that.id,_that.name,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _MenuSection() when $default != null:
return $default(_that.id,_that.name,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuSection implements MenuSection {
  const _MenuSection({required this.id, required this.name, this.sortOrder = 0});
  factory _MenuSection.fromJson(Map<String, dynamic> json) => _$MenuSectionFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  int sortOrder;

/// Create a copy of MenuSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuSectionCopyWith<_MenuSection> get copyWith => __$MenuSectionCopyWithImpl<_MenuSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuSection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sortOrder);

@override
String toString() {
  return 'MenuSection(id: $id, name: $name, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$MenuSectionCopyWith<$Res> implements $MenuSectionCopyWith<$Res> {
  factory _$MenuSectionCopyWith(_MenuSection value, $Res Function(_MenuSection) _then) = __$MenuSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int sortOrder
});




}
/// @nodoc
class __$MenuSectionCopyWithImpl<$Res>
    implements _$MenuSectionCopyWith<$Res> {
  __$MenuSectionCopyWithImpl(this._self, this._then);

  final _MenuSection _self;
  final $Res Function(_MenuSection) _then;

/// Create a copy of MenuSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? sortOrder = null,}) {
  return _then(_MenuSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
