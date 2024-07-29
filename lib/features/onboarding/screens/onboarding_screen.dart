import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/onboarding/widgets/build_onboard_screen.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion/motion.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theming/text_style.dart';
import '../../../core/utils/StringsTexts.dart';
import '../../../core/utils/images_paths.dart';


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
      backgroundColor: ColorsCode.white,
      body: Container(
        padding: EdgeInsetsDirectional.only(bottom: 40.h,start: 26.h,end: 26.h),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 2);
                });
              },
              children: const [
                BuildOnboardingScreen(
                  svgBodyPath: ImagesPaths.logoImage,
                  titleBoard: StringTextsNames.titleOnBoard1,
                  desBoard: StringTextsNames.desOnBoard1,
                ),
                BuildOnboardingScreen(
                  svgBodyPath: ImagesPaths.animBodyOnBoarding2,
                  titleBoard: StringTextsNames.titleOnBoard2,
                  desBoard: StringTextsNames.desOnBoard2,
                ),
                BuildOnboardingScreen(
                  svgBodyPath: ImagesPaths.animBodyOnBoarding2,
                  titleBoard: StringTextsNames.titleOnBoard3,
                  desBoard: StringTextsNames.desOnBoard3,
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //skip
                  Bounce(
                    child: Motion(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(Routes.getStartedScreen);
                        },
                        child: Text(
                          StringTextsNames.txtSkip,
                          style: TextStyles.font13BlueSemiBold,
                        ),
                      ),
                    ),
                  ),

                  //dot Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                  ),

                  // next or done
                  onLastPage
                      ? Bounce(
                        child: Motion(
                          child: GestureDetector(
                              onTap: () {
                                context.pushNamed(Routes.getStartedScreen);
                              },
                              child: Text(
                                StringTextsNames.txtDone,
                                style: TextStyles.font13BlueSemiBold,
                              ),
                            ),
                        ),
                      )
                      : Bounce(
                        child: Motion(
                          child: GestureDetector(
                              onTap: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Text(
                                StringTextsNames.txtNext,
                                style: TextStyles.font13BlueSemiBold,
                              ),
                            ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
