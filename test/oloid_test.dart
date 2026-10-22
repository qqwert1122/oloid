import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oloid/oloid.dart';

Widget _app(Widget home, {ThemeData? theme}) =>
    MaterialApp(theme: theme ?? OloidTheme.light(), home: home);

void main() {
  group('OloidTheme', () {
    test('라이트/다크 테마가 각자의 OloidColors를 담는다', () {
      final light = OloidTheme.light().extension<OloidColors>()!;
      final dark = OloidTheme.dark().extension<OloidColors>()!;

      expect(light.background, Colors.white);
      expect(dark.background, const Color(0xFF333333));
      expect(light.primary, Colors.indigoAccent);
    });

    test('앱마다 브랜드 색만 바꿀 수 있다', () {
      const brand = Color(0xFF00A86B);
      final theme = OloidTheme.light(primary: brand);

      expect(theme.extension<OloidColors>()!.primary, brand);
      expect(theme.extension<OloidColors>()!.surface, const Color(0xFFF7F7F7));
    });

    test('Material 면·글자 역할을 중립 토큰에 묶는다', () {
      const brand = Color(0xFFEF233C);
      final scheme = OloidTheme.dark(primary: brand).colorScheme;

      expect(scheme.primary, brand);
      expect(scheme.surface, const Color(0xFF333333));
      expect(scheme.surfaceContainerHigh, const Color(0xFF2A2A2A));
      expect(scheme.onSurface, Colors.white);
      expect(scheme.outlineVariant, const Color(0xFF3C3C3C));
    });

    test('텍스트 역할의 자간을 0으로 고정한다', () {
      final textTheme = OloidTheme.light().textTheme;

      expect(textTheme.bodyMedium!.letterSpacing, 0);
      expect(textTheme.labelLarge!.letterSpacing, 0);
      expect(textTheme.bodySmall!.fontSize, 12);
    });

    test('Pretendard를 패키지 경로로 지정한다', () {
      expect(
        OloidTheme.light().textTheme.bodyMedium!.fontFamily,
        'packages/oloid/Pretendard',
      );
    });

    testWidgets('테마가 없어도 OloidColors.of는 밝기에 맞는 기본값을 준다', (tester) async {
      late OloidColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              colors = context.oloid;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(colors.background, const Color(0xFF333333));
    });
  });

  group('OloidConfirmSheet', () {
    testWidgets('확인은 true, 취소는 false를 돌려준다', (tester) async {
      bool? result;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await OloidConfirmSheet.show(
                  context,
                  title: '삭제할까요?',
                  content: '되돌릴 수 없어요.',
                  confirmText: '삭제',
                  destructive: true,
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();
      expect(result, isTrue);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });
  });

  group('OloidButton', () {
    testWidgets('tonal은 옅은 브랜드색 면에 브랜드색 글자와 아이콘을 그린다', (tester) async {
      await tester.pumpWidget(
        _app(
          OloidButton(
            label: '저장',
            variant: OloidButtonVariant.tonal,
            icon: const Icon(Icons.add_rounded),
            onPressed: () {},
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('저장'));
      expect(text.style!.color, Colors.indigoAccent);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('secondary는 비활성 버튼과 글자색이 다르다', (tester) async {
      await tester.pumpWidget(
        _app(
          Column(
            children: [
              OloidButton(
                label: '활성',
                variant: OloidButtonVariant.secondary,
                onPressed: () {},
              ),
              const OloidButton(
                label: '비활성',
                variant: OloidButtonVariant.secondary,
                onPressed: null,
              ),
            ],
          ),
        ),
      );

      final enabled = tester.widget<Text>(find.text('활성')).style!.color;
      final disabled = tester.widget<Text>(find.text('비활성')).style!.color;
      expect(enabled, isNot(disabled));
    });
  });

  group('OloidToast', () {
    testWidgets('메시지를 보여 주고 시간이 지나면 닫는다', (tester) async {
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => OloidToast.success(context, '저장했어요'),
              child: const Text('save'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('save'));
      await tester.pump();
      expect(find.text('저장했어요'), findsOneWidget);

      await tester.pump(OloidMotion.toast + const Duration(milliseconds: 10));
      expect(find.text('저장했어요'), findsNothing);
    });

    testWidgets('새 토스트는 이전 토스트를 대신한다', (tester) async {
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () {
                OloidToast.info(context, '첫 번째');
                OloidToast.error(context, '두 번째');
              },
              child: const Text('go'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('go'));
      await tester.pump();
      expect(find.text('첫 번째'), findsNothing);
      expect(find.text('두 번째'), findsOneWidget);
      OloidToast.dismiss();
    });
  });

  testWidgets('OloidGallery가 라이트/다크 모두 오류 없이 그려진다', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    for (final theme in [OloidTheme.light(), OloidTheme.dark()]) {
      await tester.pumpWidget(_app(const OloidGallery(), theme: theme));
      expect(tester.takeException(), isNull);
      expect(find.text('Oloid'), findsOneWidget);
    }
  });
}
