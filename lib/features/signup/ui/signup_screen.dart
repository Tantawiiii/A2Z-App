import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/features/signup/ui/widgets/already_have_account_text.dart';
import 'package:a2z_app/features/signup/ui/widgets/build_sign_up_form.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../core/widgets/build_button.dart';
import '../services/graphql_service.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _gradeController = TextEditingController();

  final GraphQLService _graphQLService = GraphQLService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // to fix white part top of the Keyboard window opening
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: ListView(
          children: [
            Text(
              StringTextsNames.txtCreateAccount,
              style: TextStyles.font24BlueBold,
            ),
            verticalSpace(8),
            Text(
              StringTextsNames.txtCreateAccDes,
              style: TextStyles.font14GrayNormal,
            ),
            verticalSpace(36),
            SignupForm(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              phoneNumberController: _phoneNumberController,
              emailController: _emailController,
              usernameController: _usernameController,
              passwordController: _passwordController,
              gradeController: _gradeController,
            ),
            verticalSpace(40),
            BuildButton(
              textButton: StringTextsNames.txtCreateAccount,
              textStyle: TextStyles.font16WhiteMedium,
              onPressed: _register,
            ),
            verticalSpace(16),
            const AlreadyHaveAccountText(),
            verticalSpace(160),
          ],
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await _graphQLService.requestRegistration(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: "+2${_phoneNumberController.text}",
          email: _emailController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          grade: _gradeController.text,
        );

        // Handle the result as needed
        print("response: ${result}");
      } catch (e) {
        print("An error occurred: $e");
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _gradeController.dispose();
    super.dispose();
  }
}
