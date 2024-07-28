import 'package:flutter/material.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';

import '../../../../core/utils/StringsTexts.dart';
import '../../../../core/widgets/build_text_form_field.dart';
import 'build_password_validatons.dart';

class BuildEmailAndPassword extends StatefulWidget {
  const BuildEmailAndPassword({super.key});

  @override
  State<BuildEmailAndPassword> createState() => _BuildEmailAndPasswordState();
}

class _BuildEmailAndPasswordState extends State<BuildEmailAndPassword> {
  bool isObscuredText = true;
  bool hasLowerCase = false;
  bool hasUpperCase = false;
  bool hasSpecialCharacter = false;
  bool hasNumber = false;
  bool hasMinLength = false;

   TextEditingController passwordController = TextEditingController();
   TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowerCase = AppRegex.hasLowerCase(passwordController.text);
        hasUpperCase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacter =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          BuildTextFormField(
            controller: emailController,
            hintText: StringTextsNames.txtEmail,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isEmailValid(value)) {
                return StringTextsNames.txtEmailIsValid;
              }
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: passwordController,
            hintText: StringTextsNames.txtPassword,
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
            },
          ),
          verticalSpace(24),
          BuildPasswordValidations(
            hasLowerCase: hasLowerCase,
            hasUpperCase: hasUpperCase,
            hasMinLength: hasMinLength,
            hasNumber: hasNumber,
            hasSpecialCharacter: hasSpecialCharacter,
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
