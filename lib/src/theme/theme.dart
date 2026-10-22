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
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(OloidRadius.button),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: OloidTypography.fontFamily,
      textTheme: OloidTypography.textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      // seed로 만든 scheme은 면 색에 브랜드 색이 비친다. Material 위젯이
      // 쓰는 면·글자·구분선 역할을 토큰에 묶어 캔버스를 중립으로 유지한다.
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
      ).copyWith(
        primary: colors.primary,
        onPrimary: Colors.white,
        secondaryContainer: colors.backgroundSecondary,
        onSecondaryContainer: colors.textPrimary,
        surface: colors.background,
        surfaceContainerLowest: colors.background,
        surfaceContainerLow: colors.surface,
        surfaceContainer: colors.surface,
        surfaceContainerHigh: colors.surface,
        surfaceContainerHighest: colors.surface,
        onSurface: colors.textPrimary,
        outlineVariant: colors.backgroundSecondary,
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
        selectedLabelStyle: OloidTypography.caption,
        unselectedLabelStyle: OloidTypography.caption,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      // 앱이 직접 연 일반 sheet도 기본 sheet 모양을 따른다. Oloid의 sheet
      // 컴포넌트는 배경을 투명으로 넘기고 자기 외곽을 그린다.
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.background,
        modalBackgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(OloidRadius.sheet),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: OloidTypography.button,
          shape: buttonShape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          textStyle: OloidTypography.button,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border),
          textStyle: OloidTypography.button,
          shape: buttonShape,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll<OutlinedBorder>(buttonShape),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: colors.border),
          ),
          textStyle: const WidgetStatePropertyAll<TextStyle>(
            OloidTypography.button,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OloidRadius.card),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: OloidTypography.headline.copyWith(
          color: colors.textPrimary,
        ),
        contentTextStyle: OloidTypography.body.copyWith(
          color: colors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OloidRadius.dialog),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        textStyle: OloidTypography.body.copyWith(color: colors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OloidRadius.control),
          side: BorderSide(color: colors.border),
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
