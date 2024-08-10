import 'dart:developer';

import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/home/bottom_screens/ui/courses_tap.dart';
import 'package:a2z_app/features/home/bottom_screens/ui/search_tap.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../core/theming/text_style.dart';
import 'bottom_screens/profile_tap/ui/profile_tap.dart';
import 'bottom_screens/ui/home_tap.dart';
import 'bottom_screens/ui/our_teachers_tap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 2);

  final _controller = NotchBottomBarController(index: 2);
  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const ProfileTap(),
    const CoursesTap(),
    const HomeTap(),
    const OurTeachersTap(),
    const SearchTap(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              elevation: 0.0,
              notchBottomBarController: _controller,
              color: ColorsCode.lightWhite,
              showLabel: true,
              shadowElevation: 0.0,
              itemLabelStyle: TextStyles.font10GrayNormal,
              notchColor: ColorsCode.mainBlue,
              removeMargins: true,
              bottomBarHeight: 65,
              notchGradient: null,
              maxLine: 1,
              circleMargin: 9,
              durationInMilliSeconds: 100,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.black54,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  itemLabel: 'Profile',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.collections_bookmark_outlined,
                    color: Colors.black54,
                  ),
                  activeItem: Icon(
                    Icons.collections_bookmark_outlined,
                    color: Colors.white,
                  ),
                  itemLabel: 'Courses',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.black54,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.groups_rounded,
                    color: Colors.black54,
                  ),
                  activeItem: Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                  ),
                  itemLabel: 'Teachers',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.search_sharp,
                    color: Colors.black54,
                  ),
                  activeItem: Icon(
                    Icons.search_sharp,
                    color: Colors.white,
                  ),
                  itemLabel: 'Search',
                ),
              ],
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24,
              kBottomRadius: 0.0,
            )
          : null,
    );
  }
}
