import 'dart:async';

import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

enum OloidToastTone { success, error, warning, info }

/// 짧은 상태 메시지. 화면별 SnackBar 대신 쓴다.
///
/// 상단 중앙 floating pill, 좌우 20px margin, radius 26, 2초 뒤 자동으로
/// 닫힌다. memoaid는 toastification으로 같은 모양을 그리지만, 이 패키지는
/// 외부 의존과 앱 쪽 wrapper 없이 Overlay로 직접 그린다.
abstract final class OloidToast {
  static OverlayEntry? _current;
  static Timer? _timer;

  static void success(BuildContext context, String message) =>
      show(context, message, tone: OloidToastTone.success);

  static void error(BuildContext context, String message) =>
      show(context, message, tone: OloidToastTone.error);

  static void warning(BuildContext context, String message) =>
      show(context, message, tone: OloidToastTone.warning);

  static void info(BuildContext context, String message) =>
      show(context, message, tone: OloidToastTone.info);

  static void show(
    BuildContext context,
    String message, {
    OloidToastTone tone = OloidToastTone.info,
    Duration duration = OloidMotion.toast,
  }) {
    if (!context.mounted) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    final c = OloidColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (background, icon) = switch (tone) {
      OloidToastTone.success => (c.primary, Icons.check_rounded),
      OloidToastTone.error => (const Color(0xFFE5484D), Icons.close_rounded),
      OloidToastTone.warning => (c.warning, Icons.schedule_rounded),
      OloidToastTone.info => (
          isDark ? const Color(0xFFF1F1F1) : const Color(0xFF333333),
          Icons.info_rounded,
        ),
    };
    final foreground = tone == OloidToastTone.info && isDark
        ? const Color(0xFF252525)
        : Colors.white;

    dismiss();
    final entry = OverlayEntry(
      builder: (_) => _ToastView(
        message: message,
        icon: icon,
        background: background,
        foreground: foreground,
      ),
    );
    _current = entry;
    overlay.insert(entry);
    _timer = Timer(duration, dismiss);
  }

  /// 떠 있는 토스트를 바로 닫는다.
  static void dismiss() {
    _timer?.cancel();
    _timer = null;
    _current?.remove();
    _current = null;
  }
}

class _ToastView extends StatelessWidget {
  const _ToastView({
    required this.message,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String message;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      top: MediaQuery.paddingOf(context).top + 8,
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: OloidMotion.fast,
          curve: OloidMotion.enter,
          builder: (context, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * -12),
              child: child,
            ),
          ),
          child: Center(
            child: Semantics(
              liveRegion: true,
              child: Material(
                color: background,
                borderRadius: BorderRadius.circular(26),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: foreground, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: OloidTypography.caption.copyWith(
                            color: foreground,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
