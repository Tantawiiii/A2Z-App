import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/widgets/build_button.dart';
import 'package:a2z_app/core/widgets/build_toast.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routers.dart';
import '../../services/login_services.dart';
import '../widgets/build_dont_have_acc_text.dart';
import '../widgets/build_email_and_password.dart';
import '../widgets/build_icons_social_media.dart';
import '../widgets/build_sigin_with_media_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   final TextEditingController _usernameController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
   final AuthService _authService = AuthService();
   // To track loading
   bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringTextsNames.txtWelcomeBack,
                        style: TextStyles.font24BlueBold,
                      ),
                      verticalSpace(8),
                      Text(
                        StringTextsNames.txtDescriptionLogin,
                        style: TextStyles.font14GrayNormal,
                      ),
                      verticalSpace(36),
                      Column(
                        children: [
                          BuildEmailAndPassword(
                            emailController: _usernameController,
                            passwordController: _passwordController,
                          ),
                          verticalSpace(12),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: InkWell(
                              child: Text(
                                StringTextsNames.txtForgetPassword,
                                style: TextStyles.font13BlueNormal,
                              ),
                              onTap: () {
                                context.pushNamed(Routes.forgetPasswordScreen);
                              },
                            ),
                          ),
                          verticalSpace(40),
                          BuildButton(
                            textButton: StringTextsNames.txtLogin,
                            textStyle: TextStyles.font16WhiteMedium,
                            onPressed: _login,
                          ),
                          verticalSpace(46),
                          const BuildOrSignInMediaAccounts(),
                          verticalSpace(46),
                          const BuildIconsSocialMedia(),
                          verticalSpace(32),
                          const DontHaveAccountText(),
                          verticalSpace(50),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
               Center(
                child: CircularProgressIndicator(color: ColorsCode.mainBlue,),  // Show loading indicator
              ),
          ],
        ),
      ),
    );
  }


   void _login() async {
     final username = _usernameController.text;
     final password = _passwordController.text;

     if (username.isNotEmpty && password.isNotEmpty) {
       setState(() {
         _isLoading = true;  // Start loading
       });

       // Perform login
       await _authService.login(context, username, password);

       setState(() {
         _isLoading = false;  // Stop loading after response
       });
     } else {
       buildFailedToast(context, 'Please fill in both fields.');
     }
   }

}
