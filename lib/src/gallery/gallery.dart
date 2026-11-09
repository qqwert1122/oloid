import 'package:flutter/material.dart';

import '../components/ai_card.dart';
import '../components/button.dart';
import '../components/floating.dart';
import '../components/photo_viewer.dart';
import '../components/sheets.dart';
import '../components/shimmer_border.dart';
import '../components/surfaces.dart';
import '../components/toast.dart';
import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

/// 토큰과 컴포넌트를 한 화면에서 보는 카탈로그.
///
/// 앱의 디버그 메뉴에 `Navigator.push(.., MaterialPageRoute(builder: (_) => const OloidGallery()))`
/// 로 붙이면 현재 테마(브랜드 색, 다크 모드)로 렌더링된 모습을 바로 확인할 수 있다.
class OloidGallery extends StatelessWidget {
  const OloidGallery({super.key, this.onToggleTheme});

  /// 있으면 우측 상단에 라이트/다크 전환 버튼을 그린다.
  final VoidCallback? onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    final text = OloidTypography.body.copyWith(color: c.textPrimary);
    final caption = OloidTypography.caption.copyWith(color: c.textSecondary);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              SafeArea(
                bottom: false,
                child: OloidPageTitle(
                  'Oloid',
                  trailing: onToggleTheme == null
                      ? null
                      : IconButton(
                          onPressed: onToggleTheme,
                          icon: Icon(
                            Icons.contrast_rounded,
                            color: c.textPrimary,
                          ),
                        ),
                ),
              ),
              const OloidSectionHeader('색상'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (name, color) in [
                      ('primary', c.primary),
                      ('background', c.background),
                      ('bg2', c.backgroundSecondary),
                      ('surface', c.surface),
                      ('text', c.textPrimary),
                      ('text2', c.textSecondary),
                      ('person', c.person),
                      ('location', c.location),
                      ('date', c.date),
                      ('danger', c.danger),
                      ('todo', c.todo),
                    ])
                      _Swatch(name: name, color: color),
                  ],
                ),
              ),
              const OloidSectionHeader('타이포그래피'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (name, style) in [
                      ('title 28', OloidTypography.title),
                      ('subTitle 22', OloidTypography.subTitle),
                      ('headline 17', OloidTypography.headline),
                      ('body 15', OloidTypography.body),
                      ('caption 13', OloidTypography.caption),
                    ])
                      Text(name, style: style.copyWith(color: c.textPrimary)),
                  ],
                ),
              ),
              const OloidSectionHeader('리스트와 메타데이터'),
              OloidListRow(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('3분 전', style: caption.copyWith(color: c.primary)),
                    const SizedBox(height: 4),
                    Text('비 오는 날 성수동에서 민지랑 커피 마셨다.', style: text),
                    const SizedBox(height: 8),
                    const Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        OloidChip.tag('카페'),
                        OloidChip.person('민지'),
                        OloidChip.location('성수동'),
                      ],
                    ),
                  ],
                ),
              ),
              OloidListRow(child: Text('구분선은 얇고 낮은 투명도로 둔다.', style: text)),
              const OloidSectionHeader('AI 카드'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OloidAiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '비 오는 날의 기록을 다시 꺼냈어요',
                        style: OloidTypography.headline.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: OloidAiDecoration.inset(context),
                        child: Text('작년 이맘때도 같은 카페에 갔어요.', style: text),
                      ),
                    ],
                  ),
                ),
              ),
              const OloidSectionHeader('설정'),
              OloidSettingRow(
                icon: Icons.notifications_none_rounded,
                title: '알림',
                subtitle: '매일 저녁 9시',
                onTap: () {},
              ),
              OloidSettingRow(
                icon: Icons.dark_mode_outlined,
                title: '다크 모드',
                trailing: Switch(value: false, onChanged: (_) {}),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OloidPanel(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Stat(label: '기록', value: '128'),
                      _Stat(label: '할일', value: '12'),
                      _Stat(label: '사람', value: '24'),
                    ],
                  ),
                ),
              ),
              const OloidSectionHeader('버튼과 시트'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    OloidButton(
                      label: '보조 액션',
                      variant: OloidButtonVariant.tonal,
                      dense: true,
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () {},
                    ),
                    const SizedBox(height: OloidSpacing.s3),
                    OloidButton(
                      label: '확인 시트 열기',
                      onPressed: () => OloidConfirmSheet.show(
                        context,
                        title: '기록을 삭제할까요?',
                        content: '삭제한 기록은 되돌릴 수 없어요.',
                        confirmText: '삭제',
                        destructive: true,
                      ),
                    ),
                    const SizedBox(height: OloidSpacing.s3),
                    Row(
                      children: [
                        Expanded(
                          child: OloidButton(
                            label: '안내 시트',
                            variant: OloidButtonVariant.secondary,
                            onPressed: () => OloidInfoSheet.show(
                              context,
                              title: '이렇게 써 보세요',
                              bullets: const ['적기만 하세요', '정리는 AI가 해요'],
                            ),
                          ),
                        ),
                        const SizedBox(width: OloidSpacing.s3),
                        Expanded(
                          child: OloidButton(
                            label: '토스트',
                            variant: OloidButtonVariant.secondary,
                            onPressed: () =>
                                OloidToast.success(context, '저장했어요'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const OloidSectionHeader('빈 상태'),
              const OloidEmptyState(
                message: '아직 기록이 없어요',
                icon: Icons.inbox_outlined,
                centered: false,
              ),
              const OloidSectionHeader('사진 뷰어'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(OloidRadius.card),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => OloidPhotoViewer.show(
                            context,
                            photos: const [
                              _GalleryPhotoArtwork(index: 0),
                              _GalleryPhotoArtwork(index: 1),
                            ],
                          ),
                          child: SizedBox(
                            height: 184,
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                const _GalleryPhotoArtwork(index: 0),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 64,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Color(0x99000000),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  left: 12,
                                  right: 12,
                                  bottom: 12,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.zoom_in_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '눌러서 사진 크게 보기',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.photo_library_outlined,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '1 / 2',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: OloidSpacing.s2),
                    Text(
                      '핀치로 확대하고, 확대하지 않은 상태에서 아래로 당겨 닫아요.',
                      style: caption,
                    ),
                  ],
                ),
              ),
              const OloidSectionHeader('입력 포커스 shimmer'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _QuickEntryShimmerDemo(),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: OloidFloatingBar(
              placeholder: '지금 떠오른 걸 남겨보세요',
              onTap: () => showOloidBottomSheet<void>(
                context,
                heightFactor: 0.7,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    autofocus: true,
                    minLines: 3,
                    maxLines: 20,
                    style: OloidTypography.input.copyWith(color: c.textPrimary),
                    decoration: const InputDecoration(
                      hintText: '지금 떠오른 걸 남겨보세요',
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

class _GalleryPhotoArtwork extends StatelessWidget {
  const _GalleryPhotoArtwork({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GalleryPhotoPainter(index),
      child: const SizedBox.expand(),
    );
  }
}

class _GalleryPhotoPainter extends CustomPainter {
  const _GalleryPhotoPainter(this.index);

  final int index;

  @override
  void paint(Canvas canvas, Size size) {
    final isCoast = index.isEven;
    final sky = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isCoast
            ? const [Color(0xFF7E879D), Color(0xFFE6A77F)]
            : const [Color(0xFF68879A), Color(0xFFD7B993)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final sunPaint = Paint()
      ..color = isCoast ? const Color(0xFFFFE2B4) : const Color(0xFFFFD99D);
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.34),
      size.shortestSide * 0.105,
      sunPaint,
    );

    final backRidge = Path()
      ..moveTo(0, size.height * 0.66)
      ..lineTo(size.width * 0.22, size.height * 0.48)
      ..lineTo(size.width * 0.39, size.height * 0.62)
      ..lineTo(size.width * 0.62, size.height * 0.44)
      ..lineTo(size.width, size.height * 0.61)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      backRidge,
      Paint()
        ..color = isCoast ? const Color(0xFF756E78) : const Color(0xFF63776F),
    );

    final foreground = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.62,
        size.width * 0.48,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.92,
        size.width,
        size.height * 0.69,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      foreground,
      Paint()
        ..color = isCoast ? const Color(0xFF374D5A) : const Color(0xFF40564D),
    );
  }

  @override
  bool shouldRepaint(covariant _GalleryPhotoPainter oldDelegate) =>
      index != oldDelegate.index;
}

class _QuickEntryShimmerDemo extends StatefulWidget {
  const _QuickEntryShimmerDemo();

  @override
  State<_QuickEntryShimmerDemo> createState() => _QuickEntryShimmerDemoState();
}

class _QuickEntryShimmerDemoState extends State<_QuickEntryShimmerDemo> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '포커스 상태 미리보기',
                style: OloidTypography.body.copyWith(color: c.textPrimary),
              ),
            ),
            Switch.adaptive(
              value: _isFocused,
              onChanged: (value) => setState(() => _isFocused = value),
            ),
          ],
        ),
        OloidShimmerBorder(
          isActive: _isFocused,
          borderRadius: OloidRadius.card,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: BorderRadius.circular(OloidRadius.card),
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '지금 떠오른 걸 가볍게 남겨보세요',
                  style: OloidTypography.body.copyWith(
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: OloidSpacing.s3),
                Row(
                  children: [
                    Icon(
                      Icons.mic_none_rounded,
                      color: c.textSecondary,
                      size: OloidIconSize.nav,
                    ),
                    const SizedBox(width: OloidSpacing.s2),
                    Text(
                      '자세히 입력하기',
                      style: OloidTypography.caption.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.send_rounded, color: c.primary, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(OloidRadius.card),
            border: Border.all(color: c.border, width: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: OloidTypography.caption.copyWith(
            fontSize: 11,
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = OloidColors.of(context);
    return Column(
      children: [
        Text(
          value,
          style: OloidTypography.headline.copyWith(color: c.textPrimary),
        ),
        Text(
          label,
          style: OloidTypography.caption.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}
