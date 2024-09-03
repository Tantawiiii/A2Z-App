import 'package:a2z_app/core/language/StringsTexts.dart';
import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:a2z_app/features/getstarted/widgets/teacher_image_text_widget.dart';
import 'package:a2z_app/features/getstarted/widgets/getstarted_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../../a2z_app.dart';
import '../../core/language/language.dart';
import '../../core/theming/text_style.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Initialize slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // start position is slightly off-screen
      end: Offset.zero, // end position is on-screen
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: 30.0.h, bottom: 30.h),
            child: ListView(
              children: [
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: const TeacherImageTextWidget(),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          Language.instance.txtOnBoardingDescription(),
                          style: TextStyles.font13GrayNormal,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: const GetStartedButton(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
