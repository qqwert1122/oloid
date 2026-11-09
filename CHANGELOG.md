## 0.3.1

* `BottomSheetThemeData`에서 지원하지 않는 `enableDrag` 인자를 제거해 앱 빌드 오류를 수정했다. 당겨 닫기 설정은 각 시트의 `showModalBottomSheet` 호출에서 유지한다.

## 0.3.0

* `OloidPhotoViewer`를 추가했다. 핀치 확대·이동, 사진 넘기기, 드래그에 반응하는 전체 화면 닫기를 제공하고 갤러리에서 동작을 확인할 수 있다.
* `OloidShimmerBorder`와 `OloidMotion.shimmer`를 추가했다. 입력 포커스 강조에 쓰며, 애니메이션 감소 설정에서는 정적인 테두리로 표시한다.
* Oloid 바텀시트에 당겨 닫기 동작을 명시적으로 적용하고 `enableDrag` 옵션을 통일했다. 바깥 영역 탭 닫기는 `isDismissible`로 별도 제어한다.

## 0.2.1

* caption과 captionStrong을 12px에서 13px로 키웠다(memoaid 앱 코드와 같은 값). `Design.md`와 웹 토큰은 아직 12px이다.

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
