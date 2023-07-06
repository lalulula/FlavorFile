# flavorfile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# RecipeBook

### 에러나 배운 포인트들

- HomePage Bottom NavBar error

  - BottomNavigationBar 항목이 3개 이상인 경우, BottomNavigationBarType.shifting으로 변경된다
  - SOL)
    `type: BottomNavigationBarType.fixed, ...` 추가 해주면 됨

- ## `Future Builder`

- Background ->이미지 추가
  -Use Container -> BoxDecoration => image:DecorationImage fit BoxFit.cover
- "CONTEXT"
