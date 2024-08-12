import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../../../core/utils/StringsTexts.dart';
import '../../../../../core/widgets/build_button.dart';
import '../../../../../core/widgets/build_text_form_field.dart';
import '../services/change_password_request.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isObscuredText = true;
  bool newIsObscuredText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.w),
        child: ListView(
          children: [
            Text(
              StringTextsNames.txtChangePass,
              style: TextStyles.font24BlueBold,
            ),
            verticalSpace(8),
            Text(
              StringTextsNames.txtChangePassDes,
              style: TextStyles.font14GrayNormal,
            ),
            verticalSpace(42),
            BuildTextFormField(
              controller: userNameController,
              hintText: StringTextsNames.txtUserName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringTextsNames.txtNameValid;
                }
                return null;
              },
            ),
            verticalSpace(14),
            BuildTextFormField(
              controller: oldPasswordController,
              hintText: StringTextsNames.txtOldPassword,
              isObscureText: isObscuredText,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObscuredText = !isObscuredText;
                  });
                },
                child: Icon(
                  isObscuredText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringTextsNames.txtPasswordIsValid;
                }
                return null;
              },
            ),
            verticalSpace(14),
            BuildTextFormField(
              controller: newPasswordController,
              hintText: StringTextsNames.txtNewPassword,
              isObscureText: newIsObscuredText,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    newIsObscuredText = !newIsObscuredText;
                  });
                },
                child: Icon(
                  newIsObscuredText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringTextsNames.txtPasswordIsValid;
                }
                return null;
              },
            ),
            verticalSpace(50),
            BuildButton(
              textButton: StringTextsNames.txtChangePass,
              textStyle: TextStyles.font16WhiteMedium,
              onPressed: () {
                changePassword(
                  context: context,
                  username: userNameController.text,
                  oldPassword: oldPasswordController.text,
                  newPassword: newPasswordController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
