## 0.2.0

* `OloidButton`에 `icon`, `dense`, `tonal` 변형을 추가했다. secondary 글자색을 textPrimary 70%로 바꿔 비활성 버튼과 구분되게 했다.
* `OloidSettingRow`에 `padding`, `iconColor`를 추가했다.
* `OloidTheme`이 Filled·Outlined·Segmented 버튼(radius 16), Card(surface, radius 12), Dialog(radius 32), PopupMenu(radius 8) 모양을 정한다.
* caption을 `Design.md`·웹과 같은 12px(line height 1.4)로 맞췄다. memoaid 앱 코드는 13px라 옮길 때 1px 작아진다.
* 모든 텍스트 토큰의 letterSpacing을 0으로 고정하고, `bodyStrong`·`captionStrong`·`textTheme`을 추가했다. `OloidTheme`이 이 textTheme을 쓴다.
* `OloidTheme`의 bottomSheetTheme이 배경을 투명으로 두지 않고 기본 sheet 모양(background, 상단 radius 20)을 준다.
* `OloidTheme`이 ColorScheme의 surface·surfaceContainer*·onSurface·outlineVariant·secondaryContainer를 중립 토큰에 묶는다. 브랜드 색이 면에 비치지 않는다.

## 0.1.0

* 패키지 이름을 `oloid`로, 클래스 접두어를 `Oloid`로 정했다(예: `OloidTheme`, `OloidColors`, `context.oloid`).

* memoaid 기준 첫 릴리스: 색상·타이포·radius·간격·모션 토큰, `OloidTheme` 라이트/다크, Pretendard 번들.
* 컴포넌트: `OloidButton`, `OloidConfirmSheet`, `OloidInfoSheet`, `showOloidBottomSheet`, `OloidDragHandle`, `OloidListRow`, `OloidChip`, `OloidPanel`, `OloidSectionHeader`, `OloidSettingRow`, `OloidEmptyState`, `OloidPageTitle`, `OloidPinnedAppBar`, `OloidFloatingBar`, `OloidAiCard`, `OloidToast`, `OloidGallery`.
