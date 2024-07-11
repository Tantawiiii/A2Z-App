import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/features/onboarding/widgets/build_onboard_screen_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../widgets/build_onboard_screen_three.dart';
import '../widgets/build_onboard_screen_two.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // controller to keep track with page we are currently on
  final PageController _pageController = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              BuildOnboardingScreen1(),
              BuildOnboardingScreen2(),
              BuildOnboardingScreen3(),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(2);
                  },
                  child: Text(
                    StringsTexts.txtSkip,
                    style: TextStyles.font14DarkBlueMedium,
                  ),
                ),

                //dot Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                ),

                // next or done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          context.pushNamed(Routes.getStartedScreen);
                        },
                        child: Text(
                          StringsTexts.txtDone,
                          style: TextStyles.font14DarkBlueMedium,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          StringsTexts.txtNext,
                          style: TextStyles.font14DarkBlueMedium,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
