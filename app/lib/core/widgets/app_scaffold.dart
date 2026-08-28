import 'package:flutter/material.dart';
import 'package:saji/app/theme/tokens.dart';

/// The standard customer screen shell. Keeps background colour, bar handling
/// and bottom-bar extension consistent across every screen.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.bottomBar,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = true,
    this.backgroundColor = AppColors.background,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? bottomBar;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: true,
      floatingActionButton: floatingActionButton,
      body: body,
      bottomNavigationBar: bottomBar ?? bottomNavigationBar,
    );
  }
}

/// Wraps a body in the three states every async screen must have.
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    required this.value,
    required this.onData,
    required this.onLoading,
    required this.onError,
    super.key,
  });

  final AsyncSnapshotLike<T> value;
  final Widget Function(T data) onData;
  final Widget Function() onLoading;
  final Widget Function(Object error) onError;

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) return onLoading();
    if (value.error != null) return onError(value.error!);
    return onData(value.data as T);
  }
}

/// A tiny transport-agnostic snapshot, so widgets do not depend on Riverpod's
/// AsyncValue directly in their signatures.
class AsyncSnapshotLike<T> {
  const AsyncSnapshotLike({this.data, this.error, this.isLoading = false});

  final T? data;
  final Object? error;
  final bool isLoading;
}
