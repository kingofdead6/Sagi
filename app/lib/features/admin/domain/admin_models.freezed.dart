// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardStats {

 int get todayOrders;@MoneyConverter() Money get revenueCentimes; int get deliveredToday; int get activeDeliveries; int get avgDeliveryMinutes; int get lateOrders; int get pendingOrders; int get onlineAgents;
/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<DashboardStats> get copyWith => _$DashboardStatsCopyWithImpl<DashboardStats>(this as DashboardStats, _$identity);

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStats&&(identical(other.todayOrders, todayOrders) || other.todayOrders == todayOrders)&&(identical(other.revenueCentimes, revenueCentimes) || other.revenueCentimes == revenueCentimes)&&(identical(other.deliveredToday, deliveredToday) || other.deliveredToday == deliveredToday)&&(identical(other.activeDeliveries, activeDeliveries) || other.activeDeliveries == activeDeliveries)&&(identical(other.avgDeliveryMinutes, avgDeliveryMinutes) || other.avgDeliveryMinutes == avgDeliveryMinutes)&&(identical(other.lateOrders, lateOrders) || other.lateOrders == lateOrders)&&(identical(other.pendingOrders, pendingOrders) || other.pendingOrders == pendingOrders)&&(identical(other.onlineAgents, onlineAgents) || other.onlineAgents == onlineAgents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayOrders,revenueCentimes,deliveredToday,activeDeliveries,avgDeliveryMinutes,lateOrders,pendingOrders,onlineAgents);

@override
String toString() {
  return 'DashboardStats(todayOrders: $todayOrders, revenueCentimes: $revenueCentimes, deliveredToday: $deliveredToday, activeDeliveries: $activeDeliveries, avgDeliveryMinutes: $avgDeliveryMinutes, lateOrders: $lateOrders, pendingOrders: $pendingOrders, onlineAgents: $onlineAgents)';
}


}

