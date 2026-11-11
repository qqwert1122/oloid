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
      expect(textTheme.bodySmall!.fontSize, 13);
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

  group('showOloidBottomSheet', () {
    Widget opener(
      void Function(BuildContext context) open, {
      ThemeData? theme,
    }) =>
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => open(context),
              child: const Text('open'),
            ),
          ),
          theme: theme,
        );

    testWidgets('상단 바가 기본: 닫기, 가운데 제목, 오른쪽 액션', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var saved = false;
      await tester.pumpWidget(
        opener(
          (context) => showOloidBottomSheet<void>(
            context,
            title: '태그 이름 수정',
            actions: [
              OloidSheetButton(
                icon: Icons.check_rounded,
                tooltip: '저장',
                onPressed: () => saved = true,
              ),
              OloidSheetButton(
                icon: Icons.more_horiz_rounded,
                tooltip: '더보기',
                onPressed: () {},
              ),
            ],
            builder: (_) => const SizedBox(height: 120),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(OloidSheetTopBar), findsOneWidget);
      // 오른쪽 버튼이 두 개여도 제목은 화면 가운데에 있다.
      expect(tester.getCenter(find.text('태그 이름 수정')).dx, closeTo(195, 1));
      expect(
        tester.getCenter(find.byTooltip('닫기')).dx,
        lessThan(tester.getCenter(find.text('태그 이름 수정')).dx),
      );

      await tester.tap(find.byTooltip('저장'));
      expect(saved, isTrue);

      await tester.tap(find.byTooltip('닫기'));
      await tester.pumpAndSettle();
      expect(find.byType(OloidSheetTopBar), findsNothing);
    });

    testWidgets('showTopBar: false면 손잡이만 그린다', (tester) async {
      await tester.pumpWidget(
        opener(
          (context) => showOloidBottomSheet<void>(
            context,
            showTopBar: false,
            builder: (_) => const Text('내용'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(OloidDragHandle), findsOneWidget);
      expect(find.byType(OloidSheetTopBar), findsNothing);
      expect(find.text('내용'), findsOneWidget);
    });

    testWidgets('원형 버튼 아이콘은 라이트 검정, 다크 textPrimary', (tester) async {
      for (final (theme, expected) in [
        (OloidTheme.light(), Colors.black),
        (OloidTheme.dark(), Colors.white),
      ]) {
        await tester.pumpWidget(
          _app(
            OloidSheetButton(
              icon: Icons.close_rounded,
              tooltip: '닫기',
              onPressed: () {},
            ),
            theme: theme,
          ),
        );
        // MaterialApp은 테마를 바꿀 때 애니메이션하므로 끝날 때까지 기다린다.
        await tester.pumpAndSettle();
        final icon = tester.widget<Icon>(find.byIcon(Icons.close_rounded));
        expect(icon.color, expected);
      }
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

  group('OloidShimmerBorder', () {
    testWidgets('포커스로 켜져도 감싼 입력창을 다시 만들지 않는다', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _app(
          Scaffold(
            body: AnimatedBuilder(
              animation: focusNode,
              builder: (context, child) => OloidShimmerBorder(
                isActive: focusNode.hasFocus,
                child: child!,
              ),
              child: TextField(focusNode: focusNode),
            ),
          ),
        ),
      );

      final before = tester.state(find.byType(EditableText));
      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
      expect(tester.state(find.byType(EditableText)), same(before));

      await tester.enterText(find.byType(TextField), '입력 유지');
      await tester.pump();
      expect(find.text('입력 유지'), findsOneWidget);

      focusNode.unfocus();
      await tester.pump();
      expect(tester.state(find.byType(EditableText)), same(before));
      expect(find.text('입력 유지'), findsOneWidget);
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
