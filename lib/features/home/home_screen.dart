import 'dart:async';
import 'dart:developer';

import 'package:a2z_app/core/language/language.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/home/bottom_screens/courses_tap/courses_tap.dart';
import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../a2z_app.dart';
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


  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // start checker internet connection
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
          switch (event) {
            case InternetStatus.connected:
              setState(() {
                isConnectedToInternet = true;
              });
              break;
            case InternetStatus.disconnected:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
            default:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
          }
        });
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const ProfileTap(),
    const CoursesTap(),
    const HomeTap(),
     OurTeachersTap(),
  ];

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        extendBody: true,
        bottomNavigationBar: AnimatedNotchBottomBar(
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
                bottomBarItems:  [
                  BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.person,
                      color: Colors.black54,
                    ),
                    activeItem: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    itemLabel: Language.instance.txtProfile(),
                  ),
                   BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.collections_bookmark_outlined,
                      color: Colors.black54,
                    ),
                    activeItem: const Icon(
                      Icons.collections_bookmark_outlined,
                      color: Colors.white,
                    ),
                    itemLabel: Language.instance.txtCourses(),
                  ),
                  BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.home_filled,
                      color: Colors.black54,
                    ),
                    activeItem: const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    itemLabel: Language.instance.txtHome(),
                  ),
                  BottomBarItem(
                    inActiveItem: const Icon(
                      Icons.groups_rounded,
                      color: Colors.black54,
                    ),
                    activeItem: const Icon(
                      Icons.groups_rounded,
                      color: Colors.white,
                    ),
                    itemLabel: Language.instance.txtTeachers(),
                  ),
                ],
                onTap: (index) {
                  /// perform action on tab change and to update pages you can update pages without pages
                  log('current selected index $index');
                  _pageController.jumpToPage(index);
                },
                kIconSize: 24,
                kBottomRadius: 0.0,
              ),
      )
      : const NoInternetScreen(),
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

}
