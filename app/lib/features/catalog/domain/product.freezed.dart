// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductOptionValue {

 String get id; String get name;@MoneyConverter() Money get priceDeltaCentimes;
/// Create a copy of ProductOptionValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductOptionValueCopyWith<ProductOptionValue> get copyWith => _$ProductOptionValueCopyWithImpl<ProductOptionValue>(this as ProductOptionValue, _$identity);

  /// Serializes this ProductOptionValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductOptionValue&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceDeltaCentimes, priceDeltaCentimes) || other.priceDeltaCentimes == priceDeltaCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priceDeltaCentimes);

@override
String toString() {
  return 'ProductOptionValue(id: $id, name: $name, priceDeltaCentimes: $priceDeltaCentimes)';
}


}

/// @nodoc
abstract mixin class $ProductOptionValueCopyWith<$Res>  {
  factory $ProductOptionValueCopyWith(ProductOptionValue value, $Res Function(ProductOptionValue) _then) = _$ProductOptionValueCopyWithImpl;
@useResult
$Res call({
 String id, String name,@MoneyConverter() Money priceDeltaCentimes
});




}
/// @nodoc
class _$ProductOptionValueCopyWithImpl<$Res>
    implements $ProductOptionValueCopyWith<$Res> {
  _$ProductOptionValueCopyWithImpl(this._self, this._then);

  final ProductOptionValue _self;
  final $Res Function(ProductOptionValue) _then;

/// Create a copy of ProductOptionValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceDeltaCentimes = null,}) {
  return _then(ProductOptionValue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDeltaCentimes: null == priceDeltaCentimes ? _self.priceDeltaCentimes : priceDeltaCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductOptionValue].
extension ProductOptionValuePatterns on ProductOptionValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductOptionValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductOptionValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductOptionValue value)  $default,){
final _that = this;
switch (_that) {
case _ProductOptionValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductOptionValue value)?  $default,){
final _that = this;
switch (_that) {
case _ProductOptionValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @MoneyConverter()  Money priceDeltaCentimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductOptionValue() when $default != null:
return $default(_that.id,_that.name,_that.priceDeltaCentimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @MoneyConverter()  Money priceDeltaCentimes)  $default,) {final _that = this;
switch (_that) {
case _ProductOptionValue():
return $default(_that.id,_that.name,_that.priceDeltaCentimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @MoneyConverter()  Money priceDeltaCentimes)?  $default,) {final _that = this;
switch (_that) {
case _ProductOptionValue() when $default != null:
return $default(_that.id,_that.name,_that.priceDeltaCentimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductOptionValue implements ProductOptionValue {
  const _ProductOptionValue({required this.id, required this.name, @MoneyConverter() this.priceDeltaCentimes = const Money.zero()});
  factory _ProductOptionValue.fromJson(Map<String, dynamic> json) => _$ProductOptionValueFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey()@MoneyConverter() final  Money priceDeltaCentimes;

/// Create a copy of ProductOptionValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductOptionValueCopyWith<_ProductOptionValue> get copyWith => __$ProductOptionValueCopyWithImpl<_ProductOptionValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductOptionValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductOptionValue&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceDeltaCentimes, priceDeltaCentimes) || other.priceDeltaCentimes == priceDeltaCentimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priceDeltaCentimes);

@override
String toString() {
  return 'ProductOptionValue(id: $id, name: $name, priceDeltaCentimes: $priceDeltaCentimes)';
}


}

/// @nodoc
abstract mixin class _$ProductOptionValueCopyWith<$Res> implements $ProductOptionValueCopyWith<$Res> {
  factory _$ProductOptionValueCopyWith(_ProductOptionValue value, $Res Function(_ProductOptionValue) _then) = __$ProductOptionValueCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@MoneyConverter() Money priceDeltaCentimes
});




}
/// @nodoc
class __$ProductOptionValueCopyWithImpl<$Res>
    implements _$ProductOptionValueCopyWith<$Res> {
  __$ProductOptionValueCopyWithImpl(this._self, this._then);

  final _ProductOptionValue _self;
  final $Res Function(_ProductOptionValue) _then;

/// Create a copy of ProductOptionValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceDeltaCentimes = null,}) {
  return _then(_ProductOptionValue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDeltaCentimes: null == priceDeltaCentimes ? _self.priceDeltaCentimes : priceDeltaCentimes // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}


/// @nodoc
mixin _$ProductOption {

 String get name; ProductOptionType get type; bool get isRequired; List<ProductOptionValue> get values;
/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductOptionCopyWith<ProductOption> get copyWith => _$ProductOptionCopyWithImpl<ProductOption>(this as ProductOption, _$identity);

  /// Serializes this ProductOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductOption&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.values, values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,isRequired,const DeepCollectionEquality().hash(values));

@override
String toString() {
  return 'ProductOption(name: $name, type: $type, isRequired: $isRequired, values: $values)';
}


}

/// @nodoc
abstract mixin class $ProductOptionCopyWith<$Res>  {
  factory $ProductOptionCopyWith(ProductOption value, $Res Function(ProductOption) _then) = _$ProductOptionCopyWithImpl;
@useResult
$Res call({
 String name, ProductOptionType type, bool isRequired, List<ProductOptionValue> values
});




}
/// @nodoc
class _$ProductOptionCopyWithImpl<$Res>
    implements $ProductOptionCopyWith<$Res> {
  _$ProductOptionCopyWithImpl(this._self, this._then);

  final ProductOption _self;
  final $Res Function(ProductOption) _then;

/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? isRequired = null,Object? values = null,}) {
  return _then(ProductOption(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductOptionType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as List<ProductOptionValue>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductOption].
extension ProductOptionPatterns on ProductOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductOption value)  $default,){
final _that = this;
switch (_that) {
case _ProductOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductOption value)?  $default,){
final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  ProductOptionType type,  bool isRequired,  List<ProductOptionValue> values)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
return $default(_that.name,_that.type,_that.isRequired,_that.values);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  ProductOptionType type,  bool isRequired,  List<ProductOptionValue> values)  $default,) {final _that = this;
switch (_that) {
case _ProductOption():
return $default(_that.name,_that.type,_that.isRequired,_that.values);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  ProductOptionType type,  bool isRequired,  List<ProductOptionValue> values)?  $default,) {final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
return $default(_that.name,_that.type,_that.isRequired,_that.values);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductOption implements ProductOption {
  const _ProductOption({required this.name, this.type = ProductOptionType.single, this.isRequired = false,  List<ProductOptionValue> values = const <ProductOptionValue>[]}): _values = values;
  factory _ProductOption.fromJson(Map<String, dynamic> json) => _$ProductOptionFromJson(json);

@override final  String name;
@override@JsonKey() final  ProductOptionType type;
@override@JsonKey() final  bool isRequired;
 final  List<ProductOptionValue> _values;
@override@JsonKey() List<ProductOptionValue> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductOptionCopyWith<_ProductOption> get copyWith => __$ProductOptionCopyWithImpl<_ProductOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductOption&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other._values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,isRequired,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'ProductOption(name: $name, type: $type, isRequired: $isRequired, values: $values)';
}


}

/// @nodoc
abstract mixin class _$ProductOptionCopyWith<$Res> implements $ProductOptionCopyWith<$Res> {
  factory _$ProductOptionCopyWith(_ProductOption value, $Res Function(_ProductOption) _then) = __$ProductOptionCopyWithImpl;
@override @useResult
$Res call({
 String name, ProductOptionType type, bool isRequired, List<ProductOptionValue> values
});




}
/// @nodoc
class __$ProductOptionCopyWithImpl<$Res>
    implements _$ProductOptionCopyWith<$Res> {
  __$ProductOptionCopyWithImpl(this._self, this._then);

  final _ProductOption _self;
  final $Res Function(_ProductOption) _then;

/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? isRequired = null,Object? values = null,}) {
  return _then(_ProductOption(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductOptionType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<ProductOptionValue>,
  ));
}


}


