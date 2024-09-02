import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/onboarding/widgets/build_onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theming/text_style.dart';
import '../../../core/language/StringsTexts.dart';
import '../../../core/utils/images_paths.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<double> _pageNotifier = ValueNotifier<double>(0.0);

  bool onLastPage = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _pageNotifier.value = _pageController.page ?? 0.0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsCode.white,
      body: Container(
        padding: EdgeInsetsDirectional.only(bottom: 40.h, start: 26.h, end: 26.h),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _pageNotifier,
              builder: (context, child) {
                return PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      onLastPage = (index == 2);
                    });
                  },
                  children: [
                    for (int i = 0; i < 3; i++)
                      Transform.translate(
                        offset: Offset(
                          0,
                          50 * (_pageNotifier.value - i).clamp(-1, 1),
                        ),
                        child: Opacity(
                          opacity: 1 - (_pageNotifier.value - i).abs().clamp(0.0, 1.0),
                          child: [
                            const BuildOnboardingScreen(
                              svgBodyPath: ImagesPaths.logoImage,
                              titleBoard: StringTextsNames.titleOnBoard1,
                              desBoard: StringTextsNames.desOnBoard1,
                            ),
                            const BuildOnboardingScreen(
                              svgBodyPath: ImagesPaths.animBodyOnBoarding2,
                              titleBoard: StringTextsNames.titleOnBoard2,
                              desBoard: StringTextsNames.desOnBoard2,
                            ),
                            const BuildOnboardingScreen(
                              svgBodyPath: ImagesPaths.animBodyOnBoarding3,
                              titleBoard: StringTextsNames.titleOnBoard3,
                              desBoard: StringTextsNames.desOnBoard3,
                            ),
                          ][i],
                        ),
                      ),
                  ],
                );
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.getStartedScreen);
                    },
                    child: Text(
                      StringTextsNames.txtSkip,
                      style: TextStyles.font18BlueSemiBold,
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const ExpandingDotsEffect(),
                  ),
                  onLastPage
                      ? GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.getStartedScreen);
                    },
                    child: Text(
                      StringTextsNames.txtDone,
                      style: TextStyles.font18BlueSemiBold,
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
                      StringTextsNames.txtNext,
                      style: TextStyles.font18BlueSemiBold,
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
