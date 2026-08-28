import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/auth/data/auth_repository.dart';
import 'package:saji/features/auth/domain/user.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    client: ref.watch(apiClientProvider),
    storage: ref.watch(tokenStorageProvider),
  ),
);

enum AuthPhase { unknown, authenticated, unauthenticated }

@immutable
class AuthState {
  const AuthState({
    this.phase = AuthPhase.unknown,
    this.user,
    this.isSubmitting = false,
    this.failure,
  });

  final AuthPhase phase;
  final AppUser? user;
  final bool isSubmitting;
  final Failure? failure;

  bool get isAuthenticated => phase == AuthPhase.authenticated && user != null;
  bool get isResolved => phase != AuthPhase.unknown;

  UserRole get role => user?.role ?? UserRole.customer;

  AuthState copyWith({
    AuthPhase? phase,
    AppUser? user,
    bool? isSubmitting,
    Failure? failure,
    bool clearFailure = false,
    bool clearUser = false,
  }) {
    return AuthState(
      phase: phase ?? this.phase,
      user: clearUser ? null : (user ?? this.user),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

/// Owns the session: restores it on launch, connects the socket, registers the
/// push token, and tears everything down on logout.
class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState()) {
    _ref.read(sessionExpiredProvider).handler = _onSessionExpired;
  }

  final Ref _ref;

  AuthRepository get _repository => _ref.read(authRepositoryProvider);

  Future<void> restoreSession() async {
    if (!await _repository.hasStoredSession()) {
      state = state.copyWith(phase: AuthPhase.unauthenticated, clearUser: true);
      return;
    }

    final result = await _repository.me();
    switch (result) {
      case Ok(:final value):
        state = state.copyWith(phase: AuthPhase.authenticated, user: value);
        await _afterLogin(value);
      case Err(:final failure):
        // A network blip must not sign the user out — only an auth failure does.
        if (failure.isOffline) {
          state = state.copyWith(phase: AuthPhase.authenticated);
        } else {
          state = state.copyWith(phase: AuthPhase.unauthenticated, clearUser: true);
        }
    }
  }

  Future<bool> login({required String phone, required String password}) async {
    state = state.copyWith(isSubmitting: true, clearFailure: true);
    final result = await _repository.login(phone: phone, password: password);
    return _handleSession(result);
  }

  Future<bool> register({
    required String phone,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isSubmitting: true, clearFailure: true);
    final result = await _repository.register(
      phone: phone,
      password: password,
      fullName: fullName,
    );
    return _handleSession(result);
  }

  Future<bool> _handleSession(Result<AuthSession> result) async {
    switch (result) {
      case Ok(:final value):
        state = state.copyWith(
          phase: AuthPhase.authenticated,
          user: value.user,
          isSubmitting: false,
          clearFailure: true,
        );
        await _afterLogin(value.user);
        return true;
      case Err(:final failure):
        state = state.copyWith(isSubmitting: false, failure: failure);
        return false;
    }
  }

  Future<void> _afterLogin(AppUser user) async {
    final token = await _ref.read(tokenStorageProvider).readAccessToken();
    if (token != null) {
      await _ref.read(socketServiceProvider).connect(token);
    }

    final notifications = _ref.read(notificationServiceProvider);
    final fcmToken = await notifications.token();
    if (fcmToken != null) {
      await _repository.registerFcmToken(fcmToken, notifications.platform);
    }
  }

  /// Re-reads the profile — used after an order changes the points balance.
  Future<void> refreshUser() async {
    final result = await _repository.me();
    if (result case Ok(:final value)) {
      state = state.copyWith(user: value);
    }
  }

  void setUser(AppUser user) => state = state.copyWith(user: user);

  Future<void> logout() async {
    await _repository.logout();
    await _ref.read(socketServiceProvider).disconnect();
    state = const AuthState(phase: AuthPhase.unauthenticated);
  }

  Future<void> _onSessionExpired() async {
    await _ref.read(socketServiceProvider).disconnect();
    state = const AuthState(phase: AuthPhase.unauthenticated);
  }

  void clearFailure() => state = state.copyWith(clearFailure: true);
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

final currentUserProvider = Provider<AppUser?>(
  (ref) => ref.watch(authControllerProvider).user,
);
