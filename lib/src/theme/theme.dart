import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/tokens.dart';
import '../tokens/typography.dart';

/// 앱의 `MaterialApp.theme` / `darkTheme`에 넣는 ThemeData.
///
/// ```dart
/// MaterialApp(
///   theme: OloidTheme.light(),
///   darkTheme: OloidTheme.dark(),
/// )
/// ```
///
/// 앱마다 브랜드 색만 바꾸려면 [primary]를 넘긴다. 구조(배경·텍스트·간격)는
/// 그대로 두고 주 액션과 선택 상태 색만 달라진다.
abstract final class OloidTheme {
  static ThemeData light({Color primary = OloidColors.defaultPrimary}) =>
      fromColors(OloidColors.light(primary: primary), Brightness.light);

  static ThemeData dark({Color primary = OloidColors.defaultPrimary}) =>
      fromColors(OloidColors.dark(primary: primary), Brightness.dark);

  /// 토큰을 직접 바꿔 쓰고 싶을 때. 예: `OloidColors.light().copyWith(todo: ...)`.
  static ThemeData fromColors(OloidColors colors, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: OloidTypography.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: OloidTypography.headline.copyWith(
          color: colors.textPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 0.5,
        space: 0.5,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.primary),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.background,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.textSecondary,
        selectedIconTheme: const IconThemeData(size: OloidIconSize.nav),
        unselectedIconTheme: const IconThemeData(size: OloidIconSize.nav),
        selectedLabelStyle: OloidTypography.caption.copyWith(fontSize: 12),
        unselectedLabelStyle: OloidTypography.caption.copyWith(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: OloidTypography.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OloidRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: OloidTypography.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: OloidTypography.input.copyWith(color: colors.textSecondary),
        border: InputBorder.none,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionColor: colors.primary.withValues(alpha: 0.2),
        selectionHandleColor: colors.primary,
      ),
    );
  }
}
