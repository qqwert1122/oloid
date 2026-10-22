import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

/// 화면 제목. 무거운 AppBar 대신 단순 텍스트로 둔다.
class OloidPageTitle extends StatelessWidget {
  const OloidPageTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: OloidSpacing.pageTitle,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: OloidTypography.title.copyWith(
                color: OloidColors.of(context).textPrimary,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// 기록성 콘텐츠의 기본 단위. 카드 대신 흰 row와 얇은 하단 구분선으로 나눈다.
class OloidListRow extends StatelessWidget {
  const OloidListRow({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(OloidSpacing.row),
    this.showDivider = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    return Material(
      color: c.background,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: showDivider
              ? BoxDecoration(
                  border: Border(bottom: BorderSide(color: c.divider)),
                )
              : null,
          child: child,
        ),
      ),
    );
  }
}

/// 메타데이터 chip. 본문보다 강해지지 않도록 accent 15% 면에 작게 붙인다.
class OloidChip extends StatelessWidget {
  const OloidChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.onTap,
  }) : _semantic = null;

  const OloidChip._semantic(
    this._semantic, {
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  }) : color = null;

  /// `#태그`. 중립 색.
  const OloidChip.tag(String name, {Key? key, VoidCallback? onTap})
      : this._semantic(null, key: key, label: '#$name', onTap: onTap);

  /// `@사람`. person 색.
  const OloidChip.person(String name, {Key? key, VoidCallback? onTap})
      : this._semantic(_personColor, key: key, label: '@$name', onTap: onTap);

  /// 장소 아이콘 + 이름. location 색.
  const OloidChip.location(String name, {Key? key, VoidCallback? onTap})
      : this._semantic(
          _locationColor,
          key: key,
          label: name,
          icon: Icons.location_on_rounded,
          onTap: onTap,
        );

  static Color _personColor(OloidColors c) => c.person;
  static Color _locationColor(OloidColors c) => c.location;

  final String label;

  /// 의미 색. 없으면 중립(textPrimary).
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color Function(OloidColors)? _semantic;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    final accent = color ?? _semantic?.call(c) ?? c.neutral;
    final chip = Container(
      padding: OloidSpacing.chip,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(OloidRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: OloidIconSize.metadata, color: accent),
            const SizedBox(width: 2),
          ],
          Text(label, style: OloidTypography.caption.copyWith(color: accent)),
        ],
      ),
    );
    if (onTap == null) return chip;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap!();
      },
      child: chip,
    );
  }
}

/// 독립된 정보 덩어리(stat card, 요약 등)를 담는 조용한 면.
class OloidPanel extends StatelessWidget {
  const OloidPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: OloidColors.of(context).surface,
        borderRadius: BorderRadius.circular(OloidRadius.card),
      ),
      child: child,
    );
  }
}

/// 설정형 화면의 섹션 제목.
class OloidSectionHeader extends StatelessWidget {
  const OloidSectionHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        text,
        style: OloidTypography.subTitle.copyWith(
          fontWeight: FontWeight.w600,
          color: OloidColors.of(context).textPrimary,
        ),
      ),
    );
  }
}

/// 설정 row. 탭하면 light haptic 후 [onTap]을 부른다.
class OloidSettingRow extends StatelessWidget {
  const OloidSettingRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  /// 상태를 알리는 아이콘일 때만 의미 색을 준다. 기본은 textSecondary.
  final Color? iconColor;

  /// 없고 [onTap]이 있으면 chevron을 그린다.
  final Widget? trailing;
  final VoidCallback? onTap;

  /// 패널 안에 넣을 때는 좌우 여백을 0으로 둔다.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onTap!();
            },
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: OloidIconSize.nav,
                color: iconColor ?? c.textSecondary,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: OloidTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: OloidTypography.caption.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: OloidIconSize.nav,
                color: c.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// 빈 상태. 남은 영역의 세로 중앙에 짧은 secondary 문구로 둔다.
/// 상세 화면의 섹션만 비었다면 [centered]를 false로 두고 본문 흐름에 넣는다.
class OloidEmptyState extends StatelessWidget {
  const OloidEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.centered = true,
  });

  final String message;
  final IconData? icon;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: OloidIconSize.picker, color: c.textSecondary),
          const SizedBox(height: 8),
        ],
        Text(
          message,
          textAlign: TextAlign.center,
          style: OloidTypography.body.copyWith(color: c.textSecondary),
        ),
      ],
    );
    if (!centered) {
      return Padding(padding: const EdgeInsets.only(top: 16), child: content);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: OloidSpacing.screen),
        child: content,
      ),
    );
  }
}