/// @nodoc
abstract mixin class $DashboardStatsCopyWith<$Res>  {
  factory $DashboardStatsCopyWith(DashboardStats value, $Res Function(DashboardStats) _then) = _$DashboardStatsCopyWithImpl;
@useResult
$Res call({
 int todayOrders,@MoneyConverter() Money revenueCentimes, int deliveredToday, int activeDeliveries, int avgDeliveryMinutes, int lateOrders, int pendingOrders, int onlineAgents
});




}
/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._self, this._then);

  final DashboardStats _self;
  final $Res Function(DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayOrders = null,Object? revenueCentimes = null,Object? deliveredToday = null,Object? activeDeliveries = null,Object? avgDeliveryMinutes = null,Object? lateOrders = null,Object? pendingOrders = null,Object? onlineAgents = null,}) {
  return _then(DashboardStats(
todayOrders: null == todayOrders ? _self.todayOrders : todayOrders // ignore: cast_nullable_to_non_nullable
as int,revenueCentimes: null == revenueCentimes ? _self.revenueCentimes : revenueCentimes // ignore: cast_nullable_to_non_nullable
as Money,deliveredToday: null == deliveredToday ? _self.deliveredToday : deliveredToday // ignore: cast_nullable_to_non_nullable
as int,activeDeliveries: null == activeDeliveries ? _self.activeDeliveries : activeDeliveries // ignore: cast_nullable_to_non_nullable
as int,avgDeliveryMinutes: null == avgDeliveryMinutes ? _self.avgDeliveryMinutes : avgDeliveryMinutes // ignore: cast_nullable_to_non_nullable
as int,lateOrders: null == lateOrders ? _self.lateOrders : lateOrders // ignore: cast_nullable_to_non_nullable
as int,pendingOrders: null == pendingOrders ? _self.pendingOrders : pendingOrders // ignore: cast_nullable_to_non_nullable
as int,onlineAgents: null == onlineAgents ? _self.onlineAgents : onlineAgents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardStats].
extension DashboardStatsPatterns on DashboardStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardStats value)  $default,){
final _that = this;
switch (_that) {
case _DashboardStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardStats value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int todayOrders, @MoneyConverter()  Money revenueCentimes,  int deliveredToday,  int activeDeliveries,  int avgDeliveryMinutes,  int lateOrders,  int pendingOrders,  int onlineAgents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.todayOrders,_that.revenueCentimes,_that.deliveredToday,_that.activeDeliveries,_that.avgDeliveryMinutes,_that.lateOrders,_that.pendingOrders,_that.onlineAgents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int todayOrders, @MoneyConverter()  Money revenueCentimes,  int deliveredToday,  int activeDeliveries,  int avgDeliveryMinutes,  int lateOrders,  int pendingOrders,  int onlineAgents)  $default,) {final _that = this;
switch (_that) {
case _DashboardStats():
return $default(_that.todayOrders,_that.revenueCentimes,_that.deliveredToday,_that.activeDeliveries,_that.avgDeliveryMinutes,_that.lateOrders,_that.pendingOrders,_that.onlineAgents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int todayOrders, @MoneyConverter()  Money revenueCentimes,  int deliveredToday,  int activeDeliveries,  int avgDeliveryMinutes,  int lateOrders,  int pendingOrders,  int onlineAgents)?  $default,) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.todayOrders,_that.revenueCentimes,_that.deliveredToday,_that.activeDeliveries,_that.avgDeliveryMinutes,_that.lateOrders,_that.pendingOrders,_that.onlineAgents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardStats implements DashboardStats {
  const _DashboardStats({this.todayOrders = 0, @MoneyConverter() this.revenueCentimes = const Money.zero(), this.deliveredToday = 0, this.activeDeliveries = 0, this.avgDeliveryMinutes = 0, this.lateOrders = 0, this.pendingOrders = 0, this.onlineAgents = 0});
  factory _DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);

@override@JsonKey() final  int todayOrders;
@override@JsonKey()@MoneyConverter() final  Money revenueCentimes;
@override@JsonKey() final  int deliveredToday;
@override@JsonKey() final  int activeDeliveries;
@override@JsonKey() final  int avgDeliveryMinutes;
@override@JsonKey() final  int lateOrders;
@override@JsonKey() final  int pendingOrders;
@override@JsonKey() final  int onlineAgents;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatsCopyWith<_DashboardStats> get copyWith => __$DashboardStatsCopyWithImpl<_DashboardStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStats&&(identical(other.todayOrders, todayOrders) || other.todayOrders == todayOrders)&&(identical(other.revenueCentimes, revenueCentimes) || other.revenueCentimes == revenueCentimes)&&(identical(other.deliveredToday, deliveredToday) || other.deliveredToday == deliveredToday)&&(identical(other.activeDeliveries, activeDeliveries) || other.activeDeliveries == activeDeliveries)&&(identical(other.avgDeliveryMinutes, avgDeliveryMinutes) || other.avgDeliveryMinutes == avgDeliveryMinutes)&&(identical(other.lateOrders, lateOrders) || other.lateOrders == lateOrders)&&(identical(other.pendingOrders, pendingOrders) || other.pendingOrders == pendingOrders)&&(identical(other.onlineAgents, onlineAgents) || other.onlineAgents == onlineAgents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayOrders,revenueCentimes,deliveredToday,activeDeliveries,avgDeliveryMinutes,lateOrders,pendingOrders,onlineAgents);

@override
String toString() {
  return 'DashboardStats(todayOrders: $todayOrders, revenueCentimes: $revenueCentimes, deliveredToday: $deliveredToday, activeDeliveries: $activeDeliveries, avgDeliveryMinutes: $avgDeliveryMinutes, lateOrders: $lateOrders, pendingOrders: $pendingOrders, onlineAgents: $onlineAgents)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatsCopyWith<$Res> implements $DashboardStatsCopyWith<$Res> {
  factory _$DashboardStatsCopyWith(_DashboardStats value, $Res Function(_DashboardStats) _then) = __$DashboardStatsCopyWithImpl;
@override @useResult
$Res call({
 int todayOrders,@MoneyConverter() Money revenueCentimes, int deliveredToday, int activeDeliveries, int avgDeliveryMinutes, int lateOrders, int pendingOrders, int onlineAgents
});




}
/// @nodoc
class __$DashboardStatsCopyWithImpl<$Res>
    implements _$DashboardStatsCopyWith<$Res> {
  __$DashboardStatsCopyWithImpl(this._self, this._then);

  final _DashboardStats _self;
  final $Res Function(_DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayOrders = null,Object? revenueCentimes = null,Object? deliveredToday = null,Object? activeDeliveries = null,Object? avgDeliveryMinutes = null,Object? lateOrders = null,Object? pendingOrders = null,Object? onlineAgents = null,}) {
  return _then(_DashboardStats(
todayOrders: null == todayOrders ? _self.todayOrders : todayOrders // ignore: cast_nullable_to_non_nullable
as int,revenueCentimes: null == revenueCentimes ? _self.revenueCentimes : revenueCentimes // ignore: cast_nullable_to_non_nullable
as Money,deliveredToday: null == deliveredToday ? _self.deliveredToday : deliveredToday // ignore: cast_nullable_to_non_nullable
as int,activeDeliveries: null == activeDeliveries ? _self.activeDeliveries : activeDeliveries // ignore: cast_nullable_to_non_nullable
as int,avgDeliveryMinutes: null == avgDeliveryMinutes ? _self.avgDeliveryMinutes : avgDeliveryMinutes // ignore: cast_nullable_to_non_nullable
as int,lateOrders: null == lateOrders ? _self.lateOrders : lateOrders // ignore: cast_nullable_to_non_nullable
as int,pendingOrders: null == pendingOrders ? _self.pendingOrders : pendingOrders // ignore: cast_nullable_to_non_nullable
as int,onlineAgents: null == onlineAgents ? _self.onlineAgents : onlineAgents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AvailableAgent {

 String get agentId; String get fullName; String get phone; bool get isOnline; String? get currentOrder; int get currentLoad; double? get distanceKm;
/// Create a copy of AvailableAgent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailableAgentCopyWith<AvailableAgent> get copyWith => _$AvailableAgentCopyWithImpl<AvailableAgent>(this as AvailableAgent, _$identity);

  /// Serializes this AvailableAgent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailableAgent&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.currentOrder, currentOrder) || other.currentOrder == currentOrder)&&(identical(other.currentLoad, currentLoad) || other.currentLoad == currentLoad)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentId,fullName,phone,isOnline,currentOrder,currentLoad,distanceKm);

@override
String toString() {
  return 'AvailableAgent(agentId: $agentId, fullName: $fullName, phone: $phone, isOnline: $isOnline, currentOrder: $currentOrder, currentLoad: $currentLoad, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $AvailableAgentCopyWith<$Res>  {
  factory $AvailableAgentCopyWith(AvailableAgent value, $Res Function(AvailableAgent) _then) = _$AvailableAgentCopyWithImpl;
@useResult
$Res call({
 String agentId, String fullName, String phone, bool isOnline, String? currentOrder, int currentLoad, double? distanceKm
});




}
/// @nodoc
class _$AvailableAgentCopyWithImpl<$Res>
    implements $AvailableAgentCopyWith<$Res> {
  _$AvailableAgentCopyWithImpl(this._self, this._then);

  final AvailableAgent _self;
  final $Res Function(AvailableAgent) _then;

/// Create a copy of AvailableAgent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agentId = null,Object? fullName = null,Object? phone = null,Object? isOnline = null,Object? currentOrder = freezed,Object? currentLoad = null,Object? distanceKm = freezed,}) {
  return _then(AvailableAgent(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,currentOrder: freezed == currentOrder ? _self.currentOrder : currentOrder // ignore: cast_nullable_to_non_nullable
as String?,currentLoad: null == currentLoad ? _self.currentLoad : currentLoad // ignore: cast_nullable_to_non_nullable
as int,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailableAgent].
extension AvailableAgentPatterns on AvailableAgent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailableAgent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailableAgent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailableAgent value)  $default,){
final _that = this;
switch (_that) {
case _AvailableAgent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailableAgent value)?  $default,){
final _that = this;
switch (_that) {
case _AvailableAgent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agentId,  String fullName,  String phone,  bool isOnline,  String? currentOrder,  int currentLoad,  double? distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailableAgent() when $default != null:
return $default(_that.agentId,_that.fullName,_that.phone,_that.isOnline,_that.currentOrder,_that.currentLoad,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agentId,  String fullName,  String phone,  bool isOnline,  String? currentOrder,  int currentLoad,  double? distanceKm)  $default,) {final _that = this;
switch (_that) {
case _AvailableAgent():
return $default(_that.agentId,_that.fullName,_that.phone,_that.isOnline,_that.currentOrder,_that.currentLoad,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agentId,  String fullName,  String phone,  bool isOnline,  String? currentOrder,  int currentLoad,  double? distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _AvailableAgent() when $default != null:
return $default(_that.agentId,_that.fullName,_that.phone,_that.isOnline,_that.currentOrder,_that.currentLoad,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailableAgent implements AvailableAgent {
  const _AvailableAgent({required this.agentId, this.fullName = '', this.phone = '', this.isOnline = false, this.currentOrder, this.currentLoad = 0, this.distanceKm});
  factory _AvailableAgent.fromJson(Map<String, dynamic> json) => _$AvailableAgentFromJson(json);

@override final  String agentId;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String phone;
@override@JsonKey() final  bool isOnline;
@override final  String? currentOrder;
@override@JsonKey() final  int currentLoad;
@override final  double? distanceKm;

/// Create a copy of AvailableAgent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailableAgentCopyWith<_AvailableAgent> get copyWith => __$AvailableAgentCopyWithImpl<_AvailableAgent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailableAgentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailableAgent&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.currentOrder, currentOrder) || other.currentOrder == currentOrder)&&(identical(other.currentLoad, currentLoad) || other.currentLoad == currentLoad)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentId,fullName,phone,isOnline,currentOrder,currentLoad,distanceKm);

@override
String toString() {
  return 'AvailableAgent(agentId: $agentId, fullName: $fullName, phone: $phone, isOnline: $isOnline, currentOrder: $currentOrder, currentLoad: $currentLoad, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$AvailableAgentCopyWith<$Res> implements $AvailableAgentCopyWith<$Res> {
  factory _$AvailableAgentCopyWith(_AvailableAgent value, $Res Function(_AvailableAgent) _then) = __$AvailableAgentCopyWithImpl;
@override @useResult
$Res call({
 String agentId, String fullName, String phone, bool isOnline, String? currentOrder, int currentLoad, double? distanceKm
});




}
/// @nodoc
class __$AvailableAgentCopyWithImpl<$Res>
    implements _$AvailableAgentCopyWith<$Res> {
  __$AvailableAgentCopyWithImpl(this._self, this._then);

  final _AvailableAgent _self;
  final $Res Function(_AvailableAgent) _then;

/// Create a copy of AvailableAgent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agentId = null,Object? fullName = null,Object? phone = null,Object? isOnline = null,Object? currentOrder = freezed,Object? currentLoad = null,Object? distanceKm = freezed,}) {
  return _then(_AvailableAgent(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,currentOrder: freezed == currentOrder ? _self.currentOrder : currentOrder // ignore: cast_nullable_to_non_nullable
as String?,currentLoad: null == currentLoad ? _self.currentLoad : currentLoad // ignore: cast_nullable_to_non_nullable
as int,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$FleetAgent {

 String get agentId; String get fullName; String get phone;@GeoPointConverter() LatLng? get location;@NullableDateConverter() DateTime? get lastSeenAt; String get state;@JsonKey(fromJson: _orderOrNull) AppOrder? get currentOrder;
/// Create a copy of FleetAgent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FleetAgentCopyWith<FleetAgent> get copyWith => _$FleetAgentCopyWithImpl<FleetAgent>(this as FleetAgent, _$identity);

  /// Serializes this FleetAgent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FleetAgent&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.location, location) || other.location == location)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.state, state) || other.state == state)&&(identical(other.currentOrder, currentOrder) || other.currentOrder == currentOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentId,fullName,phone,location,lastSeenAt,state,currentOrder);

@override
String toString() {
  return 'FleetAgent(agentId: $agentId, fullName: $fullName, phone: $phone, location: $location, lastSeenAt: $lastSeenAt, state: $state, currentOrder: $currentOrder)';
}


}

/// @nodoc
abstract mixin class $FleetAgentCopyWith<$Res>  {
  factory $FleetAgentCopyWith(FleetAgent value, $Res Function(FleetAgent) _then) = _$FleetAgentCopyWithImpl;
@useResult
$Res call({
 String agentId, String fullName, String phone,@GeoPointConverter() LatLng? location,@NullableDateConverter() DateTime? lastSeenAt, String state,@JsonKey(fromJson: _orderOrNull) AppOrder? currentOrder
});


$AppOrderCopyWith<$Res>? get currentOrder;

}
/// @nodoc
class _$FleetAgentCopyWithImpl<$Res>
    implements $FleetAgentCopyWith<$Res> {
  _$FleetAgentCopyWithImpl(this._self, this._then);

  final FleetAgent _self;
  final $Res Function(FleetAgent) _then;

/// Create a copy of FleetAgent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agentId = null,Object? fullName = null,Object? phone = null,Object? location = freezed,Object? lastSeenAt = freezed,Object? state = null,Object? currentOrder = freezed,}) {
  return _then(FleetAgent(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,currentOrder: freezed == currentOrder ? _self.currentOrder : currentOrder // ignore: cast_nullable_to_non_nullable
as AppOrder?,
  ));
}
/// Create a copy of FleetAgent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppOrderCopyWith<$Res>? get currentOrder {
    if (_self.currentOrder == null) {
    return null;
  }

  return $AppOrderCopyWith<$Res>(_self.currentOrder!, (value) {
    return _then(_self.copyWith(currentOrder: value));
  });
}
}


/// Adds pattern-matching-related methods to [FleetAgent].
extension FleetAgentPatterns on FleetAgent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FleetAgent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FleetAgent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FleetAgent value)  $default,){
final _that = this;
switch (_that) {
case _FleetAgent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FleetAgent value)?  $default,){
final _that = this;
switch (_that) {
case _FleetAgent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agentId,  String fullName,  String phone, @GeoPointConverter()  LatLng? location, @NullableDateConverter()  DateTime? lastSeenAt,  String state, @JsonKey(fromJson: _orderOrNull)  AppOrder? currentOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FleetAgent() when $default != null:
return $default(_that.agentId,_that.fullName,_that.phone,_that.location,_that.lastSeenAt,_that.state,_that.currentOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agentId,  String fullName,  String phone, @GeoPointConverter()  LatLng? location, @NullableDateConverter()  DateTime? lastSeenAt,  String state, @JsonKey(fromJson: _orderOrNull)  AppOrder? currentOrder)  $default,) {final _that = this;
switch (_that) {
case _FleetAgent():
return $default(_that.agentId,_that.fullName,_that.phone,_that.location,_that.lastSeenAt,_that.state,_that.currentOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agentId,  String fullName,  String phone, @GeoPointConverter()  LatLng? location, @NullableDateConverter()  DateTime? lastSeenAt,  String state, @JsonKey(fromJson: _orderOrNull)  AppOrder? currentOrder)?  $default,) {final _that = this;
switch (_that) {
case _FleetAgent() when $default != null:
return $default(_that.agentId,_that.fullName,_that.phone,_that.location,_that.lastSeenAt,_that.state,_that.currentOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FleetAgent extends FleetAgent {
  const _FleetAgent({required this.agentId, this.fullName = '', this.phone = '', @GeoPointConverter() this.location, @NullableDateConverter() this.lastSeenAt, this.state = 'idle', @JsonKey(fromJson: _orderOrNull) this.currentOrder}): super._();
  factory _FleetAgent.fromJson(Map<String, dynamic> json) => _$FleetAgentFromJson(json);

@override final  String agentId;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String phone;
@override@GeoPointConverter() final  LatLng? location;
@override@NullableDateConverter() final  DateTime? lastSeenAt;
@override@JsonKey() final  String state;
@override@JsonKey(fromJson: _orderOrNull) final  AppOrder? currentOrder;

/// Create a copy of FleetAgent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FleetAgentCopyWith<_FleetAgent> get copyWith => __$FleetAgentCopyWithImpl<_FleetAgent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FleetAgentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FleetAgent&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.location, location) || other.location == location)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.state, state) || other.state == state)&&(identical(other.currentOrder, currentOrder) || other.currentOrder == currentOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentId,fullName,phone,location,lastSeenAt,state,currentOrder);

@override
String toString() {
  return 'FleetAgent(agentId: $agentId, fullName: $fullName, phone: $phone, location: $location, lastSeenAt: $lastSeenAt, state: $state, currentOrder: $currentOrder)';
}


}

/// @nodoc
abstract mixin class _$FleetAgentCopyWith<$Res> implements $FleetAgentCopyWith<$Res> {
  factory _$FleetAgentCopyWith(_FleetAgent value, $Res Function(_FleetAgent) _then) = __$FleetAgentCopyWithImpl;
@override @useResult
$Res call({
 String agentId, String fullName, String phone,@GeoPointConverter() LatLng? location,@NullableDateConverter() DateTime? lastSeenAt, String state,@JsonKey(fromJson: _orderOrNull) AppOrder? currentOrder
});


@override $AppOrderCopyWith<$Res>? get currentOrder;

}
/// @nodoc
class __$FleetAgentCopyWithImpl<$Res>
    implements _$FleetAgentCopyWith<$Res> {
  __$FleetAgentCopyWithImpl(this._self, this._then);

  final _FleetAgent _self;
  final $Res Function(_FleetAgent) _then;

/// Create a copy of FleetAgent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agentId = null,Object? fullName = null,Object? phone = null,Object? location = freezed,Object? lastSeenAt = freezed,Object? state = null,Object? currentOrder = freezed,}) {
  return _then(_FleetAgent(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,currentOrder: freezed == currentOrder ? _self.currentOrder : currentOrder // ignore: cast_nullable_to_non_nullable
as AppOrder?,
  ));
}

/// Create a copy of FleetAgent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppOrderCopyWith<$Res>? get currentOrder {
    if (_self.currentOrder == null) {
    return null;
  }

  return $AppOrderCopyWith<$Res>(_self.currentOrder!, (value) {
    return _then(_self.copyWith(currentOrder: value));
  });
}
}


/// @nodoc
mixin _$TimeSeriesPoint {

 String get date; int get orders;@MoneyConverter() Money get revenueCentimes; int get cancelled;
/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSeriesPointCopyWith<TimeSeriesPoint> get copyWith => _$TimeSeriesPointCopyWithImpl<TimeSeriesPoint>(this as TimeSeriesPoint, _$identity);

  /// Serializes this TimeSeriesPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSeriesPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.revenueCentimes, revenueCentimes) || other.revenueCentimes == revenueCentimes)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,orders,revenueCentimes,cancelled);

@override
String toString() {
  return 'TimeSeriesPoint(date: $date, orders: $orders, revenueCentimes: $revenueCentimes, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class $TimeSeriesPointCopyWith<$Res>  {
  factory $TimeSeriesPointCopyWith(TimeSeriesPoint value, $Res Function(TimeSeriesPoint) _then) = _$TimeSeriesPointCopyWithImpl;
@useResult
$Res call({
 String date, int orders,@MoneyConverter() Money revenueCentimes, int cancelled
});




}
/// @nodoc
class _$TimeSeriesPointCopyWithImpl<$Res>
    implements $TimeSeriesPointCopyWith<$Res> {
  _$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final TimeSeriesPoint _self;
  final $Res Function(TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? orders = null,Object? revenueCentimes = null,Object? cancelled = null,}) {
  return _then(TimeSeriesPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,revenueCentimes: null == revenueCentimes ? _self.revenueCentimes : revenueCentimes // ignore: cast_nullable_to_non_nullable
as Money,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSeriesPoint].
extension TimeSeriesPointPatterns on TimeSeriesPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSeriesPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int orders, @MoneyConverter()  Money revenueCentimes,  int cancelled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.date,_that.orders,_that.revenueCentimes,_that.cancelled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int orders, @MoneyConverter()  Money revenueCentimes,  int cancelled)  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint():
return $default(_that.date,_that.orders,_that.revenueCentimes,_that.cancelled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int orders, @MoneyConverter()  Money revenueCentimes,  int cancelled)?  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.date,_that.orders,_that.revenueCentimes,_that.cancelled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSeriesPoint implements TimeSeriesPoint {
  const _TimeSeriesPoint({required this.date, this.orders = 0, @MoneyConverter() this.revenueCentimes = const Money.zero(), this.cancelled = 0});
  factory _TimeSeriesPoint.fromJson(Map<String, dynamic> json) => _$TimeSeriesPointFromJson(json);

@override final  String date;
@override@JsonKey() final  int orders;
@override@JsonKey()@MoneyConverter() final  Money revenueCentimes;
@override@JsonKey() final  int cancelled;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSeriesPointCopyWith<_TimeSeriesPoint> get copyWith => __$TimeSeriesPointCopyWithImpl<_TimeSeriesPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSeriesPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSeriesPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.revenueCentimes, revenueCentimes) || other.revenueCentimes == revenueCentimes)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,orders,revenueCentimes,cancelled);

@override
String toString() {
  return 'TimeSeriesPoint(date: $date, orders: $orders, revenueCentimes: $revenueCentimes, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class _$TimeSeriesPointCopyWith<$Res> implements $TimeSeriesPointCopyWith<$Res> {
  factory _$TimeSeriesPointCopyWith(_TimeSeriesPoint value, $Res Function(_TimeSeriesPoint) _then) = __$TimeSeriesPointCopyWithImpl;
@override @useResult
$Res call({
 String date, int orders,@MoneyConverter() Money revenueCentimes, int cancelled
});




}
/// @nodoc
class __$TimeSeriesPointCopyWithImpl<$Res>
    implements _$TimeSeriesPointCopyWith<$Res> {
  __$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final _TimeSeriesPoint _self;
  final $Res Function(_TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? orders = null,Object? revenueCentimes = null,Object? cancelled = null,}) {
  return _then(_TimeSeriesPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,revenueCentimes: null == revenueCentimes ? _self.revenueCentimes : revenueCentimes // ignore: cast_nullable_to_non_nullable
as Money,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RankedRow {

 String get name; int get count;@MoneyConverter() Money get amount; String? get subtitle;
/// Create a copy of RankedRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankedRowCopyWith<RankedRow> get copyWith => _$RankedRowCopyWithImpl<RankedRow>(this as RankedRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankedRow&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle));
}


@override
int get hashCode => Object.hash(runtimeType,name,count,amount,subtitle);

@override
String toString() {
  return 'RankedRow(name: $name, count: $count, amount: $amount, subtitle: $subtitle)';
}


}

/// @nodoc
abstract mixin class $RankedRowCopyWith<$Res>  {
  factory $RankedRowCopyWith(RankedRow value, $Res Function(RankedRow) _then) = _$RankedRowCopyWithImpl;
@useResult
$Res call({
 String name, int count,@MoneyConverter() Money amount, String? subtitle
});




}
/// @nodoc
class _$RankedRowCopyWithImpl<$Res>
    implements $RankedRowCopyWith<$Res> {
  _$RankedRowCopyWithImpl(this._self, this._then);

  final RankedRow _self;
  final $Res Function(RankedRow) _then;

/// Create a copy of RankedRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? count = null,Object? amount = null,Object? subtitle = freezed,}) {
  return _then(RankedRow(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RankedRow].
extension RankedRowPatterns on RankedRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankedRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankedRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankedRow value)  $default,){
final _that = this;
switch (_that) {
case _RankedRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankedRow value)?  $default,){
final _that = this;
switch (_that) {
case _RankedRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int count, @MoneyConverter()  Money amount,  String? subtitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankedRow() when $default != null:
return $default(_that.name,_that.count,_that.amount,_that.subtitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int count, @MoneyConverter()  Money amount,  String? subtitle)  $default,) {final _that = this;
switch (_that) {
case _RankedRow():
return $default(_that.name,_that.count,_that.amount,_that.subtitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int count, @MoneyConverter()  Money amount,  String? subtitle)?  $default,) {final _that = this;
switch (_that) {
case _RankedRow() when $default != null:
return $default(_that.name,_that.count,_that.amount,_that.subtitle);case _:
  return null;

}
}

}

/// @nodoc


class _RankedRow implements RankedRow {
  const _RankedRow({this.name = '', this.count = 0, @MoneyConverter() this.amount = const Money.zero(), this.subtitle});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  int count;
@override@JsonKey()@MoneyConverter() final  Money amount;
@override final  String? subtitle;

/// Create a copy of RankedRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankedRowCopyWith<_RankedRow> get copyWith => __$RankedRowCopyWithImpl<_RankedRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankedRow&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle));
}


@override
int get hashCode => Object.hash(runtimeType,name,count,amount,subtitle);

@override
String toString() {
  return 'RankedRow(name: $name, count: $count, amount: $amount, subtitle: $subtitle)';
}


}

/// @nodoc
abstract mixin class _$RankedRowCopyWith<$Res> implements $RankedRowCopyWith<$Res> {
  factory _$RankedRowCopyWith(_RankedRow value, $Res Function(_RankedRow) _then) = __$RankedRowCopyWithImpl;
@override @useResult
$Res call({
 String name, int count,@MoneyConverter() Money amount, String? subtitle
});




}
/// @nodoc
class __$RankedRowCopyWithImpl<$Res>
    implements _$RankedRowCopyWith<$Res> {
  __$RankedRowCopyWithImpl(this._self, this._then);

  final _RankedRow _self;
  final $Res Function(_RankedRow) _then;

/// Create a copy of RankedRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? count = null,Object? amount = null,Object? subtitle = freezed,}) {
  return _then(_RankedRow(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PlatformSettings {

 int get serviceFeeCentimes; int get vipSurchargeCentimes; int get assignTimeoutSec; int get lateThresholdMin; String get supportPhone; num get deliveryRadiusKm; num get pointsPerHundredDinars; int get pointValueCentimes; num get maxPointsPercentOfSubtotal; bool get electronicPaymentEnabled;
/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformSettingsCopyWith<PlatformSettings> get copyWith => _$PlatformSettingsCopyWithImpl<PlatformSettings>(this as PlatformSettings, _$identity);

  /// Serializes this PlatformSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformSettings&&(identical(other.serviceFeeCentimes, serviceFeeCentimes) || other.serviceFeeCentimes == serviceFeeCentimes)&&(identical(other.vipSurchargeCentimes, vipSurchargeCentimes) || other.vipSurchargeCentimes == vipSurchargeCentimes)&&(identical(other.assignTimeoutSec, assignTimeoutSec) || other.assignTimeoutSec == assignTimeoutSec)&&(identical(other.lateThresholdMin, lateThresholdMin) || other.lateThresholdMin == lateThresholdMin)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.deliveryRadiusKm, deliveryRadiusKm) || other.deliveryRadiusKm == deliveryRadiusKm)&&(identical(other.pointsPerHundredDinars, pointsPerHundredDinars) || other.pointsPerHundredDinars == pointsPerHundredDinars)&&(identical(other.pointValueCentimes, pointValueCentimes) || other.pointValueCentimes == pointValueCentimes)&&(identical(other.maxPointsPercentOfSubtotal, maxPointsPercentOfSubtotal) || other.maxPointsPercentOfSubtotal == maxPointsPercentOfSubtotal)&&(identical(other.electronicPaymentEnabled, electronicPaymentEnabled) || other.electronicPaymentEnabled == electronicPaymentEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceFeeCentimes,vipSurchargeCentimes,assignTimeoutSec,lateThresholdMin,supportPhone,deliveryRadiusKm,pointsPerHundredDinars,pointValueCentimes,maxPointsPercentOfSubtotal,electronicPaymentEnabled);

@override
String toString() {
  return 'PlatformSettings(serviceFeeCentimes: $serviceFeeCentimes, vipSurchargeCentimes: $vipSurchargeCentimes, assignTimeoutSec: $assignTimeoutSec, lateThresholdMin: $lateThresholdMin, supportPhone: $supportPhone, deliveryRadiusKm: $deliveryRadiusKm, pointsPerHundredDinars: $pointsPerHundredDinars, pointValueCentimes: $pointValueCentimes, maxPointsPercentOfSubtotal: $maxPointsPercentOfSubtotal, electronicPaymentEnabled: $electronicPaymentEnabled)';
}


}

/// @nodoc
abstract mixin class $PlatformSettingsCopyWith<$Res>  {
  factory $PlatformSettingsCopyWith(PlatformSettings value, $Res Function(PlatformSettings) _then) = _$PlatformSettingsCopyWithImpl;
@useResult
$Res call({
 int serviceFeeCentimes, int vipSurchargeCentimes, int assignTimeoutSec, int lateThresholdMin, String supportPhone, num deliveryRadiusKm, num pointsPerHundredDinars, int pointValueCentimes, num maxPointsPercentOfSubtotal, bool electronicPaymentEnabled
});




}
/// @nodoc
class _$PlatformSettingsCopyWithImpl<$Res>
    implements $PlatformSettingsCopyWith<$Res> {
  _$PlatformSettingsCopyWithImpl(this._self, this._then);

  final PlatformSettings _self;
  final $Res Function(PlatformSettings) _then;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceFeeCentimes = null,Object? vipSurchargeCentimes = null,Object? assignTimeoutSec = null,Object? lateThresholdMin = null,Object? supportPhone = null,Object? deliveryRadiusKm = null,Object? pointsPerHundredDinars = null,Object? pointValueCentimes = null,Object? maxPointsPercentOfSubtotal = null,Object? electronicPaymentEnabled = null,}) {
  return _then(PlatformSettings(
serviceFeeCentimes: null == serviceFeeCentimes ? _self.serviceFeeCentimes : serviceFeeCentimes // ignore: cast_nullable_to_non_nullable
as int,vipSurchargeCentimes: null == vipSurchargeCentimes ? _self.vipSurchargeCentimes : vipSurchargeCentimes // ignore: cast_nullable_to_non_nullable
as int,assignTimeoutSec: null == assignTimeoutSec ? _self.assignTimeoutSec : assignTimeoutSec // ignore: cast_nullable_to_non_nullable
as int,lateThresholdMin: null == lateThresholdMin ? _self.lateThresholdMin : lateThresholdMin // ignore: cast_nullable_to_non_nullable
as int,supportPhone: null == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String,deliveryRadiusKm: null == deliveryRadiusKm ? _self.deliveryRadiusKm : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
as num,pointsPerHundredDinars: null == pointsPerHundredDinars ? _self.pointsPerHundredDinars : pointsPerHundredDinars // ignore: cast_nullable_to_non_nullable
as num,pointValueCentimes: null == pointValueCentimes ? _self.pointValueCentimes : pointValueCentimes // ignore: cast_nullable_to_non_nullable
as int,maxPointsPercentOfSubtotal: null == maxPointsPercentOfSubtotal ? _self.maxPointsPercentOfSubtotal : maxPointsPercentOfSubtotal // ignore: cast_nullable_to_non_nullable
as num,electronicPaymentEnabled: null == electronicPaymentEnabled ? _self.electronicPaymentEnabled : electronicPaymentEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformSettings].
extension PlatformSettingsPatterns on PlatformSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformSettings value)  $default,){
final _that = this;
switch (_that) {
case _PlatformSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int serviceFeeCentimes,  int vipSurchargeCentimes,  int assignTimeoutSec,  int lateThresholdMin,  String supportPhone,  num deliveryRadiusKm,  num pointsPerHundredDinars,  int pointValueCentimes,  num maxPointsPercentOfSubtotal,  bool electronicPaymentEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
return $default(_that.serviceFeeCentimes,_that.vipSurchargeCentimes,_that.assignTimeoutSec,_that.lateThresholdMin,_that.supportPhone,_that.deliveryRadiusKm,_that.pointsPerHundredDinars,_that.pointValueCentimes,_that.maxPointsPercentOfSubtotal,_that.electronicPaymentEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int serviceFeeCentimes,  int vipSurchargeCentimes,  int assignTimeoutSec,  int lateThresholdMin,  String supportPhone,  num deliveryRadiusKm,  num pointsPerHundredDinars,  int pointValueCentimes,  num maxPointsPercentOfSubtotal,  bool electronicPaymentEnabled)  $default,) {final _that = this;
switch (_that) {
case _PlatformSettings():
return $default(_that.serviceFeeCentimes,_that.vipSurchargeCentimes,_that.assignTimeoutSec,_that.lateThresholdMin,_that.supportPhone,_that.deliveryRadiusKm,_that.pointsPerHundredDinars,_that.pointValueCentimes,_that.maxPointsPercentOfSubtotal,_that.electronicPaymentEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int serviceFeeCentimes,  int vipSurchargeCentimes,  int assignTimeoutSec,  int lateThresholdMin,  String supportPhone,  num deliveryRadiusKm,  num pointsPerHundredDinars,  int pointValueCentimes,  num maxPointsPercentOfSubtotal,  bool electronicPaymentEnabled)?  $default,) {final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
return $default(_that.serviceFeeCentimes,_that.vipSurchargeCentimes,_that.assignTimeoutSec,_that.lateThresholdMin,_that.supportPhone,_that.deliveryRadiusKm,_that.pointsPerHundredDinars,_that.pointValueCentimes,_that.maxPointsPercentOfSubtotal,_that.electronicPaymentEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformSettings implements PlatformSettings {
  const _PlatformSettings({this.serviceFeeCentimes = 5000, this.vipSurchargeCentimes = 10000, this.assignTimeoutSec = 60, this.lateThresholdMin = 45, this.supportPhone = '', this.deliveryRadiusKm = 15, this.pointsPerHundredDinars = 1, this.pointValueCentimes = 100, this.maxPointsPercentOfSubtotal = 50, this.electronicPaymentEnabled = false});
  factory _PlatformSettings.fromJson(Map<String, dynamic> json) => _$PlatformSettingsFromJson(json);

@override@JsonKey() final  int serviceFeeCentimes;
@override@JsonKey() final  int vipSurchargeCentimes;
@override@JsonKey() final  int assignTimeoutSec;
@override@JsonKey() final  int lateThresholdMin;
@override@JsonKey() final  String supportPhone;
@override@JsonKey() final  num deliveryRadiusKm;
@override@JsonKey() final  num pointsPerHundredDinars;
@override@JsonKey() final  int pointValueCentimes;
@override@JsonKey() final  num maxPointsPercentOfSubtotal;
@override@JsonKey() final  bool electronicPaymentEnabled;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformSettingsCopyWith<_PlatformSettings> get copyWith => __$PlatformSettingsCopyWithImpl<_PlatformSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformSettings&&(identical(other.serviceFeeCentimes, serviceFeeCentimes) || other.serviceFeeCentimes == serviceFeeCentimes)&&(identical(other.vipSurchargeCentimes, vipSurchargeCentimes) || other.vipSurchargeCentimes == vipSurchargeCentimes)&&(identical(other.assignTimeoutSec, assignTimeoutSec) || other.assignTimeoutSec == assignTimeoutSec)&&(identical(other.lateThresholdMin, lateThresholdMin) || other.lateThresholdMin == lateThresholdMin)&&(identical(other.supportPhone, supportPhone) || other.supportPhone == supportPhone)&&(identical(other.deliveryRadiusKm, deliveryRadiusKm) || other.deliveryRadiusKm == deliveryRadiusKm)&&(identical(other.pointsPerHundredDinars, pointsPerHundredDinars) || other.pointsPerHundredDinars == pointsPerHundredDinars)&&(identical(other.pointValueCentimes, pointValueCentimes) || other.pointValueCentimes == pointValueCentimes)&&(identical(other.maxPointsPercentOfSubtotal, maxPointsPercentOfSubtotal) || other.maxPointsPercentOfSubtotal == maxPointsPercentOfSubtotal)&&(identical(other.electronicPaymentEnabled, electronicPaymentEnabled) || other.electronicPaymentEnabled == electronicPaymentEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceFeeCentimes,vipSurchargeCentimes,assignTimeoutSec,lateThresholdMin,supportPhone,deliveryRadiusKm,pointsPerHundredDinars,pointValueCentimes,maxPointsPercentOfSubtotal,electronicPaymentEnabled);

@override
String toString() {
  return 'PlatformSettings(serviceFeeCentimes: $serviceFeeCentimes, vipSurchargeCentimes: $vipSurchargeCentimes, assignTimeoutSec: $assignTimeoutSec, lateThresholdMin: $lateThresholdMin, supportPhone: $supportPhone, deliveryRadiusKm: $deliveryRadiusKm, pointsPerHundredDinars: $pointsPerHundredDinars, pointValueCentimes: $pointValueCentimes, maxPointsPercentOfSubtotal: $maxPointsPercentOfSubtotal, electronicPaymentEnabled: $electronicPaymentEnabled)';
}


}

/// @nodoc
abstract mixin class _$PlatformSettingsCopyWith<$Res> implements $PlatformSettingsCopyWith<$Res> {
  factory _$PlatformSettingsCopyWith(_PlatformSettings value, $Res Function(_PlatformSettings) _then) = __$PlatformSettingsCopyWithImpl;
@override @useResult
$Res call({
 int serviceFeeCentimes, int vipSurchargeCentimes, int assignTimeoutSec, int lateThresholdMin, String supportPhone, num deliveryRadiusKm, num pointsPerHundredDinars, int pointValueCentimes, num maxPointsPercentOfSubtotal, bool electronicPaymentEnabled
});




}
/// @nodoc
class __$PlatformSettingsCopyWithImpl<$Res>
    implements _$PlatformSettingsCopyWith<$Res> {
  __$PlatformSettingsCopyWithImpl(this._self, this._then);

  final _PlatformSettings _self;
  final $Res Function(_PlatformSettings) _then;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceFeeCentimes = null,Object? vipSurchargeCentimes = null,Object? assignTimeoutSec = null,Object? lateThresholdMin = null,Object? supportPhone = null,Object? deliveryRadiusKm = null,Object? pointsPerHundredDinars = null,Object? pointValueCentimes = null,Object? maxPointsPercentOfSubtotal = null,Object? electronicPaymentEnabled = null,}) {
  return _then(_PlatformSettings(
serviceFeeCentimes: null == serviceFeeCentimes ? _self.serviceFeeCentimes : serviceFeeCentimes // ignore: cast_nullable_to_non_nullable
as int,vipSurchargeCentimes: null == vipSurchargeCentimes ? _self.vipSurchargeCentimes : vipSurchargeCentimes // ignore: cast_nullable_to_non_nullable
as int,assignTimeoutSec: null == assignTimeoutSec ? _self.assignTimeoutSec : assignTimeoutSec // ignore: cast_nullable_to_non_nullable
as int,lateThresholdMin: null == lateThresholdMin ? _self.lateThresholdMin : lateThresholdMin // ignore: cast_nullable_to_non_nullable
as int,supportPhone: null == supportPhone ? _self.supportPhone : supportPhone // ignore: cast_nullable_to_non_nullable
as String,deliveryRadiusKm: null == deliveryRadiusKm ? _self.deliveryRadiusKm : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
as num,pointsPerHundredDinars: null == pointsPerHundredDinars ? _self.pointsPerHundredDinars : pointsPerHundredDinars // ignore: cast_nullable_to_non_nullable
as num,pointValueCentimes: null == pointValueCentimes ? _self.pointValueCentimes : pointValueCentimes // ignore: cast_nullable_to_non_nullable
as int,maxPointsPercentOfSubtotal: null == maxPointsPercentOfSubtotal ? _self.maxPointsPercentOfSubtotal : maxPointsPercentOfSubtotal // ignore: cast_nullable_to_non_nullable
as num,electronicPaymentEnabled: null == electronicPaymentEnabled ? _self.electronicPaymentEnabled : electronicPaymentEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Voucher {

 String get id; String get code; String get type; num get value; int get minOrderCentimes; int get maxUses; int get usedCount; int get perUserLimit;@NullableDateConverter() DateTime? get startsAt;@NullableDateConverter() DateTime? get endsAt; bool get isActive;
/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoucherCopyWith<Voucher> get copyWith => _$VoucherCopyWithImpl<Voucher>(this as Voucher, _$identity);

  /// Serializes this Voucher to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Voucher&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.minOrderCentimes, minOrderCentimes) || other.minOrderCentimes == minOrderCentimes)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.usedCount, usedCount) || other.usedCount == usedCount)&&(identical(other.perUserLimit, perUserLimit) || other.perUserLimit == perUserLimit)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,type,value,minOrderCentimes,maxUses,usedCount,perUserLimit,startsAt,endsAt,isActive);

@override
String toString() {
  return 'Voucher(id: $id, code: $code, type: $type, value: $value, minOrderCentimes: $minOrderCentimes, maxUses: $maxUses, usedCount: $usedCount, perUserLimit: $perUserLimit, startsAt: $startsAt, endsAt: $endsAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $VoucherCopyWith<$Res>  {
  factory $VoucherCopyWith(Voucher value, $Res Function(Voucher) _then) = _$VoucherCopyWithImpl;
@useResult
$Res call({
 String id, String code, String type, num value, int minOrderCentimes, int maxUses, int usedCount, int perUserLimit,@NullableDateConverter() DateTime? startsAt,@NullableDateConverter() DateTime? endsAt, bool isActive
});




}
/// @nodoc
class _$VoucherCopyWithImpl<$Res>
    implements $VoucherCopyWith<$Res> {
  _$VoucherCopyWithImpl(this._self, this._then);

  final Voucher _self;
  final $Res Function(Voucher) _then;

/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? type = null,Object? value = null,Object? minOrderCentimes = null,Object? maxUses = null,Object? usedCount = null,Object? perUserLimit = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? isActive = null,}) {
  return _then(Voucher(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,minOrderCentimes: null == minOrderCentimes ? _self.minOrderCentimes : minOrderCentimes // ignore: cast_nullable_to_non_nullable
as int,maxUses: null == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int,usedCount: null == usedCount ? _self.usedCount : usedCount // ignore: cast_nullable_to_non_nullable
as int,perUserLimit: null == perUserLimit ? _self.perUserLimit : perUserLimit // ignore: cast_nullable_to_non_nullable
as int,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Voucher].
extension VoucherPatterns on Voucher {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Voucher value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Voucher() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Voucher value)  $default,){
final _that = this;
switch (_that) {
case _Voucher():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Voucher value)?  $default,){
final _that = this;
switch (_that) {
case _Voucher() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String type,  num value,  int minOrderCentimes,  int maxUses,  int usedCount,  int perUserLimit, @NullableDateConverter()  DateTime? startsAt, @NullableDateConverter()  DateTime? endsAt,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Voucher() when $default != null:
return $default(_that.id,_that.code,_that.type,_that.value,_that.minOrderCentimes,_that.maxUses,_that.usedCount,_that.perUserLimit,_that.startsAt,_that.endsAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String type,  num value,  int minOrderCentimes,  int maxUses,  int usedCount,  int perUserLimit, @NullableDateConverter()  DateTime? startsAt, @NullableDateConverter()  DateTime? endsAt,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Voucher():
return $default(_that.id,_that.code,_that.type,_that.value,_that.minOrderCentimes,_that.maxUses,_that.usedCount,_that.perUserLimit,_that.startsAt,_that.endsAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String type,  num value,  int minOrderCentimes,  int maxUses,  int usedCount,  int perUserLimit, @NullableDateConverter()  DateTime? startsAt, @NullableDateConverter()  DateTime? endsAt,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Voucher() when $default != null:
return $default(_that.id,_that.code,_that.type,_that.value,_that.minOrderCentimes,_that.maxUses,_that.usedCount,_that.perUserLimit,_that.startsAt,_that.endsAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Voucher implements Voucher {
  const _Voucher({required this.id, required this.code, this.type = 'percentage', this.value = 0, this.minOrderCentimes = 0, this.maxUses = 0, this.usedCount = 0, this.perUserLimit = 1, @NullableDateConverter() this.startsAt, @NullableDateConverter() this.endsAt, this.isActive = true});
  factory _Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);

@override final  String id;
@override final  String code;
@override@JsonKey() final  String type;
@override@JsonKey() final  num value;
@override@JsonKey() final  int minOrderCentimes;
@override@JsonKey() final  int maxUses;
@override@JsonKey() final  int usedCount;
@override@JsonKey() final  int perUserLimit;
@override@NullableDateConverter() final  DateTime? startsAt;
@override@NullableDateConverter() final  DateTime? endsAt;
@override@JsonKey() final  bool isActive;

/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoucherCopyWith<_Voucher> get copyWith => __$VoucherCopyWithImpl<_Voucher>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoucherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Voucher&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.minOrderCentimes, minOrderCentimes) || other.minOrderCentimes == minOrderCentimes)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.usedCount, usedCount) || other.usedCount == usedCount)&&(identical(other.perUserLimit, perUserLimit) || other.perUserLimit == perUserLimit)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,type,value,minOrderCentimes,maxUses,usedCount,perUserLimit,startsAt,endsAt,isActive);

@override
String toString() {
  return 'Voucher(id: $id, code: $code, type: $type, value: $value, minOrderCentimes: $minOrderCentimes, maxUses: $maxUses, usedCount: $usedCount, perUserLimit: $perUserLimit, startsAt: $startsAt, endsAt: $endsAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$VoucherCopyWith<$Res> implements $VoucherCopyWith<$Res> {
  factory _$VoucherCopyWith(_Voucher value, $Res Function(_Voucher) _then) = __$VoucherCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String type, num value, int minOrderCentimes, int maxUses, int usedCount, int perUserLimit,@NullableDateConverter() DateTime? startsAt,@NullableDateConverter() DateTime? endsAt, bool isActive
});




}
/// @nodoc
class __$VoucherCopyWithImpl<$Res>
    implements _$VoucherCopyWith<$Res> {
  __$VoucherCopyWithImpl(this._self, this._then);

  final _Voucher _self;
  final $Res Function(_Voucher) _then;

/// Create a copy of Voucher
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? type = null,Object? value = null,Object? minOrderCentimes = null,Object? maxUses = null,Object? usedCount = null,Object? perUserLimit = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? isActive = null,}) {
  return _then(_Voucher(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,minOrderCentimes: null == minOrderCentimes ? _self.minOrderCentimes : minOrderCentimes // ignore: cast_nullable_to_non_nullable
as int,maxUses: null == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int,usedCount: null == usedCount ? _self.usedCount : usedCount // ignore: cast_nullable_to_non_nullable
as int,perUserLimit: null == perUserLimit ? _self.perUserLimit : perUserLimit // ignore: cast_nullable_to_non_nullable
as int,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ManagedUser {

 String get id; String get fullName; String get phone; bool get isActive; bool get isBlocked; int get points; bool get isOnline;@NullableDateConverter() DateTime? get createdAt;
/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedUserCopyWith<ManagedUser> get copyWith => _$ManagedUserCopyWithImpl<ManagedUser>(this as ManagedUser, _$identity);

  /// Serializes this ManagedUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.points, points) || other.points == points)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,phone,isActive,isBlocked,points,isOnline,createdAt);

@override
String toString() {
  return 'ManagedUser(id: $id, fullName: $fullName, phone: $phone, isActive: $isActive, isBlocked: $isBlocked, points: $points, isOnline: $isOnline, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ManagedUserCopyWith<$Res>  {
  factory $ManagedUserCopyWith(ManagedUser value, $Res Function(ManagedUser) _then) = _$ManagedUserCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String phone, bool isActive, bool isBlocked, int points, bool isOnline,@NullableDateConverter() DateTime? createdAt
});




}
/// @nodoc
class _$ManagedUserCopyWithImpl<$Res>
    implements $ManagedUserCopyWith<$Res> {
  _$ManagedUserCopyWithImpl(this._self, this._then);

  final ManagedUser _self;
  final $Res Function(ManagedUser) _then;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? phone = null,Object? isActive = null,Object? isBlocked = null,Object? points = null,Object? isOnline = null,Object? createdAt = freezed,}) {
  return _then(ManagedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedUser].
extension ManagedUserPatterns on ManagedUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedUser value)  $default,){
final _that = this;
switch (_that) {
case _ManagedUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedUser value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String phone,  bool isActive,  bool isBlocked,  int points,  bool isOnline, @NullableDateConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.isActive,_that.isBlocked,_that.points,_that.isOnline,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String phone,  bool isActive,  bool isBlocked,  int points,  bool isOnline, @NullableDateConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedUser():
return $default(_that.id,_that.fullName,_that.phone,_that.isActive,_that.isBlocked,_that.points,_that.isOnline,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String phone,  bool isActive,  bool isBlocked,  int points,  bool isOnline, @NullableDateConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.isActive,_that.isBlocked,_that.points,_that.isOnline,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagedUser implements ManagedUser {
  const _ManagedUser({required this.id, this.fullName = '', this.phone = '', this.isActive = true, this.isBlocked = false, this.points = 0, this.isOnline = false, @NullableDateConverter() this.createdAt});
  factory _ManagedUser.fromJson(Map<String, dynamic> json) => _$ManagedUserFromJson(json);

@override final  String id;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String phone;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isBlocked;
@override@JsonKey() final  int points;
@override@JsonKey() final  bool isOnline;
@override@NullableDateConverter() final  DateTime? createdAt;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedUserCopyWith<_ManagedUser> get copyWith => __$ManagedUserCopyWithImpl<_ManagedUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagedUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.points, points) || other.points == points)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,phone,isActive,isBlocked,points,isOnline,createdAt);

@override
String toString() {
  return 'ManagedUser(id: $id, fullName: $fullName, phone: $phone, isActive: $isActive, isBlocked: $isBlocked, points: $points, isOnline: $isOnline, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedUserCopyWith<$Res> implements $ManagedUserCopyWith<$Res> {
  factory _$ManagedUserCopyWith(_ManagedUser value, $Res Function(_ManagedUser) _then) = __$ManagedUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String phone, bool isActive, bool isBlocked, int points, bool isOnline,@NullableDateConverter() DateTime? createdAt
});




}
/// @nodoc
class __$ManagedUserCopyWithImpl<$Res>
    implements _$ManagedUserCopyWith<$Res> {
  __$ManagedUserCopyWithImpl(this._self, this._then);

  final _ManagedUser _self;
  final $Res Function(_ManagedUser) _then;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? phone = null,Object? isActive = null,Object? isBlocked = null,Object? points = null,Object? isOnline = null,Object? createdAt = freezed,}) {
  return _then(_ManagedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
