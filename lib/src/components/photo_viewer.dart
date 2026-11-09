import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

/// 핀치 확대와 좌우 넘기기를 지원하는 전체 화면 사진 뷰어.
///
/// [photos]에는 보통 `Image.file`, `Image.network` 같은 위젯을 전달한다.
/// 확대되지 않은 상태에서 아래로 당기면 뷰어가 닫힌다. 여러 장일 때는
/// 현재 순서를 우측 상단에 표시한다.
class OloidPhotoViewer extends StatefulWidget {
  const OloidPhotoViewer._({
    required this.photos,
    required this.initialIndex,
  });

  final List<Widget> photos;
  final int initialIndex;

  /// 전체 화면 뷰어를 연다.
  ///
  /// 빈 [photos] 목록은 아무 동작도 하지 않는다. [initialIndex]가 범위를
  /// 벗어나면 가장 가까운 유효한 사진으로 맞춘다.
  static Future<void> show(
    BuildContext context, {
    required List<Widget> photos,
    int initialIndex = 0,
  }) async {
    if (photos.isEmpty) return;

    final startIndex = initialIndex.clamp(0, photos.length - 1).toInt();
    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: OloidMotion.fast,
        reverseTransitionDuration: OloidMotion.fast,
        pageBuilder: (context, animation, secondaryAnimation) =>
            OloidPhotoViewer._(photos: photos, initialIndex: startIndex),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  State<OloidPhotoViewer> createState() => _OloidPhotoViewerState();
}

class _OloidPhotoViewerState extends State<OloidPhotoViewer>
    with SingleTickerProviderStateMixin {
  static const double _dismissDistanceFraction = 0.15;
  static const double _dismissVelocity = 700;

  late final PageController _pageController;
  late final AnimationController _resetController;
  late int _currentIndex;
  Animation<double>? _resetAnimation;
  double _dragOffset = 0;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _resetController = AnimationController(
      vsync: this,
      duration: OloidMotion.fast,
    )..addListener(() {
        final animation = _resetAnimation;
        if (mounted && animation != null) {
          setState(() => _dragOffset = animation.value);
        }
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _resetController.stop();
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy)
          .clamp(0.0, double.infinity)
          .toDouble();
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final height = MediaQuery.sizeOf(context).height;
    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset > height * _dismissDistanceFraction ||
        velocity > _dismissVelocity) {
      Navigator.of(context).pop();
      return;
    }

    _resetAnimation = Tween<double>(begin: _dragOffset, end: 0).animate(
      CurvedAnimation(parent: _resetController, curve: OloidMotion.enter),
    );
    _resetController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final progress = (_dragOffset / height).clamp(0.0, 1.0).toDouble();
    final backgroundOpacity = (1 - progress * 2).clamp(0.0, 1.0).toDouble();
    final chromeOpacity = (1 - progress * 4).clamp(0.0, 1.0).toDouble();

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: backgroundOpacity),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: _isZoomed ? null : _onDragUpdate,
            onVerticalDragEnd: _isZoomed ? null : _onDragEnd,
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: Transform.scale(
                scale: 1 - progress * 0.2,
                child: PhotoViewGallery.builder(
                  pageController: _pageController,
                  itemCount: widget.photos.length,
                  scrollPhysics: const BouncingScrollPhysics(),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  builder: (context, index) =>
                      PhotoViewGalleryPageOptions.customChild(
                    child: widget.photos[index],
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3,
                  ),
                  scaleStateChangedCallback: (state) {
                    final zoomed = state != PhotoViewScaleState.initial;
                    if (zoomed != _isZoomed && mounted) {
                      setState(() => _isZoomed = zoomed);
                    }
                  },
                  onPageChanged: (index) {
                    if (!mounted) return;
                    setState(() {
                      _currentIndex = index;
                      _isZoomed = false;
                    });
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: chromeOpacity < 0.1,
            child: Opacity(
              opacity: chromeOpacity,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(OloidSpacing.s4),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ViewerChromeButton(
                          tooltip: '닫기',
                          icon: Icons.close_rounded,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        if (widget.photos.length > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: OloidSpacing.s3,
                              vertical: OloidSpacing.s2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius:
                                  BorderRadius.circular(OloidRadius.pill),
                            ),
                            child: Text(
                              '${_currentIndex + 1} / ${widget.photos.length}',
                              style: OloidTypography.captionStrong.copyWith(
                                color: Colors.white,
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
        ],
      ),
    );
  }
}

class _ViewerChromeButton extends StatelessWidget {
  const _ViewerChromeButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        splashColor: c.primary.withValues(alpha: 0.2),
      ),
    );
  }
}
