import 'package:flutter/material.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmering placeholder block. Every list in the app shows these while it
/// loads — no blank screens, ever.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = AppRadius.small,
  });

  const AppSkeleton.card({super.key})
      : width = double.infinity,
        height = 300,
        radius = AppRadius.card;

  const AppSkeleton.circle({super.key, double size = AppSizes.categoryCircle})
      : width = size,
        height = size,
        radius = AppRadius.stadium;

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.searchFill,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.searchFill,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// A column of skeletons sized like the list it stands in for.
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({
    super.key,
    this.count = 3,
    this.itemHeight = 300,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
  });

  final int count;
  final double itemHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding.add(const EdgeInsets.symmetric(vertical: AppSpacing.lg)),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (_, __) => AppSkeleton(height: itemHeight, radius: AppRadius.card),
    );
  }
}
