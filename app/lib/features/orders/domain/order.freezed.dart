// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderPerson {

 String get id; String get fullName; String get phone;
/// Create a copy of OrderPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderPersonCopyWith<OrderPerson> get copyWith => _$OrderPersonCopyWithImpl<OrderPerson>(this as OrderPerson, _$identity);

  /// Serializes this OrderPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,phone);

@override
String toString() {
  return 'OrderPerson(id: $id, fullName: $fullName, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $OrderPersonCopyWith<$Res>  {
  factory $OrderPersonCopyWith(OrderPerson value, $Res Function(OrderPerson) _then) = _$OrderPersonCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String phone
});




}
/// @nodoc
class _$OrderPersonCopyWithImpl<$Res>
    implements $OrderPersonCopyWith<$Res> {
  _$OrderPersonCopyWithImpl(this._self, this._then);

  final OrderPerson _self;
  final $Res Function(OrderPerson) _then;

/// Create a copy of OrderPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? phone = null,}) {
  return _then(OrderPerson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderPerson].
extension OrderPersonPatterns on OrderPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderPerson value)  $default,){
final _that = this;
switch (_that) {
case _OrderPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderPerson value)?  $default,){
final _that = this;
switch (_that) {
case _OrderPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderPerson() when $default != null:
return $default(_that.id,_that.fullName,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String phone)  $default,) {final _that = this;
switch (_that) {
case _OrderPerson():
return $default(_that.id,_that.fullName,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _OrderPerson() when $default != null:
return $default(_that.id,_that.fullName,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderPerson implements OrderPerson {
  const _OrderPerson({required this.id, this.fullName = '', this.phone = ''});
  factory _OrderPerson.fromJson(Map<String, dynamic> json) => _$OrderPersonFromJson(json);

@override final  String id;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String phone;

/// Create a copy of OrderPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderPersonCopyWith<_OrderPerson> get copyWith => __$OrderPersonCopyWithImpl<_OrderPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderPersonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,phone);

@override
String toString() {
  return 'OrderPerson(id: $id, fullName: $fullName, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$OrderPersonCopyWith<$Res> implements $OrderPersonCopyWith<$Res> {
  factory _$OrderPersonCopyWith(_OrderPerson value, $Res Function(_OrderPerson) _then) = __$OrderPersonCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String phone
});




}
/// @nodoc
class __$OrderPersonCopyWithImpl<$Res>
    implements _$OrderPersonCopyWith<$Res> {
  __$OrderPersonCopyWithImpl(this._self, this._then);

  final _OrderPerson _self;
  final $Res Function(_OrderPerson) _then;

/// Create a copy of OrderPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? phone = null,}) {
  return _then(_OrderPerson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OrderAddress {

 String get label; String get wilaya; String get commune; String get street; String? get notes;
/// Create a copy of OrderAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderAddressCopyWith<OrderAddress> get copyWith => _$OrderAddressCopyWithImpl<OrderAddress>(this as OrderAddress, _$identity);

  /// Serializes this OrderAddress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderAddress&&(identical(other.label, label) || other.label == label)&&(identical(other.wilaya, wilaya) || other.wilaya == wilaya)&&(identical(other.commune, commune) || other.commune == commune)&&(identical(other.street, street) || other.street == street)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,wilaya,commune,street,notes);

@override
String toString() {
  return 'OrderAddress(label: $label, wilaya: $wilaya, commune: $commune, street: $street, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $OrderAddressCopyWith<$Res>  {
  factory $OrderAddressCopyWith(OrderAddress value, $Res Function(OrderAddress) _then) = _$OrderAddressCopyWithImpl;
@useResult
$Res call({
 String label, String wilaya, String commune, String street, String? notes
});




}
/// @nodoc
class _$OrderAddressCopyWithImpl<$Res>
    implements $OrderAddressCopyWith<$Res> {
  _$OrderAddressCopyWithImpl(this._self, this._then);

  final OrderAddress _self;
  final $Res Function(OrderAddress) _then;

/// Create a copy of OrderAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? wilaya = null,Object? commune = null,Object? street = null,Object? notes = freezed,}) {
  return _then(OrderAddress(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,wilaya: null == wilaya ? _self.wilaya : wilaya // ignore: cast_nullable_to_non_nullable
as String,commune: null == commune ? _self.commune : commune // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderAddress].
extension OrderAddressPatterns on OrderAddress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderAddress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderAddress value)  $default,){
final _that = this;
switch (_that) {
case _OrderAddress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderAddress value)?  $default,){
final _that = this;
switch (_that) {
case _OrderAddress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String wilaya,  String commune,  String street,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderAddress() when $default != null:
return $default(_that.label,_that.wilaya,_that.commune,_that.street,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String wilaya,  String commune,  String street,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _OrderAddress():
return $default(_that.label,_that.wilaya,_that.commune,_that.street,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String wilaya,  String commune,  String street,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _OrderAddress() when $default != null:
return $default(_that.label,_that.wilaya,_that.commune,_that.street,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderAddress extends OrderAddress {
  const _OrderAddress({this.label = '', this.wilaya = '', this.commune = '', this.street = '', this.notes}): super._();
  factory _OrderAddress.fromJson(Map<String, dynamic> json) => _$OrderAddressFromJson(json);

@override@JsonKey() final  String label;
@override@JsonKey() final  String wilaya;
@override@JsonKey() final  String commune;
@override@JsonKey() final  String street;
@override final  String? notes;

/// Create a copy of OrderAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderAddressCopyWith<_OrderAddress> get copyWith => __$OrderAddressCopyWithImpl<_OrderAddress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderAddressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderAddress&&(identical(other.label, label) || other.label == label)&&(identical(other.wilaya, wilaya) || other.wilaya == wilaya)&&(identical(other.commune, commune) || other.commune == commune)&&(identical(other.street, street) || other.street == street)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,wilaya,commune,street,notes);

@override
String toString() {
  return 'OrderAddress(label: $label, wilaya: $wilaya, commune: $commune, street: $street, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$OrderAddressCopyWith<$Res> implements $OrderAddressCopyWith<$Res> {
  factory _$OrderAddressCopyWith(_OrderAddress value, $Res Function(_OrderAddress) _then) = __$OrderAddressCopyWithImpl;
@override @useResult
$Res call({
 String label, String wilaya, String commune, String street, String? notes
});




}
/// @nodoc
class __$OrderAddressCopyWithImpl<$Res>
    implements _$OrderAddressCopyWith<$Res> {
  __$OrderAddressCopyWithImpl(this._self, this._then);

  final _OrderAddress _self;
  final $Res Function(_OrderAddress) _then;

/// Create a copy of OrderAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? wilaya = null,Object? commune = null,Object? street = null,Object? notes = freezed,}) {
  return _then(_OrderAddress(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,wilaya: null == wilaya ? _self.wilaya : wilaya // ignore: cast_nullable_to_non_nullable
as String,commune: null == commune ? _self.commune : commune // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrderSelectedOption {

 String get name; String get value;@MoneyConverter() Money get priceDeltaCentimes;
/// Create a copy of OrderSelectedOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSelectedOptionCopyWith<OrderSelectedOption> get copyWith => _$OrderSelectedOptionCopyWithImpl<OrderSelectedOption>(this as OrderSelectedOption, _$identity);

  /// Serializes this OrderSelectedOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSelectedOption&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.priceDeltaCentimes, priceDeltaCentimes) || other.priceDeltaCentimes == priceDeltaCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,priceDeltaCentimes);

@override
String toString() {
  return 'OrderSelectedOption(name: $name, value: $value, priceDeltaCentimes: $priceDeltaCentimes)';
}


}

/// @nodoc
abstract mixin class $OrderSelectedOptionCopyWith<$Res>  {
  factory $OrderSelectedOptionCopyWith(OrderSelectedOption value, $Res Function(OrderSelectedOption) _then) = _$OrderSelectedOptionCopyWithImpl;
@useResult
$Res call({
 String name, String value,@MoneyConverter() Money priceDeltaCentimes
});




}
/// @nodoc
class _$OrderSelectedOptionCopyWithImpl<$Res>
    implements $OrderSelectedOptionCopyWith<$Res> {
  _$OrderSelectedOptionCopyWithImpl(this._self, this._then);

  final OrderSelectedOption _self;
  final $Res Function(OrderSelectedOption) _then;

/// Create a copy of OrderSelectedOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? value = null,Object? priceDeltaCentimes = null,}) {
  return _then(OrderSelectedOption(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,priceDeltaCentimes: null == priceDeltaCentimes ? _self.priceDeltaCentimes : priceDeltaCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderSelectedOption].
extension OrderSelectedOptionPatterns on OrderSelectedOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSelectedOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSelectedOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSelectedOption value)  $default,){
final _that = this;
switch (_that) {
case _OrderSelectedOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSelectedOption value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSelectedOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String value, @MoneyConverter()  Money priceDeltaCentimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSelectedOption() when $default != null:
return $default(_that.name,_that.value,_that.priceDeltaCentimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String value, @MoneyConverter()  Money priceDeltaCentimes)  $default,) {final _that = this;
switch (_that) {
case _OrderSelectedOption():
return $default(_that.name,_that.value,_that.priceDeltaCentimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String value, @MoneyConverter()  Money priceDeltaCentimes)?  $default,) {final _that = this;
switch (_that) {
case _OrderSelectedOption() when $default != null:
return $default(_that.name,_that.value,_that.priceDeltaCentimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderSelectedOption implements OrderSelectedOption {
  const _OrderSelectedOption({required this.name, required this.value, @MoneyConverter() this.priceDeltaCentimes = const Money.zero()});
  factory _OrderSelectedOption.fromJson(Map<String, dynamic> json) => _$OrderSelectedOptionFromJson(json);

@override final  String name;
@override final  String value;
@override@JsonKey()@MoneyConverter() final  Money priceDeltaCentimes;

/// Create a copy of OrderSelectedOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSelectedOptionCopyWith<_OrderSelectedOption> get copyWith => __$OrderSelectedOptionCopyWithImpl<_OrderSelectedOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderSelectedOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSelectedOption&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.priceDeltaCentimes, priceDeltaCentimes) || other.priceDeltaCentimes == priceDeltaCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,priceDeltaCentimes);

@override
String toString() {
  return 'OrderSelectedOption(name: $name, value: $value, priceDeltaCentimes: $priceDeltaCentimes)';
}


}

/// @nodoc
abstract mixin class _$OrderSelectedOptionCopyWith<$Res> implements $OrderSelectedOptionCopyWith<$Res> {
  factory _$OrderSelectedOptionCopyWith(_OrderSelectedOption value, $Res Function(_OrderSelectedOption) _then) = __$OrderSelectedOptionCopyWithImpl;
@override @useResult
$Res call({
 String name, String value,@MoneyConverter() Money priceDeltaCentimes
});




}
/// @nodoc
class __$OrderSelectedOptionCopyWithImpl<$Res>
    implements _$OrderSelectedOptionCopyWith<$Res> {
  __$OrderSelectedOptionCopyWithImpl(this._self, this._then);

  final _OrderSelectedOption _self;
  final $Res Function(_OrderSelectedOption) _then;

/// Create a copy of OrderSelectedOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? value = null,Object? priceDeltaCentimes = null,}) {
  return _then(_OrderSelectedOption(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,priceDeltaCentimes: null == priceDeltaCentimes ? _self.priceDeltaCentimes : priceDeltaCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}


/// @nodoc
mixin _$OrderItem {

@RefIdConverter() String? get product; String get nameSnapshot;@MoneyConverter() Money get unitPriceCentimes; int get qty; List<OrderSelectedOption> get selectedOptions;@MoneyConverter() Money get lineTotalCentimes;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.product, product) || other.product == product)&&(identical(other.nameSnapshot, nameSnapshot) || other.nameSnapshot == nameSnapshot)&&(identical(other.unitPriceCentimes, unitPriceCentimes) || other.unitPriceCentimes == unitPriceCentimes)&&(identical(other.qty, qty) || other.qty == qty)&&const DeepCollectionEquality().equals(other.selectedOptions, selectedOptions)&&(identical(other.lineTotalCentimes, lineTotalCentimes) || other.lineTotalCentimes == lineTotalCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,nameSnapshot,unitPriceCentimes,qty,const DeepCollectionEquality().hash(selectedOptions),lineTotalCentimes);

@override
String toString() {
  return 'OrderItem(product: $product, nameSnapshot: $nameSnapshot, unitPriceCentimes: $unitPriceCentimes, qty: $qty, selectedOptions: $selectedOptions, lineTotalCentimes: $lineTotalCentimes)';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
@RefIdConverter() String? product, String nameSnapshot,@MoneyConverter() Money unitPriceCentimes, int qty, List<OrderSelectedOption> selectedOptions,@MoneyConverter() Money lineTotalCentimes
});




}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = freezed,Object? nameSnapshot = null,Object? unitPriceCentimes = null,Object? qty = null,Object? selectedOptions = null,Object? lineTotalCentimes = null,}) {
  return _then(OrderItem(
product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String?,nameSnapshot: null == nameSnapshot ? _self.nameSnapshot : nameSnapshot // ignore: cast_nullable_to_non_nullable
as String,unitPriceCentimes: null == unitPriceCentimes ? _self.unitPriceCentimes : unitPriceCentimes // ignore: cast_nullable_to_non_nullable
as Money,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,selectedOptions: null == selectedOptions ? _self.selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as List<OrderSelectedOption>,lineTotalCentimes: null == lineTotalCentimes ? _self.lineTotalCentimes : lineTotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@RefIdConverter()  String? product,  String nameSnapshot, @MoneyConverter()  Money unitPriceCentimes,  int qty,  List<OrderSelectedOption> selectedOptions, @MoneyConverter()  Money lineTotalCentimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.product,_that.nameSnapshot,_that.unitPriceCentimes,_that.qty,_that.selectedOptions,_that.lineTotalCentimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@RefIdConverter()  String? product,  String nameSnapshot, @MoneyConverter()  Money unitPriceCentimes,  int qty,  List<OrderSelectedOption> selectedOptions, @MoneyConverter()  Money lineTotalCentimes)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.product,_that.nameSnapshot,_that.unitPriceCentimes,_that.qty,_that.selectedOptions,_that.lineTotalCentimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@RefIdConverter()  String? product,  String nameSnapshot, @MoneyConverter()  Money unitPriceCentimes,  int qty,  List<OrderSelectedOption> selectedOptions, @MoneyConverter()  Money lineTotalCentimes)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.product,_that.nameSnapshot,_that.unitPriceCentimes,_that.qty,_that.selectedOptions,_that.lineTotalCentimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem extends OrderItem {
  const _OrderItem({@RefIdConverter() this.product, this.nameSnapshot = '', @MoneyConverter() this.unitPriceCentimes = const Money.zero(), this.qty = 1,  List<OrderSelectedOption> selectedOptions = const <OrderSelectedOption>[], @MoneyConverter() this.lineTotalCentimes = const Money.zero()}): _selectedOptions = selectedOptions,super._();
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override@RefIdConverter() final  String? product;
@override@JsonKey() final  String nameSnapshot;
@override@JsonKey()@MoneyConverter() final  Money unitPriceCentimes;
@override@JsonKey() final  int qty;
 final  List<OrderSelectedOption> _selectedOptions;
@override@JsonKey() List<OrderSelectedOption> get selectedOptions {
  if (_selectedOptions is EqualUnmodifiableListView) return _selectedOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedOptions);
}

@override@JsonKey()@MoneyConverter() final  Money lineTotalCentimes;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.product, product) || other.product == product)&&(identical(other.nameSnapshot, nameSnapshot) || other.nameSnapshot == nameSnapshot)&&(identical(other.unitPriceCentimes, unitPriceCentimes) || other.unitPriceCentimes == unitPriceCentimes)&&(identical(other.qty, qty) || other.qty == qty)&&const DeepCollectionEquality().equals(other._selectedOptions, _selectedOptions)&&(identical(other.lineTotalCentimes, lineTotalCentimes) || other.lineTotalCentimes == lineTotalCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,nameSnapshot,unitPriceCentimes,qty,const DeepCollectionEquality().hash(_selectedOptions),lineTotalCentimes);

@override
String toString() {
  return 'OrderItem(product: $product, nameSnapshot: $nameSnapshot, unitPriceCentimes: $unitPriceCentimes, qty: $qty, selectedOptions: $selectedOptions, lineTotalCentimes: $lineTotalCentimes)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
@RefIdConverter() String? product, String nameSnapshot,@MoneyConverter() Money unitPriceCentimes, int qty, List<OrderSelectedOption> selectedOptions,@MoneyConverter() Money lineTotalCentimes
});




}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = freezed,Object? nameSnapshot = null,Object? unitPriceCentimes = null,Object? qty = null,Object? selectedOptions = null,Object? lineTotalCentimes = null,}) {
  return _then(_OrderItem(
product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String?,nameSnapshot: null == nameSnapshot ? _self.nameSnapshot : nameSnapshot // ignore: cast_nullable_to_non_nullable
as String,unitPriceCentimes: null == unitPriceCentimes ? _self.unitPriceCentimes : unitPriceCentimes // ignore: cast_nullable_to_non_nullable
as Money,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,selectedOptions: null == selectedOptions ? _self._selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as List<OrderSelectedOption>,lineTotalCentimes: null == lineTotalCentimes ? _self.lineTotalCentimes : lineTotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}


/// @nodoc
mixin _$OrderEvent {

@JsonKey(fromJson: OrderStatus.parse) OrderStatus get to;@DateConverter() DateTime get at;@JsonKey(fromJson: _statusOrNull) OrderStatus? get from; String get actorRole; String? get note;
/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderEventCopyWith<OrderEvent> get copyWith => _$OrderEventCopyWithImpl<OrderEvent>(this as OrderEvent, _$identity);

  /// Serializes this OrderEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderEvent&&(identical(other.to, to) || other.to == to)&&(identical(other.at, at) || other.at == at)&&(identical(other.from, from) || other.from == from)&&(identical(other.actorRole, actorRole) || other.actorRole == actorRole)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,to,at,from,actorRole,note);

@override
String toString() {
  return 'OrderEvent(to: $to, at: $at, from: $from, actorRole: $actorRole, note: $note)';
}


}

/// @nodoc
abstract mixin class $OrderEventCopyWith<$Res>  {
  factory $OrderEventCopyWith(OrderEvent value, $Res Function(OrderEvent) _then) = _$OrderEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: OrderStatus.parse) OrderStatus to,@DateConverter() DateTime at,@JsonKey(fromJson: _statusOrNull) OrderStatus? from, String actorRole, String? note
});




}
/// @nodoc
class _$OrderEventCopyWithImpl<$Res>
    implements $OrderEventCopyWith<$Res> {
  _$OrderEventCopyWithImpl(this._self, this._then);

  final OrderEvent _self;
  final $Res Function(OrderEvent) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? to = null,Object? at = null,Object? from = freezed,Object? actorRole = null,Object? note = freezed,}) {
  return _then(OrderEvent(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as OrderStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as OrderStatus?,actorRole: null == actorRole ? _self.actorRole : actorRole // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderEvent].
extension OrderEventPatterns on OrderEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderEvent value)  $default,){
final _that = this;
switch (_that) {
case _OrderEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderEvent value)?  $default,){
final _that = this;
switch (_that) {
case _OrderEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: OrderStatus.parse)  OrderStatus to, @DateConverter()  DateTime at, @JsonKey(fromJson: _statusOrNull)  OrderStatus? from,  String actorRole,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderEvent() when $default != null:
return $default(_that.to,_that.at,_that.from,_that.actorRole,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: OrderStatus.parse)  OrderStatus to, @DateConverter()  DateTime at, @JsonKey(fromJson: _statusOrNull)  OrderStatus? from,  String actorRole,  String? note)  $default,) {final _that = this;
switch (_that) {
case _OrderEvent():
return $default(_that.to,_that.at,_that.from,_that.actorRole,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: OrderStatus.parse)  OrderStatus to, @DateConverter()  DateTime at, @JsonKey(fromJson: _statusOrNull)  OrderStatus? from,  String actorRole,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _OrderEvent() when $default != null:
return $default(_that.to,_that.at,_that.from,_that.actorRole,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderEvent implements OrderEvent {
  const _OrderEvent({@JsonKey(fromJson: OrderStatus.parse) required this.to, @DateConverter() required this.at, @JsonKey(fromJson: _statusOrNull) this.from, this.actorRole = 'system', this.note});
  factory _OrderEvent.fromJson(Map<String, dynamic> json) => _$OrderEventFromJson(json);

@override@JsonKey(fromJson: OrderStatus.parse) final  OrderStatus to;
@override@DateConverter() final  DateTime at;
@override@JsonKey(fromJson: _statusOrNull) final  OrderStatus? from;
@override@JsonKey() final  String actorRole;
@override final  String? note;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderEventCopyWith<_OrderEvent> get copyWith => __$OrderEventCopyWithImpl<_OrderEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderEvent&&(identical(other.to, to) || other.to == to)&&(identical(other.at, at) || other.at == at)&&(identical(other.from, from) || other.from == from)&&(identical(other.actorRole, actorRole) || other.actorRole == actorRole)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,to,at,from,actorRole,note);

@override
String toString() {
  return 'OrderEvent(to: $to, at: $at, from: $from, actorRole: $actorRole, note: $note)';
}


}

/// @nodoc
abstract mixin class _$OrderEventCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory _$OrderEventCopyWith(_OrderEvent value, $Res Function(_OrderEvent) _then) = __$OrderEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: OrderStatus.parse) OrderStatus to,@DateConverter() DateTime at,@JsonKey(fromJson: _statusOrNull) OrderStatus? from, String actorRole, String? note
});




}
/// @nodoc
class __$OrderEventCopyWithImpl<$Res>
    implements _$OrderEventCopyWith<$Res> {
  __$OrderEventCopyWithImpl(this._self, this._then);

  final _OrderEvent _self;
  final $Res Function(_OrderEvent) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? to = null,Object? at = null,Object? from = freezed,Object? actorRole = null,Object? note = freezed,}) {
  return _then(_OrderEvent(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as OrderStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as OrderStatus?,actorRole: null == actorRole ? _self.actorRole : actorRole // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AppOrder {

 String get id; String get code;@DateConverter() DateTime get createdAt;@JsonKey(fromJson: OrderStatus.parse) OrderStatus get status;@JsonKey(fromJson: _personOrNull) OrderPerson? get customer;@JsonKey(fromJson: _vendorOrNull) Vendor? get vendor;@JsonKey(fromJson: _personOrNull) OrderPerson? get agent; DeliveryType get deliveryType; PaymentMethod get paymentMethod; OrderAddress get address;@GeoPointConverter() LatLng? get deliveryLocation; String? get customerNote; List<OrderItem> get items;@MoneyConverter() Money get subtotalCentimes;@MoneyConverter() Money get serviceFeeCentimes;@MoneyConverter() Money get deliveryFeeCentimes;@MoneyConverter() Money get discountCentimes;@MoneyConverter() Money get totalCentimes; int get pointsUsed; int get pointsEarned; List<OrderEvent> get events; String? get cancelledReason;@NullableDateConverter() DateTime? get confirmedAt;@NullableDateConverter() DateTime? get assignedAt;@NullableDateConverter() DateTime? get acceptedAt;@NullableDateConverter() DateTime? get pickedUpAt;@NullableDateConverter() DateTime? get deliveredAt; bool get isLate;
/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppOrderCopyWith<AppOrder> get copyWith => _$AppOrderCopyWithImpl<AppOrder>(this as AppOrder, _$identity);

  /// Serializes this AppOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.deliveryType, deliveryType) || other.deliveryType == deliveryType)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.address, address) || other.address == address)&&(identical(other.deliveryLocation, deliveryLocation) || other.deliveryLocation == deliveryLocation)&&(identical(other.customerNote, customerNote) || other.customerNote == customerNote)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalCentimes, subtotalCentimes) || other.subtotalCentimes == subtotalCentimes)&&(identical(other.serviceFeeCentimes, serviceFeeCentimes) || other.serviceFeeCentimes == serviceFeeCentimes)&&(identical(other.deliveryFeeCentimes, deliveryFeeCentimes) || other.deliveryFeeCentimes == deliveryFeeCentimes)&&(identical(other.discountCentimes, discountCentimes) || other.discountCentimes == discountCentimes)&&(identical(other.totalCentimes, totalCentimes) || other.totalCentimes == totalCentimes)&&(identical(other.pointsUsed, pointsUsed) || other.pointsUsed == pointsUsed)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.cancelledReason, cancelledReason) || other.cancelledReason == cancelledReason)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.pickedUpAt, pickedUpAt) || other.pickedUpAt == pickedUpAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.isLate, isLate) || other.isLate == isLate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,code,createdAt,status,customer,vendor,agent,deliveryType,paymentMethod,address,deliveryLocation,customerNote,const DeepCollectionEquality().hash(items),subtotalCentimes,serviceFeeCentimes,deliveryFeeCentimes,discountCentimes,totalCentimes,pointsUsed,pointsEarned,const DeepCollectionEquality().hash(events),cancelledReason,confirmedAt,assignedAt,acceptedAt,pickedUpAt,deliveredAt,isLate]);

@override
String toString() {
  return 'AppOrder(id: $id, code: $code, createdAt: $createdAt, status: $status, customer: $customer, vendor: $vendor, agent: $agent, deliveryType: $deliveryType, paymentMethod: $paymentMethod, address: $address, deliveryLocation: $deliveryLocation, customerNote: $customerNote, items: $items, subtotalCentimes: $subtotalCentimes, serviceFeeCentimes: $serviceFeeCentimes, deliveryFeeCentimes: $deliveryFeeCentimes, discountCentimes: $discountCentimes, totalCentimes: $totalCentimes, pointsUsed: $pointsUsed, pointsEarned: $pointsEarned, events: $events, cancelledReason: $cancelledReason, confirmedAt: $confirmedAt, assignedAt: $assignedAt, acceptedAt: $acceptedAt, pickedUpAt: $pickedUpAt, deliveredAt: $deliveredAt, isLate: $isLate)';
}


}

/// @nodoc
abstract mixin class $AppOrderCopyWith<$Res>  {
  factory $AppOrderCopyWith(AppOrder value, $Res Function(AppOrder) _then) = _$AppOrderCopyWithImpl;
@useResult
$Res call({
 String id, String code,@DateConverter() DateTime createdAt,@JsonKey(fromJson: OrderStatus.parse) OrderStatus status,@JsonKey(fromJson: _personOrNull) OrderPerson? customer,@JsonKey(fromJson: _vendorOrNull) Vendor? vendor,@JsonKey(fromJson: _personOrNull) OrderPerson? agent, DeliveryType deliveryType, PaymentMethod paymentMethod, OrderAddress address,@GeoPointConverter() LatLng? deliveryLocation, String? customerNote, List<OrderItem> items,@MoneyConverter() Money subtotalCentimes,@MoneyConverter() Money serviceFeeCentimes,@MoneyConverter() Money deliveryFeeCentimes,@MoneyConverter() Money discountCentimes,@MoneyConverter() Money totalCentimes, int pointsUsed, int pointsEarned, List<OrderEvent> events, String? cancelledReason,@NullableDateConverter() DateTime? confirmedAt,@NullableDateConverter() DateTime? assignedAt,@NullableDateConverter() DateTime? acceptedAt,@NullableDateConverter() DateTime? pickedUpAt,@NullableDateConverter() DateTime? deliveredAt, bool isLate
});


$OrderPersonCopyWith<$Res>? get customer;$VendorCopyWith<$Res>? get vendor;$OrderPersonCopyWith<$Res>? get agent;$OrderAddressCopyWith<$Res> get address;

}
/// @nodoc
class _$AppOrderCopyWithImpl<$Res>
    implements $AppOrderCopyWith<$Res> {
  _$AppOrderCopyWithImpl(this._self, this._then);

  final AppOrder _self;
  final $Res Function(AppOrder) _then;

/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? createdAt = null,Object? status = null,Object? customer = freezed,Object? vendor = freezed,Object? agent = freezed,Object? deliveryType = null,Object? paymentMethod = null,Object? address = null,Object? deliveryLocation = freezed,Object? customerNote = freezed,Object? items = null,Object? subtotalCentimes = null,Object? serviceFeeCentimes = null,Object? deliveryFeeCentimes = null,Object? discountCentimes = null,Object? totalCentimes = null,Object? pointsUsed = null,Object? pointsEarned = null,Object? events = null,Object? cancelledReason = freezed,Object? confirmedAt = freezed,Object? assignedAt = freezed,Object? acceptedAt = freezed,Object? pickedUpAt = freezed,Object? deliveredAt = freezed,Object? isLate = null,}) {
  return _then(AppOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as OrderPerson?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as Vendor?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as OrderPerson?,deliveryType: null == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as DeliveryType,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddress,deliveryLocation: freezed == deliveryLocation ? _self.deliveryLocation : deliveryLocation // ignore: cast_nullable_to_non_nullable
as LatLng?,customerNote: freezed == customerNote ? _self.customerNote : customerNote // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,subtotalCentimes: null == subtotalCentimes ? _self.subtotalCentimes : subtotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,serviceFeeCentimes: null == serviceFeeCentimes ? _self.serviceFeeCentimes : serviceFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,deliveryFeeCentimes: null == deliveryFeeCentimes ? _self.deliveryFeeCentimes : deliveryFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,discountCentimes: null == discountCentimes ? _self.discountCentimes : discountCentimes // ignore: cast_nullable_to_non_nullable
as Money,totalCentimes: null == totalCentimes ? _self.totalCentimes : totalCentimes // ignore: cast_nullable_to_non_nullable
as Money,pointsUsed: null == pointsUsed ? _self.pointsUsed : pointsUsed // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<OrderEvent>,cancelledReason: freezed == cancelledReason ? _self.cancelledReason : cancelledReason // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pickedUpAt: freezed == pickedUpAt ? _self.pickedUpAt : pickedUpAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLate: null == isLate ? _self.isLate : isLate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderPersonCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $OrderPersonCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorCopyWith<$Res>? get vendor {
    if (_self.vendor == null) {
    return null;
  }

  return $VendorCopyWith<$Res>(_self.vendor!, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderPersonCopyWith<$Res>? get agent {
    if (_self.agent == null) {
    return null;
  }

  return $OrderPersonCopyWith<$Res>(_self.agent!, (value) {
    return _then(_self.copyWith(agent: value));
  });
}/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressCopyWith<$Res> get address {
  
  return $OrderAddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppOrder].
extension AppOrderPatterns on AppOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppOrder value)  $default,){
final _that = this;
switch (_that) {
case _AppOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppOrder value)?  $default,){
final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code, @DateConverter()  DateTime createdAt, @JsonKey(fromJson: OrderStatus.parse)  OrderStatus status, @JsonKey(fromJson: _personOrNull)  OrderPerson? customer, @JsonKey(fromJson: _vendorOrNull)  Vendor? vendor, @JsonKey(fromJson: _personOrNull)  OrderPerson? agent,  DeliveryType deliveryType,  PaymentMethod paymentMethod,  OrderAddress address, @GeoPointConverter()  LatLng? deliveryLocation,  String? customerNote,  List<OrderItem> items, @MoneyConverter()  Money subtotalCentimes, @MoneyConverter()  Money serviceFeeCentimes, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money discountCentimes, @MoneyConverter()  Money totalCentimes,  int pointsUsed,  int pointsEarned,  List<OrderEvent> events,  String? cancelledReason, @NullableDateConverter()  DateTime? confirmedAt, @NullableDateConverter()  DateTime? assignedAt, @NullableDateConverter()  DateTime? acceptedAt, @NullableDateConverter()  DateTime? pickedUpAt, @NullableDateConverter()  DateTime? deliveredAt,  bool isLate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
return $default(_that.id,_that.code,_that.createdAt,_that.status,_that.customer,_that.vendor,_that.agent,_that.deliveryType,_that.paymentMethod,_that.address,_that.deliveryLocation,_that.customerNote,_that.items,_that.subtotalCentimes,_that.serviceFeeCentimes,_that.deliveryFeeCentimes,_that.discountCentimes,_that.totalCentimes,_that.pointsUsed,_that.pointsEarned,_that.events,_that.cancelledReason,_that.confirmedAt,_that.assignedAt,_that.acceptedAt,_that.pickedUpAt,_that.deliveredAt,_that.isLate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code, @DateConverter()  DateTime createdAt, @JsonKey(fromJson: OrderStatus.parse)  OrderStatus status, @JsonKey(fromJson: _personOrNull)  OrderPerson? customer, @JsonKey(fromJson: _vendorOrNull)  Vendor? vendor, @JsonKey(fromJson: _personOrNull)  OrderPerson? agent,  DeliveryType deliveryType,  PaymentMethod paymentMethod,  OrderAddress address, @GeoPointConverter()  LatLng? deliveryLocation,  String? customerNote,  List<OrderItem> items, @MoneyConverter()  Money subtotalCentimes, @MoneyConverter()  Money serviceFeeCentimes, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money discountCentimes, @MoneyConverter()  Money totalCentimes,  int pointsUsed,  int pointsEarned,  List<OrderEvent> events,  String? cancelledReason, @NullableDateConverter()  DateTime? confirmedAt, @NullableDateConverter()  DateTime? assignedAt, @NullableDateConverter()  DateTime? acceptedAt, @NullableDateConverter()  DateTime? pickedUpAt, @NullableDateConverter()  DateTime? deliveredAt,  bool isLate)  $default,) {final _that = this;
switch (_that) {
case _AppOrder():
return $default(_that.id,_that.code,_that.createdAt,_that.status,_that.customer,_that.vendor,_that.agent,_that.deliveryType,_that.paymentMethod,_that.address,_that.deliveryLocation,_that.customerNote,_that.items,_that.subtotalCentimes,_that.serviceFeeCentimes,_that.deliveryFeeCentimes,_that.discountCentimes,_that.totalCentimes,_that.pointsUsed,_that.pointsEarned,_that.events,_that.cancelledReason,_that.confirmedAt,_that.assignedAt,_that.acceptedAt,_that.pickedUpAt,_that.deliveredAt,_that.isLate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code, @DateConverter()  DateTime createdAt, @JsonKey(fromJson: OrderStatus.parse)  OrderStatus status, @JsonKey(fromJson: _personOrNull)  OrderPerson? customer, @JsonKey(fromJson: _vendorOrNull)  Vendor? vendor, @JsonKey(fromJson: _personOrNull)  OrderPerson? agent,  DeliveryType deliveryType,  PaymentMethod paymentMethod,  OrderAddress address, @GeoPointConverter()  LatLng? deliveryLocation,  String? customerNote,  List<OrderItem> items, @MoneyConverter()  Money subtotalCentimes, @MoneyConverter()  Money serviceFeeCentimes, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money discountCentimes, @MoneyConverter()  Money totalCentimes,  int pointsUsed,  int pointsEarned,  List<OrderEvent> events,  String? cancelledReason, @NullableDateConverter()  DateTime? confirmedAt, @NullableDateConverter()  DateTime? assignedAt, @NullableDateConverter()  DateTime? acceptedAt, @NullableDateConverter()  DateTime? pickedUpAt, @NullableDateConverter()  DateTime? deliveredAt,  bool isLate)?  $default,) {final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
return $default(_that.id,_that.code,_that.createdAt,_that.status,_that.customer,_that.vendor,_that.agent,_that.deliveryType,_that.paymentMethod,_that.address,_that.deliveryLocation,_that.customerNote,_that.items,_that.subtotalCentimes,_that.serviceFeeCentimes,_that.deliveryFeeCentimes,_that.discountCentimes,_that.totalCentimes,_that.pointsUsed,_that.pointsEarned,_that.events,_that.cancelledReason,_that.confirmedAt,_that.assignedAt,_that.acceptedAt,_that.pickedUpAt,_that.deliveredAt,_that.isLate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppOrder extends AppOrder {
  const _AppOrder({required this.id, required this.code, @DateConverter() required this.createdAt, @JsonKey(fromJson: OrderStatus.parse) this.status = OrderStatus.pending, @JsonKey(fromJson: _personOrNull) this.customer, @JsonKey(fromJson: _vendorOrNull) this.vendor, @JsonKey(fromJson: _personOrNull) this.agent, this.deliveryType = DeliveryType.normal, this.paymentMethod = PaymentMethod.cash, this.address = const OrderAddress(), @GeoPointConverter() this.deliveryLocation, this.customerNote,  List<OrderItem> items = const <OrderItem>[], @MoneyConverter() this.subtotalCentimes = const Money.zero(), @MoneyConverter() this.serviceFeeCentimes = const Money.zero(), @MoneyConverter() this.deliveryFeeCentimes = const Money.zero(), @MoneyConverter() this.discountCentimes = const Money.zero(), @MoneyConverter() this.totalCentimes = const Money.zero(), this.pointsUsed = 0, this.pointsEarned = 0,  List<OrderEvent> events = const <OrderEvent>[], this.cancelledReason, @NullableDateConverter() this.confirmedAt, @NullableDateConverter() this.assignedAt, @NullableDateConverter() this.acceptedAt, @NullableDateConverter() this.pickedUpAt, @NullableDateConverter() this.deliveredAt, this.isLate = false}): _items = items,_events = events,super._();
  factory _AppOrder.fromJson(Map<String, dynamic> json) => _$AppOrderFromJson(json);

@override final  String id;
@override final  String code;
@override@DateConverter() final  DateTime createdAt;
@override@JsonKey(fromJson: OrderStatus.parse) final  OrderStatus status;
@override@JsonKey(fromJson: _personOrNull) final  OrderPerson? customer;
@override@JsonKey(fromJson: _vendorOrNull) final  Vendor? vendor;
@override@JsonKey(fromJson: _personOrNull) final  OrderPerson? agent;
@override@JsonKey() final  DeliveryType deliveryType;
@override@JsonKey() final  PaymentMethod paymentMethod;
@override@JsonKey() final  OrderAddress address;
@override@GeoPointConverter() final  LatLng? deliveryLocation;
@override final  String? customerNote;
 final  List<OrderItem> _items;
@override@JsonKey() List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey()@MoneyConverter() final  Money subtotalCentimes;
@override@JsonKey()@MoneyConverter() final  Money serviceFeeCentimes;
@override@JsonKey()@MoneyConverter() final  Money deliveryFeeCentimes;
@override@JsonKey()@MoneyConverter() final  Money discountCentimes;
@override@JsonKey()@MoneyConverter() final  Money totalCentimes;
@override@JsonKey() final  int pointsUsed;
@override@JsonKey() final  int pointsEarned;
 final  List<OrderEvent> _events;
@override@JsonKey() List<OrderEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  String? cancelledReason;
@override@NullableDateConverter() final  DateTime? confirmedAt;
@override@NullableDateConverter() final  DateTime? assignedAt;
@override@NullableDateConverter() final  DateTime? acceptedAt;
@override@NullableDateConverter() final  DateTime? pickedUpAt;
@override@NullableDateConverter() final  DateTime? deliveredAt;
@override@JsonKey() final  bool isLate;

/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppOrderCopyWith<_AppOrder> get copyWith => __$AppOrderCopyWithImpl<_AppOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.deliveryType, deliveryType) || other.deliveryType == deliveryType)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.address, address) || other.address == address)&&(identical(other.deliveryLocation, deliveryLocation) || other.deliveryLocation == deliveryLocation)&&(identical(other.customerNote, customerNote) || other.customerNote == customerNote)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalCentimes, subtotalCentimes) || other.subtotalCentimes == subtotalCentimes)&&(identical(other.serviceFeeCentimes, serviceFeeCentimes) || other.serviceFeeCentimes == serviceFeeCentimes)&&(identical(other.deliveryFeeCentimes, deliveryFeeCentimes) || other.deliveryFeeCentimes == deliveryFeeCentimes)&&(identical(other.discountCentimes, discountCentimes) || other.discountCentimes == discountCentimes)&&(identical(other.totalCentimes, totalCentimes) || other.totalCentimes == totalCentimes)&&(identical(other.pointsUsed, pointsUsed) || other.pointsUsed == pointsUsed)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.cancelledReason, cancelledReason) || other.cancelledReason == cancelledReason)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.pickedUpAt, pickedUpAt) || other.pickedUpAt == pickedUpAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.isLate, isLate) || other.isLate == isLate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,code,createdAt,status,customer,vendor,agent,deliveryType,paymentMethod,address,deliveryLocation,customerNote,const DeepCollectionEquality().hash(_items),subtotalCentimes,serviceFeeCentimes,deliveryFeeCentimes,discountCentimes,totalCentimes,pointsUsed,pointsEarned,const DeepCollectionEquality().hash(_events),cancelledReason,confirmedAt,assignedAt,acceptedAt,pickedUpAt,deliveredAt,isLate]);

@override
String toString() {
  return 'AppOrder(id: $id, code: $code, createdAt: $createdAt, status: $status, customer: $customer, vendor: $vendor, agent: $agent, deliveryType: $deliveryType, paymentMethod: $paymentMethod, address: $address, deliveryLocation: $deliveryLocation, customerNote: $customerNote, items: $items, subtotalCentimes: $subtotalCentimes, serviceFeeCentimes: $serviceFeeCentimes, deliveryFeeCentimes: $deliveryFeeCentimes, discountCentimes: $discountCentimes, totalCentimes: $totalCentimes, pointsUsed: $pointsUsed, pointsEarned: $pointsEarned, events: $events, cancelledReason: $cancelledReason, confirmedAt: $confirmedAt, assignedAt: $assignedAt, acceptedAt: $acceptedAt, pickedUpAt: $pickedUpAt, deliveredAt: $deliveredAt, isLate: $isLate)';
}


}

/// @nodoc
abstract mixin class _$AppOrderCopyWith<$Res> implements $AppOrderCopyWith<$Res> {
  factory _$AppOrderCopyWith(_AppOrder value, $Res Function(_AppOrder) _then) = __$AppOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String code,@DateConverter() DateTime createdAt,@JsonKey(fromJson: OrderStatus.parse) OrderStatus status,@JsonKey(fromJson: _personOrNull) OrderPerson? customer,@JsonKey(fromJson: _vendorOrNull) Vendor? vendor,@JsonKey(fromJson: _personOrNull) OrderPerson? agent, DeliveryType deliveryType, PaymentMethod paymentMethod, OrderAddress address,@GeoPointConverter() LatLng? deliveryLocation, String? customerNote, List<OrderItem> items,@MoneyConverter() Money subtotalCentimes,@MoneyConverter() Money serviceFeeCentimes,@MoneyConverter() Money deliveryFeeCentimes,@MoneyConverter() Money discountCentimes,@MoneyConverter() Money totalCentimes, int pointsUsed, int pointsEarned, List<OrderEvent> events, String? cancelledReason,@NullableDateConverter() DateTime? confirmedAt,@NullableDateConverter() DateTime? assignedAt,@NullableDateConverter() DateTime? acceptedAt,@NullableDateConverter() DateTime? pickedUpAt,@NullableDateConverter() DateTime? deliveredAt, bool isLate
});


