import 'package:flutter/material.dart';
import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/language/language.dart';
import '../../../../core/widgets/build_text_form_field.dart';
import 'build_password_validatons.dart';

class BuildEmailAndPassword extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const BuildEmailAndPassword({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<BuildEmailAndPassword> createState() => _BuildEmailAndPasswordState();
}

class _BuildEmailAndPasswordState extends State<BuildEmailAndPassword> {
   bool isObscuredText = true;
  // bool hasLowerCase = false;
  // bool hasUpperCase = false;
  // bool hasSpecialCharacter = false;
  // bool hasNumber = false;
  // bool hasMinLength = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   setupPasswordControllerListener();
  // }

  // void setupPasswordControllerListener() {
  //   widget.passwordController.addListener(() {
  //     setState(() {
  //       hasLowerCase = AppRegex.hasLowerCase(widget.passwordController.text);
  //       hasUpperCase = AppRegex.hasUpperCase(widget.passwordController.text);
  //       hasSpecialCharacter = AppRegex.hasSpecialCharacter(widget.passwordController.text);
  //       hasNumber = AppRegex.hasNumber(widget.passwordController.text);
  //       hasMinLength = AppRegex.hasMinLength(widget.passwordController.text);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          BuildTextFormField(
            controller: widget.emailController,
            hintText: Language.instance.txtEmail(),
            validator: (value) {
              if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
                return Language.instance.txtEmailIsValid;
              }
              return null;
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.passwordController,
            hintText: Language.instance.txtPassword(),
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
                return Language.instance.txtPasswordIsValid;
              }
              return null;
            },
          ),
         //  verticalSpace(24),
          // BuildPasswordValidations(
          //   hasLowerCase: hasLowerCase,
          //   hasUpperCase: hasUpperCase,
          //   hasMinLength: hasMinLength,
          //   hasNumber: hasNumber,
          //   hasSpecialCharacter: hasSpecialCharacter,
          // ),
        ],
      ),
    );
  }

}
