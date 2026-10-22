import 'package:flutter/material.dart';

/// 색상 토큰.
///
/// memoaid의 `AppColors`와 같은 값이지만, 전역 싱글턴 대신 [ThemeExtension]으로
/// 들고 다닌다. 그래서 라이트/다크 전환은 `MaterialApp.themeMode`만 바꾸면 되고,
/// 위젯은 `OloidColors.of(context)`(또는 `context.oloid`)로 현재 테마의 값을 읽는다.
@immutable
class OloidColors extends ThemeExtension<OloidColors> {
  const OloidColors({
    required this.primary,
    required this.background,
    required this.backgroundSecondary,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.shadow,
    required this.person,
    required this.location,
    required this.date,
    required this.favorite,
    required this.danger,
    required this.todo,
    required this.positive,
    required this.warning,
    required this.aiGradientStart,
    required this.aiGradientMid,
    required this.aiGradientEnd,
    required this.aiBorder,
    required this.aiInset,
  });

  /// memoaid 기본 브랜드 색(`Colors.indigoAccent`, #536DFE).
  static const Color defaultPrimary = Colors.indigoAccent;

  /// 주 액션, 선택 상태, progress, active highlight.
  final Color primary;

  /// 페이지와 리스트 row 배경.
  final Color background;

  /// 구분선, 비활성 fill, 조용한 컨트롤.
  final Color backgroundSecondary;

  /// 섹션 분리, stat card, loading surface.
  final Color surface;

  final Color textPrimary;

  /// 보조 텍스트, 비활성 아이콘, placeholder.
  final Color textSecondary;

  /// 투명도 없이 색 자체로 정한 테두리 색.
  final Color border;

  /// 플로팅 컨트롤과 작은 elevated surface의 그림자.
  final Color shadow;

  // 의미 색상: 색은 상태나 메타데이터 타입을 알릴 때만 쓴다.
  final Color person;
  final Color location;
  final Color date;
  final Color favorite;
  final Color danger;
  final Color todo;
  final Color positive;
  final Color warning;

  // AI 보조 surface 전용. 다른 영역에 장식용으로 쓰지 않는다.
  final Color aiGradientStart;
  final Color aiGradientMid;
  final Color aiGradientEnd;
  final Color aiBorder;
  final Color aiInset;

  /// 리스트 row 사이 얇은 구분선.
  Color get divider => backgroundSecondary.withValues(alpha: 0.5);

  /// 중립 메타데이터(태그 등).
  Color get neutral => textPrimary;

  factory OloidColors.light({Color primary = defaultPrimary}) {
    return OloidColors(
      primary: primary,
      background: Colors.white,
      backgroundSecondary: const Color(0xFFEBEBEB),
      surface: const Color(0xFFF7F7F7),
      textPrimary: const Color(0xFF333333),
      textSecondary: const Color(0xFFBBBBBB),
      border: const Color(0xFFD6D6D6),
      shadow: const Color(0xFF333333).withValues(alpha: 0.1),
      person: Colors.blueAccent,
      location: Colors.deepPurple,
      date: Colors.green,
      favorite: Colors.redAccent,
      danger: Colors.redAccent,
      todo: Colors.orange,
      positive: Colors.green,
      warning: const Color(0xFFD97706),
      aiGradientStart: const Color(0xFF06B6D4).withValues(alpha: 0.06),
      aiGradientMid: const Color(0xFF3B82F6).withValues(alpha: 0.08),
      aiGradientEnd: const Color(0xFF4F46E5).withValues(alpha: 0.10),
      aiBorder: Colors.blueAccent.withValues(alpha: 0.08),
      aiInset: Colors.white.withValues(alpha: 0.46),
    );
  }

  factory OloidColors.dark({Color primary = defaultPrimary}) {
    return OloidColors.light(primary: primary).copyWith(
      background: const Color(0xFF333333),
      backgroundSecondary: const Color(0xFF3C3C3C),
      surface: const Color(0xFF2A2A2A),
      textPrimary: Colors.white,
      textSecondary: Colors.white,
      border: const Color(0xFF555555),
      shadow: const Color(0xFFBBBBBB).withValues(alpha: 0.1),
      // memoaid는 다크에서도 흰색 46%를 쓰지만 어두운 배경에서 밝은 회색 판이
      // 되므로, 같은 "살짝 떠 있는 면" 느낌이 나도록 낮췄다.
      aiInset: Colors.white.withValues(alpha: 0.06),
    );
  }

  /// 현재 테마의 토큰. 테마에 등록되지 않았으면 밝기에 맞는 기본값을 쓴다.
  static OloidColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<OloidColors>() ??
        (theme.brightness == Brightness.dark
            ? OloidColors.dark()
            : OloidColors.light());
  }

  @override
  OloidColors copyWith({
    Color? primary,
    Color? background,
    Color? backgroundSecondary,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? shadow,
    Color? person,
    Color? location,
    Color? date,
    Color? favorite,
    Color? danger,
    Color? todo,
    Color? positive,
    Color? warning,
    Color? aiGradientStart,
    Color? aiGradientMid,
    Color? aiGradientEnd,
    Color? aiBorder,
    Color? aiInset,
  }) {
    return OloidColors(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      person: person ?? this.person,
      location: location ?? this.location,
      date: date ?? this.date,
      favorite: favorite ?? this.favorite,
      danger: danger ?? this.danger,
      todo: todo ?? this.todo,
      positive: positive ?? this.positive,
      warning: warning ?? this.warning,
      aiGradientStart: aiGradientStart ?? this.aiGradientStart,
      aiGradientMid: aiGradientMid ?? this.aiGradientMid,
      aiGradientEnd: aiGradientEnd ?? this.aiGradientEnd,
      aiBorder: aiBorder ?? this.aiBorder,
      aiInset: aiInset ?? this.aiInset,
    );
  }

  @override
  OloidColors lerp(covariant OloidColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return OloidColors(
      primary: l(primary, other.primary),
      background: l(background, other.background),
      backgroundSecondary: l(backgroundSecondary, other.backgroundSecondary),
      surface: l(surface, other.surface),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      border: l(border, other.border),
      shadow: l(shadow, other.shadow),
      person: l(person, other.person),
      location: l(location, other.location),
      date: l(date, other.date),
      favorite: l(favorite, other.favorite),
      danger: l(danger, other.danger),
      todo: l(todo, other.todo),
      positive: l(positive, other.positive),
      warning: l(warning, other.warning),
      aiGradientStart: l(aiGradientStart, other.aiGradientStart),
      aiGradientMid: l(aiGradientMid, other.aiGradientMid),
      aiGradientEnd: l(aiGradientEnd, other.aiGradientEnd),
      aiBorder: l(aiBorder, other.aiBorder),
      aiInset: l(aiInset, other.aiInset),
    );
  }
}

/// `context.oloid.primary`처럼 짧게 쓰기 위한 확장.
extension OloidContext on BuildContext {
  OloidColors get oloid => OloidColors.of(this);
}