@override $OrderPersonCopyWith<$Res>? get customer;@override $VendorCopyWith<$Res>? get vendor;@override $OrderPersonCopyWith<$Res>? get agent;@override $OrderAddressCopyWith<$Res> get address;

}
/// @nodoc
class __$AppOrderCopyWithImpl<$Res>
    implements _$AppOrderCopyWith<$Res> {
  __$AppOrderCopyWithImpl(this._self, this._then);

  final _AppOrder _self;
  final $Res Function(_AppOrder) _then;

/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? createdAt = null,Object? status = null,Object? customer = freezed,Object? vendor = freezed,Object? agent = freezed,Object? deliveryType = null,Object? paymentMethod = null,Object? address = null,Object? deliveryLocation = freezed,Object? customerNote = freezed,Object? items = null,Object? subtotalCentimes = null,Object? serviceFeeCentimes = null,Object? deliveryFeeCentimes = null,Object? discountCentimes = null,Object? totalCentimes = null,Object? pointsUsed = null,Object? pointsEarned = null,Object? events = null,Object? cancelledReason = freezed,Object? confirmedAt = freezed,Object? assignedAt = freezed,Object? acceptedAt = freezed,Object? pickedUpAt = freezed,Object? deliveredAt = freezed,Object? isLate = null,}) {
  return _then(_AppOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as OrderPerson?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as Vendor?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as OrderPerson?,deliveryType: null == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as DeliveryType,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as OrderAddress,deliveryLocation: freezed == deliveryLocation ? _self.deliveryLocation : deliveryLocation // ignore: cast_nullable_to_non_nullable
as LatLng?,customerNote: freezed == customerNote ? _self.customerNote : customerNote // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,subtotalCentimes: null == subtotalCentimes ? _self.subtotalCentimes : subtotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,serviceFeeCentimes: null == serviceFeeCentimes ? _self.serviceFeeCentimes : serviceFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,deliveryFeeCentimes: null == deliveryFeeCentimes ? _self.deliveryFeeCentimes : deliveryFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,discountCentimes: null == discountCentimes ? _self.discountCentimes : discountCentimes // ignore: cast_nullable_to_non_nullable
as Money,totalCentimes: null == totalCentimes ? _self.totalCentimes : totalCentimes // ignore: cast_nullable_to_non_nullable
as Money,pointsUsed: null == pointsUsed ? _self.pointsUsed : pointsUsed // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<OrderEvent>,cancelledReason: freezed == cancelledReason ? _self.cancelledReason : cancelledReason // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pickedUpAt: freezed == pickedUpAt ? _self.pickedUpAt : pickedUpAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLate: null == isLate ? _self.isLate : isLate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderPersonCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $OrderPersonCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorCopyWith<$Res>? get vendor {
    if (_self.vendor == null) {
    return null;
  }

  return $VendorCopyWith<$Res>(_self.vendor!, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderPersonCopyWith<$Res>? get agent {
    if (_self.agent == null) {
    return null;
  }

  return $OrderPersonCopyWith<$Res>(_self.agent!, (value) {
    return _then(_self.copyWith(agent: value));
  });
}/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderAddressCopyWith<$Res> get address {
  
  return $OrderAddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

// dart format on
