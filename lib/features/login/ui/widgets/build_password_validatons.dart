
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/utils/colors_code.dart';

class BuildPasswordValidations extends StatefulWidget {
  bool hasLowerCase;
  bool hasUpperCase;
  bool hasSpecialCharacter;
  bool hasNumber;
  bool hasMinLength;

  BuildPasswordValidations({
    required this.hasLowerCase,
    required this.hasUpperCase,
    required this.hasSpecialCharacter,
    required this.hasNumber,
    required this.hasMinLength,
    super.key,
  });

  @override
  State<BuildPasswordValidations> createState() => _BuildPasswordValidationsState();
}

class _BuildPasswordValidationsState extends State<BuildPasswordValidations> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuildValidationRow("at least 1 of lowerCase latter", widget.hasLowerCase),
        verticalSpace(2),
        BuildValidationRow("at least 1 of upperCase latter", widget.hasUpperCase),
        verticalSpace(2),
        BuildValidationRow("at least 1 of Special Character", widget.hasSpecialCharacter),
        verticalSpace(2),
        BuildValidationRow("at least 1 of Number", widget.hasNumber),
        verticalSpace(2),
        BuildValidationRow("at least 8 Of Character long", widget.hasMinLength),
        verticalSpace(2),
      ],
    );
  }

  Widget BuildValidationRow(String text, bool hasValidated) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 2.5,
          backgroundColor: ColorsCode.gray,
        ),
        horizontalSpace(6),
        Text(
          text,
          style: TextStyles.font13DarkBlueRegular.copyWith(
            decoration: hasValidated ? TextDecoration.lineThrough : null,
            decorationColor: ColorsCode.fillGreen,
            decorationThickness: 2,
            color: hasValidated ? ColorsCode.gray : ColorsCode.darkBlue,
          ),
        )
      ],
    );
  }
}