import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

enum OloidButtonVariant {
  /// 주 액션. primary 배경.
  primary,

  /// 취소·보조 액션. surface 배경.
  secondary,

  /// 삭제처럼 되돌리기 어려운 액션. danger 배경.
  destructive,
}

/// sheet와 화면 하단에서 쓰는 기본 버튼. 단일 액션은 full-width,
/// 확인/취소는 [Expanded] 두 개로 같은 너비를 맞춘다.
class OloidButton extends StatelessWidget {
  const OloidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = OloidButtonVariant.primary,
    this.color,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final OloidButtonVariant variant;

  /// 배경색을 직접 지정할 때(예: 의미 색). [variant]보다 우선한다.
  final Color? color;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    final (background, foreground) = switch (variant) {
      OloidButtonVariant.primary => (color ?? c.primary, Colors.white),
      OloidButtonVariant.secondary => (color ?? c.surface, c.textSecondary),
      OloidButtonVariant.destructive => (color ?? c.danger, Colors.white),
    };

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledBackgroundColor: c.backgroundSecondary,
        disabledForegroundColor: c.textSecondary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OloidRadius.button),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: OloidTypography.button.copyWith(color: foreground),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
