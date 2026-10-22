import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';
import 'button.dart';

/// sheet 상단 중앙의 drag handle.
class OloidDragHandle extends StatelessWidget {
  const OloidDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: OloidColors.of(context).backgroundSecondary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// 작성·편집·상세용 기본 bottom sheet를 연다.
///
/// [heightFactor]를 주면 화면 높이의 그 비율로 고정한다(입력 sheet는 0.7,
/// 큰 상세 sheet는 0.9). 키보드가 올라오면 그만큼 위로 밀린다.
Future<T?> showOloidBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  double? heightFactor,
  bool showDragHandle = true,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: isDismissible,
    builder: (context) {
      final c = OloidColors.of(context);
      final media = MediaQuery.of(context);
      Widget body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) const OloidDragHandle(),
          Flexible(child: builder(context)),
        ],
      );
      if (heightFactor != null) {
        body = SizedBox(height: media.size.height * heightFactor, child: body);
      }
      return Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: c.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(OloidRadius.sheet),
            ),
            border: Border.all(color: c.backgroundSecondary, width: 0.5),
          ),
          child: SafeArea(top: false, child: body),
        ),
      );
    },
  );
}

/// 떠 있는 카드형(dialog형) sheet의 외곽. 확인·정보 sheet가 이 위에 올라간다.
class OloidDialogSheet extends StatelessWidget {
  const OloidDialogSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: OloidColors.of(context).background,
            borderRadius: BorderRadius.circular(OloidRadius.dialog),
            boxShadow: OloidShadows.dialog,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const OloidDragHandle(), child],
          ),
        ),
      ),
    );
  }
}

/// 삭제·수정처럼 중요한 액션 전에 확인을 받는 sheet.
///
/// 확인을 누르면 true, 취소를 누르면 false, 바깥을 눌러 닫으면 null.
class OloidConfirmSheet extends StatelessWidget {
  const OloidConfirmSheet({
    super.key,
    required this.title,
    this.content,
    this.bullets,
    required this.confirmText,
    this.cancelText = '취소',
    this.destructive = false,
    this.confirmColor,
  });

  final String title;

  /// 한 문단 본문. [bullets]가 있으면 대신 목록을 그린다.
  final String? content;
  final List<String>? bullets;
  final String confirmText;
  final String cancelText;
  final bool destructive;
  final Color? confirmColor;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? content,
    List<String>? bullets,
    required String confirmText,
    String cancelText = '취소',
    bool destructive = false,
    Color? confirmColor,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OloidConfirmSheet(
        title: title,
        content: content,
        bullets: bullets,
        confirmText: confirmText,
        cancelText: cancelText,
        destructive: destructive,
        confirmColor: confirmColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OloidDialogSheet(
      child: _SheetBody(
        title: title,
        content: content,
        bullets: bullets,
        actions: Row(
          children: [
            Expanded(
              child: OloidButton(
                label: cancelText,
                variant: OloidButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OloidButton(
                label: confirmText,
                variant: destructive
                    ? OloidButtonVariant.destructive
                    : OloidButtonVariant.primary,
                color: confirmColor,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 안내만 하고 확인 버튼 하나로 닫는 sheet.
class OloidInfoSheet extends StatelessWidget {
  const OloidInfoSheet({
    super.key,
    required this.title,
    this.content,
    this.bullets,
    this.buttonText = '확인',
  }) : assert(content != null || bullets != null);

  final String title;
  final String? content;
  final List<String>? bullets;
  final String buttonText;

  static Future<void> show(
    BuildContext context, {
    required String title,
    String? content,
    List<String>? bullets,
    String buttonText = '확인',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OloidInfoSheet(
        title: title,
        content: content,
        bullets: bullets,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OloidDialogSheet(
      child: _SheetBody(
        title: title,
        content: content,
        bullets: bullets,
        actions: OloidButton(
          label: buttonText,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({
    required this.title,
    required this.content,
    required this.bullets,
    required this.actions,
  });

  final String title;
  final String? content;
  final List<String>? bullets;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    final bodyStyle = OloidTypography.body.copyWith(
      color: c.textPrimary.withValues(alpha: 0.7),
    );
    final bulletList = bullets;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            title,
            style: OloidTypography.headline.copyWith(color: c.textPrimary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OloidSpacing.sheet),
          child: bulletList != null && bulletList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in bulletList)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 16,
                              child: Text(
                                '•',
                                style: bodyStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(child: Text(line, style: bodyStyle)),
                          ],
                        ),
                      ),
                  ],
                )
              : Text(content ?? '', style: bodyStyle),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: actions,
        ),
      ],
    );
  }
}
