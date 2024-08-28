import 'dart:developer';

import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/home/bottom_screens/courses_tap/courses_tap.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../core/theming/text_style.dart';
import 'bottom_screens/our_teachers_tap/ui/our_teachers_tap.dart';
import 'bottom_screens/profile_tap/ui/profile_tap.dart';
import 'bottom_screens/home_tap/ui/home_tap.dart';

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
     OurTeachersTap(),
    // const CartTap(),
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
              elevation: 4.0,
              notchBottomBarController: _controller,
              color: ColorsCode.backBottomNav,
              showLabel: true,
              shadowElevation: 4.0,
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
                // BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.add_shopping_cart,
                //     color: Colors.black54,
                //   ),
                //   activeItem: Icon(
                //     Icons.add_shopping_cart,
                //     color: Colors.white,
                //   ),
                //   itemLabel: 'Cart',
                // ),
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
