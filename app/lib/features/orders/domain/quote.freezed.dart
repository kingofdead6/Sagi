// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuoteLine {

 String get productId; String get name; int get qty;@MoneyConverter() Money get unitPriceCentimes;@MoneyConverter() Money get lineTotalCentimes;
/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteLineCopyWith<QuoteLine> get copyWith => _$QuoteLineCopyWithImpl<QuoteLine>(this as QuoteLine, _$identity);

  /// Serializes this QuoteLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPriceCentimes, unitPriceCentimes) || other.unitPriceCentimes == unitPriceCentimes)&&(identical(other.lineTotalCentimes, lineTotalCentimes) || other.lineTotalCentimes == lineTotalCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,qty,unitPriceCentimes,lineTotalCentimes);

@override
String toString() {
  return 'QuoteLine(productId: $productId, name: $name, qty: $qty, unitPriceCentimes: $unitPriceCentimes, lineTotalCentimes: $lineTotalCentimes)';
}


}

/// @nodoc
abstract mixin class $QuoteLineCopyWith<$Res>  {
  factory $QuoteLineCopyWith(QuoteLine value, $Res Function(QuoteLine) _then) = _$QuoteLineCopyWithImpl;
@useResult
$Res call({
 String productId, String name, int qty,@MoneyConverter() Money unitPriceCentimes,@MoneyConverter() Money lineTotalCentimes
});




}
/// @nodoc
class _$QuoteLineCopyWithImpl<$Res>
    implements $QuoteLineCopyWith<$Res> {
  _$QuoteLineCopyWithImpl(this._self, this._then);

  final QuoteLine _self;
  final $Res Function(QuoteLine) _then;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? qty = null,Object? unitPriceCentimes = null,Object? lineTotalCentimes = null,}) {
  return _then(QuoteLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,unitPriceCentimes: null == unitPriceCentimes ? _self.unitPriceCentimes : unitPriceCentimes // ignore: cast_nullable_to_non_nullable
as Money,lineTotalCentimes: null == lineTotalCentimes ? _self.lineTotalCentimes : lineTotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteLine].
extension QuoteLinePatterns on QuoteLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteLine value)  $default,){
final _that = this;
switch (_that) {
case _QuoteLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteLine value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String name,  int qty, @MoneyConverter()  Money unitPriceCentimes, @MoneyConverter()  Money lineTotalCentimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that.productId,_that.name,_that.qty,_that.unitPriceCentimes,_that.lineTotalCentimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String name,  int qty, @MoneyConverter()  Money unitPriceCentimes, @MoneyConverter()  Money lineTotalCentimes)  $default,) {final _that = this;
switch (_that) {
case _QuoteLine():
return $default(_that.productId,_that.name,_that.qty,_that.unitPriceCentimes,_that.lineTotalCentimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String name,  int qty, @MoneyConverter()  Money unitPriceCentimes, @MoneyConverter()  Money lineTotalCentimes)?  $default,) {final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that.productId,_that.name,_that.qty,_that.unitPriceCentimes,_that.lineTotalCentimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuoteLine implements QuoteLine {
  const _QuoteLine({required this.productId, required this.name, this.qty = 1, @MoneyConverter() this.unitPriceCentimes = const Money.zero(), @MoneyConverter() this.lineTotalCentimes = const Money.zero()});
  factory _QuoteLine.fromJson(Map<String, dynamic> json) => _$QuoteLineFromJson(json);

@override final  String productId;
@override final  String name;
@override@JsonKey() final  int qty;
@override@JsonKey()@MoneyConverter() final  Money unitPriceCentimes;
@override@JsonKey()@MoneyConverter() final  Money lineTotalCentimes;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteLineCopyWith<_QuoteLine> get copyWith => __$QuoteLineCopyWithImpl<_QuoteLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPriceCentimes, unitPriceCentimes) || other.unitPriceCentimes == unitPriceCentimes)&&(identical(other.lineTotalCentimes, lineTotalCentimes) || other.lineTotalCentimes == lineTotalCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,qty,unitPriceCentimes,lineTotalCentimes);

@override
String toString() {
  return 'QuoteLine(productId: $productId, name: $name, qty: $qty, unitPriceCentimes: $unitPriceCentimes, lineTotalCentimes: $lineTotalCentimes)';
}


}

