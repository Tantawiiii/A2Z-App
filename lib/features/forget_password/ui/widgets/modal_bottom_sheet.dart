import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:a2z_app/core/widgets/build_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/language/language.dart';

class BottomSheetDialog extends StatelessWidget {
  const BottomSheetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Lottie.asset(
              ImagesPaths.animDoneSuccess,
              width: 150.w,
              height: 150.h,
              repeat: true,
              // to solve the load problem
              frameRate: FrameRate.max,
            ),
            verticalSpace(16.h),
            Text(
              Language.instance.txtSuccessfully(),
              style: TextStyles.font20BlueBold,
            ),
            verticalSpace(8.h),
            Text(
              Language.instance.txtSuccessDes(),
              style: TextStyles.font13DarkBlueRegular,
              textAlign: TextAlign.center,
            ),
            verticalSpace(20.h),
            BuildButton(
              textButton: Language.instance.txtDone(),
              textStyle: TextStyles.font16WhiteMedium,
              onPressed: () {
                context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate:  (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
