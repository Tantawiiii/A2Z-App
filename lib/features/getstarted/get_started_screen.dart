import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/features/getstarted/widgets/doctor_image_text_widget.dart';
import 'package:a2z_app/features/getstarted/widgets/getstarted_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theming/text_style.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0.h, bottom:30.h),
            child:  Column(
              children: [
                SizedBox(height: 30.h,),
                const DoctorImageTextWidget(),
                SizedBox(height: 18.h,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Text(
                        StringsTexts.txtOnBoardingDescription,
                        style: TextStyles.font13GrayNormal,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h,),
                      const GetStartedButton(),
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