/// @nodoc
mixin _$Product {

 String get id; String get name;@RefIdConverter() String? get vendor;@RefIdConverter() String? get section; String? get description; ImageRef? get image;@MoneyConverter() Money get priceCentimes; bool get isAvailable; int get sortOrder; List<ProductOption> get options;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.section, section) || other.section == section)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.priceCentimes, priceCentimes) || other.priceCentimes == priceCentimes)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,vendor,section,description,image,priceCentimes,isAvailable,sortOrder,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'Product(id: $id, name: $name, vendor: $vendor, section: $section, description: $description, image: $image, priceCentimes: $priceCentimes, isAvailable: $isAvailable, sortOrder: $sortOrder, options: $options)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name,@RefIdConverter() String? vendor,@RefIdConverter() String? section, String? description, ImageRef? image,@MoneyConverter() Money priceCentimes, bool isAvailable, int sortOrder, List<ProductOption> options
});


$ImageRefCopyWith<$Res>? get image;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? vendor = freezed,Object? section = freezed,Object? description = freezed,Object? image = freezed,Object? priceCentimes = null,Object? isAvailable = null,Object? sortOrder = null,Object? options = null,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ImageRef?,priceCentimes: null == priceCentimes ? _self.priceCentimes : priceCentimes // ignore: cast_nullable_to_non_nullable
as Money,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ProductOption>,
  ));
}
/// Create a copy of Product
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


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @RefIdConverter()  String? vendor, @RefIdConverter()  String? section,  String? description,  ImageRef? image, @MoneyConverter()  Money priceCentimes,  bool isAvailable,  int sortOrder,  List<ProductOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.vendor,_that.section,_that.description,_that.image,_that.priceCentimes,_that.isAvailable,_that.sortOrder,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @RefIdConverter()  String? vendor, @RefIdConverter()  String? section,  String? description,  ImageRef? image, @MoneyConverter()  Money priceCentimes,  bool isAvailable,  int sortOrder,  List<ProductOption> options)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.vendor,_that.section,_that.description,_that.image,_that.priceCentimes,_that.isAvailable,_that.sortOrder,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @RefIdConverter()  String? vendor, @RefIdConverter()  String? section,  String? description,  ImageRef? image, @MoneyConverter()  Money priceCentimes,  bool isAvailable,  int sortOrder,  List<ProductOption> options)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.vendor,_that.section,_that.description,_that.image,_that.priceCentimes,_that.isAvailable,_that.sortOrder,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({required this.id, required this.name, @RefIdConverter() this.vendor, @RefIdConverter() this.section, this.description, this.image, @MoneyConverter() this.priceCentimes = const Money.zero(), this.isAvailable = true, this.sortOrder = 0,  List<ProductOption> options = const <ProductOption>[]}): _options = options,super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override@RefIdConverter() final  String? vendor;
@override@RefIdConverter() final  String? section;
@override final  String? description;
@override final  ImageRef? image;
@override@JsonKey()@MoneyConverter() final  Money priceCentimes;
@override@JsonKey() final  bool isAvailable;
@override@JsonKey() final  int sortOrder;
 final  List<ProductOption> _options;
