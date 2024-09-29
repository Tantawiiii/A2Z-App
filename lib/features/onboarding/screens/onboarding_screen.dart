import 'dart:async';

import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/onboarding/widgets/build_onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../a2z_app.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/language/language.dart';
import '../../../core/theming/text_style.dart';
import '../../../core/language/StringsTexts.dart';
import '../../../core/utils/images_paths.dart';
import '../../no_internet/no_internet_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<double> _pageNotifier = ValueNotifier<double>(0.0);

  bool onLastPage = false;
  String currentLang = "";

  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _pageNotifier.value = _pageController.page ?? 0.0;
    });

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


  @override
  Widget build(BuildContext context) {

    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? Scaffold(
            backgroundColor: ColorsCode.white,
            body: Container(
              padding: EdgeInsetsDirectional.only(
                bottom: 40.h,
                start: isArabic ? 26.h : 26.h,
                end: isArabic ? 26.h : 26.h,
              ),
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

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.asset(
                                        ImagesPaths.logoImage,
                                        width: 360.w,
                                      ),
                                      verticalSpace(60.h),
                                      Text(
                                        Language.instance.titleOnBoard1(),
                                        style: TextStyles.font24BlueBold,
                                        textAlign: TextAlign.center,
                                      ),
                                      verticalSpace(20.h),
                                      Text(
                                        Language.instance.desOnBoard1(),
                                        style: TextStyles.font13GrayNormal,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),

                                   BuildOnboardingScreen(
                                    svgBodyPath: ImagesPaths.animBodyOnBoarding2,
                                    titleBoard: Language.instance.titleOnBoard2(),
                                    desBoard: Language.instance.desOnBoard2(),
                                  ),
                                   BuildOnboardingScreen(
                                    svgBodyPath: ImagesPaths.animBodyOnBoarding3,
                                    titleBoard: Language.instance.titleOnBoard3(),
                                    desBoard: Language.instance.desOnBoard3(),
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
                            Language.instance.txtSkip(),
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
                            Language.instance.txtDone(),
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
                            Language.instance.txtNext(),
                            style: TextStyles.font18BlueSemiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 50.h,
                    right: isArabic ? 8.w :  null,
                    left: isArabic ?  null : 8.w,
                    child: SizedBox(
                      width: 130,
                      height: 40,
                      child: LiteRollingSwitch(
                        value: false,
                        textOn: 'English',
                        textOff: 'Arabic',
                        colorOn: ColorsCode.mainBlue,
                        colorOff: ColorsCode.darkBlue,
                        iconOn: Icons.done,
                        iconOff: Icons.remove_circle_outline,
                        textSize: 14.0,
                        width: 55,
                        onChanged: (bool state) {
                          print('Current State of SWITCH IS: $state');
                          setState(() {
                            if (state) {
                              changeLanguage("en");
                            } else {
                              changeLanguage("ar");
                            }
                          });
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                        onSwipe: () {},
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
          : const NoInternetScreen(),
    );
  }


  changeLanguage(lang) async {
    if (A2ZApp.getLocal(context).languageCode == 'ar') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("language", "EN");

      Language.instance.setLanguage("EN");
      currentLang = "EN";
      setState(() {});
      Locale newLocale = const Locale('en');
      A2ZApp.setLocale(context, newLocale);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("language", "AR");

      Language.instance.setLanguage("AR");
      currentLang = "AR";
      setState(() {});
      Locale newLocale = const Locale('ar');
      A2ZApp.setLocale(context, newLocale);
    }

  setState(() {

   });
  }
  @override
  void dispose() {
    _pageController.dispose();
    _pageNotifier.dispose();

    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
