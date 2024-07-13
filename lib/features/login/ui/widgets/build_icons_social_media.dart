import 'package:a2z_app/core/utils/images_paths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/spacing.dart';

class BuildIconsSocialMedia extends StatelessWidget {
  const BuildIconsSocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          ImagesPaths.googleIcon,
          width: 56,
        ),
        horizontalSpace(32),
        SvgPicture.asset(
          ImagesPaths.facebookIcon,
          width: 56,
        ),
        horizontalSpace(32),
        SvgPicture.asset(
          ImagesPaths.appleIcon,
          width: 56,
        ),
      ],
    );
  }
}