@override@JsonKey() List<ProductOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.section, section) || other.section == section)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.priceCentimes, priceCentimes) || other.priceCentimes == priceCentimes)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,vendor,section,description,image,priceCentimes,isAvailable,sortOrder,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'Product(id: $id, name: $name, vendor: $vendor, section: $section, description: $description, image: $image, priceCentimes: $priceCentimes, isAvailable: $isAvailable, sortOrder: $sortOrder, options: $options)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@RefIdConverter() String? vendor,@RefIdConverter() String? section, String? description, ImageRef? image,@MoneyConverter() Money priceCentimes, bool isAvailable, int sortOrder, List<ProductOption> options
});


@override $ImageRefCopyWith<$Res>? get image;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? vendor = freezed,Object? section = freezed,Object? description = freezed,Object? image = freezed,Object? priceCentimes = null,Object? isAvailable = null,Object? sortOrder = null,Object? options = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ImageRef?,priceCentimes: null == priceCentimes ? _self.priceCentimes : priceCentimes // ignore: cast_nullable_to_non_nullable
as Money,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ProductOption>,
  ));
}

/// Create a copy of Product
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

/// @nodoc
mixin _$MenuGroup {

 String get sectionId; String get sectionName; List<Product> get products;
/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuGroupCopyWith<MenuGroup> get copyWith => _$MenuGroupCopyWithImpl<MenuGroup>(this as MenuGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuGroup&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionName, sectionName) || other.sectionName == sectionName)&&const DeepCollectionEquality().equals(other.products, products));
}