/// @nodoc
abstract mixin class _$QuoteLineCopyWith<$Res> implements $QuoteLineCopyWith<$Res> {
  factory _$QuoteLineCopyWith(_QuoteLine value, $Res Function(_QuoteLine) _then) = __$QuoteLineCopyWithImpl;
@override @useResult
$Res call({
 String productId, String name, int qty,@MoneyConverter() Money unitPriceCentimes,@MoneyConverter() Money lineTotalCentimes
});




}
/// @nodoc
class __$QuoteLineCopyWithImpl<$Res>
    implements _$QuoteLineCopyWith<$Res> {
  __$QuoteLineCopyWithImpl(this._self, this._then);

  final _QuoteLine _self;
  final $Res Function(_QuoteLine) _then;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? qty = null,Object? unitPriceCentimes = null,Object? lineTotalCentimes = null,}) {
  return _then(_QuoteLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,unitPriceCentimes: null == unitPriceCentimes ? _self.unitPriceCentimes : unitPriceCentimes // ignore: cast_nullable_to_non_nullable
as Money,lineTotalCentimes: null == lineTotalCentimes ? _self.lineTotalCentimes : lineTotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}


/// @nodoc
mixin _$OrderQuote {

 List<QuoteLine> get items;@MoneyConverter() Money get subtotalCentimes;@MoneyConverter() Money get serviceFeeCentimes;@MoneyConverter() Money get deliveryFeeCentimes;@MoneyConverter() Money get discountCentimes;@MoneyConverter() Money get voucherDiscountCentimes;@MoneyConverter() Money get pointsDiscountCentimes;@MoneyConverter() Money get totalCentimes; int get pointsUsed; int get pointsEarned; String? get voucherCode; List<String> get warnings;
/// Create a copy of OrderQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderQuoteCopyWith<OrderQuote> get copyWith => _$OrderQuoteCopyWithImpl<OrderQuote>(this as OrderQuote, _$identity);

  /// Serializes this OrderQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderQuote&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalCentimes, subtotalCentimes) || other.subtotalCentimes == subtotalCentimes)&&(identical(other.serviceFeeCentimes, serviceFeeCentimes) || other.serviceFeeCentimes == serviceFeeCentimes)&&(identical(other.deliveryFeeCentimes, deliveryFeeCentimes) || other.deliveryFeeCentimes == deliveryFeeCentimes)&&(identical(other.discountCentimes, discountCentimes) || other.discountCentimes == discountCentimes)&&(identical(other.voucherDiscountCentimes, voucherDiscountCentimes) || other.voucherDiscountCentimes == voucherDiscountCentimes)&&(identical(other.pointsDiscountCentimes, pointsDiscountCentimes) || other.pointsDiscountCentimes == pointsDiscountCentimes)&&(identical(other.totalCentimes, totalCentimes) || other.totalCentimes == totalCentimes)&&(identical(other.pointsUsed, pointsUsed) || other.pointsUsed == pointsUsed)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),subtotalCentimes,serviceFeeCentimes,deliveryFeeCentimes,discountCentimes,voucherDiscountCentimes,pointsDiscountCentimes,totalCentimes,pointsUsed,pointsEarned,voucherCode,const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'OrderQuote(items: $items, subtotalCentimes: $subtotalCentimes, serviceFeeCentimes: $serviceFeeCentimes, deliveryFeeCentimes: $deliveryFeeCentimes, discountCentimes: $discountCentimes, voucherDiscountCentimes: $voucherDiscountCentimes, pointsDiscountCentimes: $pointsDiscountCentimes, totalCentimes: $totalCentimes, pointsUsed: $pointsUsed, pointsEarned: $pointsEarned, voucherCode: $voucherCode, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $OrderQuoteCopyWith<$Res>  {
  factory $OrderQuoteCopyWith(OrderQuote value, $Res Function(OrderQuote) _then) = _$OrderQuoteCopyWithImpl;
@useResult
$Res call({
 List<QuoteLine> items,@MoneyConverter() Money subtotalCentimes,@MoneyConverter() Money serviceFeeCentimes,@MoneyConverter() Money deliveryFeeCentimes,@MoneyConverter() Money discountCentimes,@MoneyConverter() Money voucherDiscountCentimes,@MoneyConverter() Money pointsDiscountCentimes,@MoneyConverter() Money totalCentimes, int pointsUsed, int pointsEarned, String? voucherCode, List<String> warnings
});




}
/// @nodoc
class _$OrderQuoteCopyWithImpl<$Res>
    implements $OrderQuoteCopyWith<$Res> {
  _$OrderQuoteCopyWithImpl(this._self, this._then);

  final OrderQuote _self;
  final $Res Function(OrderQuote) _then;

/// Create a copy of OrderQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? subtotalCentimes = null,Object? serviceFeeCentimes = null,Object? deliveryFeeCentimes = null,Object? discountCentimes = null,Object? voucherDiscountCentimes = null,Object? pointsDiscountCentimes = null,Object? totalCentimes = null,Object? pointsUsed = null,Object? pointsEarned = null,Object? voucherCode = freezed,Object? warnings = null,}) {
  return _then(OrderQuote(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<QuoteLine>,subtotalCentimes: null == subtotalCentimes ? _self.subtotalCentimes : subtotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,serviceFeeCentimes: null == serviceFeeCentimes ? _self.serviceFeeCentimes : serviceFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,deliveryFeeCentimes: null == deliveryFeeCentimes ? _self.deliveryFeeCentimes : deliveryFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,discountCentimes: null == discountCentimes ? _self.discountCentimes : discountCentimes // ignore: cast_nullable_to_non_nullable
as Money,voucherDiscountCentimes: null == voucherDiscountCentimes ? _self.voucherDiscountCentimes : voucherDiscountCentimes // ignore: cast_nullable_to_non_nullable
as Money,pointsDiscountCentimes: null == pointsDiscountCentimes ? _self.pointsDiscountCentimes : pointsDiscountCentimes // ignore: cast_nullable_to_non_nullable
as Money,totalCentimes: null == totalCentimes ? _self.totalCentimes : totalCentimes // ignore: cast_nullable_to_non_nullable
as Money,pointsUsed: null == pointsUsed ? _self.pointsUsed : pointsUsed // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderQuote].
extension OrderQuotePatterns on OrderQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderQuote value)  $default,){
final _that = this;
switch (_that) {
case _OrderQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderQuote value)?  $default,){
final _that = this;
switch (_that) {
case _OrderQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuoteLine> items, @MoneyConverter()  Money subtotalCentimes, @MoneyConverter()  Money serviceFeeCentimes, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money discountCentimes, @MoneyConverter()  Money voucherDiscountCentimes, @MoneyConverter()  Money pointsDiscountCentimes, @MoneyConverter()  Money totalCentimes,  int pointsUsed,  int pointsEarned,  String? voucherCode,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderQuote() when $default != null:
return $default(_that.items,_that.subtotalCentimes,_that.serviceFeeCentimes,_that.deliveryFeeCentimes,_that.discountCentimes,_that.voucherDiscountCentimes,_that.pointsDiscountCentimes,_that.totalCentimes,_that.pointsUsed,_that.pointsEarned,_that.voucherCode,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuoteLine> items, @MoneyConverter()  Money subtotalCentimes, @MoneyConverter()  Money serviceFeeCentimes, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money discountCentimes, @MoneyConverter()  Money voucherDiscountCentimes, @MoneyConverter()  Money pointsDiscountCentimes, @MoneyConverter()  Money totalCentimes,  int pointsUsed,  int pointsEarned,  String? voucherCode,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _OrderQuote():
return $default(_that.items,_that.subtotalCentimes,_that.serviceFeeCentimes,_that.deliveryFeeCentimes,_that.discountCentimes,_that.voucherDiscountCentimes,_that.pointsDiscountCentimes,_that.totalCentimes,_that.pointsUsed,_that.pointsEarned,_that.voucherCode,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuoteLine> items, @MoneyConverter()  Money subtotalCentimes, @MoneyConverter()  Money serviceFeeCentimes, @MoneyConverter()  Money deliveryFeeCentimes, @MoneyConverter()  Money discountCentimes, @MoneyConverter()  Money voucherDiscountCentimes, @MoneyConverter()  Money pointsDiscountCentimes, @MoneyConverter()  Money totalCentimes,  int pointsUsed,  int pointsEarned,  String? voucherCode,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _OrderQuote() when $default != null:
return $default(_that.items,_that.subtotalCentimes,_that.serviceFeeCentimes,_that.deliveryFeeCentimes,_that.discountCentimes,_that.voucherDiscountCentimes,_that.pointsDiscountCentimes,_that.totalCentimes,_that.pointsUsed,_that.pointsEarned,_that.voucherCode,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderQuote extends OrderQuote {
  const _OrderQuote({ List<QuoteLine> items = const <QuoteLine>[], @MoneyConverter() this.subtotalCentimes = const Money.zero(), @MoneyConverter() this.serviceFeeCentimes = const Money.zero(), @MoneyConverter() this.deliveryFeeCentimes = const Money.zero(), @MoneyConverter() this.discountCentimes = const Money.zero(), @MoneyConverter() this.voucherDiscountCentimes = const Money.zero(), @MoneyConverter() this.pointsDiscountCentimes = const Money.zero(), @MoneyConverter() this.totalCentimes = const Money.zero(), this.pointsUsed = 0, this.pointsEarned = 0, this.voucherCode,  List<String> warnings = const <String>[]}): _items = items,_warnings = warnings,super._();
  factory _OrderQuote.fromJson(Map<String, dynamic> json) => _$OrderQuoteFromJson(json);

 final  List<QuoteLine> _items;
@override@JsonKey() List<QuoteLine> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey()@MoneyConverter() final  Money subtotalCentimes;
@override@JsonKey()@MoneyConverter() final  Money serviceFeeCentimes;
@override@JsonKey()@MoneyConverter() final  Money deliveryFeeCentimes;
@override@JsonKey()@MoneyConverter() final  Money discountCentimes;
@override@JsonKey()@MoneyConverter() final  Money voucherDiscountCentimes;
@override@JsonKey()@MoneyConverter() final  Money pointsDiscountCentimes;
@override@JsonKey()@MoneyConverter() final  Money totalCentimes;
@override@JsonKey() final  int pointsUsed;
@override@JsonKey() final  int pointsEarned;
@override final  String? voucherCode;
 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of OrderQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderQuoteCopyWith<_OrderQuote> get copyWith => __$OrderQuoteCopyWithImpl<_OrderQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderQuote&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalCentimes, subtotalCentimes) || other.subtotalCentimes == subtotalCentimes)&&(identical(other.serviceFeeCentimes, serviceFeeCentimes) || other.serviceFeeCentimes == serviceFeeCentimes)&&(identical(other.deliveryFeeCentimes, deliveryFeeCentimes) || other.deliveryFeeCentimes == deliveryFeeCentimes)&&(identical(other.discountCentimes, discountCentimes) || other.discountCentimes == discountCentimes)&&(identical(other.voucherDiscountCentimes, voucherDiscountCentimes) || other.voucherDiscountCentimes == voucherDiscountCentimes)&&(identical(other.pointsDiscountCentimes, pointsDiscountCentimes) || other.pointsDiscountCentimes == pointsDiscountCentimes)&&(identical(other.totalCentimes, totalCentimes) || other.totalCentimes == totalCentimes)&&(identical(other.pointsUsed, pointsUsed) || other.pointsUsed == pointsUsed)&&(identical(other.pointsEarned, pointsEarned) || other.pointsEarned == pointsEarned)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),subtotalCentimes,serviceFeeCentimes,deliveryFeeCentimes,discountCentimes,voucherDiscountCentimes,pointsDiscountCentimes,totalCentimes,pointsUsed,pointsEarned,voucherCode,const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'OrderQuote(items: $items, subtotalCentimes: $subtotalCentimes, serviceFeeCentimes: $serviceFeeCentimes, deliveryFeeCentimes: $deliveryFeeCentimes, discountCentimes: $discountCentimes, voucherDiscountCentimes: $voucherDiscountCentimes, pointsDiscountCentimes: $pointsDiscountCentimes, totalCentimes: $totalCentimes, pointsUsed: $pointsUsed, pointsEarned: $pointsEarned, voucherCode: $voucherCode, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$OrderQuoteCopyWith<$Res> implements $OrderQuoteCopyWith<$Res> {
  factory _$OrderQuoteCopyWith(_OrderQuote value, $Res Function(_OrderQuote) _then) = __$OrderQuoteCopyWithImpl;
@override @useResult
$Res call({
 List<QuoteLine> items,@MoneyConverter() Money subtotalCentimes,@MoneyConverter() Money serviceFeeCentimes,@MoneyConverter() Money deliveryFeeCentimes,@MoneyConverter() Money discountCentimes,@MoneyConverter() Money voucherDiscountCentimes,@MoneyConverter() Money pointsDiscountCentimes,@MoneyConverter() Money totalCentimes, int pointsUsed, int pointsEarned, String? voucherCode, List<String> warnings
});




}
/// @nodoc
class __$OrderQuoteCopyWithImpl<$Res>
    implements _$OrderQuoteCopyWith<$Res> {
  __$OrderQuoteCopyWithImpl(this._self, this._then);

  final _OrderQuote _self;
  final $Res Function(_OrderQuote) _then;

/// Create a copy of OrderQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? subtotalCentimes = null,Object? serviceFeeCentimes = null,Object? deliveryFeeCentimes = null,Object? discountCentimes = null,Object? voucherDiscountCentimes = null,Object? pointsDiscountCentimes = null,Object? totalCentimes = null,Object? pointsUsed = null,Object? pointsEarned = null,Object? voucherCode = freezed,Object? warnings = null,}) {
  return _then(_OrderQuote(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<QuoteLine>,subtotalCentimes: null == subtotalCentimes ? _self.subtotalCentimes : subtotalCentimes // ignore: cast_nullable_to_non_nullable
as Money,serviceFeeCentimes: null == serviceFeeCentimes ? _self.serviceFeeCentimes : serviceFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,deliveryFeeCentimes: null == deliveryFeeCentimes ? _self.deliveryFeeCentimes : deliveryFeeCentimes // ignore: cast_nullable_to_non_nullable
as Money,discountCentimes: null == discountCentimes ? _self.discountCentimes : discountCentimes // ignore: cast_nullable_to_non_nullable
as Money,voucherDiscountCentimes: null == voucherDiscountCentimes ? _self.voucherDiscountCentimes : voucherDiscountCentimes // ignore: cast_nullable_to_non_nullable
as Money,pointsDiscountCentimes: null == pointsDiscountCentimes ? _self.pointsDiscountCentimes : pointsDiscountCentimes // ignore: cast_nullable_to_non_nullable
as Money,totalCentimes: null == totalCentimes ? _self.totalCentimes : totalCentimes // ignore: cast_nullable_to_non_nullable
as Money,pointsUsed: null == pointsUsed ? _self.pointsUsed : pointsUsed // ignore: cast_nullable_to_non_nullable
as int,pointsEarned: null == pointsEarned ? _self.pointsEarned : pointsEarned // ignore: cast_nullable_to_non_nullable
as int,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
