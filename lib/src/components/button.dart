import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

enum OloidButtonVariant {
  /// 주 액션. primary 배경.
  primary,

  /// 화면에 주 액션이 따로 있을 때의 조용한 액션. primary 10% 배경.
  tonal,

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
    this.icon,
    this.color,
    this.expand = true,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final OloidButtonVariant variant;

  /// 라벨 앞 아이콘. 진행 중 표시처럼 Icon이 아닌 위젯도 받는다.
  final Widget? icon;

  /// 배경색을 직접 지정할 때(예: 의미 색). [variant]보다 우선한다.
  final Color? color;
  final bool expand;

  /// 패널 안에 다른 컨트롤과 나란히 둘 때. 높이를 40 안팎으로 줄인다.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    final (background, foreground) = switch (variant) {
      OloidButtonVariant.primary => (color ?? c.primary, Colors.white),
      OloidButtonVariant.tonal => (
          (color ?? c.primary).withValues(alpha: 0.1),
          color ?? c.primary,
        ),
      // 비활성(textSecondary)과 구분되도록 본문보다 한 단계 옅은 글자색을 쓴다.
      OloidButtonVariant.secondary => (
          color ?? c.surface,
          c.textPrimary.withValues(alpha: 0.7),
        ),
      OloidButtonVariant.destructive => (color ?? c.danger, Colors.white),
    };

    final style = ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: c.backgroundSecondary,
      disabledForegroundColor: c.textSecondary,
      padding: EdgeInsets.symmetric(
        vertical: dense ? 10 : 16,
        horizontal: dense ? 16 : 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OloidRadius.button),
      ),
      elevation: 0,
    );
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: OloidTypography.button.copyWith(
        color: onPressed == null ? c.textSecondary : foreground,
      ),
    );
    final button = icon == null
        ? ElevatedButton(onPressed: onPressed, style: style, child: text)
        : ElevatedButton.icon(
            onPressed: onPressed,
            style: style,
            icon: icon,
            label: text,
          );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
