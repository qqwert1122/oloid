import 'package:flutter/widgets.dart';

/// 타이포그래피 토큰. 색은 넣지 않고 사용하는 곳에서 `copyWith(color:)`로 붙인다.
///
/// 작은 UI에서는 글자 크기보다 weight와 opacity로 위계를 만든다.
abstract final class OloidTypography {
  /// 이 패키지에 번들된 Pretendard. 앱이 따로 폰트를 넣을 필요가 없다.
  static const String fontFamily = 'packages/oloid/Pretendard';

  /// 드문 대형 제목.
  static const TextStyle largeTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
  );

  /// 화면 제목.
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  /// 화면 내 큰 제목, pinned app bar.
  static const TextStyle subTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  /// 섹션 제목, bottom sheet 제목, compact heading.
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  /// 본문, 리스트 본문, 일반 UI 문구.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// 입력창 본문.
  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 메타데이터, 시간, chip, 작은 카운터.
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle tab = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}
