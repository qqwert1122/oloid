import 'package:flutter/material.dart';

/// 타이포그래피 토큰. 색은 넣지 않고 사용하는 곳에서 `copyWith(color:)`로 붙인다.
///
/// 작은 UI에서는 글자 크기보다 weight와 opacity로 위계를 만든다.
/// letterSpacing은 모두 0으로 고정한다. 비워 두면 Material 기본 텍스트
/// 스타일(bodyMedium 0.25 등)의 자간이 섞여 들어온다.
abstract final class OloidTypography {
  /// 이 패키지에 번들된 Pretendard. 앱이 따로 폰트를 넣을 필요가 없다.
  static const String fontFamily = 'packages/oloid/Pretendard';

  static const double _lineHeight = 1.4;

  /// 드문 대형 제목.
  static const TextStyle largeTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// 화면 제목.
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// 화면 내 큰 제목, pinned app bar.
  static const TextStyle subTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// 섹션 제목, bottom sheet 제목, compact heading.
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// 본문, 리스트 본문, 일반 UI 문구.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: _lineHeight,
    letterSpacing: 0,
  );

  /// 강조한 본문(row 제목, 선택된 값).
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: _lineHeight,
    letterSpacing: 0,
  );

  /// 입력창 본문.
  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// 메타데이터, 시간, chip, 작은 카운터.
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: _lineHeight,
    letterSpacing: 0,
  );

  /// 강조한 caption(작은 라벨, 배지).
  static const TextStyle captionStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: _lineHeight,
    letterSpacing: 0,
  );

  static const TextStyle tab = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Material 텍스트 역할에 토큰을 묶은 TextTheme. Text의 기본 스타일과
  /// ListTile·버튼 같은 Material 위젯이 이 값을 쓴다.
  static const TextTheme textTheme = TextTheme(
    displayLarge: largeTitle,
    displayMedium: title,
    displaySmall: subTitle,
    headlineLarge: title,
    headlineMedium: subTitle,
    headlineSmall: headline,
    titleLarge: subTitle,
    titleMedium: headline,
    titleSmall: bodyStrong,
    bodyLarge: input,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: button,
    labelMedium: captionStrong,
    labelSmall: caption,
  );
}
