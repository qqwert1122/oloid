import 'package:flutter/widgets.dart';

import 'colors.dart';

/// radius는 기능별 의미로 쓴다.
abstract final class OloidRadius {
  /// slidable action 모서리, 작은 due-date chip.
  static const double xs = 4;

  /// metadata chip.
  static const double chip = 6;

  /// compact selected state, 작은 컨트롤, dropdown.
  static const double control = 8;

  /// 기본 panel, stat card, toolbar.
  static const double card = 12;

  /// sheet 내부 버튼, input shell.
  static const double button = 16;

  /// 기본 bottom sheet 상단 모서리.
  static const double sheet = 20;

  /// floating input/search/add bar, pill control, AI card.
  static const double pill = 24;

  /// info/confirm dialog형 bottom sheet.
  static const double dialog = 32;
}

/// 4px 단위 간격과 자주 쓰는 의미 간격.
abstract final class OloidSpacing {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;

  /// 화면 좌우 padding.
  static const double screen = s4;

  /// 카드 / 리스트 row padding.
  static const double row = s4;

  /// bottom sheet 본문 좌우 padding.
  static const double sheet = s6;

  /// 들여쓰기 한 단계(할일 계층 등).
  static const double indent = s6;

  static const EdgeInsets pageTitle = EdgeInsets.fromLTRB(16, 16, 16, 8);
  static const EdgeInsets chip = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
}

abstract final class OloidIconSize {
  static const double metadata = 12;
  static const double row = 16;
  static const double nav = 18;
  static const double picker = 24;
}

/// 애니메이션은 상태 이해를 돕는 용도로만 쓴다.
abstract final class OloidMotion {
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration number = Duration(milliseconds: 1000);
  static const Duration toast = Duration(seconds: 2);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve scroll = Curves.easeOut;
}

/// shadow는 플로팅 바, 모달, 작게 떠 있는 도구에만 쓴다.
abstract final class OloidShadows {
  static List<BoxShadow> floating(OloidColors colors, {double blur = 12}) => [
        BoxShadow(color: colors.shadow, blurRadius: blur),
      ];

  static const List<BoxShadow> dialog = [
    BoxShadow(color: Color(0x4D000000), blurRadius: 20, offset: Offset(0, -5)),
  ];
}
