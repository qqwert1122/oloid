import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';

/// 포커스된 빠른 입력창 등에 쓰는 은은한 움직이는 테두리.
///
/// [isActive]를 포커스 상태에 연결한다. 애니메이션 감소 설정이 켜져 있으면
/// 움직임 대신 primary 색의 정적인 테두리를 표시한다.
class OloidShimmerBorder extends StatefulWidget {
  const OloidShimmerBorder({
    super.key,
    required this.child,
    this.isActive = false,
    this.borderRadius = OloidRadius.card,
    this.borderWidth = 1.25,
    this.baseColor,
    this.highlightColor,
    this.duration = OloidMotion.shimmer,
  });

  final Widget child;
  final bool isActive;
  final double borderRadius;
  final double borderWidth;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  State<OloidShimmerBorder> createState() => _OloidShimmerBorderState();
}

class _OloidShimmerBorderState extends State<OloidShimmerBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant OloidShimmerBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    _syncAnimation();
  }

  void _syncAnimation() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (widget.isActive && !reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat();
    } else if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = OloidColors.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final baseColor = widget.baseColor ?? colors.primary;

    // 활성 여부와 상관없이 같은 위젯 트리(AnimatedBuilder → CustomPaint → child)를
    // 유지한다. 비활성일 때 child를 바로 돌려주면 포커스가 바뀌는 순간 child가
    // 다른 부모 아래로 옮겨져 다시 만들어지고, TextField라면 입력 연결과 입력 중인
    // 글자를 잃는다. 비활성일 때는 painter만 빼서 아무것도 그리지 않는다.
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => CustomPaint(
        foregroundPainter: widget.isActive
            ? _OloidShimmerBorderPainter(
                progress: _controller.value,
                borderRadius: widget.borderRadius,
                borderWidth: widget.borderWidth,
                baseColor: baseColor,
                highlightColor: reduceMotion
                    ? baseColor
                    : widget.highlightColor ?? Colors.white,
                reduceMotion: reduceMotion,
              )
            : null,
        child: child,
      ),
    );
  }
}

class _OloidShimmerBorderPainter extends CustomPainter {
  const _OloidShimmerBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.borderWidth,
    required this.baseColor,
    required this.highlightColor,
    required this.reduceMotion,
  });

  final double progress;
  final double borderRadius;
  final double borderWidth;
  final Color baseColor;
  final Color highlightColor;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= borderWidth || size.height <= borderWidth) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    if (reduceMotion) {
      paint.color = baseColor.withValues(alpha: 0.9);
    } else {
      final shimmer = progress * 8 - 4;
      paint.shader = LinearGradient(
        begin: Alignment(shimmer, 0),
        end: Alignment(shimmer + 2, 0),
        colors: [
          baseColor.withValues(alpha: 0.88),
          highlightColor.withValues(alpha: 0.98),
          baseColor.withValues(alpha: 0.88),
        ],
      ).createShader(Offset.zero & size);
    }

    final inset = borderWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - borderWidth,
      size.height - borderWidth,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _OloidShimmerBorderPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.baseColor != baseColor ||
      oldDelegate.highlightColor != highlightColor ||
      oldDelegate.reduceMotion != reduceMotion;
}
