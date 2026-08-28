import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saji/core/models/image_ref.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  @JsonValue('customer')
  customer,
  @JsonValue('agent')
  agent,
  @JsonValue('admin')
  admin;

  bool get isCustomer => this == UserRole.customer;
  bool get isAgent => this == UserRole.agent;
  bool get isAdmin => this == UserRole.admin;
}

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String phone,
    required String fullName,
    @Default(UserRole.customer) UserRole role,
    ImageRef? avatar,
    @Default(true) bool isActive,
    @Default(false) bool isBlocked,
    @Default(0) int points,
    @JsonKey(fromJson: _defaultAddressId) String? defaultAddress,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}

String? _defaultAddressId(Object? json) {
  if (json is String) return json;
  if (json is Map) return json['id'] as String?;
  return null;
}

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required AppUser user,
    required String accessToken,
    required String refreshToken,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);
}
