// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  phone: json['phone'] as String,
  fullName: json['fullName'] as String,
  role:
      $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.customer,
  avatar: json['avatar'] == null
      ? null
      : ImageRef.fromJson(json['avatar'] as Map<String, dynamic>),
  isActive: json['isActive'] as bool? ?? true,
  isBlocked: json['isBlocked'] as bool? ?? false,
  points: (json['points'] as num?)?.toInt() ?? 0,
  defaultAddress: _defaultAddressId(json['defaultAddress']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'fullName': instance.fullName,
  'role': _$UserRoleEnumMap[instance.role]!,
  'avatar': instance.avatar,
  'isActive': instance.isActive,
  'isBlocked': instance.isBlocked,
  'points': instance.points,
  'defaultAddress': instance.defaultAddress,
};

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.agent: 'agent',
  UserRole.admin: 'admin',
  UserRole.vendor: 'vendor',
};

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{
      'user': instance.user,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
