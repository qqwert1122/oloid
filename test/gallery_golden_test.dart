@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oloid/oloid.dart';

/// 카탈로그를 실제 폰트로 렌더링해 test/goldens/에 남긴다.
/// 디자인을 바꾼 뒤 `flutter test --tags golden --update-goldens`로 갱신한다.
Future<void> _loadFonts() async {
  final pretendard = FontLoader(OloidTypography.fontFamily);
  for (final name in ['Light', 'Regular', 'Bold', 'ExtraBold']) {
    final bytes = File('fonts/Pretendard-$name.otf').readAsBytesSync();
    pretendard.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await pretendard.load();

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final icons = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (icons.existsSync()) {
    final loader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
    await loader.load();
  }
}

void main() {
  setUpAll(_loadFonts);

  for (final (name, theme) in [
    ('light', OloidTheme.light()),
    ('dark', OloidTheme.dark()),
  ]) {
    testWidgets('gallery $name', (tester) async {
      tester.view.physicalSize = const Size(1170, 3600);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const OloidGallery(),
        ),
      );
      await expectLater(
        find.byType(OloidGallery),
        matchesGoldenFile('goldens/gallery_$name.png'),
      );
    });
  }
}
