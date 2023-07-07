import 'package:flavorfile/pages/SettingsPages/edit_recipebook_page.dart';
import 'package:flavorfile/pages/SettingsPages/edit_user_page.dart';
import 'package:flavorfile/pages/SettingsPages/logout_page.dart';
import 'package:flavorfile/pages/SettingsPages/user_info_page.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenSideBar extends StatefulWidget {
  const HiddenSideBar({super.key});

  @override
  State<HiddenSideBar> createState() => _HiddenSideBarState();
}

class _HiddenSideBarState extends State<HiddenSideBar> {
  List<ScreenHiddenDrawer> _pages = [];
  final baseTextStyle = const TextStyle(
      fontFamily: 'Noto Sans KR',
      fontSize: 15,
      fontWeight: FontWeight.w300,
      color: Colors.black);

  final selectedTextStyle = const TextStyle(
      fontFamily: 'Noto Sans KR',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black);

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "사용자",
              baseStyle: baseTextStyle,
              selectedStyle: selectedTextStyle,
              colorLineSelected: Colors.indigo),
          const UserInfo()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "레시피 북 수정",
              baseStyle: baseTextStyle,
              selectedStyle: selectedTextStyle,
              colorLineSelected: Colors.indigo),
          const EditRecipeBook()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "사용자 정보 수정",
              baseStyle: baseTextStyle,
              selectedStyle: selectedTextStyle,
              colorLineSelected: Colors.indigo),
          const EditUserInfo()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorAppBar: Theme.of(context).canvasColor,
      // backgroundColorMenu: Theme.of(context).canvasColor,
      backgroundColorMenu: Colors.white,
      screens: _pages,
      initPositionSelected: 0,
      contentCornerRadius: 30,
    );
  }
}
