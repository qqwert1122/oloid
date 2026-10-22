import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

/// 상단 고정 헤더. 배경에서 투명으로 사라지는 gradient 위에 중앙 제목을 둔다.
/// 스크롤 뒤에도 제목이 필요할 때 무거운 AppBar 대신 쓴다.
class OloidPinnedAppBar extends StatelessWidget {
  const OloidPinnedAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.leading1,
    this.leading2,
    this.trailing1,
    this.trailing2,
  });

  static const double height = 64;

  final String title;
  final Widget? titleWidget;
  final Widget? leading1;
  final Widget? leading2;
  final Widget? trailing1;
  final Widget? trailing2;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            c.background,
            c.background.withValues(alpha: 0.8),
            c.background.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 48, child: leading1),
          SizedBox(width: 48, child: leading2),
          Expanded(
            child: titleWidget ??
                Text(
                  title,
                  style: OloidTypography.subTitle.copyWith(
                    color: c.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
          ),
          SizedBox(width: 48, child: trailing2),
          SizedBox(width: 48, child: trailing1),
        ],
      ),
    );
  }
}

/// 하단 플로팅 입력/검색/추가 바. 기록 생성과 빠른 검색의 진입점이다.
///
/// 화면 하단에 `Positioned(left: 0, right: 0, bottom: 0, child: OloidFloatingBar(...))`
/// 로 둔다. 위쪽은 배경색으로 서서히 덮여 리스트가 자연스럽게 사라진다.
class OloidFloatingBar extends StatelessWidget {
  const OloidFloatingBar({
    super.key,
    required this.placeholder,
    required this.onTap,
    this.icon = Icons.add_rounded,
  });

  final String placeholder;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            c.background.withValues(alpha: 0),
            c.background.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.8],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Semantics(
          button: true,
          label: placeholder,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: BorderRadius.circular(OloidRadius.pill),
                border: Border.all(
                  color: c.textSecondary.withValues(alpha: isDark ? 0.2 : 0.6),
                  width: 0.5,
                ),
                boxShadow: OloidShadows.floating(c),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OloidTypography.body.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, color: c.primary, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
