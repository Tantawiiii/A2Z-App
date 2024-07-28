import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/build_text_form_field.dart';
import '../../../login/ui/widgets/build_password_validatons.dart';

class SignupForm extends StatefulWidget {
   SignupForm(
      {super.key,
      required this.formKey,
      required this.firstNameController,
      required this.lastNameController,
      required this.phoneNumberController,
      required this.emailController,
      required this.usernameController,
      required this.passwordController,
      required this.gradeController});

  final GlobalKey<FormState> formKey;

   TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController gradeController;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool isPasswordObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;


  @override
  void initState() {
    super.initState();
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    widget.passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(  widget.passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(widget.passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(widget.passwordController.text);
        hasNumber = AppRegex.hasNumber(widget.passwordController.text);
        hasMinLength = AppRegex.hasMinLength(widget.passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          BuildTextFormField(
            controller: widget.firstNameController,
            hintText: StringTextsNames.txtFullName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return StringTextsNames.txtNameValid;
              }
            },
          ),
          BuildTextFormField(
            controller: widget.lastNameController,
            hintText: StringTextsNames.txtFullName,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return StringTextsNames.txtNameValid;
              }
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.phoneNumberController,
            hintText: StringTextsNames.txtPhoneNumber,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isPhoneNumValid(value)) {
                return StringTextsNames.txtHintValidPhoneNum;
              }
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.emailController,
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
            controller: widget.passwordController,
            hintText: StringTextsNames.txtPassword,
            isObscureText: isPasswordObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordObscureText = !isPasswordObscureText;
                });
              },
              child: Icon(
                isPasswordObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return StringTextsNames.txtPasswordIsValid;
              }
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.gradeController,
            hintText: StringTextsNames.txtGrade,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ) {
                return StringTextsNames.txtGradeValid;
              }
            },
          ),
          verticalSpace(24),
          BuildPasswordValidations(
            hasLowerCase: hasLowercase,
            hasUpperCase: hasUppercase,
            hasMinLength: hasMinLength,
            hasNumber: hasNumber,
            hasSpecialCharacter: hasSpecialCharacters,
          ),
        ],
      ),
    );
  }


}
