// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentOnlineStatus {

 bool get isOnline;@RefIdConverter() String? get currentOrder;@NullableDateConverter() DateTime? get lastSeenAt;
/// Create a copy of AgentOnlineStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentOnlineStatusCopyWith<AgentOnlineStatus> get copyWith => _$AgentOnlineStatusCopyWithImpl<AgentOnlineStatus>(this as AgentOnlineStatus, _$identity);

  /// Serializes this AgentOnlineStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentOnlineStatus&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.currentOrder, currentOrder) || other.currentOrder == currentOrder)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOnline,currentOrder,lastSeenAt);

@override
String toString() {
  return 'AgentOnlineStatus(isOnline: $isOnline, currentOrder: $currentOrder, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class $AgentOnlineStatusCopyWith<$Res>  {
  factory $AgentOnlineStatusCopyWith(AgentOnlineStatus value, $Res Function(AgentOnlineStatus) _then) = _$AgentOnlineStatusCopyWithImpl;
@useResult
$Res call({
 bool isOnline,@RefIdConverter() String? currentOrder,@NullableDateConverter() DateTime? lastSeenAt
});




}
/// @nodoc
class _$AgentOnlineStatusCopyWithImpl<$Res>
    implements $AgentOnlineStatusCopyWith<$Res> {
  _$AgentOnlineStatusCopyWithImpl(this._self, this._then);

  final AgentOnlineStatus _self;
  final $Res Function(AgentOnlineStatus) _then;

/// Create a copy of AgentOnlineStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOnline = null,Object? currentOrder = freezed,Object? lastSeenAt = freezed,}) {
  return _then(AgentOnlineStatus(
isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,currentOrder: freezed == currentOrder ? _self.currentOrder : currentOrder // ignore: cast_nullable_to_non_nullable
as String?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentOnlineStatus].
extension AgentOnlineStatusPatterns on AgentOnlineStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentOnlineStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentOnlineStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentOnlineStatus value)  $default,){
final _that = this;
switch (_that) {
case _AgentOnlineStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentOnlineStatus value)?  $default,){
final _that = this;
switch (_that) {
case _AgentOnlineStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOnline, @RefIdConverter()  String? currentOrder, @NullableDateConverter()  DateTime? lastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentOnlineStatus() when $default != null:
return $default(_that.isOnline,_that.currentOrder,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOnline, @RefIdConverter()  String? currentOrder, @NullableDateConverter()  DateTime? lastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _AgentOnlineStatus():
return $default(_that.isOnline,_that.currentOrder,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOnline, @RefIdConverter()  String? currentOrder, @NullableDateConverter()  DateTime? lastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _AgentOnlineStatus() when $default != null:
return $default(_that.isOnline,_that.currentOrder,_that.lastSeenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentOnlineStatus implements AgentOnlineStatus {
  const _AgentOnlineStatus({this.isOnline = false, @RefIdConverter() this.currentOrder, @NullableDateConverter() this.lastSeenAt});
  factory _AgentOnlineStatus.fromJson(Map<String, dynamic> json) => _$AgentOnlineStatusFromJson(json);

@override@JsonKey() final  bool isOnline;
@override@RefIdConverter() final  String? currentOrder;
@override@NullableDateConverter() final  DateTime? lastSeenAt;

/// Create a copy of AgentOnlineStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentOnlineStatusCopyWith<_AgentOnlineStatus> get copyWith => __$AgentOnlineStatusCopyWithImpl<_AgentOnlineStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentOnlineStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentOnlineStatus&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.currentOrder, currentOrder) || other.currentOrder == currentOrder)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOnline,currentOrder,lastSeenAt);

@override
String toString() {
  return 'AgentOnlineStatus(isOnline: $isOnline, currentOrder: $currentOrder, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$AgentOnlineStatusCopyWith<$Res> implements $AgentOnlineStatusCopyWith<$Res> {
  factory _$AgentOnlineStatusCopyWith(_AgentOnlineStatus value, $Res Function(_AgentOnlineStatus) _then) = __$AgentOnlineStatusCopyWithImpl;
@override @useResult
$Res call({
 bool isOnline,@RefIdConverter() String? currentOrder,@NullableDateConverter() DateTime? lastSeenAt
});




}
/// @nodoc
class __$AgentOnlineStatusCopyWithImpl<$Res>
    implements _$AgentOnlineStatusCopyWith<$Res> {
  __$AgentOnlineStatusCopyWithImpl(this._self, this._then);

  final _AgentOnlineStatus _self;
  final $Res Function(_AgentOnlineStatus) _then;

/// Create a copy of AgentOnlineStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOnline = null,Object? currentOrder = freezed,Object? lastSeenAt = freezed,}) {
  return _then(_AgentOnlineStatus(
isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,currentOrder: freezed == currentOrder ? _self.currentOrder : currentOrder // ignore: cast_nullable_to_non_nullable
as String?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$Waypoint {

 double? get lat; double? get lng; String? get name; String? get phone; String? get address;
/// Create a copy of Waypoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaypointCopyWith<Waypoint> get copyWith => _$WaypointCopyWithImpl<Waypoint>(this as Waypoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Waypoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,lat,lng,name,phone,address);

@override
String toString() {
  return 'Waypoint(lat: $lat, lng: $lng, name: $name, phone: $phone, address: $address)';
}


}

/// @nodoc
abstract mixin class $WaypointCopyWith<$Res>  {
  factory $WaypointCopyWith(Waypoint value, $Res Function(Waypoint) _then) = _$WaypointCopyWithImpl;
@useResult
$Res call({
 double? lat, double? lng, String? name, String? phone, String? address
});




}
/// @nodoc
class _$WaypointCopyWithImpl<$Res>
    implements $WaypointCopyWith<$Res> {
  _$WaypointCopyWithImpl(this._self, this._then);

  final Waypoint _self;
  final $Res Function(Waypoint) _then;

/// Create a copy of Waypoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = freezed,Object? lng = freezed,Object? name = freezed,Object? phone = freezed,Object? address = freezed,}) {
  return _then(Waypoint(
lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Waypoint].
extension WaypointPatterns on Waypoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Waypoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Waypoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Waypoint value)  $default,){
final _that = this;
switch (_that) {
case _Waypoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Waypoint value)?  $default,){
final _that = this;
switch (_that) {
case _Waypoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? lat,  double? lng,  String? name,  String? phone,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Waypoint() when $default != null:
return $default(_that.lat,_that.lng,_that.name,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? lat,  double? lng,  String? name,  String? phone,  String? address)  $default,) {final _that = this;
switch (_that) {
case _Waypoint():
return $default(_that.lat,_that.lng,_that.name,_that.phone,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? lat,  double? lng,  String? name,  String? phone,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _Waypoint() when $default != null:
return $default(_that.lat,_that.lng,_that.name,_that.phone,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _Waypoint extends Waypoint {
  const _Waypoint({this.lat, this.lng, this.name, this.phone, this.address}): super._();
  

@override final  double? lat;
@override final  double? lng;
@override final  String? name;
@override final  String? phone;
@override final  String? address;

/// Create a copy of Waypoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaypointCopyWith<_Waypoint> get copyWith => __$WaypointCopyWithImpl<_Waypoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Waypoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,lat,lng,name,phone,address);

@override
String toString() {
  return 'Waypoint(lat: $lat, lng: $lng, name: $name, phone: $phone, address: $address)';
}


}

/// @nodoc
abstract mixin class _$WaypointCopyWith<$Res> implements $WaypointCopyWith<$Res> {
  factory _$WaypointCopyWith(_Waypoint value, $Res Function(_Waypoint) _then) = __$WaypointCopyWithImpl;
@override @useResult
$Res call({
 double? lat, double? lng, String? name, String? phone, String? address
});




}
/// @nodoc
class __$WaypointCopyWithImpl<$Res>
    implements _$WaypointCopyWith<$Res> {
  __$WaypointCopyWithImpl(this._self, this._then);

  final _Waypoint _self;
  final $Res Function(_Waypoint) _then;

/// Create a copy of Waypoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = freezed,Object? lng = freezed,Object? name = freezed,Object? phone = freezed,Object? address = freezed,}) {
  return _then(_Waypoint(
lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DeliveryOffer {

 String get assignmentId; AppOrder get order; DateTime get expiresAt; Waypoint? get pickup; Waypoint? get dropoff; double? get distanceKm;@MoneyConverter() Money get payoutCentimes; int get timeoutSec;
/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryOfferCopyWith<DeliveryOffer> get copyWith => _$DeliveryOfferCopyWithImpl<DeliveryOffer>(this as DeliveryOffer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryOffer&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.order, order) || other.order == order)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.payoutCentimes, payoutCentimes) || other.payoutCentimes == payoutCentimes)&&(identical(other.timeoutSec, timeoutSec) || other.timeoutSec == timeoutSec));
}


@override
int get hashCode => Object.hash(runtimeType,assignmentId,order,expiresAt,pickup,dropoff,distanceKm,payoutCentimes,timeoutSec);

@override
String toString() {
  return 'DeliveryOffer(assignmentId: $assignmentId, order: $order, expiresAt: $expiresAt, pickup: $pickup, dropoff: $dropoff, distanceKm: $distanceKm, payoutCentimes: $payoutCentimes, timeoutSec: $timeoutSec)';
}


}

/// @nodoc
abstract mixin class $DeliveryOfferCopyWith<$Res>  {
  factory $DeliveryOfferCopyWith(DeliveryOffer value, $Res Function(DeliveryOffer) _then) = _$DeliveryOfferCopyWithImpl;
@useResult
$Res call({
 String assignmentId, AppOrder order, DateTime expiresAt, Waypoint? pickup, Waypoint? dropoff, double? distanceKm,@MoneyConverter() Money payoutCentimes, int timeoutSec
});


$AppOrderCopyWith<$Res> get order;$WaypointCopyWith<$Res>? get pickup;$WaypointCopyWith<$Res>? get dropoff;

}
/// @nodoc
class _$DeliveryOfferCopyWithImpl<$Res>
    implements $DeliveryOfferCopyWith<$Res> {
  _$DeliveryOfferCopyWithImpl(this._self, this._then);

  final DeliveryOffer _self;
  final $Res Function(DeliveryOffer) _then;

/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assignmentId = null,Object? order = null,Object? expiresAt = null,Object? pickup = freezed,Object? dropoff = freezed,Object? distanceKm = freezed,Object? payoutCentimes = null,Object? timeoutSec = null,}) {
  return _then(DeliveryOffer(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as AppOrder,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as Waypoint?,dropoff: freezed == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as Waypoint?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,payoutCentimes: null == payoutCentimes ? _self.payoutCentimes : payoutCentimes // ignore: cast_nullable_to_non_nullable
as Money,timeoutSec: null == timeoutSec ? _self.timeoutSec : timeoutSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppOrderCopyWith<$Res> get order {
  
  return $AppOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get pickup {
    if (_self.pickup == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.pickup!, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get dropoff {
    if (_self.dropoff == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.dropoff!, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeliveryOffer].
extension DeliveryOfferPatterns on DeliveryOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryOffer value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryOffer value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assignmentId,  AppOrder order,  DateTime expiresAt,  Waypoint? pickup,  Waypoint? dropoff,  double? distanceKm, @MoneyConverter()  Money payoutCentimes,  int timeoutSec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
return $default(_that.assignmentId,_that.order,_that.expiresAt,_that.pickup,_that.dropoff,_that.distanceKm,_that.payoutCentimes,_that.timeoutSec);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assignmentId,  AppOrder order,  DateTime expiresAt,  Waypoint? pickup,  Waypoint? dropoff,  double? distanceKm, @MoneyConverter()  Money payoutCentimes,  int timeoutSec)  $default,) {final _that = this;
switch (_that) {
case _DeliveryOffer():
return $default(_that.assignmentId,_that.order,_that.expiresAt,_that.pickup,_that.dropoff,_that.distanceKm,_that.payoutCentimes,_that.timeoutSec);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assignmentId,  AppOrder order,  DateTime expiresAt,  Waypoint? pickup,  Waypoint? dropoff,  double? distanceKm, @MoneyConverter()  Money payoutCentimes,  int timeoutSec)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryOffer() when $default != null:
return $default(_that.assignmentId,_that.order,_that.expiresAt,_that.pickup,_that.dropoff,_that.distanceKm,_that.payoutCentimes,_that.timeoutSec);case _:
  return null;

}
}

}

/// @nodoc


class _DeliveryOffer extends DeliveryOffer {
  const _DeliveryOffer({required this.assignmentId, required this.order, required this.expiresAt, this.pickup, this.dropoff, this.distanceKm, @MoneyConverter() this.payoutCentimes = const Money.zero(), this.timeoutSec = 60}): super._();
  

@override final  String assignmentId;
@override final  AppOrder order;
@override final  DateTime expiresAt;
@override final  Waypoint? pickup;
@override final  Waypoint? dropoff;
@override final  double? distanceKm;
@override@JsonKey()@MoneyConverter() final  Money payoutCentimes;
@override@JsonKey() final  int timeoutSec;

/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryOfferCopyWith<_DeliveryOffer> get copyWith => __$DeliveryOfferCopyWithImpl<_DeliveryOffer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryOffer&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.order, order) || other.order == order)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.payoutCentimes, payoutCentimes) || other.payoutCentimes == payoutCentimes)&&(identical(other.timeoutSec, timeoutSec) || other.timeoutSec == timeoutSec));
}


@override
int get hashCode => Object.hash(runtimeType,assignmentId,order,expiresAt,pickup,dropoff,distanceKm,payoutCentimes,timeoutSec);

@override
String toString() {
  return 'DeliveryOffer(assignmentId: $assignmentId, order: $order, expiresAt: $expiresAt, pickup: $pickup, dropoff: $dropoff, distanceKm: $distanceKm, payoutCentimes: $payoutCentimes, timeoutSec: $timeoutSec)';
}


}

/// @nodoc
abstract mixin class _$DeliveryOfferCopyWith<$Res> implements $DeliveryOfferCopyWith<$Res> {
  factory _$DeliveryOfferCopyWith(_DeliveryOffer value, $Res Function(_DeliveryOffer) _then) = __$DeliveryOfferCopyWithImpl;
@override @useResult
$Res call({
 String assignmentId, AppOrder order, DateTime expiresAt, Waypoint? pickup, Waypoint? dropoff, double? distanceKm,@MoneyConverter() Money payoutCentimes, int timeoutSec
});


@override $AppOrderCopyWith<$Res> get order;@override $WaypointCopyWith<$Res>? get pickup;@override $WaypointCopyWith<$Res>? get dropoff;

}
/// @nodoc
class __$DeliveryOfferCopyWithImpl<$Res>
    implements _$DeliveryOfferCopyWith<$Res> {
  __$DeliveryOfferCopyWithImpl(this._self, this._then);

  final _DeliveryOffer _self;
  final $Res Function(_DeliveryOffer) _then;

/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assignmentId = null,Object? order = null,Object? expiresAt = null,Object? pickup = freezed,Object? dropoff = freezed,Object? distanceKm = freezed,Object? payoutCentimes = null,Object? timeoutSec = null,}) {
  return _then(_DeliveryOffer(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as AppOrder,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as Waypoint?,dropoff: freezed == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as Waypoint?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,payoutCentimes: null == payoutCentimes ? _self.payoutCentimes : payoutCentimes // ignore: cast_nullable_to_non_nullable
as Money,timeoutSec: null == timeoutSec ? _self.timeoutSec : timeoutSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppOrderCopyWith<$Res> get order {
  
  return $AppOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get pickup {
    if (_self.pickup == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.pickup!, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of DeliveryOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get dropoff {
    if (_self.dropoff == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.dropoff!, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}
}

/// @nodoc
mixin _$ActiveDelivery {

 AppOrder get order; Waypoint? get pickup; Waypoint? get dropoff;
/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveDeliveryCopyWith<ActiveDelivery> get copyWith => _$ActiveDeliveryCopyWithImpl<ActiveDelivery>(this as ActiveDelivery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveDelivery&&(identical(other.order, order) || other.order == order)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff));
}


@override
int get hashCode => Object.hash(runtimeType,order,pickup,dropoff);

@override
String toString() {
  return 'ActiveDelivery(order: $order, pickup: $pickup, dropoff: $dropoff)';
}


}

/// @nodoc
abstract mixin class $ActiveDeliveryCopyWith<$Res>  {
  factory $ActiveDeliveryCopyWith(ActiveDelivery value, $Res Function(ActiveDelivery) _then) = _$ActiveDeliveryCopyWithImpl;
@useResult
$Res call({
 AppOrder order, Waypoint? pickup, Waypoint? dropoff
});


$AppOrderCopyWith<$Res> get order;$WaypointCopyWith<$Res>? get pickup;$WaypointCopyWith<$Res>? get dropoff;

}
/// @nodoc
class _$ActiveDeliveryCopyWithImpl<$Res>
    implements $ActiveDeliveryCopyWith<$Res> {
  _$ActiveDeliveryCopyWithImpl(this._self, this._then);

  final ActiveDelivery _self;
  final $Res Function(ActiveDelivery) _then;

/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? pickup = freezed,Object? dropoff = freezed,}) {
  return _then(ActiveDelivery(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as AppOrder,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as Waypoint?,dropoff: freezed == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as Waypoint?,
  ));
}
/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppOrderCopyWith<$Res> get order {
  
  return $AppOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get pickup {
    if (_self.pickup == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.pickup!, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get dropoff {
    if (_self.dropoff == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.dropoff!, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActiveDelivery].
extension ActiveDeliveryPatterns on ActiveDelivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveDelivery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveDelivery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveDelivery value)  $default,){
final _that = this;
switch (_that) {
case _ActiveDelivery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveDelivery value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveDelivery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppOrder order,  Waypoint? pickup,  Waypoint? dropoff)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveDelivery() when $default != null:
return $default(_that.order,_that.pickup,_that.dropoff);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppOrder order,  Waypoint? pickup,  Waypoint? dropoff)  $default,) {final _that = this;
switch (_that) {
case _ActiveDelivery():
return $default(_that.order,_that.pickup,_that.dropoff);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppOrder order,  Waypoint? pickup,  Waypoint? dropoff)?  $default,) {final _that = this;
switch (_that) {
case _ActiveDelivery() when $default != null:
return $default(_that.order,_that.pickup,_that.dropoff);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveDelivery implements ActiveDelivery {
  const _ActiveDelivery({required this.order, this.pickup, this.dropoff});
  

@override final  AppOrder order;
@override final  Waypoint? pickup;
@override final  Waypoint? dropoff;

/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveDeliveryCopyWith<_ActiveDelivery> get copyWith => __$ActiveDeliveryCopyWithImpl<_ActiveDelivery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveDelivery&&(identical(other.order, order) || other.order == order)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff));
}


@override
int get hashCode => Object.hash(runtimeType,order,pickup,dropoff);

@override
String toString() {
  return 'ActiveDelivery(order: $order, pickup: $pickup, dropoff: $dropoff)';
}


}

/// @nodoc
abstract mixin class _$ActiveDeliveryCopyWith<$Res> implements $ActiveDeliveryCopyWith<$Res> {
  factory _$ActiveDeliveryCopyWith(_ActiveDelivery value, $Res Function(_ActiveDelivery) _then) = __$ActiveDeliveryCopyWithImpl;
@override @useResult
$Res call({
 AppOrder order, Waypoint? pickup, Waypoint? dropoff
});


@override $AppOrderCopyWith<$Res> get order;@override $WaypointCopyWith<$Res>? get pickup;@override $WaypointCopyWith<$Res>? get dropoff;

}
/// @nodoc
class __$ActiveDeliveryCopyWithImpl<$Res>
    implements _$ActiveDeliveryCopyWith<$Res> {
  __$ActiveDeliveryCopyWithImpl(this._self, this._then);

  final _ActiveDelivery _self;
  final $Res Function(_ActiveDelivery) _then;

/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? pickup = freezed,Object? dropoff = freezed,}) {
  return _then(_ActiveDelivery(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as AppOrder,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as Waypoint?,dropoff: freezed == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as Waypoint?,
  ));
}

/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppOrderCopyWith<$Res> get order {
  
  return $AppOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get pickup {
    if (_self.pickup == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.pickup!, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of ActiveDelivery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaypointCopyWith<$Res>? get dropoff {
    if (_self.dropoff == null) {
    return null;
  }

  return $WaypointCopyWith<$Res>(_self.dropoff!, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}
}


/// @nodoc
mixin _$AgentStats {

 int get deliveries;@MoneyConverter() Money get earningsCentimes; int get avgMinutes; int get todayDeliveries; int get rejectedOffers;
/// Create a copy of AgentStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentStatsCopyWith<AgentStats> get copyWith => _$AgentStatsCopyWithImpl<AgentStats>(this as AgentStats, _$identity);

  /// Serializes this AgentStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentStats&&(identical(other.deliveries, deliveries) || other.deliveries == deliveries)&&(identical(other.earningsCentimes, earningsCentimes) || other.earningsCentimes == earningsCentimes)&&(identical(other.avgMinutes, avgMinutes) || other.avgMinutes == avgMinutes)&&(identical(other.todayDeliveries, todayDeliveries) || other.todayDeliveries == todayDeliveries)&&(identical(other.rejectedOffers, rejectedOffers) || other.rejectedOffers == rejectedOffers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deliveries,earningsCentimes,avgMinutes,todayDeliveries,rejectedOffers);

@override
String toString() {
  return 'AgentStats(deliveries: $deliveries, earningsCentimes: $earningsCentimes, avgMinutes: $avgMinutes, todayDeliveries: $todayDeliveries, rejectedOffers: $rejectedOffers)';
}


}

/// @nodoc
abstract mixin class $AgentStatsCopyWith<$Res>  {
  factory $AgentStatsCopyWith(AgentStats value, $Res Function(AgentStats) _then) = _$AgentStatsCopyWithImpl;
@useResult
$Res call({
 int deliveries,@MoneyConverter() Money earningsCentimes, int avgMinutes, int todayDeliveries, int rejectedOffers
});




}
/// @nodoc
class _$AgentStatsCopyWithImpl<$Res>
    implements $AgentStatsCopyWith<$Res> {
  _$AgentStatsCopyWithImpl(this._self, this._then);

  final AgentStats _self;
  final $Res Function(AgentStats) _then;

/// Create a copy of AgentStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveries = null,Object? earningsCentimes = null,Object? avgMinutes = null,Object? todayDeliveries = null,Object? rejectedOffers = null,}) {
  return _then(AgentStats(
deliveries: null == deliveries ? _self.deliveries : deliveries // ignore: cast_nullable_to_non_nullable
as int,earningsCentimes: null == earningsCentimes ? _self.earningsCentimes : earningsCentimes // ignore: cast_nullable_to_non_nullable
as Money,avgMinutes: null == avgMinutes ? _self.avgMinutes : avgMinutes // ignore: cast_nullable_to_non_nullable
as int,todayDeliveries: null == todayDeliveries ? _self.todayDeliveries : todayDeliveries // ignore: cast_nullable_to_non_nullable
as int,rejectedOffers: null == rejectedOffers ? _self.rejectedOffers : rejectedOffers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentStats].
extension AgentStatsPatterns on AgentStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentStats value)  $default,){
final _that = this;
switch (_that) {
case _AgentStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentStats value)?  $default,){
final _that = this;
switch (_that) {
case _AgentStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int deliveries, @MoneyConverter()  Money earningsCentimes,  int avgMinutes,  int todayDeliveries,  int rejectedOffers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentStats() when $default != null:
return $default(_that.deliveries,_that.earningsCentimes,_that.avgMinutes,_that.todayDeliveries,_that.rejectedOffers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int deliveries, @MoneyConverter()  Money earningsCentimes,  int avgMinutes,  int todayDeliveries,  int rejectedOffers)  $default,) {final _that = this;
switch (_that) {
case _AgentStats():
return $default(_that.deliveries,_that.earningsCentimes,_that.avgMinutes,_that.todayDeliveries,_that.rejectedOffers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int deliveries, @MoneyConverter()  Money earningsCentimes,  int avgMinutes,  int todayDeliveries,  int rejectedOffers)?  $default,) {final _that = this;
switch (_that) {
case _AgentStats() when $default != null:
return $default(_that.deliveries,_that.earningsCentimes,_that.avgMinutes,_that.todayDeliveries,_that.rejectedOffers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentStats implements AgentStats {
  const _AgentStats({this.deliveries = 0, @MoneyConverter() this.earningsCentimes = const Money.zero(), this.avgMinutes = 0, this.todayDeliveries = 0, this.rejectedOffers = 0});
  factory _AgentStats.fromJson(Map<String, dynamic> json) => _$AgentStatsFromJson(json);

@override@JsonKey() final  int deliveries;
@override@JsonKey()@MoneyConverter() final  Money earningsCentimes;
@override@JsonKey() final  int avgMinutes;
@override@JsonKey() final  int todayDeliveries;
@override@JsonKey() final  int rejectedOffers;

/// Create a copy of AgentStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentStatsCopyWith<_AgentStats> get copyWith => __$AgentStatsCopyWithImpl<_AgentStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentStats&&(identical(other.deliveries, deliveries) || other.deliveries == deliveries)&&(identical(other.earningsCentimes, earningsCentimes) || other.earningsCentimes == earningsCentimes)&&(identical(other.avgMinutes, avgMinutes) || other.avgMinutes == avgMinutes)&&(identical(other.todayDeliveries, todayDeliveries) || other.todayDeliveries == todayDeliveries)&&(identical(other.rejectedOffers, rejectedOffers) || other.rejectedOffers == rejectedOffers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deliveries,earningsCentimes,avgMinutes,todayDeliveries,rejectedOffers);

@override
String toString() {
  return 'AgentStats(deliveries: $deliveries, earningsCentimes: $earningsCentimes, avgMinutes: $avgMinutes, todayDeliveries: $todayDeliveries, rejectedOffers: $rejectedOffers)';
}


}

/// @nodoc
abstract mixin class _$AgentStatsCopyWith<$Res> implements $AgentStatsCopyWith<$Res> {
  factory _$AgentStatsCopyWith(_AgentStats value, $Res Function(_AgentStats) _then) = __$AgentStatsCopyWithImpl;
@override @useResult
$Res call({
 int deliveries,@MoneyConverter() Money earningsCentimes, int avgMinutes, int todayDeliveries, int rejectedOffers
});




}
/// @nodoc
class __$AgentStatsCopyWithImpl<$Res>
    implements _$AgentStatsCopyWith<$Res> {
  __$AgentStatsCopyWithImpl(this._self, this._then);

  final _AgentStats _self;
  final $Res Function(_AgentStats) _then;

/// Create a copy of AgentStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveries = null,Object? earningsCentimes = null,Object? avgMinutes = null,Object? todayDeliveries = null,Object? rejectedOffers = null,}) {
  return _then(_AgentStats(
deliveries: null == deliveries ? _self.deliveries : deliveries // ignore: cast_nullable_to_non_nullable
as int,earningsCentimes: null == earningsCentimes ? _self.earningsCentimes : earningsCentimes // ignore: cast_nullable_to_non_nullable
as Money,avgMinutes: null == avgMinutes ? _self.avgMinutes : avgMinutes // ignore: cast_nullable_to_non_nullable
as int,todayDeliveries: null == todayDeliveries ? _self.todayDeliveries : todayDeliveries // ignore: cast_nullable_to_non_nullable
as int,rejectedOffers: null == rejectedOffers ? _self.rejectedOffers : rejectedOffers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
