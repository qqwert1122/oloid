import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';

/// AI 보조 surface 전용 장식. 일반 카드에는 쓰지 않는다.
abstract final class OloidAiDecoration {
  static BoxDecoration card(
    BuildContext context, {
    double radius = OloidRadius.pill,
  }) {
    final c = OloidColors.of(context);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [c.aiGradientStart, c.aiGradientMid, c.aiGradientEnd],
        stops: const [0.0, 0.48, 1.0],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: c.aiBorder),
    );
  }

  /// AI 카드 안에 한 번 더 들어가는 면(미니 타일 등).
  static BoxDecoration inset(
    BuildContext context, {
    double radius = OloidRadius.card,
  }) {
    final c = OloidColors.of(context);
    return BoxDecoration(
      color: c.aiInset,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: c.aiBorder),
    );
  }
}

/// 조용한 보조자처럼 보이는 AI 카드. 내부 추론이나 raw 응답은 넣지 않는다.
class OloidAiCard extends StatelessWidget {
  const OloidAiCard({
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
      decoration: OloidAiDecoration.card(context),
      child: child,
    );
  }
}