@override
int get hashCode => Object.hash(runtimeType,sectionId,sectionName,const DeepCollectionEquality().hash(products));

@override
String toString() {
  return 'MenuGroup(sectionId: $sectionId, sectionName: $sectionName, products: $products)';
}


}

/// @nodoc
abstract mixin class $MenuGroupCopyWith<$Res>  {
  factory $MenuGroupCopyWith(MenuGroup value, $Res Function(MenuGroup) _then) = _$MenuGroupCopyWithImpl;
@useResult
$Res call({
 String sectionId, String sectionName, List<Product> products
});




}
/// @nodoc
class _$MenuGroupCopyWithImpl<$Res>
    implements $MenuGroupCopyWith<$Res> {
  _$MenuGroupCopyWithImpl(this._self, this._then);

  final MenuGroup _self;
  final $Res Function(MenuGroup) _then;

/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = null,Object? sectionName = null,Object? products = null,}) {
  return _then(MenuGroup(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String,sectionName: null == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuGroup].
extension MenuGroupPatterns on MenuGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuGroup value)  $default,){
final _that = this;
switch (_that) {
case _MenuGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sectionId,  String sectionName,  List<Product> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
return $default(_that.sectionId,_that.sectionName,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sectionId,  String sectionName,  List<Product> products)  $default,) {final _that = this;
switch (_that) {
case _MenuGroup():
return $default(_that.sectionId,_that.sectionName,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sectionId,  String sectionName,  List<Product> products)?  $default,) {final _that = this;
switch (_that) {
case _MenuGroup() when $default != null:
return $default(_that.sectionId,_that.sectionName,_that.products);case _:
  return null;

}
}

}

/// @nodoc


class _MenuGroup implements MenuGroup {
  const _MenuGroup({required this.sectionId, required this.sectionName, required  List<Product> products}): _products = products;
  

@override final  String sectionId;
@override final  String sectionName;
 final  List<Product> _products;
@override List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuGroupCopyWith<_MenuGroup> get copyWith => __$MenuGroupCopyWithImpl<_MenuGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuGroup&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionName, sectionName) || other.sectionName == sectionName)&&const DeepCollectionEquality().equals(other._products, _products));
}


@override
int get hashCode => Object.hash(runtimeType,sectionId,sectionName,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'MenuGroup(sectionId: $sectionId, sectionName: $sectionName, products: $products)';
}


}

/// @nodoc
abstract mixin class _$MenuGroupCopyWith<$Res> implements $MenuGroupCopyWith<$Res> {
  factory _$MenuGroupCopyWith(_MenuGroup value, $Res Function(_MenuGroup) _then) = __$MenuGroupCopyWithImpl;
@override @useResult
$Res call({
 String sectionId, String sectionName, List<Product> products
});




}
/// @nodoc
class __$MenuGroupCopyWithImpl<$Res>
    implements _$MenuGroupCopyWith<$Res> {
  __$MenuGroupCopyWithImpl(this._self, this._then);

  final _MenuGroup _self;
  final $Res Function(_MenuGroup) _then;

/// Create a copy of MenuGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = null,Object? sectionName = null,Object? products = null,}) {
  return _then(_MenuGroup(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String,sectionName: null == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}


}

// dart format on
